# 원본을 에뮬레이터로 돌리며 명령어마다 8088 클럭 수를 더해, 사건(시계/3DAh/PIT/키) 사이에
# 걸린 8088 시간을 잰다.  C 판의 속도 맞추기(sys_dos.c) 값을 정하려고 쓴다.
#   python tools/cpucost.py script.txt [사건 수]
import sys, os, collections, struct
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import emu
from capstone import *
from capstone.x86 import *
from unicorn import UC_HOOK_CODE
from unicorn.x86_const import *

md = Cs(CS_ARCH_X86, CS_MODE_16)
md.detail = True


def ea_cost(op):
    m = op.mem
    base = m.base != 0
    index = m.index != 0
    disp = m.disp != 0
    if not base and not index:
        return 6
    if base and index:
        return 12 if disp else 8
    return 9 if disp else 5


def clocks(ins):
    """8088 대략 클럭 수 (인텔 표를 줄여서)"""
    m = ins.mnemonic
    ops = ins.operands
    mem = [o for o in ops if o.type == X86_OP_MEM]
    ea = ea_cost(mem[0]) if mem else 0
    rep = ins.prefix[0] in (0xF2, 0xF3)
    if m.startswith('rep') or rep:
        return 0                                # 아래에서 한 바퀴씩 센다
    if m in ('mov',):
        if not mem:
            return 4 if ops[1].type == X86_OP_IMM else 2
        if ops[0].type == X86_OP_MEM:
            return (10 if ops[1].type == X86_OP_IMM else 9) + ea + (4 if ops[0].size == 2 else 0)
        return 8 + ea + (4 if ops[0].size == 2 else 0)
    if m in ('add', 'sub', 'cmp', 'and', 'or', 'xor', 'adc', 'sbb', 'test'):
        if not mem:
            return 4 if ops[1].type == X86_OP_IMM else 3
        if ops[0].type == X86_OP_MEM:
            return (17 if ops[1].type == X86_OP_IMM else 16) + ea + (4 if ops[0].size == 2 else 0)
        return 9 + ea + (4 if ops[0].size == 2 else 0)
    if m in ('inc', 'dec', 'not', 'neg'):
        return 15 + ea + 4 if mem else 3
    if m in ('shl', 'shr', 'sar', 'rcl', 'rcr', 'rol', 'ror'):
        if len(ops) > 1 and ops[1].type == X86_OP_REG:
            return 8 + 4 * 4 + (ea + 12 if mem else 0)
        return 15 + ea if mem else 2
    if m in ('mul', 'imul'):
        return 75 + ea
    if m in ('div', 'idiv'):
        return 85 + ea
    if m.startswith('j') or m.startswith('loop'):
        return 16 if m in ('jmp',) else 10      # 탔을 때와 안 탔을 때의 가운데
    if m == 'call':
        return 23 + (ea + 10 if mem else 0)
    if m == 'ret':
        return 20
    if m in ('push', 'pop'):
        return (24 + ea) if mem else 13
    if m in ('lodsb', 'lodsw', 'stosb', 'stosw', 'movsb', 'movsw', 'scasb', 'scasw'):
        return 16
    if m in ('in', 'out'):
        return 10
    if m == 'int':
        return 71
    if m == 'iret':
        return 44
    if m in ('lahf', 'sahf', 'pushf', 'popf', 'cld', 'std', 'cli', 'sti', 'clc', 'stc', 'nop', 'cbw', 'cwd'):
        return 4
    if m in ('xchg',):
        return 4 + (ea + 13 if mem else 0)
    if m in ('lea',):
        return 2 + ea
    if m in ('aaa', 'aas', 'daa', 'das'):
        return 8
    return 10


GFX = {0x2ccc: 'mask', 0x2d35: 'and', 0x2d70: 'rows', 0x2d9d: 'blit', 0x2dca: 'save', 0x2b24: 'list'}
BIOS_TICK = 200        # int 1Ah 안의 BIOS 코드 (대략)


def main():
    ev, _ = emu.load_script(sys.argv[1])
    limit = int(sys.argv[2]) if len(sys.argv) > 2 else 20000
    m = emu.Machine(ev)
    cache = {}
    st = {'clk': 0, 'last': 0, 'last_kind': None}
    per = collections.defaultdict(list)
    rep_loops = collections.Counter()

    def hook(mu, addr, size, ud):
        c = cache.get(addr)
        if c is None:
            code = bytes(mu.mem_read(addr, size))
            ins = next(md.disasm(code, addr))
            rep = ins.prefix[0] in (0xF2, 0xF3)
            c = (clocks(ins), rep)
            cache[addr] = c
        if c[1]:
            st['clk'] += 17                     # rep 한 바퀴 (unicorn 은 바퀴마다 부른다)
        else:
            st['clk'] += c[0]

    m.mu.hook_add(UC_HOOK_CODE, hook)

    def on_event(m, kind):
        if kind == 'tick':
            st['clk'] += BIOS_TICK
        d = st['clk'] - st['last']
        st['last'] = st['clk']
        per[(st['last_kind'], kind)].append(d)
        st['last_kind'] = kind
        if m.events >= limit:
            m.stop()
    m.on_event = on_event
    m.run()
    total = st['clk']
    print('total clocks %d = %.2f s at 4.77MHz, virtual time %.2f s' % (total, total / 4772727, m.vtime / 1e6))
    for k, v in sorted(per.items(), key=lambda kv: -sum(kv[1])):
        v = sorted(v)
        print('%-22s n=%6d mean=%7.0f med=%6d p90=%6d sum=%.2fs' % (k, len(v), sum(v) / len(v), v[len(v) // 2],
              v[len(v) * 9 // 10], sum(v) / 4772727))


if __name__ == '__main__' and len(sys.argv) <= 3:
    main()


def gfx_model(script, limit):
    """그리기 함수(2CCC 등)에 든 클럭을 따로 모아 크기(워드, 줄)에 대한 식으로 맞춘다"""
    ev, _ = emu.load_script(script)
    m = emu.Machine(ev)
    cache = {}
    st = {'clk': 0, 'in': None, 'start': 0, 'ret': None, 'size': None, 'gfx': 0, 'last': 0, 'lk': None}
    samples = collections.defaultdict(list)
    base = collections.defaultdict(list)
    cs16 = m.cs * 16

    def hook(mu, addr, size, ud):
        c = cache.get(addr)
        if c is None:
            ins = next(md.disasm(bytes(mu.mem_read(addr, size)), addr))
            c = (clocks(ins), ins.prefix[0] in (0xF2, 0xF3))
            cache[addr] = c
        st['clk'] += 17 if c[1] else c[0]
        off = addr - cs16
        if st['in'] is None and off in GFX:
            ss = mu.reg_read(UC_X86_REG_SS); sp = mu.reg_read(UC_X86_REG_SP)
            st['ret'] = struct.unpack('<H', mu.mem_read(ss * 16 + sp, 2))[0]
            st['in'] = GFX[off]
            st['start'] = st['clk'] - c[0]
            cx = mu.reg_read(UC_X86_REG_CX)
            if off == 0x2b24:
                bx = mu.reg_read(UC_X86_REG_BX)
                cx = struct.unpack('<H', mu.mem_read(m.dsbase + bx, 2))[0]
                n = 0
                p = bx + 2
                while struct.unpack('<H', mu.mem_read(m.dsbase + p, 2))[0] != 0xffff:
                    n += 1
                    p += 4
                st['size'] = (cx & 0xff, cx >> 8, n)
            else:
                st['size'] = (cx & 0xff, cx >> 8, mu.reg_read(UC_X86_REG_AX) & 0xff)
        elif st['in'] is not None and off == st['ret']:
            d = st['clk'] - c[0] - st['start']
            samples[st['in']].append((st['size'], d))
            st['gfx'] += d
            st['in'] = None

    m.mu.hook_add(UC_HOOK_CODE, hook)

    def on_event(m, kind):
        if kind == 'tick':
            st['clk'] += BIOS_TICK
        d = st['clk'] - st['last'] - st['gfx']
        st['last'] = st['clk']
        st['gfx'] = 0
        base[(st['lk'], kind)].append(d)
        st['lk'] = kind
        if m.events >= limit:
            m.stop()
    m.on_event = on_event
    m.run()
    import statistics
    for name, v in samples.items():
        # 워드*줄 에 대한 선형 맞춤: clk = a*words*rows + b*rows + c
        rows = [(w * h, h, 1, d) for (w, h, x), d in v]
        if name == 'list':
            rows = [(w * h * n, h * n, n, d) for (w, h, n), d in v]
        # 최소제곱 (3x3)
        import itertools
        S = [[0.0] * 3 for _ in range(3)]
        T = [0.0] * 3
        for a, b, c1, d in rows:
            x = (a, b, c1)
            for i in range(3):
                T[i] += x[i] * d
                for j in range(3):
                    S[i][j] += x[i] * x[j]
        try:
            import numpy
            sol = numpy.linalg.lstsq(numpy.array(S), numpy.array(T), rcond=None)[0]
        except Exception:
            sol = (0, 0, 0)
        print('%-5s n=%6d  per_word=%.1f per_row=%.1f per_call=%.1f  mean=%.0f' %
              (name, len(v), sol[0], sol[1], sol[2], statistics.mean(d for _, d in v)))
    for k, v in sorted(base.items(), key=lambda kv: -sum(kv[1])):
        v = sorted(v)
        print('%-22s n=%6d mean=%7.0f med=%6d p75=%6d' % (k, len(v), sum(v) / len(v), v[len(v) // 2], v[len(v) * 3 // 4]))


if __name__ == '__main__' and len(sys.argv) > 3 and sys.argv[3] == 'gfx':
    gfx_model(sys.argv[1], int(sys.argv[2]))
