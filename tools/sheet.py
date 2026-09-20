# 스크립트에 shot 을 끼워 원본 화면을 한 장에 모아 보기
#   python tools/sheet.py script.txt out.png 초1 초2 ...
import sys, os, subprocess, tempfile
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import emu
script, out = sys.argv[1], sys.argv[2]
times = [float(x) for x in sys.argv[3:]]
ev, _ = emu.load_script(script)
m = emu.Machine([e for e in ev if e[1] != 'quit'])
shots = sorted(int(t * 1e6) for t in times)
imgs = []
state = {'i': 0}
def on_event(m, kind):
    while state['i'] < len(shots) and shots[state['i']] <= m.vtime:
        imgs.append((Image.frombytes('RGB', (320, 200), m.rgb()), m.rd16(4)))
        state['i'] += 1
    if state['i'] >= len(shots):
        m.stop()
m.on_event = on_event
m.run()
cols = 4
W = Image.new('RGB', (cols * 322, ((len(imgs) + cols - 1) // cols) * 202), (60, 60, 60))
for i, (im, r) in enumerate(imgs):
    W.paste(im, ((i % cols) * 322, (i // cols) * 202))
W.save(out)
print([r for _, r in imgs])
