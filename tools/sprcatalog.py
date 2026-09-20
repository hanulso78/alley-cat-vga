# 원본을 여러 시나리오로 돌리며 그리기 함수에 넘어간 그림(데이터 세그먼트 위치, 크기)을 모은다.
#   python tools/sprcatalog.py test/*.txt > tools/sprites.txt
import sys, os, struct, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import emu
from unicorn import UC_HOOK_CODE
from unicorn.x86_const import *

ROUT = {0x2ccc: 'mask', 0x2d35: 'and', 0x2d9d: 'blit', 0x2d70: 'rows', 0x2b24: 'list',
        0x3365: 'or', 0x4fdf: 'or3'}
found = collections.OrderedDict()


def run(script):
    ev, _ = emu.load_script(script)
    m = emu.Machine(ev)
    cs = m.cs * 16

    def hook(mu, addr, size, ud):
        off = addr - cs
        r = ROUT[off]
        R = lambda reg: mu.reg_read(reg)
        ds_now = R(UC_X86_REG_DS)
        es = R(UC_X86_REG_ES)
        room = m.rd16(4)
        pal = m.port3d9
        if r == 'list':
            bx = R(UC_X86_REG_BX)
            cx = m.rd16(bx)
            p = bx + 2
            while True:
                si = m.rd16(p)
                if si == 0xffff:
                    break
                key = ('list', si, cx & 0xff, cx >> 8)
                found.setdefault(key, set()).add((room, pal & 0x20))
                p += 4
            return
        si = R(UC_X86_REG_SI)
        cx = R(UC_X86_REG_CX)
        if r == 'or':
            cx = 0x1e02
        if r == 'or3':
            cx = 0x0c03
        if r == 'rows':
            key = ('rows', si, cx & 0xff, cx >> 8, R(UC_X86_REG_AX) & 0xff)
        else:
            key = (r, si, cx & 0xff, cx >> 8)
        found.setdefault(key, set()).add((room, pal & 0x20))

    for a in ROUT:
        m.mu.hook_add(UC_HOOK_CODE, hook, None, cs + a, cs + a)
    m.run()


for s in sys.argv[1:]:
    run(s)
    print('# done', s, len(found), file=sys.stderr)
for k, v in sorted(found.items(), key=lambda kv: kv[0][1]):
    rooms = sorted(set(r for r, p in v))
    pals = sorted(set(p for r, p in v))
    print('%-5s %04x %2d %2d %s rooms=%s pal=%s' % (k[0], k[1], k[2], k[3], ' '.join(map(str, k[4:])),
                                                  ','.join(map(str, rooms)), ','.join(str(p // 32) for p in pals)))
