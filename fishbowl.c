/* ============================================================================
 *  fishbowl.c  -  방 1 (탁자 위 어항) 과 방 2 (어항 속)
 * ----------------------------------------------------------------------------
 *  원본 코드 34A0..384A, 3850..38A3.
 *
 *  어항 속에는 물고기 12마리(0..11, 1워드 x 6줄)와 뱀장어 조각 12개(12..23,
 *  2워드 x 2줄)가 있다.  물고기를 모두 잡으면 방을 깬다.  뱀장어에 닿으면
 *  "ZAP" 감전 - 잡힌 것(cat_caught).  숨은 cat.c 가 잰다.
 * ========================================================================== */
#include "allycat.h"

/* 원래: 37C1  물고기(또는 뱀장어) 지우기 - 물 무늬로 덮는다 */
static void erase_fish(int i)
{
    if (fish_hidden(i))
        return;
    blit(fish_scr(i), WATER_SPR, (i >= 12) ? 0x0202 : 0x0601);
}

/* ---------------------------------------------------------------------------
 *  원래: 363D  이번에 먹힌 수만큼 뱀장어를 가장자리에서 다시 내보낸다
 * ------------------------------------------------------------------------- */
static void respawn_eels(void)
{
    int n, i;

again:
    for (n = 12; n > 0; n--) {
        i = n + 11;
        if (fish_gone(i) == 0)
            continue;
        fish_gone(i) = 0;
        if (cat_x <= 0xA0) {
            fish_dir_x(i) = 0xFF;
            fish_x(i) = 0x12E;
        } else {
            fish_dir_x(i) = 1;
            fish_x(i) = 0;
        }
        if (--fish_eaten_now)
            goto again;
        return;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 34A0  고양이가 물고기/뱀장어에 닿았나 (먹었으면 1 = 고양이를 다시 그린다)
 * ------------------------------------------------------------------------- */
int fish_touch(void)
{
    uint16_t x, flash;
    uint8_t y;
    int i, k;

    fish_check_i = 0;
    fish_eaten_now = 0;
    for (; fish_check_i < 24; fish_check_i++) {
        i = fish_check_i;
        if (fish_gone(i))
            continue;
        k = (i >= 12) ? 1 : 0;
        if (!rects_overlap(fish_x(i), fish_hit_w(k), fish_y(i), (uint8_t)fish_hit_h(k),
                           cat_x, 0x18, cat_y, 0x0E))
            continue;
        if (i >= 12 && room_cleared == 0 && cat_drowning == 0) {
            /* 뱀장어: 감전 */
            cat_caught = 1;
            x = (cat_x >= 8) ? cat_x - 8 : 0;
            if (x >= 0x117)
                x = 0x116;
            y = cat_y;
            if (y >= 0xB5)
                y = 0xB4;
            blit(screen_offset(x, y), ZAP_SPR, 0x1205);
            reset_zap_sound();
            fish_ticks = (uint16_t)sys_ticks();
            flash = fish_ticks;
            do {
                do {
                    zap_sound();
                } while (!sys_in_retrace());
                zap_sound();
                bios_set_color(0, (flash & 1) ? 1 : 0x0F);
                zap_sound();
                flash = (uint16_t)((uint16_t)sys_ticks() - fish_ticks);
            } while (flash < 0x0D);
            return 0;
        }
        /* 먹었다 */
        fish_eaten_now++;
        start_effect(0x5DC, 0x425);
        if (fish_eaten_now == 1)
            restore_under_cat();
        erase_fish(i);
        fish_gone(i) = 1;
        if (i < 12) {
            if (--fish_left == 0 && cat_drowning == 0)
                room_cleared = 1;
        }
    }
    if (fish_eaten_now == 0)
        return 0;
    respawn_eels();
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 35C9  어항 속 준비.  난이도에 따라 뱀장어 몇 개를 처음부터 뺀다.
 * ------------------------------------------------------------------------- */
void reset_fish(void)
{
    int n, i;
    uint8_t r;

    fish_anim = 0;
    fish_turn = 0;
    fish_left = 12;
    for (n = 24; n > 0; n--) {
        i = n - 1;
        fish_hidden(i) = 1;
        fish_gone(i) = 0;
        fish_y(i) = fish_home_y(i);
        fish_dir_y(i) = 1;
        r = (uint8_t)random16() & 1;
        fish_dir_x(i) = r ? r : 0xFF;
        fish_x(i) = random16() & 0xFF;
    }
    for (n = eels_absent(level); n > 0; n--) {
        do {
            do {
                r = (uint8_t)random16() & 0x0F;
            } while (r >= 12);
            i = r + 12;
        } while (fish_gone(i));
        fish_gone(i) = 1;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 3675  물고기 하나 움직이기 (틱마다 차례로, 한 바퀴에 한 번 쉰다)
 * ------------------------------------------------------------------------- */
void move_fish(void)
{
    uint16_t t = (uint16_t)sys_ticks(), x, spr;
    int i;
    uint8_t step, y, r;

    if (t == fish_ticks)
        return;
    fish_ticks2 = t;
    i = ++fish_turn;
    if (i >= 24) {
        i = 0;
        fish_turn = 0;
        fish_anim ^= 0x0C;
        eel_anim += 8;
        fish_ticks = fish_ticks2;
    } else if (i == 12) {
        fish_ticks = fish_ticks2;
    }
    if (fish_gone(i))
        return;
    r = (uint8_t)random16();
    if (r <= 0x10) {
        r &= 1;                         /* 같은 난수의 아랫비트 */
        fish_dir_x(i) = r ? r : 0xFF;
        r = (uint8_t)random16() & 1;
        fish_dir_y(i) = r ? r : 0xFF;
    }
    step = (i >= 12) ? 2 : 4;
    x = fish_x(i);
    if (fish_dir_x(i) != 1) {
        if (x < step) {
            x = 0;
            fish_dir_x(i) = 1;
        } else {
            x -= step;
        }
    } else {
        x += step;
        if (x >= 0x12F) {
            x = 0x12E;
            fish_dir_x(i) = 0xFF;
        }
    }
    fish_x(i) = x;
    y = fish_y(i);
    if (fish_dir_y(i) != 1) {
        y--;
        if (y < fish_home_y(i)) {
            y = fish_home_y(i);
            fish_dir_y(i) = 1;
        }
    } else {
        y++;
        if (y > (uint8_t)(fish_home_y(i) + 0x18)) {
            y = (uint8_t)(fish_home_y(i) + 0x18);
            fish_dir_y(i) = 0xFF;
        }
    }
    fish_y(i) = y;
    fish_new_scr = screen_offset(fish_x(i), y);
    erase_fish(fish_turn);
    i = fish_turn;
    fish_scr(i) = fish_new_scr;
    fish_hidden(i) = 0;
    ACTOR_BEGIN_KEY(0x20000u + (uint32_t)i);   /* 개선판: 물고기/뱀장어도 부드럽게 */
    if (i >= 12) {
        spr = (uint16_t)((((i << 3) + eel_anim) & 0x18) + EEL_SPR);
        blit(fish_new_scr, spr, 0x0202);
        ACTOR_END(99, fish_new_scr, fish_x(i), spr);
        return;
    }
    spr = fish_anim;
    if (!(i & 1))
        spr ^= 0x0C;
    if (fish_dir_x(i) != 1)
        spr += 0x18;
    blit(fish_new_scr, (uint16_t)(spr + FISH_SPR), 0x0601);
    ACTOR_END(99, fish_new_scr, fish_x(i), (uint16_t)(spr + FISH_SPR));
}

/* ---------------------------------------------------------------------------
 *  원래: 37E5  수면 물결 (한 칸씩 무늬를 바꾼다, 숨 쉬는 고양이 머리 근처는 건너뛴다)
 * ------------------------------------------------------------------------- */
void move_waves(void)
{
    uint16_t t = (uint16_t)sys_ticks(), d, col2, w;
    int col;
    uint8_t ph;

    if ((uint16_t)(t - wave_ticks) < 8)
        return;
    col = ++wave_col;
    if (col >= 0x28) {
        col = 0;
        wave_col = 0;
        wave_ticks = t;
    }
    col2 = (uint16_t)(col * 2);
    if (cat_y <= 7) {
        w = (uint16_t)((cat_x >> 2) + 1);
        d = (w >= col2) ? w - col2 : (uint16_t)~(uint16_t)(w - col2);
        if (d < 4)
            return;
    }
    ph = (uint8_t)(wave_phase(col) + 8);
    wave_phase(col) = ph;
    blit((uint16_t)(col2 + 0xA0), (uint16_t)((ph & 0x18) + WAVE_SPR), 0x0401);
}

/* ---------------------------------------------------------------------------
 *  원래: 3850  방 1: 어항 속 물고기 그림 돌리기, 고양이가 어항에 닿으면 들어간다
 * ------------------------------------------------------------------------- */
void fishbowl_splash(void)
{
    uint16_t t = (uint16_t)sys_ticks();

    if ((uint16_t)(t - bowl_ticks) < 6)
        return;
    bowl_ticks = t;
    bowl_frame += 2;
    blit(0x15C9, DW(BOWL_SPRITES + (bowl_frame & 6)), 0x0A02);
    if (rects_overlap(0xE4, 0x10, 0x8A, 0x0A, cat_x, 0x18, cat_y, 0x0E))
        fishbowl_entered = 1;
}
