/* ============================================================================
 *  title.c  -  타이틀 화면, 조이스틱/난이도 메뉴, 일시정지("Paws Game")
 * ----------------------------------------------------------------------------
 *  원본 코드 5CB0..6033.
 *
 *  글자는 모두 BIOS 텔레타이프(int 10h, AH=0Eh)로 찍는다 (bios.c).
 * ========================================================================== */
#include "allycat.h"

/* 원래: 5E2B  0 으로 끝나는 문자열 찍기 (색 2) */
static void print_text(uint16_t s)
{
    uint8_t c;
#ifdef CATVGA
    /* 개선판: 원판 색 2 는 골목 색 테마에서 검은 바탕의 어두운 보라가 되어 안 보인다.
       글자에 밝은 색을 따로 칠한다: 글줄은 크림색, 누를 키는 노랑, 키 설명은 하늘색
         "(K)itten", "Ctrl-S  turns ..." 처럼 들여 쓴 줄: 첫 낱말(괄호면 괄호까지)이 키
         "(Y/N)" 처럼 괄호 안: 키 */
    static uint8_t cream, yellow, sky;
    int indented = DB(s) == ' ', key = 0, paren = 0, lead = 1;

    if (!cream) {
        cream = col256_nearest(60, 57, 50);
        yellow = col256_nearest(63, 52, 16);
        sky = col256_nearest(38, 52, 62);
    }
    while ((c = DB(s++)) != 0) {
        if (indented && lead && c != ' ') {
            lead = 0;
            key = c == '(' ? 2 : 1;             /* 2: 괄호가 닫힐 때까지, 1: 빈칸까지 */
        }
        if (!indented && c == '(')
            paren = 1;
        text_col256 = key || paren ? yellow : indented && !lead ? sky : cream;
        bios_putc(c, 2);
        if (c == ')') {
            paren = 0;
            if (key == 2)
                key = 0;
        }
        if (key == 1 && DB(s) == ' ')
            key = 0;
    }
    text_col256 = 0;
#else
    while ((c = DB(s++)) != 0)
        bios_putc(c, 2);
#endif
}

/* 원래: 5E3B  "(c) Copyright" 줄 깜빡이기 */
static void blink_copyright(void)
{
    copyright_frame += 2;
    blit(0x1D38, DW(COPYRIGHT_SPRITES + (copyright_frame & 2)), 0x0C0A);
}

/* ---------------------------------------------------------------------------
 *  원래: 5DD4  타이틀에서 고양이 저절로 걷기
 * ------------------------------------------------------------------------- */
static void attract_cat(void)
{
    uint16_t t;
    uint8_t r;

    if (cat_x <= 0x20) {
        joy_x = 1;
    } else if (cat_x >= 0x120) {
        joy_x = 0xFF;
    } else {
        t = (uint16_t)sys_ticks();
        if ((uint16_t)(t - attract_ticks) >= 0x12) {
            attract_ticks = t;
            r = (uint8_t)random16();
            joy_x = 0;
            if (r <= 0xA0)
                joy_x = (r & 1) ? 1 : 0xFF;
        }
    }
    if (!sys_in_retrace())
        return;
    cat_speed_x = 4;
    move_cat();
}

/* ---------------------------------------------------------------------------
 *  원래: 5CB0  타이틀 화면.  처음에는 곡이 끝나면 넘어가고, 메뉴를 한 번 본
 *  뒤로는 키를 누를 때까지 곡을 되풀이한다.
 * ------------------------------------------------------------------------- */
#ifdef CATVGA
/* 개선판: 오른쪽 위 하늘에 만든 사람 (글자만, 바탕은 그대로) */
static void draw_credit(void)
{
    static const char *const line[2] = { "VGA REMASTER", "In-Hak Min" };
    const uint8_t *font = sys_font8x8();
    int i, n, r, b, x0, y0;
    const char *s;

    for (i = 0; i < 2; i++) {
        for (n = 0, s = line[i]; *s; s++)
            n++;
        x0 = 320 - 6 - n * 8;
        y0 = 6 + i * 11;
        for (s = line[i]; *s; s++, x0 += 8)
            for (r = 0; r < 8; r++)
                for (b = 0; b < 8; b++)
                    if (font[(uint8_t)*s * 8 + r] & (0x80 >> b))
                        vram_plot(x0 + b, y0 + r, 3);
    }
}
#endif

void title_screen(void)
{
    uint16_t t, d, len;

    room = ROOM_ALLEY;
    reset_thrower();
    reset_line_mice();
    draw_title_alley();
    blit(0x00BD, 0x6152, 0x1D0B);               /* IBM PRESENTS */
    blit(0x069E, 0x63D0, 0x160E);               /* Alley Cat */
    blit(0x0A78, 0x6638, 0x0C03);               /* TM */
    blit(0x0CA8, 0x6680, 0x080E);               /* By Bill Williams */
    blit(0x1D6E, 0x6760, 0x0B0C);               /* (c) Copyright SynSoft */
    blit(0x1DEC, 0x6868, 0x0804);               /* TM */
#ifdef CATVGA
    draw_credit();
#endif
    copyright_frame = 0;
    blink_copyright();
    cat_x = 0;
    reset_cat();
    cat_y = 0x60;
    cat_foot_y = 0x92;
    draw_high_score();
    draw_score();
    lives = 9;
    lives_shown = 0xFF;
    draw_lives();
    reset_dog();
    joy_x = 0;
    joy_y = 0;
    title_button_seen = 0;
    title_key_count = key_count;

restart_tune:
    MUSIC(SONG_TITLE, 1);
    t = (uint16_t)sys_ticks();
    title_ticks = t;
    title_tune_ticks = t;
    blink_ticks = t;
    attract_ticks = t - 0x30;
    title_tune_pos = 0;
    for (;;) {
        t = (uint16_t)sys_ticks();
        if ((uint16_t)(t - blink_ticks) >= 0x24) {
            blink_ticks = t;
            blink_copyright();
        }
        d = (uint16_t)(t - title_ticks);
        len = title_length;
        if (menu_done) {
            if (d >= (uint16_t)(len + 0x48))
                goto restart_tune;
        } else if (d > (uint16_t)(len + 6)) {
            return;
        }
        title_tune();
        attract_cat();
        if (use_joystick) {
            if (sys_in201() & 0x10) {
                title_button_seen = 1;
            } else if (title_button_seen) {
                return;
            }
        }
        if (title_key_count != key_count)
            return;
    }
}

/* 원래: 5FB1  메뉴 글줄 하나 (자리와 문자열은 표에서) */
static void print_menu_line(void)
{
    bios_set_cursor((uint8_t)(DW(MENU_POS + menu_line) >> 8), 0);
    print_text(DW(MENU_TEXT + menu_line));
    menu_line += 2;
}

/* 원래: 5FCD  화면 지우기 */
static void clear_screen(void)
{
    SET_THEME(ROOM_ALLEY);
    vram_fill_word(0, 0, 0xFA0);
    vram_fill_word(0x2000, 0, 0xFA0);
}

/* 원래: 5F97  아무 키 (조이스틱이면 단추) */
static void wait_any_key(void)
{
    uint16_t k;

    if (use_joystick) {
        while (sys_in201() & 0x10)
            ;
        return;
    }
    k = key_count;
    do {
        sys_idle();
    } while (k == key_count);
}

/* 원래: 600F  조이스틱 단안정이 1.x 초 안에 풀리나 (풀리면 1) */
static int joystick_responds(void)
{
    uint16_t t;

    sys_out201();
    joy_test_ticks = (uint16_t)sys_ticks();
    for (;;) {
        if (!(sys_in201() & 3))
            return 1;
        t = (uint16_t)sys_ticks();
        if ((uint16_t)(t - joy_test_ticks) >= 0x12)
            return 0;
    }
}

/* 원래: 5FE5  조이스틱 확인 (없으면 알리고 0) */
static int check_joystick(void)
{
    int n;
    uint16_t k;

    if (sys_equipment() & 0x1000) {
        if (joystick_responds())
            return 1;
        if (joystick_responds())
            return 1;
    }
    menu_line = 0x24;
    for (n = 4; n; n--)
        print_menu_line();
    k = key_count;
    do {
        sys_idle();
    } while (k == key_count);
    return 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 5EE5  조이스틱?  난이도?  조작법
 * ------------------------------------------------------------------------- */
void options_menu(void)
{
    uint16_t k, choice;
    int n;

    speaker_off();
again:
    clear_screen();
    menu_line = 0;
    print_menu_line();                          /* Do you want to use a joystick (Y/N)? */
    for (;;) {
        k = key_count;
        do {
            sys_idle();
        } while (k == key_count);
        if (KEY_DOWN(KEY_Y)) {
            if (!check_joystick())
                goto again;
            use_joystick = 1;
            break;
        }
        if (KEY_DOWN(KEY_N)) {
            use_joystick = 0;
            break;
        }
    }
    for (n = 5; n; n--)
        print_menu_line();                      /* 난이도 네 가지 */
    for (;;) {
        k = key_count;
        do {
            sys_idle();
        } while (k == key_count);
        if (KEY_DOWN(KEY_K)) { choice = 0; break; }
        if (KEY_DOWN(KEY_H)) { choice = 1; break; }
        if (KEY_DOWN(KEY_T)) { choice = 2; break; }
        if (KEY_DOWN(KEY_A)) { choice = 3; break; }
    }
    skill = choice;
    for (n = 5; n; n--)
        print_menu_line();                      /* During play: ... */
    if (use_joystick) {
        menu_line = 0x20;
        print_menu_line();
        print_menu_line();
        menu_line = 0x18;
        print_menu_line();
        print_menu_line();
    } else {
        menu_line = 0x1C;
        print_menu_line();
        print_menu_line();
        menu_line = 0x16;
        print_menu_line();
    }
    wait_any_key();
}

/* ---------------------------------------------------------------------------
 *  원래: 5E70  일시정지 (Esc).  가운데를 저장하고 글을 찍고, 키를 기다린 뒤
 *  되돌린다.  멈춘 동안 시계가 가지 않은 것처럼 BIOS 시계를 되돌린다.
 * ------------------------------------------------------------------------- */
void pause_game(void)
{
    uint32_t t;

    speaker_off();
    MUSIC_PAUSE(1);
    t = sys_ticks();
    pause_ticks_lo = (uint16_t)t;
    pause_ticks_hi = (uint16_t)(t >> 16);
    save_rect(SCRATCH, 0x0DCA, 0x1020);
    bios_set_cursor(0x0B, 5);
    print_text(PAWS_TEXT);
    bios_set_cursor(0x0C, 5);
    print_text(use_joystick ? PRESS_BUTTON_TEXT : PRESS_KEY_TEXT);
    wait_any_key();
    blit(0x0DCA, SCRATCH, 0x1020);
    sys_set_ticks(((uint32_t)pause_ticks_hi << 16) | pause_ticks_lo);
    esc_key_count = key_count;
    MUSIC_PAUSE(0);
}
