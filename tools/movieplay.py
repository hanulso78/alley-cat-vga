# -*- coding: utf-8 -*-
"""플레이 영상용 입력 찾기 - movie.exe plan 을 되풀이해 돌려 빔 탐색으로 키 입력을 고른다.

   python tools/movieplay.py 결과.txt [길이초]

   - 게임은 결정적이다 (가상 시간 = 8088 클럭).  그래서 처음부터 같은 입력을 주면
     늘 같은 판이 된다.  0.5초마다 이어 붙일 입력 후보를 여러 개 돌려 보고
     데이터 세그먼트로 점수를 매겨 좋은 것 몇 개(빔)만 남긴다.
   - 연출: 어느 창문이든 들어갈 방은 목표 방이 되게 방 표(DS:0421..0431)를
     바꿔 둔다 (게임이 창문에 따라 방을 고르는 표).  나머지는 진짜로 논다.
"""
import os, sys, struct, subprocess, tempfile, random, shutil
from concurrent.futures import ThreadPoolExecutor

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
EXE = os.path.join(ROOT, 'movie.exe')
SPR = os.path.join(ROOT, 'ALLEY256.SPR')
FONT = os.path.join(ROOT, 'test', 'font.bin')
WORK = tempfile.mkdtemp(prefix='movieplay_')
DSSIZE = 0x7130

STEP = 0.5
LOOK = 1.0
BEAM = 6
DIRS = [None, 'left', 'right', 'up', 'down', 'pgup', 'pgdn', 'home', 'end']
ACTIONS = [(d, a) for a in (False, True) for d in DIRS]

# 타이틀 -> 메뉴 -> 시작
PREFIX = [(10.0, 'down n'), (10.1, 'up n'), (11.2, 'down n'), (11.3, 'up n'),
          (12.4, 'down k'), (12.5, 'up k'), (13.4, 'down space'), (13.5, 'up space')]
START = 14.0


class DS:
    def __init__(self, b):
        self.b = b

    def B(self, o):
        return self.b[o]

    def W(self, o):
        return self.b[o] | self.b[o + 1] << 8

    def S(self, o):                       # 부호 있는 바이트
        v = self.b[o]
        return v - 256 if v >= 128 else v


def run(events, snaps, tag):
    """events: [(t, 문자열)], snaps: [초] -> {초: DS}"""
    fn = os.path.join(WORK, 's%s.txt' % tag)
    out = os.path.join(WORK, 'd%s.bin' % tag)
    end = max(snaps) + 0.01
    with open(fn, 'w') as f:
        for t, s in sorted(events, key=lambda e: e[0]):
            if t < end:
                f.write('%.4f %s\n' % (t, s))
        f.write('%.4f quit\n' % end)
    subprocess.run([EXE, 'plan', fn, SPR, FONT, out, ','.join('%.4f' % t for t in snaps)],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    res = {}
    data = open(out, 'rb').read()
    rec = 8 + DSSIZE
    for k in range(len(data) // rec):
        t = struct.unpack_from('<d', data, k * rec)[0]
        res[round(t, 4)] = DS(data[k * rec + 8:(k + 1) * rec])
    return [res.get(round(t, 4)) for t in snaps]


def action_events(t0, t1, act):
    d, alt = act
    ev = []
    for k in ([d] if d else []) + (['alt'] if alt else []):
        ev.append((t0, 'down ' + k))
        ev.append((t1, 'up ' + k))
    return ev


# ---------------------------------------------------------------- 점수 ------
ROOM, PREV_ROOM, LIVES = 0x0004, 0x0006, 0x1F80
CAT_X, CAT_Y, CAT_VDIR = 0x0579, 0x057B, 0x0571
EXIT_ROOM, CAT_CAUGHT, ROOM_CLEARED = 0x0551, 0x0552, 0x0553
DOG_HAS_CAT = 0x1CB8
WINDOW_ANIM, WINDOW_X, WINDOW_Y = 0x1665, 0x1666, 0x1668


def dist(ds, x, y):
    return abs(ds.W(CAT_X) + 12 - x) + abs(ds.B(CAT_Y) + 7 - y)


def room_progress(ds, r):
    """방 안에서 할 일을 얼마나 했나 (클수록 좋다)"""
    s = 0
    if r == 1:
        if ds.W(ROOM) == 2:
            r = 2
            s += 200000
        else:
            return -ds.B(CAT_Y) * 30
    if r == 2:
        if ds.B(0x05F3):                                # 빠지는 중
            return -9e7
        left = ds.B(0x3410)
        s += (12 - left) * 60000
        # 숨 (틱): 거품이 나오기 시작하는 시간(판마다 표)의 60% 가 지나면 물 위로
        air = (ds.W(0x057D) - ds.W(0x05F1)) & 0xFFFF
        bubble = ds.W(0x0589 + ds.W(0x0008) * 2)
        if air * 5 >= bubble * 3:
            return s - ds.B(CAT_Y) * 3000 - air * 500
        near = [dist(ds, ds.W(0x3447 + 2 * i) + 4, ds.B(0x3477 + i) + 3)
                for i in range(12) if not ds.B(0x34A7 + i)]
        if near:
            s -= min(near) * 40
        return s
    if r == 3:
        s += (3 - ds.B(0x37AF)) * 100000
        return s - ds.B(CAT_Y) * 60
    if r == 4:
        s += (4 - ds.B(0x3ED8)) * 100000
        near = [dist(ds, ds.W(0x3ECC + 2 * i) + 8, ds.B(0x3ED4 + i) + 6)
                for i in range(4) if not ds.B(0x3EAE + i) and not ds.B(0x3EB2 + i)]
        if near:
            s -= min(near) * 40
        return s
    if r == 5:
        if ds.B(0x40B1):
            s += 100000 - dist(ds, ds.W(0x40B2) + 4, ds.B(0x40B4) + 2) * 60
        else:
            s -= dist(ds, ds.W(0x40A8) + 12, ds.B(0x40AA) + 8) * 60
        return s
    if r == 6:
        levels = [ds.B(0x44C4 + i) for i in range(12)]
        s -= sum(levels) * 20000
        s += (12 - ds.B(0x44D6)) * 100000
        near = [dist(ds, ds.W(0x4481 + 2 * i) + 8, ds.B(0x4499 + i)) for i in range(12) if levels[i]]
        if near:
            s -= min(near) * 40
        return s
    if r == 7:
        return -ds.B(CAT_Y) * 400
    return 0


def score(goal, ds, lives0):
    kind, r = goal
    if ds is None:
        return -1e9
    s = 0.0
    if ds.B(LIVES) < lives0:
        return -1e8
    if ds.B(DOG_HAS_CAT):
        return -5e7
    room = ds.W(ROOM)
    if kind == 'enter':
        if room == r or (r == 1 and room == 2):
            return 1e7
        if room != 0:
            return 1e6                      # 다른 방이라도 들어가긴 했다
        s -= ds.B(CAT_Y) * 25
        a = ds.B(WINDOW_ANIM)
        if 5 <= a < 0x19:
            wx, wy = ds.W(WINDOW_X) + 16, ds.B(WINDOW_Y)
            dx = abs(ds.W(CAT_X) + 12 - wx)
            dy = ds.B(CAT_Y) + 14 - wy
            s += 8000 - dx * 40 - abs(dy + 6) * 25
        return s
    if kind == 'clear':
        if ds.B(CAT_CAUGHT):
            return -5e7
        if room == 0:
            return 1e7 if ds.B(ROOM_CLEARED) else -3e7
        if ds.B(ROOM_CLEARED):
            return 1e7
        return room_progress(ds, r)
    return s


def success(goal, ds):
    kind, r = goal
    room = ds.W(ROOM)
    if kind == 'enter':
        return room != 0
    if kind == 'clear':
        return bool(ds.B(ROOM_CLEARED)) or room == 0
    return False


def director_pokes(t, goal):
    kind, r = goal
    ev = []
    if kind == 'enter':
        for i in range(12):
            ev.append((t, 'poke %x %x' % (0x421 + i, r if r != 7 else 1)))
        for i in range(5):
            ev.append((t, 'poke %x %x' % (0x42D + i, r if r != 7 else 1)))
        ev.append((t, 'poke 418 %x' % (1 if r == 7 else 0)))
    return ev


def main():
    out = sys.argv[1]
    length = float(sys.argv[2]) if len(sys.argv) > 2 else 180.0
    plan = [('enter', 4), ('clear', 4), ('enter', 1), ('clear', 1), ('enter', 6), ('clear', 6),
            ('enter', 7), ('clear', 7), ('enter', 5), ('clear', 5), ('enter', 3), ('clear', 3),
            ('enter', 7), ('clear', 7), ('enter', 1), ('clear', 1), ('enter', 4), ('clear', 4),
            ('enter', 6), ('clear', 6), ('enter', 7), ('clear', 7)]
    rnd = random.Random(1984)
    base = list(PREFIX)
    beam = [(0.0, [], None)]
    t = START
    gi = 0
    goal = plan[0]
    base += director_pokes(t, goal)
    lives0 = run(base, [t])[0].B(LIVES) if False else 3
    pool = ThreadPoolExecutor(max_workers=max(2, (os.cpu_count() or 4) - 2))
    while t + STEP <= length:
        jobs = []
        for bi, (sc, ev, last) in enumerate(beam):
            acts = list(ACTIONS)
            rnd.shuffle(acts)
            acts = acts[:12]
            if last not in acts:
                acts[0] = last if last else (None, False)
            for ai, act in enumerate(acts):
                new = ev + action_events(t, t + STEP, act)
                roll = new + action_events(t + STEP, t + STEP + LOOK, act)
                jobs.append((new, act, base + roll, '%d_%d' % (bi, ai)))
        results = list(pool.map(lambda j: (j, run(j[2], [t + STEP, t + STEP + LOOK], j[3])), jobs))
        cand = []
        for (new, act, _, _), (d1, d2) in results:
            s = score(goal, d1, lives0) * 0.4 + score(goal, d2, lives0) * 0.6
            if d1 is not None and success(goal, d1) and score(goal, d1, lives0) > 0:
                s += 1e9
            cand.append((s, new, act, d1))
        cand.sort(key=lambda c: -c[0])
        best = cand[0]
        d1 = best[3]
        t += STEP
        print('%6.1f %-6s %d  score %12.0f  cat %3d,%3d room %d lives %d act %s' %
              (t, goal[0], goal[1], best[0], d1.W(CAT_X), d1.B(CAT_Y), d1.W(ROOM), d1.B(LIVES),
               best[2]), flush=True)
        if best[0] <= -5e7 and d1 is not None:
            # 어떤 입력으로도 피할 수 없었다 (목숨을 잃었거나 방에서 쫓겨남): 받아들이고 다음으로
            lives0 = min(lives0, d1.B(LIVES))
            if goal[0] == 'clear' and d1.W(ROOM) == 0 and not d1.B(ROOM_CLEARED):
                gi += 1
                goal = plan[gi] if gi < len(plan) else ('wait', 0)
                base += director_pokes(t, goal)
                print('--- failed room, goal -> %s %d at %.1f' % (goal[0], goal[1], t), flush=True)
        if success(goal, d1) and best[0] > 0:
            # 목표를 이뤘다: 가장 좋은 것만 남기고 다음 목표로
            beam = [(best[0], best[1], best[2])]
            lives0 = d1.B(LIVES)
            gi += 1
            if gi < len(plan):
                goal = plan[gi]
                base += director_pokes(t, goal)
            else:
                goal = ('wait', 0)
            print('--- goal -> %s %d at %.1f' % (goal[0], goal[1], t), flush=True)
        else:
            seen = set()
            beam = []
            for s, new, act, d in cand:
                key = (d.W(CAT_X), d.B(CAT_Y), d.W(ROOM)) if d else None
                if key in seen:
                    continue
                seen.add(key)
                beam.append((s, new, act))
                if len(beam) >= BEAM:
                    break
        with open(out, 'w') as f:
            for tt, s in sorted(base + beam[0][1], key=lambda e: e[0]):
                f.write('%.4f %s\n' % (tt, s))
            f.write('%.4f quit\n' % length)
    shutil.rmtree(WORK, ignore_errors=True)


if __name__ == '__main__':
    main()
