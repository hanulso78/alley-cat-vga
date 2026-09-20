# ALLYCAT.EXE 를 unicorn(8086 실모드)으로 돌리는 기준 에뮬레이터
#   - 입출력(시계, 3DAh, PIT, 스피커, BIOS 비디오)은 결정적인 가상 시간으로 흉내 낸다.
#   - C 판의 시험 백엔드와 똑같은 규칙이라, 같은 입력이면 같은 상태가 나와야 한다.
#   python tools/emu.py script.txt out_dir     (스크립트 형식은 load_script 참고)
import struct, sys, os
from unicorn import *
from unicorn.x86_const import *

EXE = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'allycat.exe')
LOADSEG = 0x1000
TICK_US = 54925
FONT = None


def load_font():
    """8x8 글꼴 (BIOS ROM 글꼴 대신 윈도우의 CGA 글꼴)"""
    global FONT
    if FONT is not None:
        return FONT
    d = open('C:/Windows/Fonts/cga80woa.fon', 'rb').read()
    ne = struct.unpack_from('<I', d, 0x3c)[0]
    rt = ne + struct.unpack_from('<H', d, ne + 0x24)[0]
    shift = struct.unpack_from('<H', d, rt)[0]
    p = rt + 2
    FONT = bytearray(256 * 8)
    while True:
        t, cnt = struct.unpack_from('<HH', d, p)
        p += 8
        if t == 0:
            break
        for i in range(cnt):
            off, ln = struct.unpack_from('<HH', d, p)
            p += 12
            if t == 0x8008:
                o = off << shift
                first = d[o + 95]
                last = d[o + 96]
                for c in range(first, last + 1):
                    w, bo = struct.unpack_from('<HH', d, o + 118 + (c - first) * 4)
                    FONT[c * 8:c * 8 + 8] = d[o + bo:o + bo + 8]
    return FONT


CGA_RGB = [0x000000, 0x0000AA, 0x00AA00, 0x00AAAA, 0xAA0000, 0xAA00AA, 0xAA5500, 0xAAAAAA,
           0x555555, 0x5555FF, 0x55FF55, 0x55FFFF, 0xFF5555, 0xFF55FF, 0xFFFF55, 0xFFFFFF]

KEYS = ['alt', 'up', 'right', 'down', 'left', 'pgup', 'pgdn', 'end', 'home', 'esc',
        'y', 'n', 'k', 'h', 't', 'a', 's', 'r', 'ctrl', 'del', 'm', '9']

IDLE_POLLS = (0x5ef7, 0x5f29, 0x5faa, 0x6007)      # 키 누름을 메모리만 보며 기다리는 곳


class Machine:
    def __init__(self, script=()):
        e = open(EXE, 'rb').read()
        h = struct.unpack('<14H', e[:28])
        img = bytearray(e[h[4] * 16:])
        for i in range(h[3]):
            o, s = struct.unpack_from('<HH', e, h[12] + 4 * i)
            v = struct.unpack_from('<H', img, s * 16 + o)[0]
            struct.pack_into('<H', img, s * 16 + o, (v + LOADSEG) & 0xffff)
        mu = self.mu = Uc(UC_ARCH_X86, UC_MODE_16)
        mu.mem_map(0, 0x100000)
        mu.mem_write(LOADSEG * 16, bytes(img))
        mu.mem_write(0xFFFFE, b'\xff')                       # 기종 = IBM PC
        mu.mem_write(0x410, struct.pack('<H', 0x0021))
        mu.mem_write((LOADSEG - 0x10) * 16, b'\xcd\x20')      # PSP:0 = int 20h
        self.dsbase = (LOADSEG + 0x10) * 16
        self.cs = LOADSEG + h[11]
        mu.reg_write(UC_X86_REG_CS, self.cs)
        mu.reg_write(UC_X86_REG_IP, h[10])
        mu.reg_write(UC_X86_REG_SS, LOADSEG + h[7])
        mu.reg_write(UC_X86_REG_SP, h[8])
        mu.reg_write(UC_X86_REG_DS, LOADSEG - 0x10)
        mu.reg_write(UC_X86_REG_ES, LOADSEG - 0x10)
        mu.hook_add(UC_HOOK_INTR, self.on_int)
        mu.hook_add(UC_HOOK_INSN, self.on_in, None, 1, 0, UC_X86_INS_IN)
        mu.hook_add(UC_HOOK_INSN, self.on_out, None, 1, 0, UC_X86_INS_OUT)
        for a in IDLE_POLLS:
            mu.hook_add(UC_HOOK_CODE, self.on_idle, None, self.cs * 16 + a, self.cs * 16 + a)
        self.vtime = 0
        self.tick_base = 0
        self.events = 0
        self.port61 = 0
        self.port3d9 = 0x30
        self.bios_pal = 0x30
        self.cur_row = self.cur_col = 0
        self.pit_latch = 0
        self.pit_phase = 0
        self.script = sorted(script, key=lambda e: e[0])
        self.sp = 0
        self.on_event = None
        self.stopped = False

    # ---- 공용 규칙 (C 시험 백엔드와 같아야 한다) --------------------------------
    def advance(self, us, kind):
        self.vtime += us
        self.events += 1
        while self.sp < len(self.script) and self.script[self.sp][0] <= self.vtime:
            self.apply(self.script[self.sp])
            self.sp += 1
        if self.on_event:
            self.on_event(self, kind)

    def rd8(self, off):
        return self.mu.mem_read(self.dsbase + off, 1)[0]

    def rd16(self, off):
        return struct.unpack('<H', self.mu.mem_read(self.dsbase + off, 2))[0]

    def apply(self, ev):
        t, cmd, arg = ev
        if cmd in ('down', 'up'):
            idx = KEYS.index(arg) if arg in KEYS else -1      # 표에 없는 키는 누른 횟수만 센다
            if cmd == 'down':
                cnt = self.rd16(0x693)
                self.mu.mem_write(self.dsbase + 0x693, struct.pack('<H', (cnt + 1) & 0xffff))
                if idx >= 0:
                    self.mu.mem_write(self.dsbase + 0x6b7 + idx, b'\x00')
            elif idx >= 0:
                self.mu.mem_write(self.dsbase + 0x6b7 + idx, b'\x80')
        elif cmd == 'poke':                     # arg = (오프셋, 값) 바이트
            self.mu.mem_write(self.dsbase + arg[0], bytes([arg[1] & 0xff]))
        elif cmd == 'pokew':
            self.mu.mem_write(self.dsbase + arg[0], struct.pack('<H', arg[1] & 0xffff))
        elif cmd == 'quit':
            self.stop()

    def stop(self):
        self.stopped = True
        self.mu.emu_stop()

    def ticks(self):
        return (self.vtime // TICK_US + self.tick_base) & 0xffffffff

    # ---- 후크 ------------------------------------------------------------------
    def on_idle(self, mu, addr, size, ud):
        self.advance(1000, 'idle')

    def on_int(self, mu, intno, ud):
        r = mu.reg_read
        ax = r(UC_X86_REG_AX)
        ah = ax >> 8
        al = ax & 0xff
        if intno == 0x1a:
            if ah == 0:
                self.advance(1000, 'tick')
                t = self.ticks()
                mu.reg_write(UC_X86_REG_CX, t >> 16)
                mu.reg_write(UC_X86_REG_DX, t & 0xffff)
                mu.reg_write(UC_X86_REG_AX, 0)
            elif ah == 1:
                want = (r(UC_X86_REG_CX) << 16) | r(UC_X86_REG_DX)
                self.tick_base = (want - self.vtime // TICK_US) & 0xffffffff
        elif intno == 0x11:
            mu.reg_write(UC_X86_REG_AX, 0x0021)
        elif intno == 0x10:
            self.int10(mu, ah, al)
        elif intno == 0x20:
            self.stop()
        else:
            print('unhandled int %02x at %04x' % (intno, r(UC_X86_REG_IP)))
            self.stop()

    def vram(self):
        return self.mu.mem_read(0xB8000, 0x4000)

    def int10(self, mu, ah, al):
        bx = mu.reg_read(UC_X86_REG_BX)
        bh = bx >> 8
        bl = bx & 0xff
        if ah == 0:
            mu.mem_write(0xB8000, bytes(0x4000))
            self.bios_pal = self.port3d9 = 0x30
            self.cur_row = self.cur_col = 0
        elif ah == 0x0b:
            v = self.bios_pal
            if bh == 0:
                v = (v & 0xe0) | (bl & 0x1f)
            else:
                v = (v & 0xdf) | (0x20 if bl & 1 else 0)
            self.bios_pal = self.port3d9 = v
        elif ah == 0x02:
            dx = mu.reg_read(UC_X86_REG_DX)
            self.cur_row = dx >> 8
            self.cur_col = dx & 0xff
        elif ah == 0x0e:
            self.teletype(al, bl)
        elif ah == 0x10:
            pass
        else:
            print('int10 ah=%02x' % ah)

    def teletype(self, ch, color):
        if ch == 13:
            self.cur_col = 0
            return
        if ch == 10:
            self.cur_row += 1
        elif ch == 8:
            if self.cur_col:
                self.cur_col -= 1
            return
        elif ch == 7:
            return
        else:
            self.putchar(ch, color)
            self.cur_col += 1
            if self.cur_col >= 40:
                self.cur_col = 0
                self.cur_row += 1
        if self.cur_row >= 25:
            self.scroll_up()
            self.cur_row = 24

    def putchar(self, ch, color):
        f = load_font()
        c = color & 3
        v = bytearray(self.vram())
        for y in range(8):
            bits = f[ch * 8 + y]
            py = self.cur_row * 8 + y
            base = (py // 2) * 80 + (0x2000 if py & 1 else 0) + self.cur_col * 2
            row = 0
            for x in range(8):
                row = (row << 2) | (c if bits & (0x80 >> x) else 0)
            if color & 0x80:
                v[base] ^= row >> 8
                v[base + 1] ^= row & 0xff
            else:
                v[base] = row >> 8
                v[base + 1] = row & 0xff
        self.mu.mem_write(0xB8000, bytes(v))

    def scroll_up(self):
        v = bytearray(self.vram())
        for plane in (0, 0x2000):
            v[plane:plane + 96 * 80] = v[plane + 4 * 80:plane + 100 * 80]
            v[plane + 96 * 80:plane + 100 * 80] = bytes(320)
        self.mu.mem_write(0xB8000, bytes(v))

    def on_in(self, mu, port, size, ud):
        if port == 0x3da:
            self.advance(200, 'retrace')
            ph = self.vtime % 16667
            return (8 if ph < 1500 else 0) | (1 if ph < 1500 or (ph // 64) % 4 == 0 else 0)
        if port == 0x40:
            if self.pit_phase == 0:
                self.advance(20, 'pit')
                cnt = (0x10000 - (self.vtime * 1193182 // 1000000) % 0x10000) & 0xffff
                self.pit_latch = cnt
                self.pit_phase = 1
                return cnt & 0xff
            self.pit_phase = 0
            return self.pit_latch >> 8
        if port == 0x61:
            return self.port61
        if port == 0x201:
            return 0xf0
        print('in %x' % port)
        return 0xff

    def on_out(self, mu, port, size, value, ud):
        if port == 0x61:
            self.port61 = value & 0xff
        elif port == 0x3d9:
            self.port3d9 = value & 0xff
        elif port == 0x43:
            self.pit_phase = 0
        elif port in (0x42, 0x201, 0x20, 0x3d4, 0x3d5):
            pass
        else:
            print('out %x %x' % (port, value))

    def run(self, max_events=10 ** 12):
        while not self.stopped and self.events < max_events:
            ip = self.mu.reg_read(UC_X86_REG_IP)
            cs = self.mu.reg_read(UC_X86_REG_CS)
            self.mu.emu_start(cs * 16 + ip, 0xFFFFFFFF, 0, 500000)

    # ---- 화면 ------------------------------------------------------------------
    def palette(self):
        p = self.port3d9
        hi = 8 if p & 0x10 else 0
        cols = (3, 5, 7) if p & 0x20 else (2, 4, 6)
        return [CGA_RGB[p & 15]] + [CGA_RGB[c + hi] for c in cols]

    def rgb(self):
        v = self.vram()
        pal = self.palette()
        out = bytearray(320 * 200 * 3)
        for y in range(200):
            base = (y // 2) * 80 + (0x2000 if y & 1 else 0)
            for x in range(320):
                c = (v[base + (x >> 2)] >> (6 - 2 * (x & 3))) & 3
                col = pal[c]
                o = (y * 320 + x) * 3
                out[o] = col >> 16
                out[o + 1] = (col >> 8) & 255
                out[o + 2] = col & 255
        return bytes(out)

    def save_png(self, fn, scale=2):
        from PIL import Image
        im = Image.frombytes('RGB', (320, 200), self.rgb())
        im = im.resize((320 * scale, 200 * scale), Image.NEAREST)
        im.save(fn)


def load_script(fn):
    """줄마다: <초> down|up <키이름>  /  <초> shot <이름>  /  <초> quit"""
    ev, shots = [], []
    for ln in open(fn):
        ln = ln.split('#')[0].split()
        if not ln:
            continue
        t = int(float(ln[0]) * 1000000)
        if ln[1] == 'shot':
            shots.append((t, ln[2]))
        elif ln[1] in ('poke', 'pokew'):
            ev.append((t, ln[1], (int(ln[2], 16), int(ln[3], 16))))
        else:
            ev.append((t, ln[1], ln[2] if len(ln) > 2 else None))
    return ev, shots


if __name__ == '__main__':
    ev, shots = load_script(sys.argv[1])
    outdir = sys.argv[2] if len(sys.argv) > 2 else 'shots'
    os.makedirs(outdir, exist_ok=True)
    m = Machine(ev)
    shots.sort()
    state = {'i': 0}

    def on_event(m, kind):
        while state['i'] < len(shots) and shots[state['i']][0] <= m.vtime:
            name = shots[state['i']][1]
            m.save_png(os.path.join(outdir, name + '.png'))
            print('shot', name, 'events', m.events, 'room', m.rd16(4))
            state['i'] += 1
        if state['i'] >= len(shots):
            m.stop()
    m.on_event = on_event
    m.run()
