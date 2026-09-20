import sys
from capstone import *
E=open('allycat.exe','rb').read(); IMG=E[0x200:]
md=Cs(CS_ARCH_X86,CS_MODE_16); md.skipdata=True
a=int(sys.argv[1],16); n=int(sys.argv[2],16)
for ins in md.disasm(IMG[0x7230+a:0x7230+a+n],a):
    print('%04x %-12s %s %s'%(ins.address,ins.bytes.hex(),ins.mnemonic,ins.op_str))
