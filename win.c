/* ============================================================================
 *  win.c  -  판을 깼을 때, 사랑의 방에서 실패했을 때, 개에게 쫓겨났을 때의 장면
 * ----------------------------------------------------------------------------
 *  원본 코드 5060..52CC, 5313..53A4, 5BE0..5C5B, 6040..60F2.
 * ========================================================================== */
#include "allycat.h"

/* ---------------------------------------------------------------------------
 *  원래: 5060  고양이가 하트를 타고 화면 가운데로 올라간다 (끝나면 판 보너스)
 * ------------------------------------------------------------------------- */
static void cat_rises_on_heart(void)
{
    uint16_t x = cat_x, step;

    if (x >= 0x117)
        x = 0x116;
    x = (x >= 0x10) ? x - 0x10 : 0;
    x &= 0x0FF0;
    cat_x = x;
    cat_y = 0x14;
    step = (x >= 0x80) ? x - 0x80 : (uint16_t)~(uint16_t)(x - 0x80);
    step >>= 3;
    if (step > 0x0D)
        step = 0x0D;
    hearts_dx = step + 2;
    win_wait = 0x0A;

    for (;;) {
        if (win_wait != 0x0A)
            love_tune();
        win_ticks = (uint16_t)sys_ticks();
        x = cat_x;
        if ((x & 0x0FF0) == 0x80)
            x &= 0x0FF0;
        else if ((x & 0x0FF0) > 0x80)
            x -= hearts_dx;
        else
            x += hearts_dx;
        cat_x = x;
        if (cat_y >= 0x54)
            return;
        cat_y += 8;
        win_heart_scr = screen_offset(cat_x + 4, cat_y);
        draw_sprite(win_heart_scr, BIG_HEART_SPR, SCRATCH, 0x2007);
        blit(win_heart_scr + 0xF3, KISSING_CATS_SPR, 0x0D04);
        if (win_wait == 0x0A) {
            rising_sound();
            reset_love_tune();
        }
        do {
            love_tune();
        } while ((uint16_t)((uint16_t)sys_ticks() - win_ticks) < win_wait);
        if (win_wait == 0x0A) {
            room_bonus();
            bios_set_color(0, 0);
        }
        win_wait = 2;
    }
}

/* 원래: 522A  하트 하나 움직이기 (가장자리에 닿으면 hearts_done 을 센다) */
static void move_heart(int i)
{
    uint16_t v;

    v = heart_x(i);
    if (DW(HEART_DIR_X + 2 * i) >= 1) {
        if (DW(HEART_DIR_X + 2 * i) == 1) {
            v += hearts_dx;
            if (v > hearts_max_x) {
                v = hearts_max_x;
                hearts_done++;
            }
        } else if (v < hearts_dx) {
            v = 0;
            hearts_done++;
        } else {
            v -= hearts_dx;
        }
        heart_x(i) = v;
    }
    v = heart_y(i);
    if (DW(HEART_DIR_Y + 2 * i) >= 1) {
        if (DW(HEART_DIR_Y + 2 * i) == 1) {
            v += hearts_dy;
            if (v > hearts_max_y) {
                v = hearts_max_y;
                hearts_done++;
            }
        } else if (v < hearts_dy) {
            v = 0;
            hearts_done++;
        } else {
            v -= hearts_dy;
        }
        heart_y(i) = v;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 519B  하트 8개를 한 점에서 사방으로 퍼뜨린다 (그리기만 하고 지우지 않는다)
 * ------------------------------------------------------------------------- */
static void burst_hearts(void)
{
    int n, i;

    hearts_first = 1;
    for (n = 8; n; n--) {
        love_tune();
        i = n - 1;
        heart_x(i) = hearts_start_x;
        heart_y(i) = hearts_start_y;
    }
    hearts_done = 0;
    do {
        win_ticks = (uint16_t)sys_ticks();
        for (n = 8; n; n--) {
            love_tune();
            i = n - 1;
            if (hearts_first == 0 || n == 8)
                draw_sprite(screen_offset(heart_x(i), (uint8_t)heart_y(i)),
                            hearts_sprite, SCRATCH, hearts_size);
            move_heart(i);
        }
        do {
            love_tune();
        } while ((uint16_t)((uint16_t)sys_ticks() - win_ticks) < hearts_wait);
        hearts_first = 0;
    } while (hearts_done == 0);
}

/* 원래: 514A  작은, 중간, 큰 하트 차례로 */
static void hearts_fireworks(void)
{
    int k;

    for (k = 0; k < 3; k++) {
        hearts_dx = DW(0x4DA4 + 2 * k);
        hearts_dy = DW(0x4DAA + 2 * k);
        hearts_start_x = DW(0x4D98 + 2 * k);
        hearts_start_y = DW(0x4D9E + 2 * k);
        hearts_max_x = DW(0x4DB0 + 2 * k);
        hearts_max_y = DW(0x4DB6 + 2 * k);
        hearts_size = DW(0x4DBC + 2 * k);
        hearts_sprite = DW(0x4D92 + 2 * k);
        hearts_wait = DW(0x4DC2 + 2 * k);
        burst_hearts();
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 528B  판을 깼다: 하트, 보너스, 목숨 하나 더, 다음 판
 * ------------------------------------------------------------------------- */
void level_won(void)
{
    MUSIC(SONG_HEARTS, 1);
    reset_love_tune();
    bios_set_color(1, 1);
    cat_rises_on_heart();
    hearts_fireworks();
    finish_love_tune();
    if (lives < 9)
        lives++;
    if (level < 7)
        level++;
    rooms_won = 0;
    level_start_ticks = (uint16_t)sys_ticks();
    speaker_off();
}

/* ---------------------------------------------------------------------------
 *  원래: 5313, 5368  판을 깨고 골목으로 돌아올 때: 그림 틀을 번갈아 그리며 곡
 * ------------------------------------------------------------------------- */
static void draw_win_frame(void)
{
    uint16_t dst, flag;

    win_frame_ptr = win_frames(level);
    for (;;) {
        dst = DW(win_frame_ptr);
        if (dst == 0)
            return;
        flag = (uint16_t)((DW(win_frame_ptr + 2) ^ win_frame_flip) & 2);
        blit(dst, DW(WIN_FRAME_SPRITES + flag), 0x2304);
        win_tune_step();
        win_frame_ptr += 4;
    }
}

void love_won_tune(void)
{
    uint16_t t;

    if (level < 2)
        return;
    MUSIC(SONG_WIN, 1);
    win_frame_flip = 0;
    t = (uint16_t)sys_ticks();
    win_tune_frame_ticks = t;
    win_tune_start_ticks = t;
    win_tune_ticks = t;
    win_tune_pos = 0;
    win_tune_note = 0;
    do {
        draw_win_frame();
        win_frame_flip ^= 2;
        for (;;) {
            win_tune_step();
            t = (uint16_t)sys_ticks();
            if ((uint16_t)(t - win_tune_frame_ticks) >= 5)
                break;
        }
        win_tune_frame_ticks = t;
    } while ((uint16_t)(t - win_tune_start_ticks) < 0x28);
    speaker_off();
}

/* 원래: 52D0  판 끝 곡 한 음 (틱마다) */
void win_tune_step(void)
{
    uint16_t t, div;

    if (sound_on == 0)
        return;
    t = (uint16_t)sys_ticks();
    if (t == win_tune_ticks)
        return;
    win_tune_ticks = t;
    div = DW(WIN_TUNE + win_tune_pos);
    win_tune_pos += 2;
    if (div == win_tune_note) {
        tune_off();
        return;
    }
    win_tune_note = div;
    tune_tone(div);
}

/* ---------------------------------------------------------------------------
 *  원래: 5BE0  개에게 쫓겨났을 때: 주인이 "HERE KITTY KITTY" 하고 부른다
 * ------------------------------------------------------------------------- */
void chased_out_scene(void)
{
    uint16_t t;
    int k;

    owner_ticks = (uint16_t)sys_ticks();
    owner_frame = 0;
    do {
        k = owner_frame & 2;
        owner_frame += 2;
        blit(0x0A74, DW(OWNER_SPRITES + k), 0x4404);
        for (;;) {
            sad_tune();
            t = (uint16_t)sys_ticks();
            if ((uint16_t)(t - owner_ticks) >= 4)
                break;
        }
        owner_ticks = t;
        if (owner_frame == 4)
            blit(0x0668, HERE_SPR, 0x1004);
        if (owner_frame >= 8 && owner_frame - 8 < 6)
            blit(DW(KITTY_SCR + owner_frame - 8), KITTY_SPR, 0x1506);
    } while (owner_frame < 0x10);
    speaker_off();
}

/* ---------------------------------------------------------------------------
 *  원래: 6040  사랑의 방에서 떨어져 나왔을 때: 졸린 얼굴이 내려오고 코를 곤다
 * ------------------------------------------------------------------------- */
void love_failed(void)
{
    uint16_t t;

    ds_fill_word(SCRATCH, 0, 0x24);
    sleepy_scr = 0x25;
    do {
        while (!sys_in_retrace())
            ;
        blit(sleepy_scr, SCRATCH, 0x0C03);
        sleepy_scr += 0x1E0;
        blit(sleepy_scr, SLEEPY_FACE_SPR, 0x0C03);
        do {
            t = (uint16_t)sys_ticks();
        } while (t == sleepy_ticks);
        sleepy_ticks = t;
        if (sound_on)
            speaker_tone(sleepy_scr >> 1);
    } while (sleepy_scr < 0x1A40);
    blit(sleepy_scr, SNORING_CAT_SPR, 0x1106);
    do {
        do {
            t = (uint16_t)sys_ticks();
        } while (t == snore_ticks);
        snore_ticks = t;
        if (sound_on) {
            sys_out43(0xB6);
            speaker_divisor((t & 1) ? 0x0B54 : 0x0C00);
        }
    } while ((uint16_t)(t - sleepy_ticks) < 0x12);
    speaker_off();
}
