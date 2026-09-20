# 원본(emu.py)과 C 판(hosttest.exe)을 같은 입력으로 돌려 사건마다 상태를 맞춰 본다.
#   python tools/difftest.py script.txt [최대 사건 수]
# test/ 폴더에 trace.bin, font.bin 을 만들고 hosttest.exe 를 돌린다.
# 다르면 그 사건에서 원본의 데이터 세그먼트/화면을 덤프해 바이트 차이를 보여 준다.
import struct, sys, os, zlib, subprocess
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import emu

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
TEST = os.path.join(ROOT, 'test')
KIND = {'tick': 1, 'retrace': 2, 'pit': 3, 'idle': 4}
IGNORE = [(0x2AC7, 0x2AD0), (0x2AE0, 0x2AE4), (0x2AE9, 0x2AEB), (0x3287, 0x3289)]


def state(m):
    d = bytearray(m.mu.mem_read(m.dsbase, 0x7130))
    for a, b in IGNORE:
        d[a:b + 1] = bytes(b - a + 1)
    return bytes(d), bytes(m.vram())


def crc(m):
    d, v = state(m)
    c = zlib.crc32(d)
    c = zlib.crc32(v, c)
    c = zlib.crc32(bytes([m.port3d9]), c)
    return c


def run_emu(script, limit, stop_at=None):
    ev, shots = emu.load_script(script)
    m = emu.Machine(ev)
    out = bytearray()

    def on_event(m, kind):
        if stop_at is not None:
            if m.events == stop_at:
                m.stop()
            return
        out.extend(struct.pack('<BI', KIND[kind], crc(m)))
        if m.events >= limit:
            m.stop()
    m.on_event = on_event
    m.run()
    return m, out


def main():
    script = sys.argv[1]
    limit = int(sys.argv[2]) if len(sys.argv) > 2 else 200000
    os.makedirs(TEST, exist_ok=True)
    m, trace = run_emu(script, limit)
    open(os.path.join(TEST, 'trace.bin'), 'wb').write(trace)
    open(os.path.join(TEST, 'font.bin'), 'wb').write(emu.load_font())
    print('emu: %d events' % (len(trace) // 5))
    exe = os.path.join(ROOT, 'hosttest.exe')
    r = subprocess.run([exe, script, os.path.join(TEST, 'trace.bin'), os.path.join(TEST, 'font.bin'), TEST],
                       capture_output=True, text=True)
    print(r.stdout.strip())
    if r.returncode != 1:
        return
    n = int(r.stdout.split('event')[1].split(':')[0])
    m2, _ = run_emu(script, limit, stop_at=n)
    d, v = state(m2)
    cd = bytearray(open(os.path.join(TEST, 'c_ds.bin'), 'rb').read()[:0x7130])
    for a, b in IGNORE:
        cd[a:b + 1] = bytes(b - a + 1)
    cv = open(os.path.join(TEST, 'c_vram.bin'), 'rb').read()
    diffs = [i for i in range(0x7130) if d[i] != cd[i]]
    print('DS diffs (%d):' % len(diffs))
    for i in diffs[:40]:
        print('  %04x  emu %02x  c %02x' % (i, d[i], cd[i]))
    vd = [i for i in range(0x4000) if v[i] != cv[i]]
    print('VRAM diffs (%d):' % len(vd), ' '.join('%04x' % i for i in vd[:20]))
    print('emu 3D9 %02x' % m2.port3d9)
    m2.save_png(os.path.join(TEST, 'emu_at_mismatch.png'))


if __name__ == '__main__':
    main()
