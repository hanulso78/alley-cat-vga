# ALLYCAT.EXE 역어셈블 목록 만들기
#   python tools/mklist.py > listing.asm
# 코드 세그먼트(CS=0723, 선형 7230)는 손으로 짠 어셈블리.  진입점과 점프 테이블에서
# 흐름을 따라가며 코드를 찾고 나머지는 데이터로 찍는다.  데이터 세그먼트는 DS=0010.
# 이름표는 tools/names.txt ("c 오프셋 이름" = 코드, "d 오프셋 이름 [크기]" = DS 변수)
import struct, sys, re, collections
from capstone import *
from capstone.x86 import *

E = open('allycat.exe', 'rb').read()
IMG = E[0x200:]
CSB = 0x7230
CSIZE = len(IMG) - CSB
DSB = 0x100
JUMPTABLES = {0x0250: 8}        # cs 오프셋 -> 항목 수

CNAMES, DNAMES, CCOMM = {}, {}, {}
DSIZE = {}
for ln in open('tools/names.txt', encoding='utf-8'):
    c = ''
    if '#' in ln:
        ln, c = ln.split('#', 1)
    p = ln.split()
    if len(p) < 3:
        continue
    o = int(p[1], 16)
    if p[0] == 'c':
        CNAMES[o] = p[2]
        if c.strip(): CCOMM[o] = c.strip()
    else:
        DNAMES[o] = p[2]
        DSIZE[o] = int(p[3], 0) if len(p) > 3 else 1

def dname(v):
    if v in DNAMES: return DNAMES[v]
    # 배열 안쪽
    for o, n in DNAMES.items():
        if o < v < o + DSIZE[o]:
            return '%s+%d' % (n, v - o)
    return None

md = Cs(CS_ARCH_X86, CS_MODE_16)
md.detail = True
code, funcs, labels = {}, set([0]), set()
roots = [0] + list(CNAMES)
for t, n in JUMPTABLES.items():
    for k in range(n):
        v = struct.unpack_from('<H', IMG, CSB + t + 2 * k)[0]
        roots.append(v); funcs.add(v)
funcs |= set(CNAMES)
todo = list(roots)
while todo:
    o = todo.pop(); work = [o]
    while work:
        off = work.pop()
        while off < CSIZE and off not in code:
            ins = next(md.disasm(IMG[CSB + off:CSB + off + 16], off), None)
            if ins is None: break
            code[off] = ins; m = ins.mnemonic
            if m == 'call' and ins.operands[0].type == X86_OP_IMM:
                t = ins.operands[0].imm & 0xffff
                if t not in funcs: funcs.add(t); todo.append(t)
            elif m == 'jmp':
                if ins.operands[0].type == X86_OP_IMM:
                    t = ins.operands[0].imm & 0xffff; labels.add(t); work.append(t)
                break
            elif m[0] == 'j' or m.startswith('loop'):
                t = ins.operands[0].imm & 0xffff; labels.add(t); work.append(t)
            elif m in ('ret', 'retf', 'iret', 'hlt'):
                break
            off += ins.size

def cname(o):
    return CNAMES.get(o, 'sub_%04x' % o)

def fmt(ins):
    m, s = ins.mnemonic, ins.op_str
    cm = []
    if m == 'call' and ins.operands[0].type == X86_OP_IMM:
        return 'call   ' + cname(ins.operands[0].imm & 0xffff), None
    if (m[0] == 'j' or m.startswith('loop')) and ins.operands and ins.operands[0].type == X86_OP_IMM:
        t = ins.operands[0].imm & 0xffff
        return '%-6s %s' % (m, cname(t) if t in CNAMES else 'loc_%04x' % t), None
    for op in ins.operands:
        if op.type == X86_OP_MEM:
            seg = op.mem.segment
            d = op.mem.disp & 0xffff
            if seg in (0, X86_REG_DS) and op.mem.base == 0 and op.mem.index == 0:
                n = dname(d)
                if n: cm.append(n)
            elif seg in (0, X86_REG_DS) and d >= 0x40 and not (op.mem.base == X86_REG_BP):
                n = dname(d)
                if n: cm.append('+' + n)
            elif seg == X86_REG_CS and d in CNAMES:
                cm.append('cs:' + CNAMES[d])
        elif op.type == X86_OP_IMM and m in ('mov', 'push', 'add', 'lea') and op.imm >= 0x40:
            n = DNAMES.get(op.imm & 0xffff)
            if n and ins.operands[0].type == X86_OP_REG and ins.operands[0].reg in (X86_REG_SI, X86_REG_DI, X86_REG_BX, X86_REG_BP):
                cm.append('&' + n)
    return '%-6s %s' % (m, s), (', '.join(cm) if cm else None)

w = sys.stdout.write
w('; ALLYCAT.EXE 코드 세그먼트 (CS=0723)  - tools/mklist.py 가 만든 목록\n')
a = 0
while a < CSIZE:
    if a in funcs:
        w('\n; ' + '-' * 70 + '\n')
        if a in CCOMM: w('; %s\n' % CCOMM[a])
        w('%s:\n' % cname(a))
    if a in code:
        ins = code[a]
        if a in labels and a not in funcs:
            w('  loc_%04x:\n' % a)
        t, c = fmt(ins)
        line = '%04x  %-8s  %-34s' % (a, ins.bytes.hex(), t)
        if c: line += ' ; ' + c
        w(line.rstrip() + '\n')
        a += ins.size
    else:
        b = a
        while b < CSIZE and b not in code: b += 1
        if a in JUMPTABLES:
            for k in range(JUMPTABLES[a]):
                v = struct.unpack_from('<H', IMG, CSB + a + 2 * k)[0]
                w('%04x  dw %s\n' % (a + 2 * k, cname(v)))
        else:
            for i in range(a, b, 16):
                ch = IMG[CSB + i:CSB + min(b, i + 16)]
                w('%04x  db %s   ; %s\n' % (i, ','.join('%02x' % x for x in ch),
                                          ''.join(chr(x) if 32 <= x < 127 else '.' for x in ch)))
        a = b
