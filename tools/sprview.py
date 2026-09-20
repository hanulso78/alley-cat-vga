# 데이터 세그먼트의 그림 보기: python tools/sprview.py out.png ofs:w:h[:label] ...  (w=워드, h=줄)
import sys, struct
from PIL import Image, ImageDraw
E = open('allycat.exe', 'rb').read(); D = E[0x200 + 0x100:0x200 + 0x7230]
PAL = [(0, 0, 0), (0, 170, 170), (170, 0, 170), (170, 170, 170)]
items = []
for a in sys.argv[2:]:
    p = a.split(':'); items.append((int(p[0], 16), int(p[1], 0), int(p[2], 0), p[3] if len(p) > 3 else p[0]))
S = 4; cols = 6; cw = 180; ch = 140
rows = (len(items) + cols - 1) // cols
im = Image.new('RGB', (cols * cw, rows * ch), (40, 40, 40)); dr = ImageDraw.Draw(im)
for i, (o, w, h, lab) in enumerate(items):
    ox = (i % cols) * cw + 4; oy = (i // cols) * ch + 12
    dr.text((ox, oy - 11), lab, fill=(255, 255, 0))
    for y in range(h):
        for x in range(w * 8):
            b = D[o + y * w * 2 + x // 4]
            c = (b >> (6 - 2 * (x % 4))) & 3
            dr.rectangle([ox + x * 2, oy + y * 2, ox + x * 2 + 1, oy + y * 2 + 1], fill=PAL[c])
im.save(sys.argv[1])
