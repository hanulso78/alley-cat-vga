# 대조 시험 스크립트 만들기: 메뉴를 지나 난수로 키를 누르고, 원하는 방으로 들어가게 찌른다.
#   python tools/mkscript.py 방번호 초 난수씨앗 [clear초] > test/room3.txt
#   방번호 0 이면 골목에서만 논다.  clear초 를 주면 그때 방을 깬 것으로 한다.
import random, sys

room = int(sys.argv[1])
secs = float(sys.argv[2])
rnd = random.Random(int(sys.argv[3]))
clear_at = float(sys.argv[4]) if len(sys.argv) > 4 else None
ev = []


def key(t, k, hold):
    ev.append((t, 'down %s' % k))
    ev.append((t + hold, 'up %s' % k))


key(3.0, 'n', 0.1)          # 타이틀 넘기기
key(4.0, 'n', 0.1)          # 조이스틱 아니오
key(5.0, 'k', 0.1)          # 난이도
key(6.0, 'space', 0.1)      # 시작
t0 = 7.0
if room:
    for i in range(12):
        ev.append((t0 + 1, 'poke %x %x' % (0x421 + i, room)))
    for i in range(5):
        ev.append((t0 + 1, 'poke %x %x' % (0x42D + i, room)))
    ev.append((t0 + 1.5, 'poke 551 1'))
if clear_at is not None:
    ev.append((clear_at, 'poke 553 1'))

t = t0 + 2
end = t0 + secs
while t < end:
    k = rnd.choice(['left', 'right', 'up', 'down', 'alt', 'left', 'right', 'up', 'pgup', 'home'])
    hold = rnd.uniform(0.05, 1.2)
    key(t, k, hold)
    t += hold + rnd.uniform(0.0, 0.6)
ev.append((end, 'quit'))
ev.sort(key=lambda e: e[0])
for t, s in ev:
    print('%.3f %s' % (t, s))
