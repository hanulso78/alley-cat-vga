/* ============================================================================
 *  allycat.h  -  ALLEY CAT (1984, Bill Williams / SynSoft, IBM) 공용 선언
 * ----------------------------------------------------------------------------
 *  ALLYCAT.EXE 는 어셈블리로 짠 16비트 도스 프로그램이다 (코드 세그먼트 0723,
 *  데이터 세그먼트 0010).  심볼 정보가 없어서 함수와 변수 이름은 하는 일을 보고
 *  새로 붙였다.  함수마다 "원래: XXXX" 로 코드 세그먼트 오프셋을 적어 두었다.
 *
 *  원본은 데이터 세그먼트 안의 위치를 곳곳에서 숫자로 주고받는다 (그림 위치를
 *  변수에 넣어 두거나, 표 안의 표를 가리키거나).  그래서 이 판도 데이터
 *  세그먼트를 64K 바이트 배열 ds[] 로 그대로 두고, 변수는 그 안의 이름 붙은
 *  자리로 쓴다:
 *
 *      #define cat_x  DW(0x0579)       -> 원래 [0579] 워드
 *      #define cat_y  DB(0x057B)       -> 원래 [057B] 바이트
 *
 *  화면은 CGA 320x200 4색 메모리(16K)를 vram[] 로 흉내 내고 원본과 똑같이
 *  그린다.  보여 주는 일은 플랫폼 쪽(sys_*.c)이 VGA 로 옮긴다.
 * ========================================================================== */
#ifndef ALLYCAT_H
#define ALLYCAT_H

#include <stdint.h>

/* ---- 메모리 ---------------------------------------------------------------- */
#define DS_IMAGE_SIZE   0x7130          /* 실행 파일 안의 데이터 세그먼트 크기 */
#define VRAM_SIZE       0x4000

extern uint8_t ds[0x10000];             /* 데이터 세그먼트 (data.c) */
extern uint8_t vram[VRAM_SIZE];         /* CGA 화면 메모리 (gfx.c) */
extern int vram_dirty;                  /* 화면이 바뀌었나 (플랫폼이 보고 지운다) */

/* 원판이 IBM PC(8088 4.77MHz)에서 쓰던 시간을 클럭 수로 센다 (gfx.c).
   게임 규칙에는 쓰지 않고, 도스 판이 이 속도에 맞춰 기다린다 (sys_dos.c).
   값은 tools/cpucost.py 로 원본을 재서 정했다. */
extern unsigned long cpu_clocks;
#define CPU(n)  (cpu_clocks += (unsigned long)(n))

/* 개선판: 지금 화면에 그린 방 (색 테마, col256.c).  원판에서는 아무것도 안 한다 */
#ifdef CATVGA
extern int theme_room;
#define SET_THEME(r)    (theme_room = (r))
#else
#define SET_THEME(r)    ((void)0)
#endif

/* 개선판: 고양이, 불독, 쥐, 새를 부드럽게 (actor.c).  원판에서는 아무것도 안 한다 */
#define ACTORS  10      /* 직접 잡는 번호: 0 고양이, 1 불독, 2..4 빨랫줄 쥐, 5..8 치즈 방 쥐, 9 새 */
/* 개선판: 어항 속 헤엄이 한 틱에 한 걸음이라 굼뜨다 - 한 틱에 세 걸음, 걸음은 3/4
   (모두 합쳐 원판의 2.25 배쯤, 방향 바꾸기와 가속은 세 배 빨리 먹힌다).
   키를 떼면 네 배 빨리 멈춘다 (원판은 한참 미끄러져서 돌아서기 어려웠다) */
#ifdef CATVGA
#define SWIM_BOOST(v)   (((v) * 3 + 2) / 4)
#define SWIM_DECEL      4
#else
#define SWIM_BOOST(v)   (v)
#define SWIM_DECEL      1
#endif
#ifdef CATVGA
extern int actor_capture;
extern int actor_title;            /* 첫 화면 중 (고양이 테두리) */
extern int actor_fast;             /* 느린 기계에서 모양 섞기를 건너뛴다 */
extern int actor_shift, actor_shift_on;
extern uint8_t text_col256;         /* 0 이 아니면 BIOS 글자를 이 색으로 (bios.c) */
/* 바뀐 곳만 다시 칠하기: 줄마다 바뀐 구간 (gfx.c 가 적고, col256.c 가 읽는다) */
extern short dirty_lx[200], dirty_rx[200];
extern short off_row[0x2000], off_col[0x2000];   /* 화면 위치 -> 점 좌표 (gfx.c) */
void off_table_init(void);
void vram_dirty_span(int y, int x0, int x1);
void vram_dirty_all(void);
void vram_dirty_clear(void);
void actor_prepare(double now);
uint8_t col256_nearest(int r, int g, int b);
void actor_begin(int id);
void actor_end(int id, uint16_t org_scr, int exact_x, uint16_t src);
void actor_set(uint16_t off, int k, uint8_t color);
void actor_touch(uint16_t off);
void actor_move(uint16_t dst, uint16_t src);
void actor_auto_begin(uint16_t save);
void actor_auto_end(uint16_t org_scr, uint16_t src);
void actor_begin_key(uint32_t key);
void actor_line_scroll(int line, uint16_t band_start, int dir);
void actor_reset_all(void);
extern volatile int warp_room;     /* Alt+1..7: 들어갈 방 (main.c) */
extern int warp_target;
void vram_plot(int x, int y, uint8_t v);
#define ACTOR_BEGIN(id)             actor_begin(id)
#define ACTOR_END(id, scr, x, src)  actor_end(id, scr, x, src)
#define ACTOR_BEGIN_KEY(key)        actor_begin_key(key)
#define ACTOR_LINE_SCROLL(l, s, d)  actor_line_scroll(l, s, d)
#define ACTOR_TITLE(on)             (actor_title = (on))
#define ACTOR_SHIFT(dx)             (actor_shift = (dx), actor_shift_on = 1)
#else
#define ACTOR_BEGIN(id)             ((void)0)
#define ACTOR_END(id, scr, x, src)  ((void)0)
#define ACTOR_BEGIN_KEY(key)        ((void)0)
#define ACTOR_LINE_SCROLL(l, s, d)  ((void)0)
#define ACTOR_TITLE(on)             ((void)0)
#define ACTOR_SHIFT(dx)             ((void)0)
#endif

/* 개선판: 애드립 배경음악 (musvgm.c).  원판에서는 아무것도 안 한다.
   TUNE_SPEAKER 가 0 이면 원판의 음악(타이틀 곡, 걷는 베이스, 판 끝 곡)은
   스피커를 건드리지 않고 박자만 센다. */
enum { SONG_NONE, SONG_TITLE, SONG_ALLEY, SONG_ROOM, SONG_FISH, SONG_LOVE,
       SONG_HEARTS, SONG_WIN, SONG_BONUS, SONG_SAD, SONG_CAUGHT, SONGS };
#ifdef CATVGA
void music_play(int song, int restart);
void music_stop(void);
void music_pause(int on);
#define MUSIC(s, restart)   music_play(s, restart)
#define MUSIC_STOP()        music_stop()
#define MUSIC_PAUSE(on)     music_pause(on)
#define TUNE_SPEAKER        0
#else
#define MUSIC(s, restart)   ((void)0)
#define MUSIC_STOP()        ((void)0)
#define MUSIC_PAUSE(on)     ((void)0)
#define TUNE_SPEAKER        1
#endif

#define DB(o)   (ds[(uint16_t)(o)])
#define DW(o)   (*(uint16_t *)(ds + (uint16_t)(o)))    /* -fno-strict-aliasing */

/* ---- 방 번호 --------------------------------------------------------------- */
enum {
    ROOM_ALLEY = 0,         /* 골목 */
    ROOM_TABLE,             /* 1 탁자 위 어항 */
    ROOM_FISHBOWL,          /* 2 어항 속 */
    ROOM_SPIDER,            /* 3 책장과 거미 */
    ROOM_MICE,              /* 4 치즈의 쥐구멍 */
    ROOM_BIRDCAGE,          /* 5 새장 */
    ROOM_DOGS,              /* 6 잠자는 개들 */
    ROOM_LOVE               /* 7 사랑의 방 */
};

/* ---- 키 (키보드 인터럽트가 DS:06B7+번호 에 0 = 누름, 80 = 뗌) ------------- */
enum {
    KEY_ALT, KEY_UP_ARROW, KEY_RIGHT_ARROW, KEY_DOWN_ARROW, KEY_LEFT_ARROW,
    KEY_PGUP, KEY_PGDN, KEY_END, KEY_HOME, KEY_ESC, KEY_Y, KEY_N,
    KEY_K, KEY_H, KEY_T, KEY_A, KEY_S, KEY_R, KEY_CTRL, KEY_DEL, KEY_M, KEY_9,
    KEY_COUNT
};
#define KEY_SCANCODES           0x06A1  /* 스캔 코드 22개 */
#define KEY_STATE               0x06B7
#define key_state(k)            DB(KEY_STATE + (k))
#define KEY_DOWN(k)             (!(key_state(k) & 0x80))

/* ============================================================================
 *  데이터 세그먼트 이름표
 *      이름(i) 는 표 (워드 표는 DW(자리 + 2*i)),  대문자는 그림/버퍼/표 자리
 * ========================================================================== */

/* ---- 본체 (main.c) --------------------------------------------------------- */
#define sound_on                DB(0x0000)  /* FF = 소리 켬 (Ctrl-S) */
#define alley_cat_x             DW(0x0001)  /* 방에 들어갈 때 골목 위치 */
#define alley_cat_y             DB(0x0003)
#define room                    DW(0x0004)
#define prev_room               DW(0x0006)
#define level                   DW(0x0008)  /* 판 0..7 (난이도에서 시작) */
#define SCRATCH                 0x000E      /* 임시 그림 버퍼 */
#define frame_div               DB(0x040F)
#define room_start_ticks        DW(0x0410)
#define level_start_ticks       DW(0x0412)
#define rooms_won               DW(0x0414)  /* 이번 판에 깬 방 = 사랑의 방 선물 수 */
#define unused_416              DW(0x0416)
#define love_room_next          DB(0x0418)  /* 방을 깼다: 다음 창문은 사랑의 방 */
#define back_from_room          DB(0x0419)
#define menu_done               DB(0x041A)
#define restart_req             DB(0x041B)  /* Ctrl-R */
#define menu_req                DB(0x041C)  /* Ctrl-M */
#define last_room               DW(0x041D)
#define last_room2              DW(0x041F)
#define room_by_window(i)       DB(0x0421 + (i))
#define random_room(i)          DB(0x042D + (i))

/* ---- 빨랫줄 (clothes.c) ---------------------------------------------------- */
#define CLOTHES_TOP_SPR         0x0460
#define CLOTHES_BIG_SPR         0x0490
#define clothes_item_sprite(i)  DW(0x04D0 + 2 * (i))
#define cat_on_line             DB(0x04D6)
#define CLOTHES_PIECE           0x04D7
#define line_scroll_start(i)    DW(0x0517 + 2 * (i))
#define line_entry_offset(i)    DW(0x051D + 2 * (i))
#define line_entry              DW(0x0523)
#define line_column             DB(0x0525)
#define line_column_start(i)    DB(0x0526 + (i))
#define line_column_step(i)     DB(0x0529 + (i))
#define line_clothes_chance(i)  DB(0x052C + (i))
#define active_line             DW(0x052F)
#define line_scroll_delay       DB(0x0531)
#define line_scroll_speed(i)    DB(0x0532 + (i))
#define line_foot_max(i)        DB(0x053A + (i))
#define line_foot_min(i)        DB(0x053D + (i))
#define piece_bits              DB(0x0540)
#define line_bits_insert(i)     DB(0x0541 + (i))
#define line_scroll_ticks       DW(0x0544)
#define line_bits(i)            DB(0x1016 + (i))
#define line_bits_base(i)       DB(0x1025 + (i))
#define clothes_rate(i)         DB(0x2ABA + (i))

/* ---- 고양이 (cat.c) -------------------------------------------------------- */
#define cat_perch               DB(0x0550)  /* 1 담장 위, 2 담장 뒤로 떨어지는 중 */
#define exit_room               DB(0x0551)  /* 방으로 들어간다 / 방에서 나간다 */
#define cat_caught              DB(0x0552)  /* 방에서 잡혔다 (DD = 개에게 쫓겨남) */
#define room_cleared            DB(0x0553)
#define fishbowl_entered        DW(0x0554)
#define perch_ticks             DW(0x0556)
#define cat_enter_steps         DB(0x0558)  /* 가장자리에서 들어오는 중 */
#define cat_enter_delay         DB(0x0559)
#define cat_knocked_down        DB(0x055A)
#define cat_jump_delay          DB(0x055B)
#define cat_standing            DB(0x055C)
#define cat_sprite              DW(0x055D)
#define cat_scr                 DW(0x055F)
#define cat_save_size           DW(0x0561)
#define cat_new_scr             DW(0x0563)
#define cat_sprite_size         DW(0x0565)
#define cat_jump_size           DW(0x0567)
#define cat_jump_sprite         DW(0x0569)
#define cat_walk_frame          DB(0x056B)
#define cat_popped              DB(0x056C)
#define cat_idle_count          DB(0x056D)
#define cat_hdir                DB(0x056E)
#define cat_prev_hdir           DB(0x056F)
#define cat_prev_vdir           DB(0x0570)
#define cat_vdir                DB(0x0571)
#define cat_speed_x             DW(0x0572)
#define cat_swim_accel          DW(0x0574)
#define cat_vy                  DB(0x0576)
#define cat_vy_frac             DB(0x0577)
#define cat_vy_rate             DB(0x0578)
#define cat_x                   DW(0x0579)
#define cat_y                   DB(0x057B)
#define cat_foot_y              DB(0x057C)
#define cat_ticks               DW(0x057D)
#define cat_ticks_prev          DW(0x057F)
#define splat_scr               DW(0x0581)
#define cat_hidden              DB(0x0583)
#define cat_bounced             DB(0x0584)
#define cat_bounce_frame        DW(0x0585)
#define cat_swim_frame          DW(0x0587)
#define AIR_BUBBLE_TIME         0x0589      /* 판마다 (워드 표) */
#define AIR_DROWN_TIME          0x0599
#define AIR_WARN1_TIME          0x05A9
#define AIR_WARN2_TIME          0x05B9
#define AIR_WARN3_TIME          0x05C9
#define room_cat_x(i)           DW(0x05D9 + 2 * (i))
#define room_cat_y(i)           DB(0x05E9 + (i))
#define air_ticks               DW(0x05F1)
#define cat_drowning            DB(0x05F3)
#define bubble_rise             DB(0x05F4)
#define bubble_delay            DB(0x05F5)
#define cat_min_x               DW(0x05F6)
#define cat_max_x               DW(0x05F8)
#define CAT_SAVE                0x05FA
#define BUBBLE_SPR              0x064E      /* "GLUB" */
#define swim_max_speed(i)       DW(0x066C + 2 * (i))
#define swim_max_vy(i)          DB(0x067C + (i))
#define cat_frame_count         DW(0x0684)
#define SWIM_SPRITES            0x09A6
#define SWIM_SIZES              0x09C0
#define SPR_CAT_CROUCH          0x09DA
#define cat_walk_sprites(i)     DW(0x0F7A + 2 * (i))
#define cat_idle_heads(i)       DW(0x0F92 + 2 * (i))
#define cat_idle_tails(i)       DW(0x0FA2 + 2 * (i))
#define cat_jump_sprites(i)     DW(0x0FAA + 2 * (i))
#define cat_jump_sizes(i)       DW(0x0FB6 + 2 * (i))
#define CAT_BOUNCE_SPRITES      0x0FC2
#define CAT_BOUNCE_SIZES        0x0FD2
#define trash_can(i)            DB(0x0FF0 + (i))
#define trash_first(i)          DB(0x1006 + (i))
#define trash_count(i)          DB(0x100E + (i))
#define last_trash_can          DB(0x1028)
#define plat_y(i)               DB(0x1029 + (i))
#define plat_stand(i)           DB(0x1089 + (i))
#define plat_x(i)               DW(0x10E9 + 2 * (i))
#define plat_w(i)               DW(0x11A9 + 2 * (i))
#define room_plat_first(i)      DW(0x1269 + 2 * (i))
#define plat_w_tmp              DW(0x1279)
#define plat_stand_tmp          DB(0x127B)
#define on_trash_can            DB(0x127C)
#define SPLAT_SPR               0x1679      /* "BONK!" */

/* ---- 입력 (main.c) --------------------------------------------------------- */
#define crt_hpos                DB(0x0690)
#define last_key_count          DW(0x0691)
#define key_count               DW(0x0693)  /* 키를 누를 때마다 는다 */
#define machine_model           DB(0x0697)
#define joy_x                   DB(0x0698)
#define joy_y                   DB(0x0699)
#define fire                    DB(0x069A)  /* 0 = 눌림 */
#define use_joystick            DB(0x069B)
#define joy_start               DW(0x069C)
#define joy_pending             DB(0x069E)
#define input_ticks             DW(0x069F)

/* ---- 창문과 던진 물건 (alley.c) -------------------------------------------- */
#define dog_sprites(i)          DW(0x15C8 + 2 * (i))
#define WINDOW_SWEETIE_SPR      0x15E0
#define window_col_x(i)         DW(0x1658 + 2 * (i))
#define window_row_y(i)         DB(0x1660 + (i))
#define mouse_under_window      DB(0x1664)
#define window_anim             DB(0x1665)
#define window_x                DW(0x1666)
#define window_y                DB(0x1668)
#define window_number           DB(0x1669)
#define window_delay            DB(0x166A)
#define window_row              DB(0x166B)
#define window_open_time        DW(0x166C)
#define window_ticks            DW(0x166E)
#define throws_left             DB(0x1670)
#define thrown_x                DW(0x1671)
#define thrown_y                DB(0x1673)
#define thrown_dir              DB(0x1674)
#define thrown_hit              DB(0x1675)
#define thrown_floor            DB(0x1676)
#define thrower_aims            DB(0x1677)
#define thrown_is_deadly        DB(0x1678)
#define thrown_sprites(i)       DW(0x17C9 + 2 * (i))
#define thrown_sizes(i)         DW(0x17D1 + 2 * (i))
#define thrown_floors(i)        DB(0x17D9 + (i))
#define thrown_sprite           DW(0x17DD)
#define thrown_size             DW(0x17DF)
#define thrown_draw_size        DW(0x17E1)
#define thrown_save_size        DW(0x17E3)
#define thrown_scr              DW(0x17E5)
#define thrown_new_scr          DW(0x17E7)
#define thrown_fall             DB(0x17E9)
#define thrown_speed            DW(0x17EA)
#define thrown_ticks            DW(0x17EC)
#define THROWN_SAVE             0x17EE
#define window_open_ticks(i)    DW(0x181E + 2 * (i))
#define WINDOW_GLASS_SPR        0x2681

/* ---- 화면 바꾸기 (screen.c) ------------------------------------------------ */
#define failed_ticks            DW(0x1830)
#define wipe_x                  DW(0x1832)
#define wipe_y                  DB(0x1834)
#define wipe_width              DW(0x1835)
#define wipe_rows               DB(0x1837)
#define wipe_edges              DB(0x1838)
#define wipe_fill               DW(0x1839)
#define room_palette(i)         DB(0x1853 + (i))
#define FAILED_DEFAULT_SPR      0x185B
#define failed_mask             DW(0x1C1B)
#define failed_count            DB(0x1C1D)
#define failed_masks(i)         DW(0x1C1E + 2 * (i))
#define failed_sprites(i)       DW(0x1C26 + 2 * (i))
#define failed_sprite           DW(0x1C2E)
#define chased_out_frame        DW(0x1C30)

/* ---- 개 (dog.c) ------------------------------------------------------------ */
#define DOG_SAVE                0x1C40
#define dog_has_cat             DB(0x1CB8)  /* 고양이를 물고 가는 방향 */
#define dog_wiggle              DW(0x1CB9)
#define dog_sprite              DW(0x1CBB)
#define dog_scr                 DW(0x1CBD)
#define dog_running             DB(0x1CBF)
#define dog_entering            DB(0x1CC0)
#define dog_leaving             DB(0x1CC1)
#define dog_save_size           DW(0x1CC2)
#define dog_size                DW(0x1CC4)
#define dog_x                   DW(0x1CC6)
#define dog_y                   DB(0x1CC8)
#define dog_ticks               DW(0x1CC9)
#define dog_new_scr             DW(0x1CCD)
#define dog_frame               DB(0x1CCF)
#define dog_dir                 DB(0x1CD0)
#define dog_start_chance(i)     DB(0x1CD1 + (i))
#define dog_turn_chance(i)      DB(0x1CD9 + (i))
#define dog_steps               DW(0x1CE1)

/* ---- 쓰레기통 놈 (alley.c) ------------------------------------------------- */
#define POPPER_SPR              0x1CF0
#define POPPER_SAVE             0x1D24
#define popper_woke_dog         DB(0x1D58)
#define popper_anim             DB(0x1D59)
#define popper_ticks            DW(0x1D5A)
#define popper_x                DW(0x1D5C)
#define popper_base_y           DB(0x1D5E)
#define popper_y                DB(0x1D5F)
#define popper_scr              DW(0x1D60)
#define popper_new_scr          DW(0x1D62)
#define popper_size             DW(0x1D64)
#define popper_save_size        DW(0x1D66)

/* ---- 빨랫줄 쥐 (alley.c) --------------------------------------------------- */
#define SQUEEK_SPR              0x1D70
#define MOUSE_SIT_SPR           0x1E30
#define MOUSE_RUN_SPR           0x1E50
#define mouse_x(i)              DW(0x1F30 + 2 * (i))
#define mouse_y(i)              DB(0x1F36 + (i))
#define mouse_points(i)         DB(0x1F39 + (i))
#define mouse_dir(i)            DB(0x1F3C + (i))
#define mouse_prev_dir(i)       DB(0x1F3F + (i))
#define mouse_scr(i)            DW(0x1F42 + 2 * (i))
#define mouse_hidden(i)         DB(0x1F48 + (i))
#define mouse_new_scr           DW(0x1F4B)
#define mouse_anim(i)           DB(0x1F4D + (i))
#define mouse_caught(i)         DB(0x1F50 + (i))
#define mouse_caught_ticks(i)   DW(0x1F53 + 2 * (i))
#define mouse_save(i)           DW(0x1F59 + 2 * (i))
#define mouse_points_spr(i)     DW(0x1F5F + 2 * (i))
#define mice_ticks              DW(0x1F65)
#define squeek_scr              DW(0x1F67)
#define mouse_speed             DW(0x1F69)
#define mouse_turn              DW(0x1F6C)
#define mouse_flee_chance(i)    DB(0x1F6E + (i))

/* ---- 점수 (score.c) -------------------------------------------------------- */
#define lives                   DB(0x1F80)
#define lives_shown             DB(0x1F81)
#define SCORE                   0x1F82      /* 7자리 BCD */
#define HIGH_SCORE              0x1F89
#define digit_scr               DW(0x1F90)
#define digit_count             DB(0x1F92)
#define digit_ptr               DW(0x1F93)
#define DIGIT_SPR               0x2720

/* ---- 방과 골목 그리기 (draw.c) --------------------------------------------- */
#define room_list_base          DW(0x2634)
#define room_exit_x             DW(0x2650)  /* 방의 나가는 창문 */
#define room_exit_y             DB(0x2652)
#define wave_last               DB(0x2653)
#define wave_draw_col           DW(0x2654)
#define wave_phase(i)           DB(0x2656 + (i))
#define room_frame_base         DW(0x267E)
#define WINDOW_SPR              0x2680
#define FENCE_TOP_SPR           0x2904
#define BONE_SPR                0x296C
#define TRASH_LID_SPR           0x2976
#define TRASH_BODY_SPR          0x29EE
#define TRASH_BOTTOM_SPR        0x2A2E
#define TRASH_LAYOUT            0x2A86
#define TRASH_LAYOUT_FIRST      0x2AB2
#define alley_ptr               DW(0x2AC2)
#define alley_count             DB(0x2AC4)
#define trash_draw_i            DW(0x2AC5)
#define SKILL_BADGES            0x2AD1
#define rand_seed               DW(0x2AE5)
#define DECOR_SPRITES           0x584C
#define DECOR_SIZES             0x5858
#define DECOR_INDEX             0x5888
#define DECOR_LISTS             0x5908
#define decor_base              DW(0x5918)

/* ---- 사랑의 방 (love.c) ---------------------------------------------------- */
#define GIFT_SPR                0x2AF0
#define gift_start_x(i)         DW(0x2B4A + 2 * (i))
#define gift_x(i)               DW(0x2B5A + 2 * (i))
#define gift_y(i)               DB(0x2B6A + (i))
#define GIFT_PRESENT            0x2B72
#define gift_present(i)         DB(GIFT_PRESENT + (i))
#define GIFT_BG_SPR             0x2B7A
#define floor_y(i)              DB(0x2BD4 + (i))
#define floor_row(i)            DB(0x2BDB + (i))
#define floor_hole(i)           DB(0x2BE2 + (i))
#define FLOOR_TILE_SPRITES      0x2E20
#define LOVE_ROOM_LIST          0x2E24
#define floor_draw_x            DW(0x2E88)
#define floor_draw_y            DB(0x2E8A)
#define floor_draw_i            DW(0x2E8B)
#define gift_carried            DW(0x2E8D)
#define gift_ticks              DW(0x2E8F)
#define gift_best_dy            DB(0x2E91)
#define gift_best_floor         DW(0x2E92)
#define gift_dropped            DW(0x2E94)
#define gift_drop_x             DW(0x2E96)
#define gift_drop_y             DB(0x2E98)
#define SUITOR_STAND_SPR        0x4500
#define SUITOR                  0x4548      /* 지금 움직이는 수컷 고양이 (12바이트) */
#define suitor_x                DW(0x4548)
#define suitor_dir              DB(0x454A)
#define suitor_y                DB(0x454B)
#define suitor_scr              DW(0x454C)
#define suitor_hidden           DB(0x454E)
#define suitor_wait             DW(0x454F)
#define suitor_frame            DW(0x4551)
#define suitor_stun             DB(0x4553)
#define SUITOR_RECORDS          0x45A8
#define suitor_turn             DW(0x45B6)
#define suitor_ticks            DW(0x45B8)
#define suitor_new_scr          DW(0x45BA)
#define suitor_speed            DW(0x45BC)
#define suitor_quiet            DB(0x45BE)
#define suitor_chase(i)         DB(0x45BF + (i))
#define suitor_wait_time(i)     DW(0x45C7 + 2 * (i))
#define SUITOR_SPRITES          0x4A60
#define ARROW_SPR               0x6F30
#define arrow_side_y(i)         DB(0x70B0 + (i))
#define arrow_top_x(i)          DW(0x70B8 + 2 * (i))
#define ARROW_SAVE              0x70CC
#define arrow_last_tile         DW(0x70EC)
#define arrow_ticks             DW(0x70EE)
#define arrow_frame             DW(0x70F0)
#define arrow_active            DB(0x70F2)
#define arrow_x                 DW(0x70F3)
#define arrow_y                 DB(0x70F5)
#define arrow_dir               DB(0x70F6)
#define arrow_hidden            DB(0x70F7)
#define arrow_scr               DW(0x70F8)
#define arrow_new_scr           DW(0x70FA)
#define FLOOR_TILE_X            0x70FC
#define floor_tile_y(i)         DB(0x7120 + (i))

/* ---- 빗자루 (broom.c) ------------------------------------------------------ */
#define BROOM_SAVE              0x31E8
#define BROOM_SPRITES           0x3260
#define broom_frame             DW(0x327A)
#define broom_x                 DW(0x327D)
#define broom_y                 DB(0x327F)
#define broom_dx                DB(0x3280)
#define broom_dy                DB(0x3281)
#define broom_scr               DW(0x3282)
#define broom_new_scr           DW(0x3284)
#define broom_hidden            DB(0x3286)
#define broom_col               DW(0x328A)
#define broom_ticks             DW(0x328C)
#define footprint(i)            DB(0x328E + (i))
#define footprint_col           DW(0x32B6)
#define FOOTPRINT_SPR           0x32B8
#define broom_count             DB(0x32EA)
#define broom_mood              DB(0x32EB)
#define broom_dist              DB(0x32EC)
#define broom_toward_x          DB(0x32ED)
#define broom_toward_y          DB(0x32EE)
#define broom_old_x             DW(0x32EF)
#define broom_old_y             DB(0x32F1)
#define broom_speed(i)          DW(0x32F2 + 2 * (i))

/* ---- 어항 (fishbowl.c) ----------------------------------------------------- */
#define WAVE_SPR                0x2020
#define FISH_SPR                0x3300
#define EEL_SPR                 0x3330
#define ZAP_SPR                 0x3350
#define WATER_SPR               0x3404
#define fish_left               DB(0x3410)
#define fish_anim               DW(0x3411)
#define eel_anim                DW(0x3413)
#define fish_turn               DW(0x3415)
#define fish_dir_x(i)           DB(0x3417 + (i))
#define fish_dir_y(i)           DB(0x342F + (i))
#define fish_x(i)               DW(0x3447 + 2 * (i))
#define fish_y(i)               DB(0x3477 + (i))
#define fish_hidden(i)          DB(0x348F + (i))
#define fish_gone(i)            DB(0x34A7 + (i))
#define fish_scr(i)             DW(0x34BF + 2 * (i))
#define fish_new_scr            DW(0x34EF)
#define fish_home_y(i)          DB(0x34F1 + (i))
#define fish_ticks              DW(0x3509)
#define fish_ticks2             DW(0x350B)
#define wave_col                DW(0x350D)
#define wave_ticks              DW(0x350F)
#define fish_check_i            DW(0x3511)
#define fish_hit_w(i)           DW(0x3513 + 2 * (i))
#define fish_hit_h(i)           DW(0x3517 + 2 * (i))
#define fish_eaten_now          DB(0x351B)
#define eels_absent(i)          DB(0x351C + (i))
#define BOWL_SPRITES            0x35D0
#define bowl_frame              DW(0x35D8)
#define bowl_ticks              DW(0x35DA)

/* ---- 보너스 (score.c) ------------------------------------------------------ */
#define BONUS_SPR               0x35E0
#define BONUS_LIST              0x361C
#define BCD_POW2                0x3630      /* 7자리 BCD 1, 2, 4 .. 4096 */
#define bonus_time_bits         DW(0x368B)
#define BONUS_DIGITS            0x368D
#define bonus_ticks             DW(0x3695)
#define bonus_time              DW(0x3697)
#define bonus_flash_color       DB(0x3699)
#define bonus_stop              DW(0x369A)
#define bonus_base              DW(0x369C)
#define bonus_row               DB(0x369E)
#define bonus_with_sound        DB(0x369F)
#define bonus_print_i           DW(0x36A0)
#define room_base_bonus(i)      DW(0x36CC + 2 * (i))
#define level_multiplier(i)     DW(0x36DC + 2 * (i))
#define MULTIPLIER_DIGITS       0x36EC
#define multiplier_index        DW(0x370C)
#define MULTIPLIER_TEXT         0x370E
#define bonus_show_ticks        DW(0x3722)

/* ---- 책장과 거미 (spider.c) ------------------------------------------------ */
#define BOOK_SPR                0x3730
#define shelf_row_scr           DW(0x37A0)
#define shelf_tile              DB(0x37A2)
#define SHELF_TARGET_X          0x37A3
#define shelf_target_scr(i)     DW(0x37A9 + 2 * (i))
#define shelf_targets_left      DB(0x37AF)
#define SHELF_TARGET            0x37B0
#define shelf_target(i)         DW(SHELF_TARGET + 2 * (i))
#define shelf_check             DW(0x37B6)
#define shelf_ticks             DW(0x37B8)
#define BYTE_SPR                0x37C0      /* "BYTE!" */
#define SPIDER_SPR              0x38BC
#define spider_x                DW(0x3964)
#define spider_y                DB(0x3966)
#define spider_vdir             DB(0x3967)
#define spider_scr              DW(0x3968)
#define spider_hidden           DB(0x396A)
#define spider_frame            DW(0x396B)
#define spider_frame_delay      DB(0x396D)
#define spider_climb            DB(0x396E)
#define SPIDER_SAVE             0x396F
#define spider_old_x            DW(0x39C3)
#define spider_old_y            DB(0x39C5)
#define spider_speed            DW(0x39C6)
#define spider_ticks            DW(0x39C8)
#define spider_new_scr          DW(0x39CA)
#define spider_speeds(i)        DW(0x39CC + 2 * (i))

/* ---- 치즈 (cheese.c) ------------------------------------------------------- */
#define hole_index              DB(0x39E0)  /* 서 있는 구멍 번호+1 */
#define hole_anim               DB(0x39E1)
#define hole_in_scr             DW(0x39E2)
#define hole_in_ofs             DW(0x39E4)
#define hole_out_scr            DW(0x39E6)
#define hole_out_ofs            DW(0x39E8)
#define CHEESE_SPR              0x3AEA
#define CHEESE_BUMP_SPR         0x3AF8
#define CHEESE_PIT_SPR          0x3B02
#define HOLE_LIST               0x3C56
#define HOLE_LIST_DST           0x3C5A
#define cheese_row_len(i)       DB(0x3CAE + (i))
#define cheese_row_scr          DW(0x3CBF)
#define cheese_row              DW(0x3CC1)
#define hole_pairs(i)           DB(0x3CC3 + (i))
#define hole_link(i)            DB(0x3CE3 + (i))
#define hole_out_x              DW(0x3D03)
#define hole_out_y              DB(0x3D05)
#define HOLE_ANIM_SPRITES       0x3D06
#define hole_ticks              DW(0x3D16)
#define hole_delay_ticks        DW(0x3D18)
#define MOUSE4_SPR              0x3D20
#define MOUSE4_WALK             0x3DE0
#define m4_new_scr              DW(0x3DE4)
#define m4_scr(i)               DW(0x3EA6 + 2 * (i))
#define m4_hidden(i)            DB(0x3EAE + (i))
#define m4_caught(i)            DB(0x3EB2 + (i))
#define m4_timer(i)             DB(0x3EB6 + (i))
#define m4_hole(i)              DW(0x3EBA + 2 * (i))
#define m4_save(i)              DW(0x3EC2 + 2 * (i))
#define m4_sprite               DW(0x3ECA)
#define m4_x(i)                 DW(0x3ECC + 2 * (i))
#define m4_y(i)                 DB(0x3ED4 + (i))
#define mice4_left              DB(0x3ED8)
#define m4_tries                DB(0x3ED9)
#define m4_turn                 DW(0x3EDA)
#define m4_ticks                DW(0x3EDC)
#define m4_near(i)              DW(0x3EDE + 2 * (i))

/* ---- 새장 (birdcage.c) ----------------------------------------------------- */
#define BIRD_SAVE               0x3F2C
#define BROKEN_CAGE_SPR         0x3F36
#define CAGE_SPR                0x3FBE
#define CAGE_SAVE               0x401E
#define cage_scr                DW(0x40A6)
#define cage_x                  DW(0x40A8)
#define cage_y                  DB(0x40AA)
#define cage_new_scr            DW(0x40AB)
#define cage_ticks              DW(0x40AD)
#define cage_pushed             DB(0x40AF)
#define cage_push_dir           DB(0x40B0)
#define cage_fell               DB(0x40B1)
#define bird_x                  DW(0x40B2)
#define bird_y                  DB(0x40B4)
#define bird_ticks              DW(0x40B5)
#define bird_dx                 DB(0x40B7)
#define bird_dy                 DB(0x40B8)
#define bird_hidden             DB(0x40B9)
#define bird_scr                DW(0x40BA)
#define bird_new_scr            DW(0x40BC)
#define bird_frame              DW(0x40BE)
#define BIRD_SPRITES            0x40C0
#define bird_goal               DW(0x40C8)
#define bird_away_dx            DB(0x40CA)
#define bird_away_dy            DB(0x40CB)
#define bird_dist               DW(0x40CC)
#define bird_flee_dist(i)       DW(0x40CE + 2 * (i))
#define PERCH_X                 0x40DE
#define PERCH_Y                 0x40F4
#define bird_count              DB(0x40FF)

/* ---- 개들과 우유 (dogs.c) -------------------------------------------------- */
#define DOG6_EYES_SPR           0x4100
#define BOWL_SPR                0x41FC
#define DRINK_SAVE              0x43A0
#define drink_new_scr           DW(0x43DC)
#define drink_scr               DW(0x43DE)
#define drink_hidden            DB(0x43E0)
#define dog6_x(i)               DW(0x43E1 + 2 * (i))
#define dog6_y(i)               DW(0x43F9 + 2 * (i))
#define dog6_scr(i)             DW(0x4411 + 2 * (i))
#define dog6_sprite(i)          DW(0x4429 + 2 * (i))
#define dog6_present(i)         DW(0x4441 + 2 * (i))
#define dog6_wake(i)            DW(0x4459 + 2 * (i))
#define dog6_count(i)           DB(0x4471 + (i))
#define bowl_full(i)            DB(0x4479 + (i))
#define bowl_x(i)               DW(0x4481 + 2 * (i))
#define bowl_y(i)               DB(0x4499 + (i))
#define bowl_drink_sprite(i)    DW(0x44A5 + 2 * (i))
#define cat_drinking            DB(0x44BD)
#define drink_dir               DB(0x44BE)
#define drink_dist              DW(0x44BF)
#define drink_bowl              DW(0x44C1)
#define drink_toward            DB(0x44C3)
#define bowl_level(i)           DB(0x44C4 + (i))
#define drink_phase             DB(0x44D0)
#define drink_sprite            DW(0x44D1)
#define drink_ticks             DW(0x44D3)
#define drink_gulp              DB(0x44D5)
#define bowls_left              DB(0x44D6)
#define dogs_ticks              DW(0x44D7)
#define dog6_near_cat           DB(0x44D9)
#define dog6_wake_scr           DW(0x44DA)
#define dogs_wake_period(i)     DW(0x44DC + 2 * (i))
#define dog6_sense(i)           DW(0x44EC + 2 * (i))
#define dogs_growl              DB(0x44FC)

/* ---- 판 끝 장면 (win.c) ---------------------------------------------------- */
#define win_ticks               DW(0x4A80)
#define KISSING_CATS_SPR        0x4A82
#define BIG_HEART_SPR           0x4B8A
#define heart_x(i)              DW(0x4D4A + 2 * (i))
#define heart_y(i)              DW(0x4D5A + 2 * (i))
#define hearts_dx               DW(0x4D6A)
#define hearts_dy               DW(0x4D6C)
#define hearts_done             DB(0x4D6E)
#define HEART_DIR_X             0x4D6F
#define HEART_DIR_Y             0x4D7F
#define hearts_first            DB(0x4D91)
#define hearts_wait             DW(0x4DC8)
#define hearts_sprite           DW(0x4DCA)
#define hearts_start_x          DW(0x4DCC)
#define hearts_start_y          DW(0x4DCE)
#define hearts_max_x            DW(0x4DD0)
#define hearts_max_y            DW(0x4DD2)
#define hearts_size             DW(0x4DD4)
#define win_wait                DW(0x4DD6)
#define win_heart_scr           DW(0x4DD8)
#define win_frame_ptr           DW(0x5010)
#define WIN_FRAME_SPRITES       0x5012
#define win_frame_flip          DW(0x5016)
#define win_frames(i)           DW(0x52AE + 2 * (i))
#define win_tune_frame_ticks    DW(0x52C0)
#define win_tune_start_ticks    DW(0x52C2)
#define win_tune_ticks          DW(0x52C4)
#define win_tune_pos            DW(0x52C6)
#define win_tune_note           DW(0x52C8)
#define WIN_TUNE                0x52CA
#define owner_frame             DW(0x5F60)
#define OWNER_SPRITES           0x5F62
#define owner_ticks             DW(0x5F66)
#define HERE_SPR                0x5F68
#define KITTY_SPR               0x5FE8
#define KITTY_SCR               0x60E4
#define SLEEPY_FACE_SPR         0x6E10
#define SNORING_CAT_SPR         0x6E58
#define sleepy_scr              DW(0x6F24)
#define sleepy_ticks            DW(0x6F26)
#define snore_ticks             DW(0x6F28)

/* ---- 소리 (sound.c) -------------------------------------------------------- */
#define title_tune_pos          DW(0x5320)
#define title_tune_ticks        DW(0x5322)
#define TITLE_PITCHES           0x5324
#define TITLE_TUNE              0x538C
#define title_length            DW(0x56DA)
#define effect_ticks_left       DB(0x5920)
#define effect_ticks            DW(0x5921)
#define effect_second           DW(0x5923)
#define beat_ticks              DW(0x5925)
#define beat_bit                DB(0x5927)
#define beat_count              DB(0x5928)
#define beat_phrase             DB(0x5929)
#define music_pitch             DW(0x592A)
#define music_dir               DB(0x592C)
#define beat_rest               DB(0x592D)
#define music_length            DW(0x592E)
#define LOVE_TUNE               0x5934
#define dog_bark_step           DW(0x59BA)
#define love_note               DW(0x59BC)
#define love_pos                DW(0x59BE)
#define love_ticks              DW(0x59C0)
#define RHYTHM_BITS             0x59C2
#define BEAT_TICKS              0x59F2
#define PHRASE_MASK             0x59FA
#define PHRASE_KEEP             0x59FC
#define RHYTHM_TABLE            0x59FE
#define NOTE_LENGTH             0x5A02
#define REST_LENGTH             0x5A06
#define PHRASE_STEP             0x5A0A
#define REST_CHANCE             0x5A0C
#define land_last               DW(0x5A0E)
#define land_ticks              DW(0x5A10)
#define land_pitch              DW(0x5A12)
#define squeek_ticks            DW(0x5A14)
#define hit_sound_last          DW(0x5A16)
#define hit_sound_frame         DW(0x5A18)
#define HIT_PITCHES             0x5A1A
#define hit_sound_phase         DW(0x5A3C)
#define hit_sound_step          DW(0x5A3E)
#define fall_ticks              DW(0x5A40)
#define fall_step               DW(0x5A42)
#define BARK_PITCHES            0x5A44
#define walk_step               DW(0x5A54)
#define wipe_pos                DW(0x5A56)
#define WIPE_PITCHES            0x5A5A
#define tick_pos                DW(0x5A62)
#define TICK_PITCHES            0x5A64
#define bonus_tune_ticks        DW(0x5A80)
#define bonus_beat              DB(0x5A82)
#define sad_ticks               DW(0x5A83)
#define sad_pos                 DW(0x5A85)
#define SAD_TUNE                0x5A87
#define CAUGHT_TUNE             0x5AA3
#define rising_pitch            DW(0x5ACB)
#define zap_width               DW(0x5ACD)
#define zap_count               DB(0x5ACF)
#define bite_phase              DW(0x5AD0)
#define BITE_WAVE               0x5AD2
#define growl_ticks             DW(0x5AE2)
#define growl_pos               DW(0x5AE4)
#define GROWL_WAVE              0x5AE6
#define growl_shift             DB(0x5B06)
#define after_effect            DB(0x5B07)
#define bubble_pitch            DW(0x5B08)
#define siren_mask              DW(0x5B0A)
#define siren_mode              DW(0x5B0C)
#define siren_delay             DB(0x5B0E)
#define siren_rise              DB(0x5B0F)
#define siren_ticks             DW(0x5B10)
#define siren_pitch             DW(0x5B12)

/* ---- 타이틀과 메뉴 (title.c) ----------------------------------------------- */
#define title_key_count         DW(0x6150)
#define attract_ticks           DW(0x6A88)
#define title_button_seen       DB(0x6A8A)
#define title_ticks             DW(0x6A8B)
#define copyright_frame         DW(0x6A8D)
#define COPYRIGHT_SPRITES       0x6A8F
#define blink_ticks             DW(0x6A93)
#define MENU_TEXT               0x6D37
#define MENU_POS                0x6D63
#define menu_line               DW(0x6D8F)
#define PAWS_TEXT               0x6D91
#define PRESS_KEY_TEXT          0x6DB2
#define PRESS_BUTTON_TEXT       0x6DD3
#define skill                   DW(0x6DF8)
#define joy_test_ticks          DW(0x6DFA)
#define pause_ticks_lo          DW(0x6DFC)
#define pause_ticks_hi          DW(0x6DFE)
#define esc_key_count           DW(0x6E00)

/* ============================================================================
 *  함수
 * ========================================================================== */

/* gfx.c */
void vram_put(uint16_t dst, uint16_t src, int n);
void vram_get(uint16_t dst, uint16_t src, int n);
void ds_copy(uint16_t dst, uint16_t src, int n);
void ds_fill_word(uint16_t dst, uint16_t value, int n);
void ds_and_words(uint16_t dst, uint16_t src, uint16_t mask, int n);
void vram_set(uint16_t dst, uint8_t value);
void vram_set_word(uint16_t dst, uint16_t value);
void vram_fill_word(uint16_t dst, uint16_t value, int n);
void vram_move(uint16_t dst, uint16_t src, int n, int step);
void put_or(uint16_t dst, uint16_t src);
void put_and(uint16_t dst, uint16_t src);
void put_masked(uint16_t dst, uint16_t src);
uint16_t screen_offset(uint16_t x, uint8_t y);
void draw_sprite(uint16_t dst, uint16_t src, uint16_t save, uint16_t size);
void draw_sprite_and(uint16_t dst, uint16_t src, uint16_t save, uint16_t size);
void draw_sprite_or(uint16_t dst, uint16_t src, uint16_t save, uint16_t size);
void extract_rows(uint16_t dst, uint16_t src, uint8_t stride, uint16_t size);
void blit(uint16_t dst, uint16_t src, uint16_t size);
void save_rect(uint16_t dst, uint16_t src, uint16_t size);
void draw_list(uint16_t list, uint16_t base);
void draw_column(uint16_t dst, uint8_t value);
uint16_t random16(void);
void random_seed(void);
int rects_overlap(uint16_t x1, uint16_t w1, uint8_t y1, uint8_t h1,
                  uint16_t x2, uint16_t w2, uint8_t y2, uint8_t h2);

/* bios.c - int 10h 흉내 (모드 4 그래픽 화면) */
extern uint8_t cga_color_select;        /* 포트 3D9h 에 지금 들어 있는 값 */
void bios_set_mode4(void);
void bios_set_color(uint8_t bh, uint8_t bl);
void bios_set_cursor(uint8_t row, uint8_t col);
void bios_putc(uint8_t ch, uint8_t color);
void cga_color_select_out(uint8_t value);

/* main.c */
void game_main(void);
int room_fishbowl(void);
void check_hotkeys(void);
void read_input(void);
void read_joystick(void);
uint8_t joystick_axis(void);
void read_keyboard_dirs(void);
uint16_t pit_counter(void);
void reset_keys(void);
void check_color_display(void);

/* clothes.c */
void scroll_clotheslines(void);
void reset_clotheslines(void);
int cat_land_on_line(void);

/* cat.c */
void reset_cat(void);
void place_cat(void);
void bounce_cat(void);
int move_cat_x(void);
void knock_down_cat(void);
void resave_cat(void);
void save_under_cat(void);
void draw_cat(void);
void cat_hit_flash(void);
void restore_under_cat(void);
void move_cat(void);
int find_support(void);
uint16_t pick_trash_can(uint8_t *y);
int land_on_trash_can(void);
int room_find_support(void);

/* alley.c */
void reset_thrower(void);
void move_thrown(void);
void erase_thrown(void);
void window_thrower(void);
int thrown_hits_cat(void);
void reset_popper(void);
void move_popper(void);
int popper_hits_cat(void);
void reset_line_mice(void);
void move_line_mice(void);

/* dog.c */
void reset_dog(void);
void erase_dog(void);
void move_dog(void);
int dog_catches_cat(void);
void dog_grab_cat(void);
int dog_touches_broom(void);

/* screen.c */
void room_transition(void);
void set_room_palette(void);
void room_failed(void);

/* score.c */
void bcd_add(uint16_t dst, uint16_t src);
void add_score(uint8_t points);
void update_high_score(void);
void draw_lives(void);
void clear_score(void);
void clear_high_score(void);
void draw_high_score(void);
void draw_score(void);
void room_bonus(void);

/* draw.c */
void draw_room(void);
void draw_alley(void);
void draw_title_alley(void);
void draw_window_decor(void);

/* broom.c */
void reset_broom(void);
void make_footprint(void);
void erase_broom(void);
void draw_broom(void);
int broom_hits_cat(void);
void move_broom(void);

/* fishbowl.c */
int fish_touch(void);
void reset_fish(void);
void move_fish(void);
void move_waves(void);
void fishbowl_splash(void);

/* spider.c */
void reset_shelf_targets(void);
void touch_shelf_targets(void);
void draw_bookshelf(void);
int spider_shelf_support(void);
void reset_spider(void);
void move_spider(void);

/* cheese.c */
void cat_in_hole(void);
void draw_cheese(void);
void reset_cheese_mice(void);
void move_cheese_mice(void);

/* birdcage.c */
void move_bird(void);
void reset_birdcage(void);
void draw_cage(void);
void move_birdcage(void);

/* dogs.c */
int broom_near_drinking_cat(void);
void dogs_wake(void);
void dogs_cat_drink(void);
void reset_dogs(void);

/* love.c */
void draw_love_room(void);
int love_find_support(void);
void love_gift_touch(void);
void love_gift_drop(void);
void suitors_check_gifts(void);
void reset_suitors(void);
void move_suitors(void);
void reset_arrow(void);
void erase_arrow(void);
void draw_arrow(void);
void move_arrow(void);

/* win.c */
void level_won(void);
void love_won_tune(void);
void win_tune_step(void);
void chased_out_scene(void);
void love_failed(void);

/* sound.c */
void speaker_off(void);
void speaker_divisor(uint16_t div);
void speaker_tone(uint16_t div);
void tune_tone(uint16_t div);          /* 원판 음악의 스피커 (개선판은 소리 없음) */
void tune_off(void);
void reset_dog_sound(void);
void reset_music(void);
void play_music(void);
void growl_sound(void);
void reset_bite_sound(void);
void bite_sound(void);
void rising_sound(void);
void reset_zap_sound(void);
void zap_sound(void);
void reset_sad_tune(void);
void sad_tune(void);
void reset_tick_sound(void);
void bonus_tune(void);
void tick_sound(void);
void wipe_stub(void);
void wipe_sound(void);
void leave_trash_can(void);
void trash_can_sound(void);
void popper_sound(void);
void start_effect(uint16_t first, uint16_t second);
void chirp_sound(void);
void bubble_sound(void);
void fall_sound(void);
void hit_sound(void);
void squeek_sound(void);
void land_sound(void);
void reset_love_tune(void);
void love_tune(void);
void finish_love_tune(void);
void title_tune(void);

/* title.c */
void title_screen(void);
void options_menu(void);
void pause_game(void);

/* ============================================================================
 *  플랫폼 (sys_dos.c = 도스/djgpp,  tools/hosttest.c = 시험용)
 *  원본이 하드웨어를 만지던 곳.  sys_ticks, sys_in_retrace, sys_pit_counter_raw,
 *  sys_idle 은 시험판에서 "사건"이다 (tools/emu.py 와 같은 순서로 불려야 한다).
 * ========================================================================== */
uint32_t sys_ticks(void);                   /* int 1Ah AH=0 */
void sys_set_ticks(uint32_t t);             /* int 1Ah AH=1 */
int sys_in_retrace(void);                   /* in 3DAh 의 비트 3 */
uint16_t sys_pit_counter_raw(void);         /* out 43h,0 뒤 in 40h 두 번 (먼저 읽은 것이 위) */
uint8_t sys_in61(void);
void sys_out61(uint8_t v);
void sys_out42(uint8_t v);
void sys_out43(uint8_t v);
uint8_t sys_in201(void);                    /* 게임 포트 */
void sys_out201(void);
void sys_idle(void);                        /* 메모리만 보며 키를 기다리는 곳 */
void sys_cpu_loop(unsigned n);              /* 8088 에서 "loop $" n 번 걸리는 시간 */
uint16_t sys_equipment(void);               /* int 11h */
uint8_t sys_machine_model(void);            /* F000:FFFE */
void sys_install_keyboard(void);
void sys_remove_keyboard(void);
void sys_exit(void);
const uint8_t *sys_font8x8(void);           /* 글자 0..255, 8바이트씩 */
void sys_cga_port_changed(void);            /* 포트 3D9h 값이 바뀌었다 */

#endif
