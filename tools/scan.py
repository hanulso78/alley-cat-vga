# 1차 흐름 추적: 함수/간접분기/인터럽트/포트 목록
import struct, sys, collections
from capstone import *
from capstone.x86 import *
E=open('allycat.exe','rb').read(); IMG=E[0x200:]
CSB=0x7230; CEND=len(IMG)
md=Cs(CS_ARCH_X86,CS_MODE_16); md.detail=True
code={}; funcs=set([0]); labels=set(); indirect=[]
todo=[0]
extra=[int(x,16) for x in sys.argv[1:]]
todo+=extra; funcs|=set(extra)
while todo:
    o=todo.pop(); work=[o]
    while work:
        off=work.pop()
        while True:
            if off in code or CSB+off>=CEND: break
            ins=next(md.disasm(IMG[CSB+off:CSB+off+16],off),None)
            if ins is None: print('BAD',hex(off)); break
            code[off]=ins; m=ins.mnemonic
            if m=='call':
                op=ins.operands[0]
                if op.type==X86_OP_IMM:
                    t=op.imm&0xffff
                    if t not in funcs: funcs.add(t); todo.append(t)
                else: indirect.append(ins)
            elif m=='jmp':
                op=ins.operands[0]
                if op.type==X86_OP_IMM:
                    t=op.imm&0xffff; labels.add(t); work.append(t)
                else: indirect.append(ins)
                break
            elif m.startswith('j') or m.startswith('loop'):
                t=ins.operands[0].imm&0xffff; labels.add(t); work.append(t)
            elif m in('ret','retf','iret','hlt','ljmp'): 
                if m=='ljmp': indirect.append(ins)
                break
            off+=ins.size
print('funcs',len(funcs),'insns',len(code),'bytes',sum(i.size for i in code.values()))
for i in indirect: print('IND %04x %s %s'%(i.address,i.mnemonic,i.op_str))
cnt=collections.Counter()
for a in sorted(code):
    i=code[a]
    if i.mnemonic in('int','in','out','cli','sti','lcall','ljmp','iret','retf') or 'es:' in i.op_str and i.mnemonic=='mov' and False:
        cnt[(i.mnemonic,i.op_str)]+=1
for k,v in sorted(cnt.items()): print(k,v)
# gaps
a=0; gaps=[]
while a<CEND-CSB:
    if a in code: a+=code[a].size; continue
    b=a
    while b<CEND-CSB and b not in code: b+=1
    gaps.append((a,b)); a=b
for g in gaps: print('GAP %04x-%04x %d'%(g[0],g[1],g[1]-g[0]))
print(' '.join('%04x'%f for f in sorted(funcs)))
