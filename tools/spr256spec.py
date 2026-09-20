# -*- coding: utf-8 -*-
"""ALLEY256.SPR 그림 색 정하기 (mkspr256.py 가 읽는다)

   (이름, [(자리, 워드 수, 줄 수), ...], 설정)
     VALUE {값: 색}           값마다 새 색 (없는 값은 원래 CGA 색 그대로 = 방 테마)
     GRAD  {값: (위, 아래)}    위아래 그러데이션
     VARY  {값: [색, ...]}     4점 칸마다 돌아가며 (책장의 책)
     EDGE  {값: 색}           그 값의 윗가장자리 점
     ROWS  [(첫 줄, 끝 줄, {값: 색})]
     BG    {값, ...}          가장자리와 이어진 그 값의 점은 배경 (원래 색 그대로)
     CLEAR True               BG 바깥 점은 아예 칠하지 않는다 (밑의 탁자 등이 비친다)
     INNER {값: 색}           BG 값인데 안쪽에 갇힌 점의 색
     INNER_ROWS (줄, 색)       그 줄부터 아래의 갇힌 점은 INNER 대신 이 색 (고양이 눈)
     BYTES 한 줄의 바이트 수 (기본 워드 수 x 2)
     OUTLINE (몸 값, 색)       BG 쪽 바깥 점 중 몸에 붙은 점 (한 점 테두리)
     SMOOTH 체크무늬 디더를 중간색으로 (기본 True)
"""

CAT_BODY = '#1e1a26'
# 고양이: 원판처럼 온통 검은 몸 + 노란 눈 (테두리, 가장자리 밝힘 없음)
CAT = dict(VALUE={0: CAT_BODY}, BG={3}, INNER={3: '#f0d848'},
           INNER_ROWS=(5, CAT_BODY))                              # 눈은 위 5줄(머리)의 구멍만
DOG_BODY = ('#c89858', '#8a6436')
DOG_COLLAR = '#d82020'


def seq(start, step, n, w, h):
    return [(start + step * i, w, h) for i in range(n)]


SPRITES = [
    # ---- 고양이 (AND 로 그림: 0 = 몸, 3 = 비침) ----
    ('cat_swim', [(0x06D0, 3, 12), (0x0718, 3, 13), (0x0766, 3, 10), (0x07A2, 3, 12), (0x07EA, 3, 13),
                  (0x0838, 3, 10), (0x0874, 3, 14), (0x08C8, 3, 13), (0x0916, 2, 14), (0x094E, 2, 13),
                  (0x0982, 2, 9)],
     CAT),
    ('cat_crouch', [(0x09DA, 3, 14)], CAT),
    ('cat_walk', [(0x0A2E, 3, 13), (0x0A7C, 3, 13), (0x0ACA, 3, 12), (0x0B12, 3, 12), (0x0B5A, 3, 10),
                  (0x0B96, 3, 10)] + seq(0x0BD2, 0x42, 12, 3, 11),
     CAT),
    ('cat_idle', seq(0x0EEA, 0x18, 6, 2, 6), dict(VALUE={0: CAT_BODY}, BG={3}, INNER={3: '#f0d848'},
                                                    INNER_ROWS=(5, CAT_BODY))),   # 머리/꼬리 조각은 몸 위에 겹쳐 그려서 테두리 없이
    ('drink_cat', seq(0x410C, 0x3C, 4, 3, 10), CAT),

    # ---- 불독 (투명 그리기: 3 몸, 1 눈과 목걸이) / 고양이를 문 개 (통째로: 0 고양이, 2 배경) ----
    ('dog', seq(0x13E8, 0x78, 4, 4, 15),
     dict(GRAD={3: DOG_BODY}, VALUE={1: DOG_COLLAR}, EDGE={3: '#f0c890'})),
    ('dog_fight', seq(0x1280, 0x78, 3, 4, 15),              # 개가 고양이를 물고 뛰는 먼지 구름
     dict(GRAD={3: ('#d8ccb8', '#a89880')}, VALUE={0: '#4a4048', 1: DOG_COLLAR})),
    ('dog6', [(0x429C, 5, 13), (0x431E, 5, 13)], dict(GRAD={3: DOG_BODY}, VALUE={1: DOG_COLLAR, 0: '#2a1c10'})),
    ('dog6_eyes', [(0x4100, 5, 1)], dict(VALUE={3: '#c89858', 0: '#2a1c10', 1: '#f0f0e0'})),   # 눈 뜨고 감기 (개 위에 덮는다)
    ('milk_bowls', seq(0x421C, 0x20, 4, 2, 8),       # 우유 1..4 (0 은 바닥으로 지운다)
     dict(BG={2}, VALUE={1: '#6080d0', 3: '#f8f4ec'}, INNER={2: '#34405c'})),
    ('portrait', [(0x1FA0, 2, 16)],
     dict(VALUE={1: '#c89838', 3: '#f0d0b0', 2: '#7a3a9a', 0: '#2a2030'})),
    ('portrait2', [(0x1FE0, 2, 16)],
     dict(VALUE={1: '#c89838', 3: '#f0d0b0', 2: '#b04020', 0: '#2a2030'})),

    # ---- 골목 ----
    ('window', [(0x2680, 5, 16)],
     dict(GRAD={1: ('#78c0f0', '#2a5a98')}, VALUE={3: '#e8f4ff', 0: '#2a1c14', 2: '#8a5a34'})),
    ('fence_stain', seq(0x2944, 0x0A, 3, 1, 5), dict(VALUE={2: '#34283a'})),
    ('trash_lid', [(0x2976, 5, 12)],
     dict(BG={1, 2}, VALUE={3: '#c8ccd4', 0: '#18181e'}, INNER={1: '#747c88', 2: '#4a505c'})),
    ('trash_body', [(0x29EE, 4, 8), (0x2A2E, 4, 11)],
     dict(BG={1, 2}, GRAD={3: ('#d0d4dc', '#8a909a')}, VALUE={0: '#18181e'},
          INNER={1: '#7a828e', 2: '#50566a'})),
    ('junk_fish', [(0x56E0, 3, 18)], dict(BG={2}, VALUE={3: '#dcd8cc', 0: '#282030', 1: '#6a8898'})),
    ('junk_bone', [(0x574C, 3, 8)], dict(BG={2}, VALUE={3: '#f0e8d8', 0: '#302820', 1: '#b0a898'})),
    ('junk_rat', [(0x577C, 2, 10)], dict(BG={2}, VALUE={1: '#7a6a5a', 3: '#b8a898', 0: '#201818'})),
    ('junk_spill', [(0x57A4, 2, 15)],
     dict(BG={2}, VALUE={1: '#6a9a40', 3: '#b0b8c0', 0: '#202020'}, INNER={2: '#8a6a3a'})),
    ('junk_can', [(0x57E0, 2, 12)], dict(BG={2}, VALUE={3: '#b8c0c8', 1: '#d05838', 0: '#202028'})),
    ('junk_boot', [(0x5810, 2, 15)], dict(BG={2}, VALUE={3: '#9a6a3a', 1: '#5a3a20', 0: '#1c1410'})),
    ('digits', seq(0x2720, 0x10, 10, 1, 8), dict(VALUE={0: '#f8f0c0'})),
    ('graffiti', seq(0x27C0, 0x10, 13, 1, 8), dict(VALUE={0: '#f050a0'})),
    ('skill_k', [(0x2890, 1, 8)], dict(VALUE={0: '#f050a0'})),        # 난이도 K (H/T/A 는 낙서 글자를 쓴다)
    ('line_mouse', seq(0x1E30, 0x20, 5, 2, 8), dict(VALUE={0: '#a09088'}, EDGE={0: '#dcd0c4'})),
    ('mouse_points', seq(0x1DD0, 0x20, 3, 2, 8), dict(VALUE={3: '#fff4c0', 2: '#e02040'})),
    ('squeek', [(0x1D70, 6, 8)], dict(VALUE={2: '#ffd020', 3: '#a04010'})),
    ('bonk', [(0x1679, 5, 18)], dict(VALUE={2: '#ff5010', 3: '#ffe050'})),
    ('thrown_bottle', [(0x172D, 2, 12)], dict(VALUE={3: '#50b060', 1: '#e8e0c0', 2: '#206030'})),
    ('thrown_phone', [(0x175D, 2, 9)], dict(VALUE={1: '#d83030', 3: '#f0f0f0'})),
    ('thrown_stick', [(0x1781, 2, 6)], dict(VALUE={1: '#a06830', 3: '#d09050'})),
    ('thrown_boot', [(0x1799, 2, 12)], dict(VALUE={1: '#8a5428', 3: '#c09060'})),
    ('popper', [(0x1CF0, 2, 13)], dict(VALUE={2: '#e08830', 3: '#fff0d8', 1: '#50d050'})),
    ('sock', [(0x0440, 1, 8)], dict(BG={2}, VALUE={3: '#e84848', 1: '#f8f0f0'})),
    ('sock2', [(0x0450, 1, 8)], dict(BG={2}, VALUE={3: '#4890e0', 1: '#f8f0f0'})),
    ('pants', [(0x0460, 2, 8)], dict(BG={2}, VALUE={3: '#f090c0', 1: '#f8f0f0'})),
    ('sock3', [(0x0480, 1, 8)], dict(BG={2}, VALUE={3: '#e8c840', 1: '#f8f0f0'})),
    ('shirt', [(0x0490, 2, 16)], dict(BG={2}, VALUE={3: '#f0f0e8', 0: '#4060a0'}, INNER={2: '#c0c8e0'})),

    # ---- 방 공통: 빗자루, 발자국 ----
    ('broom', seq(0x2EA0, 0x78, 7, 2, 30),
     dict(ROWS=[(0, 17, {3: '#9a6a34'}), (18, 29, {3: '#e8c858'})])),
    ('footprints', seq(0x32C2, 0x0A, 3, 1, 5), dict(VALUE={0: '#3a2410'})),   # 흙 발자국 1..3 (32B8 = 0개, 바닥 그대로)

    # ---- 어항 (물이 1) ----
    ('bowl', seq(0x3530, 0x28, 4, 2, 10),                # 탁자 위 어항: 가장자리의 2 는 벽이 비치는 곳
     dict(BG={1, 2}, CLEAR=True, VALUE={3: '#e8f8ff', 0: '#f08020'},     # 유리 테두리 바깥은 탁자/벽이 비친다
          INNER={1: '#90d0f0', 2: '#90d0f0'})),                           # 테두리 안 = 물, 검은 점 = 금붕어
    ('fish', seq(0x3300, 0x0C, 4, 1, 6), dict(VALUE={2: '#ff8818', 3: '#ffe080', 0: '#302010'})),
    ('eel', seq(0x3330, 0x08, 4, 2, 2), dict(VALUE={3: '#d0ff60', 2: '#60c040', 0: '#58c040'})),
    ('zap', [(0x3350, 5, 18)], dict(VALUE={0: '#ffe820', 3: '#ff8030'})),
    ('waves', seq(0x2020, 0x08, 4, 1, 4), dict(VALUE={3: '#d0f0ff'})),

    # ---- 책장과 거미 ----
    ('books', seq(0x3730, 0x10, 7, 1, 8),
     dict(VALUE={1: '#8a5a2a', 2: '#5a3418', 0: '#24160a'},
          VARY={3: ['#c83838', '#3858b0', '#e8d8a0', '#48904a', '#d8a030', '#804898']})),
    ('spider', [(0x38BC, 3, 14), (0x3910, 3, 14)],
     dict(VALUE={1: '#503858', 2: '#301828', 3: '#e02020'})),
    ('shelf_plants', [(0x25E4, 2, 16)], dict(BYTES=4, VALUE={0: '#b05a30', 1: '#3c9a48', 3: '#f07898'})),
    ('byte', [(0x37C0, 6, 21)], dict(VALUE={2: '#e82040', 3: '#ffe0e0'})),

    # ---- 치즈 ----
    ('mouse4', seq(0x3D20, 0x30, 4, 2, 12), dict(VALUE={0: '#a09088'}, EDGE={0: '#dcd0c4'})),

    # ---- 새장 ----
    ('cage', [(0x3FBE, 3, 16)], dict(VALUE={0: '#c89830'}, EDGE={0: '#fff080'})),
    ('broken_cage', [(0x3F36, 4, 17)], dict(VALUE={0: '#a88028'})),
    ('bird', seq(0x3EF0, 0x0A, 6, 1, 5), dict(VALUE={3: '#ffe020', 1: '#ff9010', 2: '#ff9010'})),

    # ---- 사랑의 방 (바탕이 1) ----
    ('gift', [(0x2AF0, 3, 15)], dict(VALUE={2: '#f0c040', 3: '#e02838', 0: '#401018'})),
    ('suitors', [(0x4500, 3, 12)] + seq(0x45E0, 0x48, 16, 3, 12),
     dict(GRAD={3: ('#d8d0c8', '#8a7a6a')}, EDGE={3: '#f8f0e8'})),
    ('arrows', seq(0x6F30, 0x20, 12, 2, 8), dict(VALUE={2: '#f0c040', 3: '#ff4060', 1: '#f0c040'})),
    ('floor_tiles', [(0x2DE0, 2, 8)], dict(VALUE={2: '#f03060', 3: '#ffa0b0'})),
    ('broken_tile', [(0x2E00, 2, 8)], dict(VALUE={0: '#4a1830'})),          # 밟은 칸: 깨진 하트
    ('cupids', [(0x2C60, 4, 24), (0x2D20, 4, 24)],
     dict(BYTES=8, VALUE={2: '#ffc8a8', 3: '#f8f0ff', 0: '#402030'})),

    # ---- 판 끝 ----
    ('hearts', [(0x4AEA, 2, 8), (0x4B0A, 4, 16), (0x4B8A, 7, 32)],
     dict(GRAD={2: ('#ff6090', '#c01040')}, VALUE={3: '#ffd0e0'})),
    ('kissing_cats', [(0x4A82, 4, 13)], dict(VALUE={0: CAT_BODY, 3: '#e8e0d8'})),
    ('dance_cat', [(0x4DE0, 4, 35), (0x4EF8, 4, 35)],
     dict(VALUE={3: '#d8d0c8', 2: '#f06090', 1: '#ff3050'})),
    ('owner', [(0x5B20, 4, 68), (0x5D40, 4, 68)],           # 쫓겨날 때 "HERE KITTY" 부르는 주인아주머니
     dict(ROWS=[(0, 5, {3: '#f0c8a8', 2: '#f080b0', 1: '#40a8e0'}),       # 헤어롤
                (6, 24, {3: '#f0c8a8', 2: '#9a4a28', 1: '#40a8e0'}),      # 얼굴, 머리카락, 안경
                (25, 55, {3: '#a8cce8', 2: '#4a70b0', 1: '#40a8e0'}),     # 줄무늬 가운
                (56, 67, {3: '#f0c8a8', 2: '#4a70b0', 1: '#40a8e0'})])),  # 다리
    ('here_kitty', [(0x5F68, 4, 16), (0x5FE8, 6, 21)], dict(GRAD={1: ('#fff060', '#f09020')})),
    ('sleepy', [(0x6E10, 3, 12), (0x6E58, 6, 17)],
     dict(VALUE={3: '#c8c0b8', 2: '#50c050', 1: '#e8f0ff'})),
    ('bonus_cat', [(0x35E0, 2, 15)], dict(VALUE={3: '#f0e0c8'})),          # 뒤는 검정 그대로
    ('failed', [(0x185B, 8, 12)] + seq(0x191B, 0xC0, 4, 8, 12), dict(GRAD={3: ('#fff080', '#f08020')})),

    # ---- 타이틀 (바탕 2) ----
    ('ibm_presents', [(0x6152, 11, 29)], dict(VALUE={0: '#2850c8', 1: '#a0c0ff'})),
    ('logo', [(0x63D0, 14, 22)], dict(GRAD={3: ('#fff0a0', '#e09020')}, VALUE={0: '#3a1800'})),
    ('byline', [(0x6638, 3, 12), (0x6680, 14, 8)], dict(VALUE={0: '#f0d8f0'})),
    ('copyright', [(0x6760, 12, 11), (0x6868, 4, 8), (0x68A8, 10, 12), (0x6998, 10, 12)],
     dict(VALUE={0: '#f0e8d0'})),
]
