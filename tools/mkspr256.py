# -*- coding: utf-8 -*-
"""ALLEYVGA.EXE 256색 그림 - ALLEY256.SPR 만들기

   쓰는 법 :  python tools/mkspr256.py            -> ALLEY256.SPR
              python tools/mkspr256.py --sheet 파일.png   -> 칠한 그림 모아 보기도

   원판 그림은 점마다 2비트(색 0..3)다.  여기서는 그림마다
       - 색 번호별 새 색 (VALUE)   None = 원래 CGA 색 그대로 (배경이 비치는 곳)
       - 위아래 그러데이션 (GRAD)
       - 윗가장자리 밝게 (EDGE)    - 검은 실루엣 그림에 입체감
       - 줄 구간마다 다른 색 (ROWS)
       - 체크무늬 디더를 두 색의 중간색으로 (SMOOTH, 기본 켬)
   를 정해서 데이터 세그먼트 점마다의 색 번호(팔레트 16..255)를 만든다.

   원래 CGA 색 그대로인 점(벽, 하늘, 담장처럼 채우기로 그린 곳)은 방마다의 색
   테마로 칠한다 (THEME: 방 8 x 높이 띠 4 x 색 4 = 팔레트 16..143).

   파일 구조는 col256.c 참고.
"""
import os, sys, struct

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
E = open(os.path.join(ROOT, 'allycat.exe'), 'rb').read()
D = E[0x200 + 0x100:0x200 + 0x7230]
DS_SIZE = len(D)


def rgb(h):
    """'#RRGGBB' -> 6비트 (r, g, b)"""
    h = h.lstrip('#')
    return tuple(int(h[i:i + 2], 16) * 63 // 255 for i in (0, 2, 4))


def mix(a, b, t=0.5):
    return tuple(int(round(a[i] * (1 - t) + b[i] * t)) for i in range(3))


# ============================================================================
#  CGA 16색을 대신할 색 (테마 밖에서 원래 색이 보일 때: 깜빡이는 바탕 등)
# ============================================================================
CGA_REMASTER = ['#000008', '#0c1878', '#1c781c', '#18a0a8', '#a81c18', '#8c2c90', '#a86018', '#b4aca4',
                '#404048', '#5864f0', '#60e864', '#5ce8f0', '#f06058', '#e860e0', '#f0e060', '#fcfcf4']

# ============================================================================
#  방마다의 색 테마: 색 0..3 을 높이 띠 넷(위에서 아래로)에 따라
#  방 0 골목, 1 탁자(어항), 2 어항 속, 3 책장, 4 치즈, 5 새장, 6 개, 7 사랑
#  팔레트 1 방: 1 청록 2 자홍 3 흰 / 팔레트 0 방(4,5,7): 1 녹색 2 빨강 3 갈색
# ============================================================================
THEME = {
    0: [('#07060e', '#07060e', '#08070f', '#0a0810'),                  # 검정
        ('#5e7e8a', '#546f7c', '#4a6068', '#3e5058'),                  # 청록: 담장 판자, 빨랫줄
        ('#2a1c48', '#3c2458', '#553068', '#6b3a70'),                  # 자홍: 해 질 녘 하늘
        ('#d8d0c8', '#d0c8c0', '#c8c0b8', '#c0b8b0')],                 # 흰
    1: [('#08060a',) * 4,
        ('#2c8c8c', '#288080', '#247474', '#206868'),
        ('#7a4a5a', '#704454', '#5a3040', '#4a2834'),                  # 벽지 -> 아래는 바닥
        ('#e8e0d0',) * 4],
    2: [('#02101c', '#021020', '#020c1c', '#020818'),
        ('#2a78b8', '#1f60a0', '#184c88', '#123a70'),                  # 물
        ('#a8e0f8', '#90d0f0', '#80c0e8', '#70b0e0'),                  # 수면
        ('#c8f0ff', '#b8e0f0', '#a8d0e8', '#98c0e0')],
    3: [('#08060a',) * 4,
        ('#3c8c78', '#347c6c', '#2c6c60', '#245c50'),
        ('#6c5438', '#644c34', '#4c3824', '#3c2c1c'),                  # 서재: 나무 벽
        ('#ece0c8',) * 4],
    4: [('#08060a',) * 4,
        ('#e8b828', '#e0b020', '#d8a818', '#d0a010'),                  # 치즈
        ('#5a2a2a', '#522626', '#3e1c1c', '#341818'),
        ('#a06828', '#986020', '#905818', '#885010')],
    5: [('#08060a',) * 4,
        ('#3c7a44', '#367040', '#30663a', '#2a5c34'),
        ('#6a3a3a', '#623434', '#4a2828', '#402222'),
        ('#b88848', '#b08040', '#a87838', '#a07030')],
    6: [('#08060a',) * 4,
        ('#4a9ca8', '#44909c', '#3e8490', '#387884'),
        ('#7c6a8a', '#746282', '#564868', '#4a3e5a'),
        ('#ece4dc',) * 4],
    7: [('#10040a', '#10040a', '#12050c', '#14060e'),
        ('#5a1a3a', '#6a2044', '#7c284e', '#8c3058'),                  # 사랑의 방 바탕
        ('#e83858', '#e03050', '#d82848', '#d02040'),                  # 하트 칸
        ('#f0c060', '#e8b858', '#e0b050', '#d8a848')],
}

# ============================================================================
#  그림 목록
#  (이름, [(자리, 워드 수, 줄 수), ...], 설정)
#     VALUE {값: 색}   GRAD {값: (위, 아래)}   EDGE {값: 색}
#     ROWS [(첫 줄, 끝 줄, {값: 색}), ...]    SMOOTH 기본 True    BYTES 워드 대신 바이트 수
# ============================================================================
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from spr256spec import SPRITES
from tweens import TWEENS


def quantize(assign, pal, first, count):
    """assign 의 색들을 count 색 이하로 줄여 pal[first..] 에 넣고, assign 값을 색 번호로 바꾼다"""
    uniq = sorted(set(assign.values()))
    if len(uniq) <= count:
        table = {c: first + i for i, c in enumerate(uniq)}
        for i, c in enumerate(uniq):
            pal[first + i] = c
    else:
        from PIL import Image
        vals = uniq                     # 색마다 한 번씩 (적게 쓰인 눈 색 같은 것도 남게)
        img = Image.new('RGB', (len(vals), 1))
        img.putdata([tuple(v * 4 for v in c) for c in vals])
        q = img.quantize(colors=count, method=Image.Quantize.MEDIANCUT)
        qp = q.getpalette()[:count * 3]
        cand = [tuple(qp[i * 3 + j] // 4 for j in range(3)) for i in range(count)]
        for i, c in enumerate(cand):
            pal[first + i] = c
        table = {}
        for c in uniq:
            table[c] = first + min(range(count), key=lambda i: sum((c[j] - cand[i][j]) ** 2 for j in range(3)))
    for k in assign:
        assign[k] = table[assign[k]]
    return len(uniq)


def colorize(px, cfg, ofs):
    """점 값 격자 px 를 cfg(spr256spec 의 설정)대로 칠한다 -> 색 (r,g,b) / None / 'CLEAR'"""
    h, width = len(px), len(px[0])
    value = {k: (rgb(v) if isinstance(v, str) else v) for k, v in cfg.get('VALUE', {}).items()}
    grad = {k: (rgb(a), rgb(b)) for k, (a, b) in cfg.get('GRAD', {}).items()}
    edge = {k: rgb(v) for k, v in cfg.get('EDGE', {}).items()}
    vary = {k: [rgb(c) for c in v] for k, v in cfg.get('VARY', {}).items()}
    rows_cfg = [(a, b, {k: (rgb(v) if isinstance(v, str) else v) for k, v in m.items()})
                for a, b, m in cfg.get('ROWS', [])]
    smooth = cfg.get('SMOOTH', True)

    # BG 값 중 가장자리와 이어진 점은 배경 (원래 색 그대로)
    outside = [[False] * width for _ in range(h)]
    bg = cfg.get('BG', set())
    inner = {k: rgb(v) for k, v in cfg.get('INNER', {}).items()}
    stack = [(x, y) for y in range(h) for x in range(width)
             if (x in (0, width - 1) or y in (0, h - 1)) and px[y][x] in bg]
    while stack:
        x, y = stack.pop()
        if outside[y][x]:
            continue
        outside[y][x] = True
        for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            if 0 <= nx < width and 0 <= ny < h and not outside[ny][nx] and px[ny][nx] in bg:
                stack.append((nx, ny))

    inner_rows = cfg.get('INNER_ROWS')
    if inner_rows:
        inner_rows = (inner_rows[0], rgb(inner_rows[1]))
    outline = cfg.get('OUTLINE')                 # (몸 값, 색): 몸 옆의 바깥 점
    clear = cfg.get('CLEAR', False)              # 바깥 점은 칠하지 않는다 (색 번호 4)
    if outline:
        ov, oc = outline[0], rgb(outline[1])

    def color_of(x, y):
        v = px[y][x]
        if v in bg:
            if outside[y][x]:
                if outline and any(0 <= nx < width and 0 <= ny < h and px[ny][nx] == ov
                                   for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1))):
                    return oc
                return 'CLEAR' if clear else None
            if inner_rows and y >= inner_rows[0]:
                return inner_rows[1]
            return inner.get(v)
        c = None
        for a, b, m in rows_cfg:
            if a <= y <= b and v in m:
                c = m[v]
        if v in grad:
            t = y / max(1, h - 1)
            c = mix(grad[v][0], grad[v][1], t)
        elif c is None and v in vary:
            k = (ofs // 16 + (x >> 2) * 5 + (y >> 3) * 3) % len(vary[v])
            c = vary[v][k]
        elif c is None and v in value:
            c = value[v]
        if c is not None and v in edge:
            if y == 0 or px[y - 1][x] != v:
                c = edge[v]
        return c

    out = [[color_of(x, y) for x in range(width)] for y in range(h)]
    if smooth:
        for y in range(1, h - 1):
            for x in range(1, width - 1):
                v = px[y][x]
                u = px[y][x - 1]
                if u != v and px[y][x + 1] == u and px[y - 1][x] == u and px[y + 1][x] == u                         and isinstance(out[y][x], tuple) and isinstance(out[y][x - 1], tuple):
                    out[y][x] = mix(out[y][x], out[y][x - 1])
    return out


def build():
    pal = [(0, 0, 0)] * 256
    col = bytearray(DS_SIZE * 4)
    # 원래 CGA 색 그대로 (0..3)
    for o in range(DS_SIZE):
        v = D[o]
        col[o * 4:o * 4 + 4] = bytes(((v >> 6) & 3, (v >> 4) & 3, (v >> 2) & 3, v & 3))
    # 테마: 16 + 방*16 + 띠*4 + 값
    for r in range(8):
        for v in range(4):
            for b in range(4):
                pal[16 + r * 16 + b * 4 + v] = rgb(THEME[r][v][b])
    assign = {}                         # (위치*4+점) -> 색 (r, g, b)
    clear_px = set()                    # 투명 (색 번호 4: 그릴 때 밑의 색을 그대로 둔다)

    used = []
    for name, regions, cfg in SPRITES:
        for (ofs, w, h) in regions:
            bpr = cfg.get('BYTES', 2 * w)       # 한 줄의 바이트 수
            width = w * 8
            px = [[(D[ofs + y * bpr + (x >> 2)] >> (6 - 2 * (x & 3))) & 3 for x in range(width)] for y in range(h)]
            out = colorize(px, cfg, ofs)
            for y in range(h):
                for x in range(width):
                    c = out[y][x]
                    if c is None:
                        continue
                    o = ofs + y * bpr + (x >> 2)
                    if o >= DS_SIZE:
                        continue
                    if c == 'CLEAR':
                        clear_px.add(o * 4 + (x & 3))
                    else:
                        assign[o * 4 + (x & 3)] = c
            used.append((name, ofs, w, h, bpr))

    # 사이 동작 그림 (tools/tweens.py): 원판 그림과 같은 규칙으로 칠한다
    cfg_by_name = {n: c for n, r, c in SPRITES}
    tween_list = []
    for name, frm, to, cname, rows, mirror in TWEENS:
        variants = [(frm, to, rows)]
        if mirror:
            variants.append((mirror[0], mirror[1], [r[::-1] for r in rows]))
        for f, t, rr in variants:
            px = [[0 if ch == '.' else int(ch) for ch in r] for r in rr]
            out = colorize(px, cfg_by_name[cname], f)
            k = len(tween_list)
            tween_list.append((f, t, len(rr[0]), len(rr)))
            for y in range(len(rr)):
                for x in range(len(rr[0])):
                    if isinstance(out[y][x], tuple):
                        assign[('T', k, y, x)] = out[y][x]
    # 그림 색은 팔레트 144..255 (112색) 에 맞게 줄인다
    n = quantize(assign, pal, 144, 112)
    tpix = [bytearray(w * h) for (f, t, w, h) in tween_list]
    for k, c in assign.items():
        if isinstance(k, tuple):
            ti, y, x = k[1], k[2], k[3]
            tpix[ti][y * tween_list[ti][2] + x] = c
        else:
            col[k] = c
    for k in clear_px:
        col[k] = 4
    remaster = b''.join(bytes(rgb(h)) for h in CGA_REMASTER)
    data = b'ALLEY256' + b''.join(bytes(c) for c in pal) + remaster + bytes(col)
    # 덧붙임: "TWEN" 개수(2) + (앞 그림 2, 뒤 그림 2, 너비 1, 높이 1, 점 너비*높이 - 0 = 투명)
    data += b'TWEN' + struct.pack('<H', len(tween_list))
    for (f, t, w, h), pixels in zip(tween_list, tpix):
        data += struct.pack('<HHBB', f, t, w, h) + bytes(pixels)
    return data, pal, col, used, n


def sheet(fn, pal, col, used):
    from PIL import Image, ImageDraw
    cw, ch = 200, 140
    cols = 6
    W = Image.new('RGB', (cols * cw, ((len(used) + cols - 1) // cols) * ch), (40, 40, 48))
    dr = ImageDraw.Draw(W)
    for i, (name, ofs, w, h, bpr) in enumerate(used):
        ox, oy = (i % cols) * cw + 4, (i // cols) * ch + 14
        dr.text((ox, oy - 12), '%s %04x' % (name, ofs), fill=(255, 255, 0))
        for y in range(h):
            for x in range(w * 8):
                o = ofs + y * bpr + (x >> 2)
                if o >= DS_SIZE:
                    continue
                c = col[o * 4 + (x & 3)]
                if c < 4:
                    rgbc = [(0, 0, 0), (0, 170, 170), (170, 0, 170), (170, 170, 170)][c]
                else:
                    rgbc = tuple(v * 255 // 63 for v in pal[c])
                dr.rectangle([ox + x * 2, oy + y * 2, ox + x * 2 + 1, oy + y * 2 + 1], fill=rgbc)
    W.save(fn)


if __name__ == '__main__':
    data, pal, col, used, n = build()
    out = os.path.join(ROOT, 'ALLEY256.SPR')
    open(out, 'wb').write(data)
    print('ALLEY256.SPR %d 바이트, 그림 색 %d개' % (len(data), n))
    if '--sheet' in sys.argv:
        sheet(sys.argv[sys.argv.index('--sheet') + 1], pal, col, used)
