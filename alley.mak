# ============================================================================
#  ALLEY CAT (골목 고양이)  -  djgpp 빌드
# ----------------------------------------------------------------------------
#  ..\..\djgpp.bat 로 연 창에서 이 폴더로 와서
#
#      make -f alley.mak           둘 다 만든다
#      make -f alley.mak orig      ALLEY.EXE     원판 그대로 (VGA 로 옮김)
#      make -f alley.mak vga       ALLEYVGA.EXE  개선판
#      make -f alley.mak clean
#
#  ---------------------------------------------------------------------------
#  ALLEY.EXE    - 1984년 원판(ALLYCAT.EXE, IBM PC, 어셈블리)을 역어셈블해 C 로
#       옮긴 것.  게임 규칙, 속도(BIOS 시계와 수직 귀선), PC 스피커 소리는
#       원판 그대로이고, 원판이 CGA 320x200 4색으로 그리던 화면을 VGA
#       320x200 (모드 13h) 에 똑같이 보여 준다.
#       필요한 파일 : CWSDPMI.EXE
#
#  ALLEYVGA.EXE - 개선판.  같은 소스를 -DCATVGA 로 따로 컴파일하고 화면과
#       배경음악만 바꾼다 (게임 규칙과 속도는 ALLEY.EXE 와 같다).
#       - 256색: 그림마다 새로 칠한 색 (ALLEY256.SPR, tools/mkspr256.py 가 만든다)
#       - 배경음악: 애드립(OPL2) VGM 을 SOUND.DAT 에 묶음 (tools/mkmusic.py)
#         효과음은 원판대로 PC 스피커
#       필요한 파일 : CWSDPMI.EXE, ALLEY256.SPR, SOUND.DAT
#
#  소스 (괄호 안은 원본 코드 세그먼트 위치)
#       allycat.h  공용 선언, 데이터 세그먼트 이름표
#       data.c     데이터 세그먼트 초기값             - tools/mkdata.py 가 만든다
#       main.c     본체, 방 고르기, 단축키, 입력      (0000..049F, 1200..13E7)
#       cat.c      고양이                             (0700..11F6, 15D0..1798)
#       clothes.c  빨랫줄                             (04A0..06FF, 17AD, 2A80)
#       alley.c    창문과 던진 물건, 쓰레기통 놈, 쥐  (1830..1BE2, 2210..2688)
#       dog.c      불독                               (1E40..220A)
#       screen.c   화면 바꾸기, 방 팔레트, 실패 그림  (1BF0..1E3D)
#       score.c    점수, 보너스                       (2690..2788, 38B0..3B20)
#       draw.c     골목과 방 그리기                   (2790..2CA5, 5400)
#       broom.c    빗자루와 발자국                    (3150..349B)
#       fishbowl.c 방 1, 2 어항                       (34A0..38A3)
#       spider.c   방 3 책장과 거미                   (3B30..3E88)
#       cheese.c   방 4 치즈의 쥐구멍                 (3E90..433F)
#       birdcage.c 방 5 새장                          (4340..47A5)
#       dogs.c     방 6 잠자는 개들                   (47B0..4BF7)
#       love.c     방 7 사랑의 방                     (2E60..314E, 4C10..5051, 6100..62EA)
#       win.c      판 끝 장면들                       (5060..52CC, 5313, 5BE0, 6040)
#       sound.c    PC 스피커 소리와 음악              (53B0, 5450..5BD0)
#       title.c    타이틀, 메뉴, 일시정지             (5CB0..6033)
#       gfx.c      그리기 기본, 난수, 충돌            (2B24..2E50)
#       bios.c     int 10h 흉내 (글자, 팔레트)
#       sys_dos.c  도스: 키보드 인터럽트, 시계, 포트
#     ALLEY.EXE 만
#       vidcga.c   CGA 4색 -> VGA
#     ALLEYVGA.EXE 만
#       vid256.c   256색 화면
#       col256.c   256색 칠하기 (ALLEY256.SPR, 방마다 색 테마)
#       actor.c    고양이와 불독을 부드럽게 (1점 단위 위치, 사이 동작)
#       musvgm.c   배경음악 - 애드립 VGM
#  도구 (파이썬, tools/)
#       mklist.py    역어셈블 목록 -> listing.asm
#       mkdata.py    데이터 세그먼트 -> data.c
#       emu.py       원본을 unicorn 으로 돌리는 기준 에뮬레이터
#       hosttest.c   C 판을 PC 에서 돌려 원본과 사건마다 대조 (build_host.sh)
#       difftest.py  대조 시험 (emu.py + hosttest.exe)
#       scenario.py, mkscript.py  대조 시험 입력 만들기
#       mkspr256.py  256색 그림 -> ALLEY256.SPR
#       mkmusic.py   애드립 곡 -> SOUND.DAT
# ============================================================================

CC      = gcc
CFLAGS  = -O2 -Wall -fno-strict-aliasing

GAME    = main.c cat.c clothes.c alley.c dog.c screen.c score.c draw.c broom.c \
          fishbowl.c spider.c cheese.c birdcage.c dogs.c love.c win.c sound.c \
          title.c gfx.c bios.c data.c sys_dos.c
ORIG    = $(GAME:.c=.o) vidcga.o
VGA     = $(GAME:.c=.vo) vid256.vo col256.vo actor.vo musvgm.vo

all: alley.exe alleyvga.exe

orig: alley.exe
vga:  alleyvga.exe

alley.exe: $(ORIG)
	$(CC) $(CFLAGS) -o alley.exe $(ORIG)
	strip alley.exe

alleyvga.exe: $(VGA)
	$(CC) $(CFLAGS) -o alleyvga.exe $(VGA)
	strip alleyvga.exe

%.o: %.c allycat.h platform.h
	$(CC) $(CFLAGS) -c $< -o $@

%.vo: %.c allycat.h platform.h col256.h
	$(CC) $(CFLAGS) -DCATVGA -c $< -o $@

# 시험판: ALLEYTST.TXT 로 키를 넣고 화면을 BMP 로 저장한다 (sys_dos.c 의 CAT_TEST)
test: alleytst.exe alleyvt.exe

alleytst.exe: $(GAME) vidcga.c allycat.h platform.h
	$(CC) $(CFLAGS) -DCAT_TEST -o alleytst.exe $(GAME) vidcga.c

alleyvt.exe: $(GAME) vid256.c col256.c actor.c musvgm.c allycat.h platform.h col256.h
	$(CC) $(CFLAGS) -DCAT_TEST -DCATVGA -o alleyvt.exe $(GAME) vid256.c col256.c actor.c musvgm.c

clean:
	rm -f *.o *.vo alley.exe alleyvga.exe alleytst.exe alleyvt.exe

.PHONY: all orig vga test clean
