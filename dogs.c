/* ============================================================================
 *  dogs.c  -  방 6: 잠자는 개들과 우유 그릇
 * ----------------------------------------------------------------------------
 *  원본 코드 47B0..4BF7.
 *
 *  바닥 자리 12곳 중 몇 곳에 개가 자고, 그릇 12개에 우유가 들어 있다.
 *  고양이가 그릇 옆에서 단추(Alt)를 누르고 있으면 우유를 마신다.
 *  그릇을 모두 비우면 방을 깬다.  고양이가 개 곁에서 서성이면 개가 깨어나
 *  (눈을 뜨고) 다 깨면 고양이를 문다.
 * ========================================================================== */
#include "allycat.h"

/* 원래: 47B0  빗자루가 마시는 고양이 근처에 있나 */
int broom_near_drinking_cat(void)
{
    uint16_t x = (cat_x >= 8) ? cat_x - 8 : 0;

    return rects_overlap(broom_x, 0x10, broom_y, 0x1E, x, 0x28, (uint8_t)(cat_y + 3), 0x0E);
}

/* 원래: 4B03  마시는 고양이 지우기 */
static void erase_drinking_cat(void)
{
    if (drink_hidden == 0)
        blit(drink_scr, DRINK_SAVE, 0x0A03);
}

/* 원래: 4B1D  마시는 고양이 그리기 (혀를 내밀었다 넣었다) */
static void draw_drinking_cat(void)
{
    uint16_t spr = drink_sprite;

    drink_hidden = 0;
    drink_scr = drink_new_scr;
    if (drink_phase >= 0x80)
        spr += 0x3C;
    draw_sprite_and(drink_new_scr, spr, DRINK_SAVE, 0x0A03);
}

/* 원래: 4BE8, 4BC8  그릇 그리기 (남은 양에 따라) */
static void draw_bowl(int b)
{
    blit(screen_offset(bowl_x(b), bowl_y(b)), (uint16_t)((bowl_level(b) << 5) + BOWL_SPR), 0x0802);
}

/* 원래: 488D */
static void hide_cat_for_dog(void)
{
    if (cat_drinking) {
        erase_drinking_cat();
        cat_drinking = 0;
        return;
    }
    restore_under_cat();
}

/* 원래: 48A1  깬 개 자리를 배경색으로 */
static void blank_dog_place(void)
{
    ds_fill_word(SCRATCH, 0xAAAA, 0x41);
    blit(dog6_wake_scr, SCRATCH, 0x0D05);
}

/* 원래: 48C1  (48D7 에서 지웠으면) 고양이 다시 그리기 */
static void redraw_cat_after_dog(void)
{
    if (dog6_near_cat == 0)
        return;
    if (cat_drinking) {
        draw_drinking_cat();
        return;
    }
    draw_cat();
}

/* 원래: 48D7  개 눈을 그리기 전에 고양이가 겹치면 지운다 */
static void hide_cat_near_dog(int d)
{
    dog6_near_cat = 0;
    if (!rects_overlap((uint16_t)(dog6_x(d) - 0x14), 0x28, (uint8_t)dog6_y(d), 6,
                       cat_x, 0x18, cat_y, 0x0E))
        return;
    dog6_near_cat = 1;
    while (!sys_in_retrace())
        ;
    if (cat_drinking) {
        erase_drinking_cat();
        return;
    }
    restore_under_cat();
}

/* 원래: 4916  개 눈 (깨어난 정도) */
static void draw_dog_eyes(int d)
{
    uint16_t dst = dog6_scr(d) + 0xA7;
    uint16_t src = (uint16_t)(dog6_wake(d) * 2 + DOG6_EYES_SPR);

    if (dog6_sprite(d) != 0x429C) {
        dst -= 6;
        src += 6;
    }
    blit(dst, src, 0x0101);
}

/* ---------------------------------------------------------------------------
 *  원래: 47D6  개 깨우기 (난이도마다 정한 틱마다)
 *  고양이가 개와 같은 높이에서 가까우면 깬 정도가 오르고, 멀면 가끔 내려간다.
 *  2 가 되면 개가 일어나 고양이를 문다.
 * ------------------------------------------------------------------------- */
void dogs_wake(void)
{
    uint16_t t = (uint16_t)sys_ticks(), d;
    int n, i;

    if ((uint16_t)(t - dogs_ticks) <= dogs_wake_period(level))
        return;
    dogs_ticks = t;
    if (dog_has_cat)
        return;
    dogs_growl = 0;
    for (n = 12; n; n--) {
        i = n - 1;
        if (dog6_present(i) == 0)
            continue;
        if ((uint8_t)dog6_y(i) == cat_y) {
            d = (dog6_x(i) >= cat_x) ? dog6_x(i) - cat_x
                                     : (uint16_t)~(uint16_t)(dog6_x(i) - cat_x);
            if (d <= dog6_sense(level)) {
                if (dog6_wake(i) >= 2) {
                    dog6_wake_scr = dog6_scr(i);
                    hide_cat_for_dog();
                    blank_dog_place();
                    draw_broom();
                    draw_cat();
                    dog_grab_cat();
                    return;
                }
                dog6_wake(i)++;
                if (dog6_wake(i) >= 2)
                    dogs_growl++;
                goto eyes;
            }
        }
        if (dog6_wake(i) == 0)
            continue;
        if ((uint8_t)random16() <= 0x38)
            dog6_wake(i)--;
eyes:
        hide_cat_near_dog(i);
        draw_dog_eyes(i);
        redraw_cat_after_dog();
    }
    if (dogs_growl)
        growl_sound();
}

/* ---------------------------------------------------------------------------
 *  원래: 4943  우유 마시기
 *  단추를 누르고 있으면 가장 가까운 (같은 높이의) 그릇 쪽으로 걸어가고,
 *  4점 안이면 마신다.  한 모금마다(drink_phase 가 넘칠 때) 그릇이 준다.
 * ------------------------------------------------------------------------- */
void dogs_cat_drink(void)
{
    uint16_t t, x, d;
    int n, b;
    uint8_t y, dir;

    if (dog_has_cat)
        return;
    if (drink_dir) {
        joy_x = drink_dir;
        joy_y = 0;
    }
    t = (uint16_t)sys_ticks();
    if (t == drink_ticks)
        return;
    drink_ticks = t;
    if (cat_bounced) {
        if (cat_drinking) {
            erase_drinking_cat();
            erase_broom();
            save_under_cat();
            draw_broom();
            cat_drinking = 0;
            drink_hidden = 1;
            drink_dir = 0;
        }
        return;
    }
    if (fire)
        goto stop;

    drink_bowl = 0xFFFF;
    drink_dist = 0xFFFF;
    x = cat_x;
    y = (uint8_t)(cat_y + 8);
    for (n = 12; n; n--) {
        b = n - 1;
        if (bowl_level(b) < 1 || y != bowl_y(b))
            continue;
        if (x >= bowl_x(b)) {
            d = (uint16_t)(x - bowl_x(b));
            dir = 0xFF;
        } else {
            d = (uint16_t)~(uint16_t)(x - bowl_x(b));
            dir = 1;
        }
        if (d > drink_dist)
            continue;
        drink_dist = d;
        drink_sprite = bowl_drink_sprite(b);
        drink_bowl = (uint16_t)b;
        drink_toward = dir;
    }
    if (drink_bowl >= 12)
        goto stop;

    if (drink_dist >= 4) {
        /* 그릇 쪽으로 걸어간다 */
        if (drink_dist <= 8)
            cat_speed_x = (cat_speed_x & 0xFF00) | 4;
        joy_x = drink_toward;
        cat_hdir = drink_toward;
        drink_dir = drink_toward;
        joy_y = 0;
        cat_vdir = 0;
        goto stop;
    }

    drink_dir = 0;
    if (cat_drinking == 0) {
        restore_under_cat();
        save_under_cat();
    }
    cat_drinking = 1;
    drink_gulp = 0;
    drink_phase += 0x30;
    if (drink_phase < 0x30)
        drink_gulp = 1;
    x = cat_x & 0x0FFC;
    y = (uint8_t)(cat_y + 3);
    if (drink_sprite == 0x410C) {
        x = (x >= 8) ? x - 8 : 0;
    } else {
        x += 8;
        if (x >= 0x127)
            x = 0x126;
    }
    drink_new_scr = screen_offset(x, y);
    while (!sys_in_retrace())
        ;
    erase_drinking_cat();
    if (drink_gulp) {
        b = drink_bowl;
        if (bowl_level(b)) {
            if (--bowl_level(b) == 0) {
                start_effect(0x08FD, 0x0723);
                joy_x = 0;
                drink_dir = 0;
                fire = 0x10;
                if (--bowls_left == 0)
                    room_cleared = 1;
            }
            if (broom_near_drinking_cat()) {
                erase_broom();
                draw_bowl(b);
                draw_broom();
            } else {
                draw_bowl(b);
            }
        }
    }
    draw_drinking_cat();
    return;

stop:
    if (cat_drinking) {
        erase_drinking_cat();
        draw_cat();
        fire = 0x10;
    }
    cat_drinking = 0;
    drink_hidden = 1;
    drink_phase = 0;
    drink_dir = 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 4B47  개 놓기, 그릇 채우기
 * ------------------------------------------------------------------------- */
void reset_dogs(void)
{
    int n, i;
    uint16_t r;

    for (i = 0; i < 12; i++)
        dog6_present(i) = 0;
    for (n = dog6_count(level); n; n--) {
        do {
            r = random16() & 0x1E;
        } while ((uint8_t)r >= 0x18 || dog6_present(r >> 1));
        i = r >> 1;
        dog6_wake(i) = 0;
        dog6_present(i) = 1;
        blit(dog6_scr(i), dog6_sprite(i), 0x0D05);
    }
    for (n = 12; n; n--) {
        i = n - 1;
        bowl_level(i) = bowl_full(level);
        draw_bowl(i);
    }
    drink_phase = 0;
    cat_drinking = 0;
    drink_hidden = 1;
    bowls_left = 12;
    drink_dir = 0;
}
