# -*- coding: utf-8 -*-
"""ALLEYVGA.EXE 배경음악 - 애드립(OPL2) VGM 곡을 만들어 SOUND.DAT 하나로 묶는다.

   쓰는 법 :  python tools/mkmusic.py [만들 폴더] [--vgm]   (기본: allycat 폴더)
              --vgm 을 주면 묶기 전의 VGM 파일도 따로 남긴다 (들어 보기용)

   SOUND.DAT 구조 (korea, kv 판과 같은 틀, 표시만 다르다)
       0..7    "ACSND10" + 0
       8..9    곡 수
       10..    곡마다 20바이트  이름 12 / 시작 위치 4 / 길이 4
       그 뒤   VGM 자료

   곡 (musvgm.c 의 순서와 같다)
       ACTITLE  타이틀        원판 타이틀 곡(주제와 변주)의 편곡 - 가락은 제 음역에 두고
                              변주마다 악기, 화음, 베이스, 스윙 리듬을 바꿔 쌓는다
       ACALLEY  골목          스윙 재즈 (되풀이)
       ACROOM   방 1,3,4,5,6  살금살금 A 단조 (되풀이)
       ACFISH   어항 속       물속 왈츠 (되풀이)
       ACLOVE   사랑의 방     느린 발라드 (되풀이)
       ACHEARTS 판을 깼을 때  원판 "사랑의 곡" 자료 (되풀이)
       ACWIN    골목에 돌아와 그림 틀   원판 판 끝 곡 자료
       ACBONUS  방을 깼을 때  짧은 팡파르
       ACSAD    방에서 나왔을 때  원판 곡 자료
       ACCAUGHT 잡혔을 때      와와와와-
"""
import os, struct, sys, math

SR = 44100
TICK = SR * 65536 / 1193182.0           # BIOS 시계 한 틱 (약 55ms) 의 샘플 수

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
EXE = open(os.path.join(ROOT, 'allycat.exe'), 'rb').read()
DSEG = EXE[0x300:0x300 + 0x7130]


def dw(o):
    return struct.unpack_from('<H', DSEG, o)[0]


def div_to_midi(div):
    return None if div == 0 else int(round(69 + 12 * math.log2(1193182.0 / div / 440.0)))


# ---------------------------------------------------------------- 음색 ------
# (모듈레이터 20 40 60 80 E0), (캐리어 20 40 60 80 E0), C0
P_BASS    = ((0x20, 0x1D, 0xB4, 0x0F, 0x00), (0x21, 0x00, 0xC3, 0x0F, 0x00), 0x3E)
P_UPRIGHT = ((0x01, 0x15, 0xF6, 0x58, 0x00), (0x01, 0x00, 0xF4, 0x58, 0x00), 0x0A)
P_PIZZ    = ((0x01, 0x1C, 0xF8, 0x7A, 0x00), (0x01, 0x02, 0xF6, 0x7A, 0x00), 0x08)
P_PIANO   = ((0x01, 0x4F, 0xF1, 0x53, 0x00), (0x11, 0x06, 0xD2, 0x74, 0x00), 0x06)
P_MUTED   = ((0x21, 0x1A, 0x85, 0x17, 0x00), (0x21, 0x04, 0x74, 0x17, 0x00), 0x0C)
P_BRASS   = ((0x21, 0x16, 0x86, 0x16, 0x00), (0x21, 0x02, 0x74, 0x17, 0x00), 0x0E)
P_TROMB   = ((0x21, 0x1A, 0x53, 0x17, 0x00), (0x21, 0x02, 0x63, 0x18, 0x00), 0x0C)
P_CLAR    = ((0x32, 0x1E, 0x74, 0x17, 0x00), (0x21, 0x04, 0x74, 0x17, 0x00), 0x0A)
P_SAX     = ((0x31, 0x17, 0x73, 0x17, 0x00), (0x21, 0x03, 0x74, 0x17, 0x00), 0x0A)
P_FLUTE   = ((0x61, 0x22, 0x74, 0x16, 0x00), (0x21, 0x02, 0x63, 0x16, 0x00), 0x08)
P_VIBES   = ((0x07, 0x22, 0xF4, 0x45, 0x00), (0x01, 0x04, 0xF3, 0x45, 0x00), 0x02)
P_GLOCK   = ((0x06, 0x1F, 0xF6, 0x44, 0x00), (0x01, 0x06, 0xF4, 0x44, 0x00), 0x00)
P_PLUCK   = ((0x01, 0x1B, 0xF6, 0x56, 0x00), (0x01, 0x08, 0xF4, 0x57, 0x00), 0x0A)
P_PAD     = ((0x21, 0x22, 0x54, 0x24, 0x00), (0x21, 0x10, 0x53, 0x25, 0x00), 0x0C)
P_STRINGS = ((0x31, 0x1C, 0x51, 0x13, 0x00), (0x21, 0x10, 0x52, 0x14, 0x00), 0x0E)
# 리듬부
P_BD      = ((0x00, 0x0B, 0xD8, 0x0F, 0x00), (0x00, 0x04, 0xF5, 0x0F, 0x00), 0x38)
P_HH_SD   = ((0x01, 0x10, 0xF8, 0x0F, 0x00), (0x01, 0x0A, 0xF7, 0x0F, 0x00), 0x39)
P_TOM_CY  = ((0x04, 0x08, 0xF7, 0x0F, 0x00), (0x0E, 0x10, 0xC9, 0x0F, 0x00), 0x3D)

BD, SD, TOM, CYM, HH = 0x10, 0x08, 0x04, 0x02, 0x01

OP1 = [0x00, 0x01, 0x02, 0x08, 0x09, 0x0A, 0x10, 0x11, 0x12]
OP2 = [0x03, 0x04, 0x05, 0x0B, 0x0C, 0x0D, 0x13, 0x14, 0x15]


def fnum_block(m):
    f = 440.0 * 2.0 ** ((m - 69) / 12.0)
    for blk in range(8):
        fn = int(round(f * (1 << (20 - blk)) / 49716.0))
        if fn < 1024 and (fn >= 300 or blk == 7):
            return fn, blk
    return 1023, 7


NAMES = {'C': 0, 'D': 2, 'E': 4, 'F': 5, 'G': 7, 'A': 9, 'B': 11}


def midi(name):
    k = NAMES[name[0]]
    i = 1
    while i < len(name) and name[i] in '#b':
        k += 1 if name[i] == '#' else -1
        i += 1
    return (int(name[i:]) + 1) * 12 + k


def seq(text):
    """'E5/4 B4/2 r/2 ...' -> [(시작, 길이, midi 또는 None)]"""
    out, t = [], 0
    for tok in text.split():
        name, ln = tok.split('/')
        ln = int(ln)
        out.append((t, ln, None if name == 'r' else midi(name)))
        t += ln
    return out, t


# ---------------------------------------------------------------- 악보 틀 ---
class Song:
    def __init__(self, bpm=None, div=4, tick_samples=None):
        self.tick_samples = tick_samples if tick_samples else SR * 60.0 / bpm / div
        self.ev = []
        self.loop_tick = None
        self.end_tick = 0

    def patch(self, t, ch, p):
        self.ev.append((t, 0, 'patch', ch, p))

    def note(self, t, ln, ch, m, gap=0.12, shift=0):
        if m is None:
            return
        self.ev.append((t, 2, 'on', ch, m + shift))
        self.ev.append((t + ln - min(gap, ln * 0.5), 1, 'off', ch, 0))
        self.end_tick = max(self.end_tick, t + ln)

    def melody(self, t, text, ch, shift=0, gap=0.12):
        notes, total = seq(text)
        for st, ln, m in notes:
            self.note(t + st, ln, ch, m, gap, shift)
        return total

    def drum(self, t, mask):
        self.ev.append((t, 3, 'drum', mask, 0))
        self.end_tick = max(self.end_tick, t + 1)

    def tom_pitch(self, t, m):
        self.ev.append((t, 0, 'tompitch', 8, m))


class Writer:
    def __init__(self):
        self.d = bytearray()
        self.samples = 0

    def w(self, reg, val):
        self.d += bytes((0x5A, reg & 0xFF, val & 0xFF))

    def wait_until(self, s):
        n = int(round(s)) - self.samples
        if n <= 0:
            return
        self.samples += n
        while n > 65535:
            self.d += bytes((0x61, 0xFF, 0xFF))
            n -= 65535
        self.d += bytes((0x61, n & 0xFF, n >> 8))

    def patch(self, ch, p):
        mod, car, c0 = p
        for r, v in zip((0x20, 0x40, 0x60, 0x80, 0xE0), mod):
            self.w(r + OP1[ch], v)
        for r, v in zip((0x20, 0x40, 0x60, 0x80, 0xE0), car):
            self.w(r + OP2[ch], v)
        self.w(0xC0 + ch, c0)


def render(song, name):
    v = Writer()
    rhythm = 0x20
    v.w(0x01, 0x20)
    v.w(0x08, 0x00)
    v.patch(6, P_BD)
    v.patch(7, P_HH_SD)
    v.patch(8, P_TOM_CY)
    for ch, m in ((6, 36), (7, 60), (8, 50)):
        fn, blk = fnum_block(m)
        v.w(0xA0 + ch, fn & 0xFF)
        v.w(0xB0 + ch, blk << 2 | fn >> 8)
    v.w(0xBD, rhythm)

    events = sorted(song.ev, key=lambda e: (e[0], e[1]))
    loop_offset = None
    last_b0 = {}
    i = 0
    while i < len(events):
        t = events[i][0]
        if song.loop_tick is not None and loop_offset is None and t >= song.loop_tick:
            v.wait_until(song.loop_tick * song.tick_samples)
            loop_offset = len(v.d)
        v.wait_until(t * song.tick_samples)
        mask = 0
        while i < len(events) and events[i][0] == t:
            e = events[i]
            kind = e[2]
            if kind == 'patch':
                v.patch(e[3], e[4])
            elif kind == 'on':
                fn, blk = fnum_block(e[4])
                v.w(0xB0 + e[3], blk << 2 | fn >> 8)
                v.w(0xA0 + e[3], fn & 0xFF)
                v.w(0xB0 + e[3], 0x20 | blk << 2 | fn >> 8)
                last_b0[e[3]] = blk << 2 | fn >> 8
            elif kind == 'off':
                v.w(0xB0 + e[3], last_b0.get(e[3], 0))     # 음높이는 두고 키만 뗀다
            elif kind == 'drum':
                mask |= e[3]
            elif kind == 'tompitch':
                fn, blk = fnum_block(e[4])
                v.w(0xA8, fn & 0xFF)
                v.w(0xB8, blk << 2 | fn >> 8)
            i += 1
        if mask:
            v.w(0xBD, rhythm & ~mask)
            v.w(0xBD, rhythm | mask)

    v.wait_until(song.end_tick * song.tick_samples)
    for ch in range(9):
        v.w(0xB0 + ch, 0x00)
    v.w(0xBD, rhythm)
    v.d += b'\x66'

    DATA = 0x100
    hdr = bytearray(DATA)
    hdr[0:4] = b'Vgm '
    struct.pack_into('<I', hdr, 0x04, DATA + len(v.d) - 4)
    struct.pack_into('<I', hdr, 0x08, 0x151)
    struct.pack_into('<I', hdr, 0x18, v.samples)
    if loop_offset is not None:
        struct.pack_into('<I', hdr, 0x1C, DATA + loop_offset - 0x1C)
        struct.pack_into('<I', hdr, 0x20, v.samples - int(round(song.loop_tick * song.tick_samples)))
    struct.pack_into('<I', hdr, 0x34, DATA - 0x34)
    struct.pack_into('<I', hdr, 0x50, 3579545)                 # YM3812 클럭
    print('%-12s %6d bytes  %5.1fs%s' % (name, DATA + len(v.d),
          v.samples / SR, '  (loop)' if loop_offset is not None else ''))
    return name, bytes(hdr) + bytes(v.d)


def bundle(path, songs):
    head = bytearray(b'ACSND10\0')
    head += struct.pack('<H', len(songs))
    off = len(head) + 20 * len(songs)
    body = bytearray()
    for name, data in songs:
        head += name.encode('ascii').ljust(12, b'\0')[:12]
        head += struct.pack('<II', off + len(body), len(data))
        body += data
    with open(path, 'wb') as f:
        f.write(bytes(head) + bytes(body))
    print('%s  %d bytes, %d songs' % (os.path.basename(path), len(head) + len(body), len(songs)))


# ---------------------------------------------------------------- 도움 함수 --
CHORD = {
    'C6': ('E4', 'G4', 'A4'), 'A7': ('C#4', 'E4', 'G4'), 'Dm7': ('F4', 'A4', 'C5'),
    'G7': ('F4', 'G4', 'B4'), 'F6': ('F4', 'A4', 'D5'), 'F#dim': ('F#4', 'A4', 'C5'),
    'C/G': ('E4', 'G4', 'C5'), 'D7': ('F#4', 'A4', 'C5'), 'Em': ('E4', 'G4', 'B4'),
    'Am': ('E4', 'A4', 'C5'), 'Dm': ('D4', 'F4', 'A4'), 'E7': ('D4', 'G#4', 'B4'),
    'F': ('F4', 'A4', 'C5'), 'Bb': ('F4', 'Bb4', 'D5'), 'C7': ('E4', 'G4', 'Bb4'),
    'C': ('E4', 'G4', 'C5'),
}
WALK = {
    'C6': 'C2 E2 G2 A2', 'A7': 'A1 C#2 E2 G2', 'Dm7': 'D2 F2 A2 C3', 'G7': 'G1 B1 D2 F2',
    'F6': 'F1 A1 C2 D2', 'F#dim': 'F#1 A1 C2 D#2', 'C/G': 'G1 C2 E2 G2', 'D7': 'D2 F#2 A2 C3',
}


def put_lines(s, t, lines, ch, bar, shift=0, gap=0.12):
    for b, line in enumerate(lines):
        s.melody(t + b * bar, line, ch, shift, gap)


def chords_of(bars):
    """'C6' 또는 'Dm7 G7' (반 마디씩) -> [(마디 안 시작 비율, 길이 비율, 이름)]"""
    out = []
    for b, text in enumerate(bars):
        names = text.split()
        for k, n in enumerate(names):
            out.append((b + k / len(names), 1.0 / len(names), n))
    return out


# ---------------------------------------------------------------- 타이틀 ----
def song_title():
    """타이틀: 원판 타이틀 곡의 편곡.

       원판(틱마다 한 음, DS:538C)은 4마디 주제 하나를 여덟 번 변주하는데, 변주마다
       한 옥타브씩 올라가 끝에는 G7 까지 간다 (PC 스피커 한 음으로 변화를 주려고).
       여기서는 가락을 C5 둘레에 두고, 변주마다 악기/화음/베이스/리듬을 바꿔 쌓는다.
       박자와 길이(한 박 6틱, 한 마디 24틱, 모두 845틱)는 원판과 같다.

         0   주제       클라리넷, 2박 베이스, 브러시
         96  변주 1     뮤트 트럼펫, 스윙 시작
         192 변주 2     비브라폰 + 색소폰, 걷는 베이스
         288 변주 3     트럼펫 (옥타브 뛰기), 끝에 탐 채움
         384 변주 4     피아노 (화음을 섞은 가락)
         480 변주 5     색소폰 + 비브라폰 겹침
         582 B          주제를 트롬본이 낮게, 트럼펫은 원판의 높은 대선율을 내려서
         762 끝맺음     원판의 분산화음을 좁혀 비브라폰으로, 떨림음 뒤 C 로 마친다
    """
    BAR = 24
    s = Song(tick_samples=TICK)

    # ---- 가락 (원판 음을 옮겨 적고 옥타브만 내렸다) ----
    V = [
        (0, P_CLAR,
         "C5/6 C5/6 B4/6 B4/6 A4/4 B4/2 A4/4 G4/6 G4/2 G4/2 A4/2 B4/8 C5/12 B4/12 A4/4 G4/14"),
        (96, P_MUTED,
         "C5/6 C5/4 B4/1 C5/1 B4/6 B4/4 A4/1 B4/1 A4/4 B4/2 A4/4 G4/6 G4/2 G4/2 A4/2 B4/8 "
         "C5/10 B4/2 B4/10 F#4/1 G4/1 A4/4 G4/10 G#4/1 A4/1 A#4/1 B4/1"),
        (192, P_VIBES,
         "C5/6 C5/4 B4/1 C5/1 B4/4 B4/1 C5/1 B4/4 A4/1 B4/1 A4/4 B4/2 A4/1 B4/1 A4/2 G4/6 G4/2 G4/2 "
         "A4/2 B4/8 C5/1 B4/1 C5/1 B4/1 C5/6 B4/2 B4/10 F#4/1 G4/1 A4/4 G4/7 "
         "G5/1 F#5/1 F5/1 E5/1 D#5/1 D5/1 C#5/1"),
        (288, P_MUTED,
         "C5/6 C6/4 B4/1 C5/1 B4/6 B5/4 A4/1 B4/1 A4/4 B4/4 A4/1 B4/1 A4/2 G4/6 G5/10 C5/2 C5/10 "
         "B4/2 B4/1 C5/1 B4/1 C5/1 B4/1 C5/1 C#5/1 D5/1 D#5/1 E5/1 F5/1 F#5/1 A5/4 G5/14"),
        (384, P_PIANO,
         "C5/2 G5/4 C5/2 E5/4 B4/1 C5/1 B4/2 D5/2 B4/6 A4/1 C5/1 A4/1 C5/1 B4/2 A4/4 G4/1 B4/1 "
         "G4/1 B4/3 G4/2 G4/2 A4/2 B4/8 C5/2 G5/2 C5/2 G5/6 B4/1 D5/1 B4/1 D5/1 B4/1 D5/1 C5/6 "
         "A4/4 G4/1 B4/1 G4/1 B4/1 G4/1 B4/1 G4/1 B4/1 G4/1 B4/1 G4/1 B4/1 G4/1 B4/1"),
        (480, P_SAX,
         "C5/6 C5/6 B4/1 C5/1 B4/4 B4/6 A4/4 B4/4 A4/4 G4/6 G4/1 B4/1 D5/1 B4/1 G4/1 B4/1 "
         "D5/1 G5/1 D5/1 B4/1 D5/1 G5/1 C5/12 B4/12 A4/6 G4/12 G#4/2 A4/2 A#4/2"),
    ]
    for t, patch, text in V:
        s.patch(t, 0, patch)
        s.melody(t, text, 0, gap=0.3)
    s.patch(192, 1, P_SAX)
    s.melody(192, V[2][2], 1, shift=-12, gap=0.3)            # 변주 2: 색소폰이 한 옥타브 아래
    s.patch(480, 1, P_VIBES)
    s.melody(480, V[5][2], 1, gap=0.1)                       # 변주 5: 비브라폰 겹침

    # ---- 화음 (반 마디씩) ----
    TONES = {'C': 'C E G', 'G7': 'G B D F', 'F': 'F A C', 'D7': 'D F# A C', 'C7': 'C E G Bb',
             'Dm7': 'D F A C', 'Cmaj7': 'C E G B', 'Bm7': 'B D F# A', 'A': 'A C# E'}

    def pcs(name):
        return [NAMES[x[0]] + x[1:].count('#') - x[1:].count('b') for x in TONES[name].split()]

    def voicing(name):
        p = pcs(name)
        top = p[1:] if len(p) == 4 else p[1:] + p[:1]
        return sorted(60 + (c % 12) for c in top)

    THEME = ['C', 'G7', 'F', 'G7', 'C', 'G7', 'D7', 'G7']
    PROG = [(0, THEME), (96, THEME), (192, THEME), (288, THEME), (384, THEME), (480, THEME),
            (576, THEME), (672, ['C7', 'C7', 'D7', 'G7', 'C', 'G7', 'Dm7', 'G7'])]
    for ch in (3, 4, 5):
        s.patch(0, ch, P_PIANO)
    s.patch(0, 2, P_UPRIGHT)
    for start, prog in PROG:
        for k, name in enumerate(prog):
            b = start + k * 12
            chord = voicing(name)
            if start == 0:
                hits = ((0, 6),)                                 # 주제: 박에 한 번씩만
            else:
                hits = ((0, 4), (10, 2))                         # 찰스턴
            for st, ln in hits:
                for v, m in enumerate(chord):
                    s.note(b + st, ln, 3 + v, m, gap=0.3)
            root = 36 + pcs(name)[0] % 12
            if root > 43:
                root -= 12                                       # 베이스는 E1..G2
            fifth = root + 7
            if start < 192:
                s.note(b, 10, 2, root, gap=0.5)                  # 2박 베이스
            elif start < 576:
                third = root + (pcs(name)[1] - pcs(name)[0]) % 12
                s.note(b, 6, 2, root, gap=0.4)                   # 걷는 베이스
                s.note(b + 6, 6, 2, fifth if k % 2 == 0 else third, gap=0.4)

    # ---- B: 주제는 낮게 (트롬본 + 베이스), 원판의 높은 대선율은 트럼펫으로 내려서 ----
    notes = []
    o = 0x538C
    while DSEG[o] != 0x66:
        n = DSEG[o]
        notes.append(div_to_midi(dw(0x5324 + n)) if n else None)
        o += 1
    s.patch(582, 0, P_MUTED)
    s.patch(582, 1, P_TROMB)
    low, high = [], []
    for i in range(582, 762):
        m = notes[i]
        if m is None:
            continue
        (low if m <= 60 else high).append((i, m))

    def line(lst, ch, cap, fold, gap):
        for k, (i, m) in enumerate(lst):
            nxt = lst[k + 1][0] if k + 1 < len(lst) else 762
            s.note(i, max(1, min(cap, nxt - i)), ch, fold(m), gap=gap)

    def fold_high(m):
        while m >= 84:                                           # C6 아래로
            m -= 12
        return m

    line(low, 1, 10, lambda m: m, 0.4)                           # 트롬본 C4..G3
    line(low, 2, 10, lambda m: m - 24, 0.5)                      # 베이스 C2..G1
    line(high, 0, 4, fold_high, 0.25)

    # ---- 끝맺음 ----
    s.patch(762, 0, P_FLUTE)
    s.patch(762, 1, P_VIBES)
    s.melody(762, "G2/2 A#2/2 G2/2 A#2/2 B2/2 C2/12 B1/12 A1/6 G1/28 C2/15", 2, gap=0.4)
    s.melody(772, "C4/2 E4/2 G4/2 E5/2 G5/2 B5/2 B3/2 D4/2 F#4/2 D5/2 F#5/2 A5/2 A3/2 C#4/2 E4/2 "
                  "G3/1 B3/1 D4/1 F4/1 G4/1 B4/1 D5/1 F5/1 G5/1 B5/1 D6/3", 1, gap=0.1)
    s.melody(816, "F#5/1 G5/1 F#5/1 G5/1 F#5/1 G5/1 F#5/1 G5/1 F#5/1 G5/1 F#5/1 G5/1 F#5/1 G5/1 "
                  "C5/15", 0, gap=0.3)
    s.melody(830, "C6/15", 1, gap=0.3)
    for t, name, ln in ((772, 'Cmaj7', 12), (784, 'Bm7', 12), (796, 'A', 6), (802, 'G7', 28),
                        (830, 'C', 15)):
        for v, m in enumerate(voicing(name)):
            s.note(t, ln, 3 + v, m, gap=0.4)

    # ---- 리듬 (스윙: 한 박 6틱, 둘째 8분음은 4틱 뒤) ----
    for bar in range(0, 768, BAR):
        full = bar >= 96
        for k in range(4):
            b = bar + k * 6
            if bar == 576 and k == 0:
                continue
            mask = HH if (full or k in (1, 3)) else 0
            if full:
                if k in (0, 2):
                    mask |= BD
                if k in (1, 3) and bar >= 192:
                    mask |= SD
            if mask:
                s.drum(b, mask)
            if full:
                s.drum(b + 4, HH)
        if bar % 96 == 0 and bar:
            s.drum(bar, CYM | BD)
    s.drum(582, CYM | BD)
    for k, m in zip((372, 375, 378, 381), (52, 48, 45, 41)):     # 변주 3 끝의 탐
        s.tom_pitch(k, m)
        s.drum(k, TOM)
    s.drum(772, CYM | BD)
    for t in (784, 796, 802):
        s.drum(t, BD)
    s.drum(830, CYM | BD)
    s.end_tick = 845
    return s


# ---------------------------------------------------------------- 골목 ------
ALLEY_BARS = ['C6', 'A7', 'Dm7', 'G7', 'C6', 'A7', 'Dm7 G7', 'C6',
              'F6', 'F#dim', 'C/G', 'A7', 'D7', 'G7', 'C6 A7', 'Dm7 G7']
ALLEY_A = [
    "G4/2 A4/1 C5/2 E5/1 D5/3 C5/3",
    "C#5/2 E5/1 G5/3 E5/2 C#5/1 A4/3",
    "D5/2 F5/1 A5/3 G5/2 F5/1 D5/3",
    "B4/3 D5/2 F5/1 E5/3 r/3",
    "G4/2 A4/1 C5/2 E5/1 G5/3 E5/3",
    "G5/2 A5/1 G5/2 E5/1 C#5/3 A4/3",
    "F5/2 E5/1 D5/3 B4/2 D5/1 G5/3",
    "C5/6 r/3 G4/2 A4/1",
]
ALLEY_B = [
    "A5/3 A5/2 G5/1 F5/3 D5/3",
    "A5/3 A5/2 G5/1 F#5/3 D#5/3",
    "E5/2 G5/1 C6/3 G5/2 E5/1 C5/3",
    "C#5/2 E5/1 A5/3 G5/6",
    "F#5/2 A5/1 C6/3 A5/2 F#5/1 D5/3",
    "F5/2 G5/1 B5/3 A5/2 G5/1 F5/3",
    "E5/3 G5/2 E5/1 C#5/3 E5/3",
    "D5/3 F5/3 B4/3 G4/3",
]


def walking_bass(s, t, bars, bar, ch=2):
    for b, text in enumerate(bars):
        names = text.split()
        if len(names) == 1:
            line = WALK[names[0]].split()
        else:
            line = WALK[names[0]].split()[:2] + WALK[names[1]].split()[:2]
        for k, n in enumerate(line):
            s.note(t + b * bar + k * bar // 4, bar // 4, ch, midi(n), gap=0.4)


def comp(s, t, bars, bar, chs=(3, 4, 5), hits=((0, 2), (5, 1))):
    for pos, ln, name in chords_of(bars):
        base = t + int(round(pos * bar))
        span = int(round(ln * bar))
        for st, l in hits:
            if st * span // bar < span and st < span:
                for v, n in enumerate(CHORD[name]):
                    s.note(base + st, l, chs[v], midi(n), gap=0.3)


def swing_drums(s, t, bars, bar=12, fill=True, brush=False):
    for b in range(bars):
        o = t + b * bar
        for k in (0, 3, 5, 6, 9, 11):
            s.drum(o + k, HH)
        if not brush:
            s.drum(o, BD | (CYM if b % 8 == 0 else 0))
            s.drum(o + 6, BD)
        s.drum(o + 3, SD)
        s.drum(o + 9, SD)
        if fill and b % 8 == 7:
            for k, m in zip((8, 10, 11), (50, 45, 41)):
                s.tom_pitch(o + k, m)
                s.drum(o + k, TOM)


def song_alley():
    bar = 12                                    # 박마다 셋잇단 (스윙)
    s = Song(150, div=3)
    s.patch(0, 0, P_MUTED)
    s.patch(0, 1, P_SAX)
    s.patch(0, 2, P_UPRIGHT)
    for ch in (3, 4, 5):
        s.patch(0, ch, P_PIANO)
    s.loop_tick = 0
    t = 0
    for rep in range(2):
        put_lines(s, t, ALLEY_A, 0, bar)
        put_lines(s, t + 8 * bar, ALLEY_B, 0, bar)
        if rep:
            put_lines(s, t, ALLEY_A, 1, bar, shift=-12)
            put_lines(s, t + 8 * bar, ALLEY_B, 1, bar, shift=-12)
        walking_bass(s, t, ALLEY_BARS, bar)
        comp(s, t, ALLEY_BARS, bar)
        swing_drums(s, t, 16, bar)
        t += 16 * bar
    s.end_tick = t
    return s


# ---------------------------------------------------------------- 방 --------
ROOM_BARS = ['Am', 'Am', 'Dm', 'E7', 'Am', 'Am', 'F E7', 'Am']
ROOM_ROOT = {'Am': ('A2', 'E2'), 'Dm': ('D2', 'A1'), 'E7': ('E2', 'B1'), 'F': ('F2', 'C2')}
ROOM_MEL = [
    "A4/2 r/2 C5/2 r/2 E5/2 r/2 D#5/2 E5/2",
    "C5/4 A4/4 r/8",
    "D5/2 r/2 F5/2 r/2 A5/2 r/2 G#5/2 A5/2",
    "G#5/4 E5/4 r/4 B4/4",
    "A4/2 r/2 C5/2 r/2 E5/2 r/2 A5/2 r/2",
    "G5/2 F5/2 E5/2 D5/2 C5/4 B4/4",
    "A4/2 C5/2 F5/4 E5/2 D5/2 B4/4",
    "A4/4 E4/4 A3/4 r/4",
]


def song_room():
    bar = 16
    s = Song(112, div=4)
    s.patch(0, 0, P_CLAR)
    s.patch(0, 1, P_GLOCK)
    s.patch(0, 2, P_PIZZ)
    for ch in (3, 4, 5):
        s.patch(0, ch, P_PIZZ)
    s.loop_tick = 0
    t = 0
    for rep in range(2):
        put_lines(s, t, ROOM_MEL, 0, bar, gap=0.4)
        if rep:
            put_lines(s, t, ROOM_MEL, 1, bar, shift=12, gap=0.2)
        for pos, ln, name in chords_of(ROOM_BARS):
            base = t + int(round(pos * bar))
            span = int(round(ln * bar))
            r1, r2 = ROOM_ROOT[name]
            for k in range(0, span, 4):
                s.note(base + k, 2, 2, midi(r1 if k % 8 == 0 else r2), gap=0.6)
                if k % 8 == 4:
                    for v, n in enumerate(CHORD[name]):
                        s.note(base + k, 1, 3 + v, midi(n), gap=0.3)
        for b in range(8):
            o = t + b * bar
            for k in (2, 6, 10, 14):
                s.drum(o + k, HH)
            s.drum(o, BD)
            s.drum(o + 8, BD)
            if rep:
                s.drum(o + 4, SD)
                s.drum(o + 12, SD)
            if b == 7:
                for k, m in zip((12, 13, 14), (52, 48, 45)):
                    s.tom_pitch(o + k, m)
                    s.drum(o + k, TOM)
        t += 8 * bar
    s.end_tick = t
    return s


# ---------------------------------------------------------------- 어항 ------
FISH_BARS = ['F', 'Dm', 'Bb', 'C7', 'F', 'Am', 'Bb C7', 'F']
FISH_ROOT = {'F': 'F2', 'Dm': 'D2', 'Bb': 'Bb1', 'C7': 'C2', 'Am': 'A1'}
FISH_MEL = ["C5/8 A4/4", "D5/8 F5/4", "F5/6 D5/2 Bb4/4", "C5/12",
            "C5/8 F5/4", "E5/8 C5/4", "D5/6 E5/6", "F5/12"]


def song_fish():
    bar = 12                                    # 3/4, 박마다 넷
    s = Song(92, div=4)
    s.patch(0, 0, P_FLUTE)
    s.patch(0, 1, P_GLOCK)
    s.patch(0, 2, P_BASS)
    for ch in (3, 4, 5):
        s.patch(0, ch, P_STRINGS)
    s.loop_tick = 0
    t = 0
    for rep in range(2):
        put_lines(s, t, FISH_MEL, 0, bar, shift=12 if rep else 0, gap=0.3)
        for pos, ln, name in chords_of(FISH_BARS):
            base = t + int(round(pos * bar))
            span = int(round(ln * bar))
            s.note(base, span, 2, midi(FISH_ROOT[name]), gap=0.5)
            tones = [midi(n) for n in CHORD[name]]
            for v, m in enumerate(tones):
                s.note(base, span, 3 + v, m, gap=0.3)
            arp = tones + [tones[0] + 12, tones[2], tones[1]]
            for k in range(0, span, 2):
                s.note(base + k, 2, 1, arp[(k // 2) % len(arp)] + 12, gap=0.1)
        for b in range(0, 8, 4):
            s.drum(t + b * bar, CYM)
        t += 8 * bar
    s.end_tick = t
    return s


# ---------------------------------------------------------------- 사랑의 방 --
LOVE_BARS = ['C', 'Am', 'Dm7', 'G7', 'Em', 'A7', 'Dm7 G7', 'C']
LOVE_ROOT = {'C': 'C2', 'Am': 'A1', 'Dm7': 'D2', 'G7': 'G1', 'Em': 'E2', 'A7': 'A1'}
LOVE_MEL = ["G4/3 C5/3 E5/5 D5/1", "C5/6 A4/6", "F4/3 A4/3 D5/5 C5/1", "B4/9 r/3",
            "G4/3 B4/3 E5/5 D5/1", "C#5/6 E5/3 G5/3", "F5/5 E5/1 D5/3 B4/3", "C5/9 r/3"]


def song_love():
    bar = 12                                    # 느린 스윙 (박마다 셋)
    s = Song(84, div=3)
    s.patch(0, 0, P_SAX)
    s.patch(0, 1, P_VIBES)
    s.patch(0, 2, P_UPRIGHT)
    for ch in (3, 4, 5):
        s.patch(0, ch, P_PAD)
    s.loop_tick = 0
    t = 0
    for rep in range(2):
        put_lines(s, t, LOVE_MEL, 0, bar, gap=0.3)
        if rep:
            put_lines(s, t, LOVE_MEL, 1, bar, shift=12, gap=0.1)
        for pos, ln, name in chords_of(LOVE_BARS):
            base = t + int(round(pos * bar))
            span = int(round(ln * bar))
            r = midi(LOVE_ROOT[name])
            s.note(base, span // 2, 2, r, gap=0.4)
            s.note(base + span // 2, span - span // 2, 2, r + 7, gap=0.4)
            for v, n in enumerate(CHORD[name]):
                s.note(base, span, 3 + v, midi(n), gap=0.5)
        swing_drums(s, t, 8, bar, fill=False, brush=True)
        t += 8 * bar
    s.end_tick = t
    return s


# ---------------------------------------------------------------- 원판 짧은 곡 --
def tick_tune(entries, ticks_per):
    """원판처럼: 틱마다 한 값, 앞과 같으면 끈다, 0 이면 끈다 -> [(시작 틱, 길이, midi)]"""
    out = []
    prev = None
    for k, div in enumerate(entries):
        t = k * ticks_per
        if div == 0 or div == prev:
            prev = div
            continue
        prev = div
        out.append([t, ticks_per, div_to_midi(div)])
    # 끈 자리가 없으면 다음 음까지 이어진다
    for k in range(len(out) - 1):
        out[k][1] = out[k + 1][0] - out[k][0]
    return out


def song_hearts():
    n = 0x86 // 2
    entries = [dw(0x5934 + i * 2) for i in range(n)]
    s = Song(tick_samples=TICK)
    s.patch(0, 0, P_GLOCK)
    s.patch(0, 1, P_PLUCK)
    s.patch(0, 2, P_BASS)
    s.loop_tick = 0
    for t, ln, m in tick_tune(entries, 2):
        s.note(t, min(ln, 4), 0, m, shift=12, gap=0.3)
        s.note(t, min(ln, 4), 1, m, gap=0.3)
    for b in range(0, n * 2, 8):
        s.note(b, 8, 2, midi('G2') if b < 60 or b >= 88 else midi('D2'), gap=0.5)
        s.drum(b, BD | (CYM if b == 0 else 0))
        s.drum(b + 4, SD | HH)
    s.end_tick = n * 2
    return s


def song_win():
    entries = [dw(0x52CA + i * 2) for i in range(0x2C)]
    s = Song(tick_samples=TICK)
    s.patch(0, 0, P_BRASS)
    s.patch(0, 1, P_GLOCK)
    s.patch(0, 2, P_BASS)
    for ch in (3, 4, 5):
        s.patch(0, ch, P_BRASS)
    notes = tick_tune(entries, 1)
    for t, ln, m in notes:
        s.note(t, max(1, min(ln, 3)), 0, m, shift=-12, gap=0.1)
        s.note(t, max(1, min(ln, 3)), 1, m, gap=0.1)
    s.note(0, 12, 2, midi('E2'))
    s.note(12, 12, 2, midi('G2'))
    s.note(24, 8, 2, midi('B1'))
    s.note(32, 12, 2, midi('E2'))
    for v, n in enumerate(('E4', 'G#4', 'B4')):
        s.note(34, 10, 3 + v, midi(n), gap=0.3)
    s.drum(0, BD | CYM)
    s.drum(12, BD)
    s.drum(24, SD)
    s.drum(32, SD)
    s.drum(34, BD | CYM)
    s.end_tick = 44
    return s


def song_bonus():
    s = Song(tick_samples=TICK)
    s.patch(0, 0, P_BRASS)
    s.patch(0, 1, P_BRASS)
    s.patch(0, 2, P_BASS)
    for ch in (3, 4, 5):
        s.patch(0, ch, P_GLOCK)
    s.melody(0, "C5/2 E5/2 G5/2 C6/2 G5/2 C6/12", 0, gap=0.2)
    s.melody(0, "E4/2 G4/2 C5/2 E5/2 D5/2 E5/12", 1, gap=0.2)
    s.note(0, 10, 2, midi('C2'))
    s.note(10, 12, 2, midi('C2'))
    for v, n in enumerate(('C6', 'E6', 'G6')):
        s.note(10 + v, 12 - v, 3 + v, midi(n), gap=0.3)
    for k in range(0, 8, 2):
        s.drum(k, SD)
    s.drum(10, BD | CYM)
    s.end_tick = 24
    return s


def song_sad():
    entries = [dw(0x5A87 + i * 2) for i in range(14)]
    s = Song(tick_samples=TICK)
    s.patch(0, 0, P_VIBES)
    s.patch(0, 1, P_PLUCK)
    s.patch(0, 2, P_BASS)
    for t, ln, m in tick_tune(entries, 2):
        s.note(t, 2, 0, m, gap=0.1)
        s.note(t, 2, 1, m, shift=-12, gap=0.1)
    for t, n in ((0, 'G2'), (6, 'D2'), (12, 'A2'), (18, 'A2'), (24, 'E2')):
        s.note(t, 6 if t < 24 else 6, 2, midi(n), gap=0.3)
    s.end_tick = 30
    return s


def song_caught():
    s = Song(tick_samples=TICK)
    s.patch(0, 0, P_TROMB)
    s.patch(0, 1, P_TROMB)
    s.patch(0, 2, P_BASS)
    s.melody(0, "G4/9 F#4/9 F4/9 E4/30", 0, gap=0.5)
    s.melody(0, "C4/9 B3/9 Bb3/9 A3/30", 1, gap=0.5)
    s.note(0, 27, 2, midi('C2'), gap=0.5)
    s.note(27, 30, 2, midi('A1'), gap=0.5)
    for k in (0, 9, 18):
        s.tom_pitch(k, 45 - k // 3)
        s.drum(k, TOM)
    s.drum(27, BD | CYM)
    s.end_tick = 60
    return s


SONGS = [('ACTITLE.VGM', song_title), ('ACALLEY.VGM', song_alley), ('ACROOM.VGM', song_room),
         ('ACFISH.VGM', song_fish), ('ACLOVE.VGM', song_love), ('ACHEARTS.VGM', song_hearts),
         ('ACWIN.VGM', song_win), ('ACBONUS.VGM', song_bonus), ('ACSAD.VGM', song_sad),
         ('ACCAUGHT.VGM', song_caught)]


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    out = args[0] if args else ROOT
    songs = [render(f(), name) for name, f in SONGS]
    bundle(os.path.join(out, 'SOUND.DAT'), songs)
    if '--vgm' in sys.argv:
        for name, data in songs:
            with open(os.path.join(out, name), 'wb') as f:
                f.write(data)


if __name__ == '__main__':
    main()
