# 대조 시험 시나리오 모음 -> test/*.txt
#   python tools/scenario.py
import random, os

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')


def keys(ev, t, k, hold=0.1):
    ev.append((t, 'down %s' % k))
    ev.append((t + hold, 'up %s' % k))


def start(ev, skill='k'):
    keys(ev, 3.0, 'n')
    keys(ev, 4.0, 'n')
    keys(ev, 5.0, skill)
    keys(ev, 6.0, 'space')


def force_room(ev, t, room):
    for i in range(12):
        ev.append((t, 'poke %x %x' % (0x421 + i, room)))
    for i in range(5):
        ev.append((t, 'poke %x %x' % (0x42D + i, room)))
    ev.append((t + 0.3, 'poke 551 1'))


def random_play(ev, t, end, seed, pool=('left', 'right', 'up', 'down', 'alt', 'pgup', 'home')):
    rnd = random.Random(seed)
    while t < end:
        k = rnd.choice(pool)
        hold = rnd.uniform(0.05, 1.2)
        keys(ev, t, k, hold)
        t += hold + rnd.uniform(0.0, 0.6)


def write(name, ev, end):
    ev.append((end, 'quit'))
    ev.sort(key=lambda e: e[0])
    with open(os.path.join(ROOT, 'test', name), 'w') as f:
        for t, s in ev:
            f.write('%.3f %s\n' % (t, s))


# 1) 방 깨기 -> 보너스 -> 사랑의 방 -> 판 깨기 (난이도 A 라 판 3 -> 4, 판 끝 곡까지)
ev = []
start(ev, 'a')
force_room(ev, 8.0, 3)
ev.append((14.0, 'poke 553 1'))
ev.append((22.0, 'poke 551 1'))             # 다음 창문 = 사랑의 방
ev.append((23.0, 'poke 553 1'))             # 암고양이에게 갔다
random_play(ev, 9.0, 70.0, 101)
write('win.txt', ev, 70.0)

# 2) 목숨 1개로 죽기 -> 타이틀 -> 다시 시작 -> 단축키들
ev = []
start(ev)
ev.append((7.5, 'poke 1f80 1'))
random_play(ev, 8.0, 40.0, 202, ('left', 'right', 'up', 'down', 'up', 'up'))
keys(ev, 45.0, 'space')
keys(ev, 47.0, 'space')
random_play(ev, 50.0, 60.0, 203)
ev.append((61.0, 'down ctrl'))
keys(ev, 61.2, 's')                         # 소리 끄기
keys(ev, 61.5, '9')                         # 목숨 9
ev.append((61.8, 'up ctrl'))
keys(ev, 63.0, 'esc')                       # 일시정지
keys(ev, 66.0, 'space')
random_play(ev, 67.0, 75.0, 204)
ev.append((76.0, 'down ctrl'))
keys(ev, 76.2, 'r')                         # 다시 시작
ev.append((76.5, 'up ctrl'))
random_play(ev, 78.0, 85.0, 205)
ev.append((86.0, 'down ctrl'))
keys(ev, 86.2, 'm')                         # 메뉴
ev.append((86.5, 'up ctrl'))
keys(ev, 88.0, 'n')
keys(ev, 89.0, 'h')
keys(ev, 90.0, 'space')
random_play(ev, 91.0, 110.0, 206)
write('hotkeys.txt', ev, 110.0)

# 3) 새장을 떨어뜨리고 새 잡기
ev = []
start(ev)
force_room(ev, 8.0, 5)
ev.append((12.0, 'pokew 40a8 74'))
ev.append((12.0, 'poke 40b0 ff'))
ev.append((12.0, 'poke 40af 1'))
random_play(ev, 9.0, 90.0, 303)
write('birdcage.txt', ev, 90.0)

# 4) 방에서 개에게 쫓겨나기 (판이 0 이 아니어야 주인 장면) - 난이도 H
for r in (1, 3, 4, 5):
    ev = []
    start(ev, 'h')
    force_room(ev, 8.0, r)
    ev.append((9.5, 'poke 1cbf 1'))          # 개가 달린다
    ev.append((9.5, 'pokew 1cc6 %x' % 0x60))
    random_play(ev, 10.0, 60.0, 400 + r, ('left', 'right', 'down', 'left', 'right'))
    write('dog%d.txt' % r, ev, 60.0)

# 5) 사랑의 방에서 떨어지기, 선물, 화살
ev = []
start(ev, 't')
ev.append((7.5, 'pokew 414 5'))             # 깬 방 5개 = 선물 5개
force_room(ev, 8.0, 7)
random_play(ev, 9.0, 120.0, 505, ('left', 'right', 'up', 'up', 'alt', 'down', 'pgup', 'home'))
write('love.txt', ev, 120.0)

# 6) 골목 오래 놀기 (창문으로 들어가기, 던진 물건, 쥐)
for s in (601, 602):
    ev = []
    start(ev)
    random_play(ev, 8.0, 180.0, s, ('left', 'right', 'up', 'up', 'up', 'pgup', 'home', 'down'))
    write('alley%d.txt' % s, ev, 180.0)
