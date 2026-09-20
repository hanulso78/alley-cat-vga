/* ============================================================================
 *  birdcage.c  -  방 5: 탁자 위의 새장
 * ----------------------------------------------------------------------------
 *  원본 코드 4340..47A5.
 *
 *  고양이가 새장을 밀어 탁자(x 78..A8) 밖으로 떨어뜨리면 새장이 깨지고
 *  새가 날아다닌다.  새를 잡으면 방을 깬다.
 *  새는 가끔 정해진 자리로 날아가고, 고양이가 가까우면 달아난다.
 * ========================================================================== */
#include "allycat.h"

/* 원래: 44E7  고양이가 탁자 높이(88)에 서 있나 */
static int cat_on_table(void)
{
    return cat_vdir == 0 && (cat_y & 0xF8) == 0x88;
}

/* 원래: 44FB  새 -> 고양이 반대 방향, 거리(가로 + 세로*2) */
static void bird_away_from_cat(void)
{
    uint16_t d;
    uint8_t dy;

    if (bird_x >= cat_x) {
        d = (uint16_t)(bird_x - cat_x);
        bird_away_dx = 1;
    } else {
        d = (uint16_t)~(uint16_t)(bird_x - cat_x);
        bird_away_dx = 0xFF;
    }
    bird_dist = d;
    if (bird_y >= cat_y) {
        dy = (uint8_t)(bird_y - cat_y);
        bird_away_dy = 1;
    } else {
        dy = (uint8_t)~(uint8_t)(bird_y - cat_y);
        bird_away_dy = 0xFF;
    }
    bird_dist += (uint16_t)(dy << 1);
}

/* 원래: 452D  새가 고양이에 닿으면 잡은 것 */
static void bird_touches_cat(void)
{
    if (rects_overlap(bird_x, 8, bird_y, 5, cat_x, 0x18, cat_y, 0x0E) && cat_caught == 0)
        room_cleared = 1;
}

/* 원래: 4557  새가 빗자루에 닿았나 (닿으면 위로) */
static int bird_touches_broom(void)
{
    if (!rects_overlap(bird_x, 8, bird_y, 5, broom_x, 0x10, broom_y, 0x1E))
        return 0;
    bird_dy = 0xFF;
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 4340  새 날리기 (새장이 깨진 뒤)
 * ------------------------------------------------------------------------- */
void move_bird(void)
{
    uint16_t t = (uint16_t)sys_ticks(), x, spr;
    int g;
    uint8_t d, y, r;

    if (t == bird_ticks)
        return;
    bird_count++;
    if (bird_count & 3)
        bird_ticks = t;
    if (cage_y < 0xA4)
        return;
    bird_touches_cat();
    if (bird_touches_broom())
        return;

    if ((uint8_t)random16() <= 0x30) {
        bird_away_from_cat();
        if (bird_dist <= bird_flee_dist(level)) {
            chirp_sound();
            bird_goal = 0xFF;
            bird_dx = bird_away_dx;
            bird_dy = bird_away_dy;
            goto fly;
        }
    }
    if (bird_goal <= 0x0A) {
        if ((uint8_t)random16() > 6)
            goto to_perch;
        bird_goal = 0xFF;
    } else {
        goto wander;
    }
    goto wander;

to_perch:
    /* 정해진 자리로 */
    g = bird_goal;
    d = 0;
    x = bird_x & 0x0FFC;
    if (x != DW(PERCH_X + 2 * g))
        d = (x < DW(PERCH_X + 2 * g)) ? 1 : 0xFF;
    bird_dx = d;
    d = 0;
    y = bird_y & 0xFE;
    if (y != DB(PERCH_Y + g))
        d = (y < DB(PERCH_Y + g)) ? 1 : 0xFF;
    bird_dy = d;
    if (d | bird_dx)
        goto fly;
    if ((uint8_t)random16() > 0x10)
        goto fly;
    bird_goal = 0xFF;
    chirp_sound();

wander:
    r = (uint8_t)random16();
    if (r <= 0x30) {
        r &= 1;
        bird_dx = r ? r : 0xFF;
        r = (uint8_t)random16() & 1;
        bird_dy = r ? r : 0xFF;
    }
    bird_goal = random16() & 0xFF;

fly:
    y = bird_y;
    if (bird_dy == 1) {
        y += 2;
        if (y >= 0xA8) {
            y = 0xA7;
            bird_dy = 0xFF;
        }
        bird_y = y;
    } else if (bird_dy != 0) {
        y -= 2;
        if (y < 0x30) {
            y = 0x30;
            bird_dy = 1;
        }
        bird_y = y;
    }
    x = bird_x;
    if (bird_dx == 1) {
        x += 4;
        if (x >= 0x136) {
            x = 0x135;
            bird_dx = 0xFF;
        }
        bird_x = x;
    } else if (bird_dx != 0) {
        if (x < 4) {
            x = 0;
            bird_dx = 1;
        } else {
            x -= 4;
        }
        bird_x = x;
    }
    bird_touches_cat();
    bird_new_scr = screen_offset(bird_x, bird_y);
    if (bird_hidden == 0)
        blit(bird_scr, BIRD_SAVE, 0x0501);
    if (bird_touches_broom())
        return;
    bird_hidden = 0;
    bird_frame += 2;
    spr = DW(BIRD_SPRITES + (bird_frame & 6));
    if (bird_dx == 0xFF)
        spr += 0x1E;
    bird_scr = bird_new_scr;
    ACTOR_BEGIN(9);
    draw_sprite(bird_new_scr, spr, BIRD_SAVE, 0x0501);
    ACTOR_END(9, bird_new_scr, bird_x, spr);
}

/* ---------------------------------------------------------------------------
 *  원래: 457A  새장 놓기
 * ------------------------------------------------------------------------- */
void reset_birdcage(void)
{
    cage_x = 0x90;
    cage_y = 0x86;
    cage_new_scr = screen_offset(0x90, 0x86);
    draw_cage();
    cage_pushed = 0;
    cage_fell = 0;
    bird_hidden = 1;
    bird_dy = 0;
    bird_goal = 0xFF;
}

/* 원래: 473E */
static int cage_touches_cat(void)
{
    return rects_overlap(cage_x, 0x18, cage_y, 0x10, cat_x, 0x18, cat_y, 0x0E);
}

/* 원래: 4759  새장 그리기 */
void draw_cage(void)
{
    cage_scr = cage_new_scr;
    draw_sprite_and(cage_new_scr, CAGE_SPR, CAGE_SAVE, 0x1003);
}

/* 원래: 4773  새장 지우기 */
static void erase_cage(void)
{
    blit(cage_scr, CAGE_SAVE, 0x1003);
}

/* 원래: 4786  빗자루가 새장 밑 탁자 근처에 있나 */
static int broom_near_cage(void)
{
    uint16_t x;

    if (broom_y < 0x66)
        return 0;
    x = (uint16_t)(cage_x - 0x14);
    if (x > broom_x)
        return 0;
    x += 0x30;
    if (x < broom_x)
        return 0;
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 45AB  새장 (고양이가 밀기, 떨어지기)
 * ------------------------------------------------------------------------- */
void move_birdcage(void)
{
    uint16_t t = (uint16_t)sys_ticks(), x;
    uint8_t a, y;
    int n;

    if (t == cage_ticks)
        return;
    cage_ticks = t;
    if (cage_y >= 0xA4)
        return;
    if (broom_near_cage()) {
        /* 빗자루가 탁자를 치면 탁자 위 고양이가 떨어진다 */
        if (!cat_on_table())
            return;
        cat_vdir = 1;
        cat_jump_delay = 0x10;
        return;
    }
    if (cage_touches_cat()) {
        /* 고양이를 새장에서 밀어낸다 */
        if (cage_pushed == 0) {
            a = cat_hdir;
            if (a == 0) {
                a = 1;
                if (cage_x <= cat_x)
                    a = 0xFF;
            }
            cage_push_dir = a;
        }
        cage_pushed = 1;
        for (n = 0x20; n; n--) {
            x = cat_x;
            if (cage_push_dir == 1) {
                x -= 8;
                cat_hdir = 0xFF;
            } else {
                x += 8;
                cat_hdir = 1;
            }
            cat_x = x;
            if (cat_vdir >= 1) {
                y = cat_y;
                y = (cat_vdir == 1) ? y - 3 : y + 3;
                cat_y = y;
                cat_foot_y = y + 0x32;
            }
            if (!cage_touches_cat())
                break;
        }
        restore_under_cat();
        resave_cat();
        return;
    }
    if (cage_fell)
        goto falling;
    if (cage_pushed == 0)
        return;
    x = cage_x;
    x = (cage_push_dir == 1) ? x + 8 : x - 8;
    cage_x = x;
    if (cage_touches_cat())
        return;
    start_effect(0x0C00, 0x0B54);
    cage_pushed = 0;
    cage_new_scr = screen_offset(cage_x, cage_y);
    erase_cage();
    draw_cage();
    if (cage_x >= 0x78 && cage_x <= 0xA8)
        return;

falling:
    for (;;) {
        cage_fell = 1;
        if (dog_running) {
            if (cat_on_table()) {
                cat_vdir = 1;
                cat_jump_delay = 0x10;
            }
            return;
        }
        t = (uint16_t)sys_ticks();
        if (t == cage_ticks)
            continue;
        cage_ticks = t;
        if (sound_on)
            speaker_tone((uint16_t)(cage_y * 4));
        if (cage_y >= 0xA4)
            break;
        cage_y += 5;
        cage_new_scr = screen_offset(cage_x, cage_y);
        erase_cage();
        draw_cage();
    }
    speaker_off();
    erase_cage();
    cage_scr--;
    draw_sprite_and(cage_scr, BROKEN_CAGE_SPR, CAGE_SAVE, 0x1104);
    bird_x = cage_x;
    bird_y = cage_y;
    bird_away_from_cat();
    bird_dx = bird_away_dx;
}
