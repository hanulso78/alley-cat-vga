# 원본을 "IBM PC 속도"로 돌린다: 가상 시간을 명령어마다의 8088 클럭 수로 흘린다.
# (emu.py 는 사건마다 정해진 만큼 흘려서 C 판과 맞춰 보는 용도, 이것은 속도 기준용)
#   python tools/pcspeed.py script.txt     -> log 줄마다 cat_x 등을 찍는다
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import emu, cpucost
from unicorn import UC_HOOK_CODE

MHZ = 4772727


class PCMachine(emu.Machine):
    def __init__(self, script):
        super().__init__(script)
        self.clk = 0
        cache = {}

        def hook(mu, addr, size, ud):
            c = cache.get(addr)
            if c is None:
                ins = next(cpucost.md.disasm(bytes(mu.mem_read(addr, size)), addr))
                c = (cpucost.clocks(ins), ins.prefix[0] in (0xF2, 0xF3))
                cache[addr] = c
            self.clk += 17 if c[1] else c[0]
        self.mu.hook_add(UC_HOOK_CODE, hook)

    def advance(self, us, kind):
        if kind == 'tick':
            self.clk += cpucost.BIOS_TICK
        self.vtime = self.clk * 1000000 // MHZ
        self.events += 1
        while self.sp < len(self.script) and self.script[self.sp][0] <= self.vtime:
            self.apply(self.script[self.sp])
            self.sp += 1
        if self.on_event:
            self.on_event(self, kind)


def main():
    ev, _ = emu.load_script(sys.argv[1])
    logs = []
    for ln in open(sys.argv[1]):
        p = ln.split()
        if len(p) >= 2 and p[1] == 'log':
            logs.append(int(float(p[0]) * 1e6))
    m = PCMachine([e for e in ev if e[1] != 'quit'])
    st = {'i': 0}
    end = max(e[0] for e in ev)

    def on_event(m, kind):
        while st['i'] < len(logs) and logs[st['i']] <= m.vtime:
            print('%.3f cat_x=%d cat_y=%d room=%d lives=%d' % (logs[st['i']] / 1e6, m.rd16(0x579), m.rd8(0x57b),
                                                            m.rd16(4), m.rd8(0x1f80)))
            st['i'] += 1
        if m.vtime >= end:
            m.stop()
    m.on_event = on_event
    m.run()


if __name__ == '__main__':
    main()
