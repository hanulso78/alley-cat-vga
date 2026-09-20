/* ============================================================================
 *  main.c  -  프로그램 본체, 방 고르기, 방마다 도는 고리, 단축키, 입력
 * ----------------------------------------------------------------------------
 *  원본 코드 세그먼트 0000..049F (본체와 방 7개), 1200..13A9 (입력, 단축키),
 *  13AA..13E7 (기종, 키 표 초기화), 5C60 (컬러 화면 확인).
 *
 *  게임 흐름
 *      타이틀 -> (처음 한 번) 조이스틱/난이도 메뉴 -> 골목
 *      골목에서 고양이가 창문에 뛰어들면 방 하나를 골라 들어간다.
 *      방에서 할 일을 마치면(room_cleared) 점수를 받고 골목으로 돌아가는데,
 *      다음에 창문에 들어가면 사랑의 방(7)으로 간다.  사랑의 방 꼭대기의
 *      암고양이에게 가면 한 판(level)이 끝난다.
 * ========================================================================== */
#include "allycat.h"

static int room_fishbowl_table(void);
static int room_love(void);
static int room_dogs(void);
static int room_birdcage(void);
static int room_mice(void);
static int room_spider(void);

/* ---------------------------------------------------------------------------
 *  원래: 0000  프로그램 시작
 * ------------------------------------------------------------------------- */
void game_main(void)
{
    uint16_t r;
    uint8_t pick;
    int result;

    check_color_display();
    machine_model = sys_machine_model();
    crt_hpos = 4;
    skill = 0;
    use_joystick = 0;
    sys_install_keyboard();
    reset_keys();
    esc_key_count = key_count + 0x240;
    bios_set_mode4();
    crt_hpos = 6;                               /* PCjr 가 아니면 6 */
    bios_set_color(1, 1);                       /* 팔레트 1 (청록/자홍/흰) */
    unused_416 = 0;
    room = ROOM_ALLEY;
    set_room_palette();
    cga_color_select_out(0x20);                 /* 팔레트 1, 어두운 색 */
    random_seed();
    clear_high_score();
    clear_score();
    menu_done = 0;
    last_room = last_room2 = 0xFFFF;
    sound_on = 0xFF;

new_game_title:
    update_high_score();
    level = 0;
    room = ROOM_ALLEY;
    set_room_palette();
    speaker_off();
    ACTOR_TITLE(1);
    title_screen();
    ACTOR_TITLE(0);
    speaker_off();
    if (menu_done)
        goto start_game;

show_menu:
    speaker_off();
    options_menu();
    menu_done = 1;

start_game:
    level = skill;
    lives = 3;
    clear_score();
    room = ROOM_ALLEY;
    set_room_palette();
    speaker_off();
    chased_out_frame = 0;
    level_start_ticks = (uint16_t)sys_ticks();
    rooms_won = 0;
    love_room_next = 0;
    back_from_room = 0;
    menu_req = 0;
    restart_req = 0;
    speaker_off();

alley:
    if (lives == 0)
        goto new_game_title;
    if (restart_req)
        goto start_game;
    if (menu_req)
        goto show_menu;

    /* ---- 골목 ---- */
    draw_alley();
    draw_window_decor();
    lives_shown = 0xFF;
    speaker_off();
    room = ROOM_ALLEY;
    if (back_from_room) {
        place_cat();                            /* 들어갔던 창문 자리로 */
        cat_perch = 2;
        cat_vy = 1;
        cat_vy_rate = 0x20;
    } else {
        cat_x = 0;
        reset_cat();
    }
    reset_dog();
    reset_thrower();
    reset_popper();
    reset_line_mice();
    draw_high_score();
    draw_score();
    reset_music();

    for (;;) {
        if (lives == 0)
            goto new_game_title;
        check_hotkeys();
        if (menu_req)
            goto show_menu;
        if (restart_req)
            goto start_game;
        read_input();
        move_cat();
        move_dog();
        if (dog_has_cat == 0) {
            /* 개가 쫓지 않을 때는 나머지를 네 번에 한 번만 */
            frame_div++;
            if (frame_div & 3)
                continue;
        }
        play_music();
        scroll_clotheslines();
        window_thrower();
        move_thrown();
        move_popper();
        move_line_mice();
        draw_lives();
        if (exit_room)
            break;
    }
    if (lives == 0)
        goto new_game_title;

    /* ---- 창문으로 들어갔다: 방 고르기 ---- */
    room_start_ticks = (uint16_t)sys_ticks();
    alley_cat_x = cat_x;
    alley_cat_y = cat_y;
    back_from_room = 1;
#ifdef CATVGA
    if (warp_target) {                          /* Alt+1..7 로 고른 방 */
        room = warp_target;
        warp_target = 0;
        love_room_next = 0;
        last_room2 = last_room;
        last_room = room;
        goto enter;
    }
#endif
    if (love_room_next) {
        love_room_next = 0;
        room = ROOM_LOVE;
        goto enter;
    }
    for (;;) {
        r = random16();
        if ((r & 0xA0) && (level & 3) != 3) {
            /* 창문 높이로 정하기 */
            pick = room_by_window((level & 3) * 4 + (r & 3));
        } else {
            do {
                r = random16();
            } while ((r & 7) >= 5);
            pick = random_room(r & 7);
        }
        /* 바로 앞의 두 번과 같은 방이면 다시 */
        if (pick != last_room || pick != last_room2)
            break;
    }
    room = pick;
    last_room2 = last_room;
    last_room = pick;

enter:
    prev_room = 0;
    switch (room) {
    case 2:  result = room_fishbowl();       break;
    case 3:  result = room_spider();         break;
    case 4:  result = room_mice();           break;
    case 5:  result = room_birdcage();       break;
    case 6:  result = room_dogs();           break;
    case 7:  result = room_love();           break;
    default: result = room_fishbowl_table(); break;     /* 0, 1 */
    }
    (void)result;

    /* ---- 방에서 나왔다 (원래 0427) ---- */
    if (restart_req)
        goto start_game;
    if (menu_req)
        goto show_menu;
    if (cat_caught)
        back_from_room = 0;
    prev_room = room;
    room = ROOM_ALLEY;
    room_transition();
    goto alley;
}

/* 방에서 나갈 일이 생겼나 */
#define QUIT_KEYS()     (menu_req | restart_req)

/* ---------------------------------------------------------------------------
 *  원래: 0260  방 7 - 사랑의 방 (꼭대기의 암고양이에게 가기)
 * ------------------------------------------------------------------------- */
static int room_love(void)
{
    room = ROOM_LOVE;
    room_transition();
    draw_room();
    place_cat();
    reset_dog();
    reset_broom();
    reset_arrow();
    reset_suitors();
    reset_music();
    do {
        check_hotkeys();
        read_input();
        play_music();
        move_cat();
        move_arrow();
        love_gift_touch();
        love_gift_drop();
        move_suitors();
    } while (!(exit_room | room_cleared | QUIT_KEYS()));
    return 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 02AA  방 6 - 잠자는 개들과 밥그릇
 * ------------------------------------------------------------------------- */
static int room_dogs(void)
{
    room = ROOM_DOGS;
    room_transition();
    draw_room();
    place_cat();
    reset_broom();
    reset_dog();
    reset_music();
    do {
        check_hotkeys();
        read_input();
        play_music();
        dogs_cat_drink();
        dogs_wake();
        move_cat();
        if (dog_has_cat)
            move_dog();
        else
            move_broom();
    } while (!(exit_room | cat_caught | room_cleared | QUIT_KEYS()));
    return 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 02FE  방 5 - 새장
 * ------------------------------------------------------------------------- */
static int room_birdcage(void)
{
    room = ROOM_BIRDCAGE;
    room_transition();
    draw_room();
    reset_birdcage();
    place_cat();
    reset_broom();
    reset_dog();
    reset_music();
    do {
        check_hotkeys();
        read_input();
        play_music();
        move_birdcage();
        move_bird();
        move_cat();
        move_broom();
        move_dog();
    } while (!(cat_caught | room_cleared | exit_room | QUIT_KEYS()));
    return 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 0349  방 4 - 쥐구멍 (치즈)
 * ------------------------------------------------------------------------- */
static int room_mice(void)
{
    room = ROOM_MICE;
    room_transition();
    draw_room();
    place_cat();
    reset_broom();
    reset_dog();
    reset_cheese_mice();
    reset_music();
    do {
        check_hotkeys();
        read_input();
        play_music();
        move_cat();
        cat_in_hole();
        move_cheese_mice();
        move_broom();
        move_dog();
    } while (!(cat_caught | room_cleared | exit_room | QUIT_KEYS()));
    return 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 0394  방 3 - 책장과 거미
 * ------------------------------------------------------------------------- */
static int room_spider(void)
{
    room = ROOM_SPIDER;
    room_transition();
    draw_room();
    place_cat();
    reset_broom();
    reset_dog();
    reset_shelf_targets();
    reset_spider();
    reset_music();
    do {
        check_hotkeys();
        read_input();
        play_music();
        move_cat();
        move_spider();
        touch_shelf_targets();
        move_broom();
        move_dog();
    } while (!(cat_caught | room_cleared | exit_room | QUIT_KEYS()));
    return 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 03E2  방 1 - 탁자 위의 어항.  어항에 뛰어들면 바로 방 2 로.
 * ------------------------------------------------------------------------- */
static int room_fishbowl_table(void)
{
    room = ROOM_TABLE;
    room_transition();
    draw_room();
    place_cat();
    reset_broom();
    reset_dog();
    reset_music();
    do {
        check_hotkeys();
        read_input();
        play_music();
        move_cat();
        move_broom();
        move_dog();
        fishbowl_splash();
        if (fishbowl_entered)
            return room_fishbowl();
    } while (!(cat_caught | exit_room | QUIT_KEYS()));
    return 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 0459  방 2 - 어항 속 (물고기 잡기)
 * ------------------------------------------------------------------------- */
int room_fishbowl(void)
{
    room = ROOM_FISHBOWL;
    room_transition();
    draw_room();
    reset_fish();
    place_cat();
    dog_running = 0;
    dog_has_cat = 0;
    reset_music();
    do {
        check_hotkeys();
        read_input();
        play_music();
        move_cat();
        move_fish();
        move_waves();
    } while (!(cat_caught | room_cleared | QUIT_KEYS()));
    return 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 1338  단축키 (키를 새로 눌렀을 때만)
 *      Esc      일시정지         Ctrl-9  목숨 9개
 *      Ctrl-Y   도스로           Ctrl-M  메뉴
 *      Ctrl-R   다시 시작        Ctrl-S  소리 켜고 끄기
 * ------------------------------------------------------------------------- */
#ifdef CATVGA
/* ---------------------------------------------------------------------------
 *  개선판: Alt+1..7 로 그 방으로 바로 (sys_dos.c 의 키보드 처리기가 warp_room 을 넣는다)
 *  골목이면 창문으로 들어간 것처럼 바로, 방 안이면 먼저 골목으로 나간 뒤 들어간다.
 * ------------------------------------------------------------------------- */
volatile int warp_room;
int warp_target;

static void check_warp(void)
{
    if (warp_room) {
        warp_target = warp_room;
        warp_room = 0;
    }
    if (!warp_target || exit_room || lives == 0)
        return;
    if (room != ROOM_ALLEY) {
        exit_room = 1;                          /* 먼저 골목으로 */
        return;
    }
    exit_room = 1;                              /* 창문으로 들어간 것처럼 */
}
#endif

void check_hotkeys(void)
{
#ifdef CATVGA
    check_warp();
#endif
    if (key_count == last_key_count)
        return;
    last_key_count = key_count;
    if (KEY_DOWN(KEY_ESC)) {
        if (key_count != esc_key_count)
            pause_game();
        return;
    }
    if (!KEY_DOWN(KEY_CTRL))
        return;
    if (KEY_DOWN(KEY_9)) {
        lives = 9;
        return;
    }
    if (KEY_DOWN(KEY_Y)) {
        sys_remove_keyboard();
        sys_exit();
    }
    if (KEY_DOWN(KEY_M)) {
        menu_req = 0xFF;
        return;
    }
    if (KEY_DOWN(KEY_R)) {
        restart_req = 0xFF;
        return;
    }
    if (KEY_DOWN(KEY_S)) {
        sound_on = ~sound_on;
        if (sound_on == 0)
            speaker_off();
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 1200  입력 읽기 (시계 2틱마다)
 *      joy_x   -1 왼쪽, 0, 1 오른쪽        joy_y  -1 위, 0, 1 아래
 *      fire    0 이면 눌림 (Alt 또는 조이스틱 단추)
 * ------------------------------------------------------------------------- */
void read_input(void)
{
    uint16_t t = (uint16_t)sys_ticks(), a, b;

#ifdef CATVGA
    /* 개선판: 키보드는 부를 때마다 바로 읽는다 (원판은 2틱마다, 조이스틱 읽는 시간만큼 쉬고) */
    if (use_joystick == 0) {
        input_ticks = t;
        read_keyboard_dirs();
        return;
    }
#endif
    if ((uint16_t)(t - input_ticks) < 2)
        return;
    input_ticks = t;
    if (use_joystick == 0) {
        read_keyboard_dirs();
        b = pit_counter();
        do {
            a = pit_counter();
        } while ((uint16_t)(a - b) < 0xF8ED);
        return;
    }
    read_joystick();
}

/* 원래: 122E  조이스틱 (게임 포트 201h).  단안정 회로가 풀리는 시간을 타이머 0 으로 잰다 */
void read_joystick(void)
{
    uint8_t v;
    int cx = 0x7D0;

    fire = sys_in201() & 0x10;
    joy_pending = 3;
    joy_start = pit_counter();
    sys_out201();
    do {
        v = sys_in201();
        if (!(v & 1) && (joy_pending & 1)) {
            joy_pending &= 0xFE;
            joy_x = joystick_axis();
        }
        if (!(v & 2) && (joy_pending & 2)) {
            joy_pending &= 0xFD;
            joy_y = joystick_axis();
        }
        if (!(joy_pending & 3))
            return;
    } while (--cx && (uint16_t)(pit_counter() - joy_start) != 0x1964);
    if (joy_pending & 1)
        joy_x = 0xFF;
    if (joy_pending & 2)
        joy_y = 0xFF;
}

/* 원래: 12A1  축 하나: 걸린 시간으로 -1, 0, 1 */
uint8_t joystick_axis(void)
{
    uint16_t d = (uint16_t)(pit_counter() - joy_start);

    if (d < 0xF5E6)
        return 1;
    if (d < 0xFAFA)
        return 0;
    return 0xFF;
}

/* ---------------------------------------------------------------------------
 *  원래: 12C1  방향키 -> joy_x, joy_y, fire
 *  대각선 키(PgUp, PgDn, End, Home)는 두 방향에 모두 들어간다.
 * ------------------------------------------------------------------------- */
void read_keyboard_dirs(void)
{
    uint8_t a;

    a = (key_state(KEY_DOWN_ARROW) & key_state(KEY_PGDN) & key_state(KEY_END)) ^ 0x80;
    joy_y = a ? 1 : 0;
    a = (key_state(KEY_UP_ARROW) & key_state(KEY_PGUP) & key_state(KEY_HOME)) ^ 0x80;
    if (a)
        joy_y = 0xFF;
    a = (key_state(KEY_RIGHT_ARROW) & key_state(KEY_PGUP) & key_state(KEY_PGDN)) ^ 0x80;
    joy_x = a ? 1 : 0;
    a = (key_state(KEY_LEFT_ARROW) & key_state(KEY_END) & key_state(KEY_HOME)) ^ 0x80;
    if (a)
        joy_x = 0xFF;
    fire = key_state(KEY_ALT) >> 3;
}

/* 원래: 13B7  타이머 0 카운터 (낮은 바이트 먼저 읽은 16비트) */
uint16_t pit_counter(void)
{
    uint16_t raw = sys_pit_counter_raw();          /* 먼저 읽은 바이트가 위 */
    return (uint16_t)((raw >> 8) | (raw << 8));
}

/* 원래: 13E8  키 표를 모두 "뗌"으로 */
void reset_keys(void)
{
    int i;
    for (i = 0; i < KEY_COUNT; i++)
        DB(KEY_STATE + i) = 0x80;
    last_key_count = key_count - 0x70;
}

/* ---------------------------------------------------------------------------
 *  원래: 5C60  흑백 화면이면 "컬러 화면을 켜 주세요" (컬러 카드가 없으면 멈춘다)
 *  이 판은 늘 VGA 라서 아무것도 하지 않는다.
 * ------------------------------------------------------------------------- */
void check_color_display(void)
{
}
