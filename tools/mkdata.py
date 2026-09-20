# ALLYCAT.EXE 의 데이터 세그먼트 -> data.c
#   python tools/mkdata.py > data.c
# allycat.h 의 이름표(#define 이름 0xXXXX / DB(0xXXXX) / DW(0xXXXX ...))를 읽어
# 그 자리마다 주석으로 이름을 달아 준다.
import re, sys, os

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..')
E = open(os.path.join(ROOT, 'allycat.exe'), 'rb').read()
D = E[0x200 + 0x100:0x200 + 0x7230]

labels = {}
for ln in open(os.path.join(ROOT, 'allycat.h'), encoding='utf-8'):
    m = re.match(r'#define\s+(\w+)(\([^)]*\))?\s+(?:D[BW]\()?(0x[0-9A-Fa-f]{4})', ln)
    if not m:
        continue
    name, arg, off = m.group(1), m.group(2), int(m.group(3), 16)
    labels.setdefault(off, []).append(name + (arg or ''))

sys.stdout.reconfigure(encoding='utf-8', newline='\n')
w = sys.stdout.write
w('''/* ============================================================================
 *  data.c  -  원본 데이터 세그먼트 (DS=0010) 초기값
 * ----------------------------------------------------------------------------
 *  tools/mkdata.py 가 ALLYCAT.EXE 에서 뽑아 만든 파일이다.  고치지 말 것.
 *  주석의 이름은 allycat.h 의 이름표.  나머지 64K 는 0 이다.
 * ========================================================================== */
#include "allycat.h"

uint8_t ds[0x10000] = {
''')
i = 0
n = len(D)
while i < n:
    if i in labels:
        w('    /* %04X %s */\n' % (i, ', '.join(labels[i])))
    j = i + 1
    while j < n and j - i < 16 and j not in labels:
        j += 1
    w('    ' + ''.join('0x%02X,' % b for b in D[i:j]) + '\n')
    i = j
w('};\n')
