# DOSBox 에서 시험판(ALLEYTST.EXE / ALLEYVTST.EXE)을 돌려 저장된 화면을 한 장으로 모은다.
#   python tools/dosshot.py 스크립트 결과.png [alleyvt.exe]
import os, sys, subprocess, glob, shutil, tempfile
from PIL import Image

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
DOSBOX = os.path.abspath(os.path.join(ROOT, '..', '..', 'dosbox', 'dosbox.exe'))

script, out = sys.argv[1], sys.argv[2]
exe = sys.argv[3] if len(sys.argv) > 3 else 'alleytst.exe'
shutil.copy(script, os.path.join(ROOT, 'alleytst.txt'))
for f in glob.glob(os.path.join(ROOT, '*.BMP')) + glob.glob(os.path.join(ROOT, '*.bmp')):
    os.remove(f)
conf = os.path.join(tempfile.gettempdir(), 'alleyrun.conf')
open(conf, 'w').write('''[dosbox]
machine=svga_s3
memsize=32
[cpu]
core=auto
cycles=%s
[sblaster]
oplmode=auto
[autoexec]
mount C "%s"
C:
%s
exit
''' % (os.environ.get('DOSBOX_CYCLES', 'max'), ROOT, exe))
subprocess.run([DOSBOX, '-conf', conf, '-noconsole'], cwd=os.path.dirname(DOSBOX), timeout=600)
names = []
for ln in open(script):
    p = ln.split()
    if len(p) >= 3 and p[1] in ('shot', 'shown'):
        names.append(p[2])
imgs = []
for n in names:
    fn = os.path.join(ROOT, n.upper() + '.BMP')
    if os.path.exists(fn):
        imgs.append(Image.open(fn).convert('RGB'))
        os.remove(fn)
cols = 3
W = Image.new('RGB', (cols * 322, max(1, (len(imgs) + cols - 1) // cols) * 202), (60, 60, 60))
for i, im in enumerate(imgs):
    W.paste(im, ((i % cols) * 322, (i // cols) * 202))
W = W.resize((W.width * 2, W.height * 2), Image.NEAREST)
W.save(out)
print('%d shots' % len(imgs))
err = os.path.join(ROOT, 'alleyerr.txt')
if os.path.exists(err):
    t = open(err, errors='replace').read().strip()
    if t:
        print(t)
    os.remove(err)
