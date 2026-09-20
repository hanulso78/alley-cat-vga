# -*- coding: utf-8 -*-
"""movie.exe 의 MOVIE_TRACE 기록으로 배우 움직임 검사 (60fps 기준)
   줄: 시각(us) 열쇠 보이는x 보이는y 실제x 실제y 그림
   배우마다: 움직인 프레임 수, 한 프레임 최대 이동, 튄 횟수(>8점), 멈칫(목표가 2점 넘게
   떨어졌는데 한 프레임 안 움직임), 뒷걸음(방향 반대로), 평균/최대 뒤처짐"""
import sys, collections
tr = collections.defaultdict(list)
for ln in open(sys.argv[1]):
    p = ln.split()
    if len(p) < 7: continue
    tr[p[1]].append((float(p[0]), int(p[2]), int(p[3]), float(p[4]), float(p[5]), p[6]))
print('%-7s %5s %5s %4s %4s %4s %4s %5s %5s %5s' % ('key','n','move','maxd','jump','stal','back','lag','lagmx','shape'))
for k, v in sorted(tr.items(), key=lambda kv: kv[0]):
    # 같은 프레임에 두 번 합친 것은 마지막만
    fr = {}
    for e in v: fr[round(e[0] / 16666.7)] = e
    ks = sorted(fr)
    move = maxd = jump = stall = back = 0; lag = []; shapes = 0
    pdx = pdy = 0
    for a, b in zip(ks, ks[1:]):
        if b != a + 1: pdx = pdy = 0; continue
        e0, e1 = fr[a], fr[b]
        dx, dy = e1[1] - e0[1], e1[2] - e0[2]
        tj = abs(e1[3] - e0[3]) + abs(e1[4] - e0[4])
        d = max(abs(dx), abs(dy))
        if e1[5] != e0[5]: shapes += 1
        if tj > 24: pdx = pdy = 0; continue      # 순간이동(방 바뀜 등)
        if d: move += 1
        maxd = max(maxd, d)
        if d > 8: jump += 1
        l = max(abs(e1[3] - e1[1]), abs(e1[4] - e1[2]))
        lag.append(l)
        if d == 0 and max(abs(e0[3] - e0[1]), abs(e0[4] - e0[2])) > 2: stall += 1
        if (dx * pdx < 0) or (dy * pdy < 0): back += 1
        if dx or dy: pdx, pdy = dx, dy
    if not lag: continue
    print('%-7s %5d %5d %4d %4d %4d %4d %5.1f %5.0f %5d' % (k, len(ks), move, maxd, jump, stall, back,
          sum(lag) / len(lag), max(lag), shapes))
