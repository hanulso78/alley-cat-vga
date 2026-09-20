/* ============================================================================
 *  alley.c  -  골목의 나머지: 창문에서 던지는 물건, 쓰레기통에서 튀어나오는 놈,
 *              빨랫줄 위의 쥐
 * ----------------------------------------------------------------------------
 *  원본 코드 1830..1BE2 (창문), 2210..2327 (쓰레기통), 2330..2688 (쥐).
 * ========================================================================== */
#include "allycat.h"

/* ============================================================================
 *  창문 - 창문 12개(3줄 x 4칸) 중 하나가 열리고 사람이 물건을 던진다.
 *  열린 창문으로 떨어지면 방에 들어간다.
 * ========================================================================== */

/* 원래: 1830 */
void reset_thrower(void)
{
    window_anim = 0;
    thrown_y = 0;
    thrower_aims = 0;
    thrown_is_deadly = 0;
    window_open_time = 9;
}

/* ---------------------------------------------------------------------------
 *  원래: 184B  던진 물건 날리기 (틱마다).  아래로 점점 빨라지고, 가로 속도는
 *  thrown_speed/8.  바닥 thrown_floor 아래로 다 들어가면 사라진다.
 * ------------------------------------------------------------------------- */
void move_thrown(void)
{
    uint16_t t, x, d, size;
    uint8_t y, a, rows;

    if (thrown_y == 0)
        return;
    t = (uint16_t)sys_ticks();
    if (t == thrown_ticks)
        return;
    thrown_ticks = t;

    if (thrower_aims) {
        /* 고양이를 노린 것: 고양이 바로 위에 오면 곧장 떨어진다 */
        if ((thrown_x & 0xFFF8) == (cat_x & 0xFFF8))
            thrown_dir = 0;
    }
    thrown_fall++;
    if (thrown_speed <= 1)
        thrown_speed--;
    x = thrown_x;
    d = (uint16_t)((thrown_speed & 0xFF00) | ((uint8_t)thrown_speed >> 3));
    if (thrown_dir == 1) {
        x += d;
        if (x >= 0x12F)
            x = 0x12E;
    } else if (thrown_dir != 0) {
        x = (x >= d) ? x - d : 0;
    }
    thrown_x = x;

    size = thrown_size;
    y = (uint8_t)((thrown_fall >> 1) + thrown_y);
    if (y >= thrown_floor) {
        a = y - thrown_floor;
        rows = size >> 8;
        if (rows <= a) {
            thrown_y = 0;
            thrown_is_deadly = 0;
            erase_thrown();
            return;
        }
        size = (uint16_t)(((rows - a) << 8) | (uint8_t)size);
    }
    thrown_y = y;
    thrown_draw_size = size;
    thrown_new_scr = screen_offset(thrown_x, y);
    if (thrown_fall != 2)
        erase_thrown();
    if (thrown_hits_cat())
        return;
    thrown_scr = thrown_new_scr;
    thrown_save_size = thrown_draw_size;
    draw_sprite(thrown_new_scr, thrown_sprite, THROWN_SAVE, thrown_draw_size);
}

/* 원래: 1922 */
void erase_thrown(void)
{
    blit(thrown_scr, THROWN_SAVE, thrown_save_size);
}

/* 원래: 1AEA  창문 번호 -> 위치 (아래 2비트 = 칸, 다음 2비트 = 줄) */
static uint16_t window_pos(uint8_t n, uint8_t *y)
{
    *y = window_row_y((n >> 2) & 3);
    return window_col_x(n & 3);
}

/* ---------------------------------------------------------------------------
 *  원래: 1B05  고양이가 창문에 닿았나 (닿으면 1).  열려 있는 창문으로
 *  떨어지는 중이었으면 방으로 들어간다 (exit_room).
 * ------------------------------------------------------------------------- */
static int window_touches_cat(void)
{
    if (!rects_overlap(window_x, 0x20, window_y, 0x0F, cat_x, 0x18, cat_y, 0x0E))
        return 0;
    if (cat_vdir == 1 && cat_knocked_down == 0 && cat_y < 0x60 &&
        window_anim >= 5 && window_anim < 0x19)
        exit_room = 1;
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 1B4C  열리는 창문 아래 빨랫줄 쥐가 있나 (있으면 쥐가 빨리 도망간다)
 * ------------------------------------------------------------------------- */
static int window_above_mouse(void)
{
    int m;
    uint16_t x;

    if (window_number >= 8)
        return 0;
    m = (window_number & 4) ? 2 : 1;
    x = mouse_x(m) + 0x10;
    if (x < window_x)
        return 0;
    x = (x >= 0x30) ? x - 0x30 : 0;
    if (x > window_x)
        return 0;
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 1936  창문 열고 닫기, 물건 던지기
 *  window_anim: 1D 에서 시작해 줄어든다.  0F 보다 크면 열리는 중(검게 한 줄씩),
 *  0F 에서 window_open_time 만큼 머물며 한 번 던지고, 그 뒤 유리를 한 줄씩 되돌린다.
 * ------------------------------------------------------------------------- */
void window_thrower(void)
{
    uint16_t r, x, dst, src;
    uint8_t n, y, row;

    if (--window_delay)
        return;
    window_delay = 0x0D;
    if (sys_in_retrace())
        return;
    if (window_anim)
        window_touches_cat();
    if (thrown_y)
        return;

    if (window_anim == 0) {
        if (cat_y > 0x60)
            return;
        thrower_aims = 0;
        if (cat_perch == 1 && love_room_next == 0) {
            /* 담장 위에서 오래 버티면 고양이 쪽 창문에서 노리고 던진다 */
            if ((uint16_t)((uint16_t)sys_ticks() - perch_ticks) >= 0x48)
                thrower_aims++;
        }
        do {
            r = random16();
            if (thrower_aims) {
                n = (uint8_t)r & 3;
            } else {
                n = (uint8_t)r & 0x0F;
                if (n >= 0x0C)
                    return;
            }
            window_number = n;
            window_x = window_pos(n, &y);
            window_y = y;
        } while (window_touches_cat());
        window_anim = 0x1D;
        window_open_time = window_open_ticks(level);
        throws_left = 1;
    }

    if (window_touches_cat())
        return;
    mouse_under_window = 0;
    if (window_above_mouse()) {
        mouse_under_window++;
        return;
    }
    if (window_anim == 0x10)
        window_ticks = (uint16_t)sys_ticks();
    if (window_anim == 0x0F) {
        if ((uint16_t)((uint16_t)sys_ticks() - window_ticks) < window_open_time) {
            if (throws_left == 0 || thrown_y || love_room_next)
                return;
            /* 던지기 */
            throws_left--;
            thrown_is_deadly = 1;
            thrown_y = window_y;
            x = (random16() & 0x0F) + window_x;
            thrown_x = x;
            thrown_dir = (x >= cat_x) ? 0xFF : 1;
            r = random16() & 6;
            thrown_sprite = thrown_sprites(r >> 1);
            thrown_size = thrown_sizes(r >> 1);
            thrown_floor = thrown_floors(r >> 1);
            thrown_speed = 0x20;
            thrown_fall = 1;
            thrown_hit = 0;
            return;
        }
    }

    window_anim--;
    x = window_x;
    y = window_y;
    if (window_anim > 0x0E)
        y += window_anim - 0x0E;
    else
        y += 0x0E - window_anim;
    window_row = y;
    dst = screen_offset(x, y);
    row = window_row - window_y;
    if (window_anim > 0x0E) {
        if (love_room_next) {
            src = (uint16_t)(row * 8 + WINDOW_SWEETIE_SPR);   /* 암고양이 얼굴 */
            vram_put(dst, src, 8);
        } else {
            vram_fill_word(dst, 0, 4);
        }
    } else {
        src = (uint16_t)(row * 10 + WINDOW_GLASS_SPR);
        vram_put(dst, src, 8);
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 1B7A  던진 물건이 고양이에 맞았나 (맞으면 1)
 *  맞으면 고양이는 떨어지고, 처음 맞은 것이면 "BONK!" 와 함께 목숨을 잃는다.
 *  물건은 반대로 튕겨 나간다.
 * ------------------------------------------------------------------------- */
int thrown_hits_cat(void)
{
    if (room != ROOM_ALLEY || thrown_y == 0)
        return 0;
    if (!rects_overlap(thrown_x, 0x10, thrown_y, (uint8_t)(thrown_size >> 8),
                       cat_x, 0x18, cat_y, 0x0E))
        return 0;
    restore_under_cat();
    erase_thrown();
    knock_down_cat();
    if (thrown_hit == 0) {
        thrown_hit = 1;
        cat_hit_flash();
        thrown_dir = (thrown_dir == 0xFF) ? 1 : 0xFF;
        thrown_speed = 0x60;
        thrown_fall = 1;
        cat_standing = 0;
    }
    return 1;
}

/* ============================================================================
 *  쓰레기통에서 튀어나오는 놈 - 고양이를 쓰레기통에서 떨어뜨리고 개를 부른다
 * ========================================================================== */

/* 원래: 2210 */
void reset_popper(void)
{
    popper_anim = 0;
}

/* 원래: 22DC */
static void erase_popper(void)
{
    if (popper_anim == 0x1A)
        return;
    blit(popper_scr, POPPER_SAVE, popper_save_size);
}

/* ---------------------------------------------------------------------------
 *  원래: 2216  쓰레기통 놈 움직이기
 *  popper_anim 1B 에서 줄어들며 0E 까지는 올라오고(보이는 줄이 는다) 그 뒤로
 *  다시 들어간다.  고양이가 쓰레기통 위에 있으면 꼭 나온다.
 * ------------------------------------------------------------------------- */
void move_popper(void)
{
    uint16_t t = (uint16_t)sys_ticks(), x, size;
    uint8_t y;

    if (t == popper_ticks)
        return;
    if (!sys_in_retrace())
        return;
    popper_ticks = t;
    if (popper_hits_cat())
        return;
    if (popper_anim == 0) {
        if (cat_y != 0x86 && cat_y != 0x8E) {
            if ((uint8_t)random16() > 5)
                return;
        }
        x = pick_trash_can(&y);
        popper_base_y = y + 3;
        popper_x = x + (random16() & 7) + 6;
        popper_anim = 0x1B;
    }
    popper_anim--;
    x = popper_x;
    y = popper_base_y;
    if (popper_anim > 0x0D) {
        y = (uint8_t)(y + popper_anim - 0x0F);
        size = (uint16_t)(((0x1B - popper_anim) << 8) | 2);
    } else {
        y = (uint8_t)(y + 0x0C - popper_anim);
        size = (uint16_t)((popper_anim << 8) | 2);
    }
    popper_size = size;
    popper_y = y;
    popper_new_scr = screen_offset(x, y);
    erase_popper();
    if (popper_hits_cat())
        return;
    if (popper_anim == 0)
        return;
    popper_scr = popper_new_scr;
    popper_save_size = popper_size;
    draw_sprite(popper_new_scr, POPPER_SPR, POPPER_SAVE, popper_size);
}

/* 원래: 22F7  쓰레기통 놈이 고양이에 닿았나 (닿으면 개가 깬다) */
int popper_hits_cat(void)
{
    if (popper_anim == 0)
        return 0;
    if (!rects_overlap(popper_x, 0x10, popper_y, (uint8_t)(popper_size >> 8),
                       cat_x, 0x18, cat_y, 0x0E))
        return 0;
    popper_woke_dog = 1;
    return 1;
}

/* ============================================================================
 *  빨랫줄 위의 쥐 세 마리 (줄마다 한 마리, y = 00, 20, 40)
 *  잡으면 9, 7, 5 (십의 자리) 점.  잡힌 쥐는 3초쯤 뒤 가장자리에서 다시 나온다.
 * ========================================================================== */

/* 원래: 2330 */
void reset_line_mice(void)
{
    uint16_t x = 0;
    uint8_t dir = 1;
    int m;

    mouse_turn = 0;
    if (cat_x <= 0xA0) {
        x = 0x12C;
        dir = 0xFF;
    }
    for (m = 0; m < 3; m++) {
        mouse_x(m) = x;
        mouse_dir(m) = dir;
        mouse_hidden(m) = 1;
        mouse_caught(m) = 0;
    }
}

/* 원래: 254D */
static void erase_mouse(void)
{
    blit(mouse_scr(mouse_turn), mouse_save(mouse_turn), 0x0802);
}

/* 원래: 265E  던진 물건이 이 쥐에 걸쳐 있나 */
static int thrown_over_mouse(void)
{
    if (thrown_y == 0)
        return 0;
    return rects_overlap(mouse_x(mouse_turn), 0x10, mouse_y(mouse_turn), 0x08,
                         thrown_x, 0x10, thrown_y, 0x0C);
}

/* ---------------------------------------------------------------------------
 *  원래: 2567  고양이와 쥐 (무슨 일이 있었으면 1)
 *  떨어지는 고양이에 닿으면 잡는다.  고양이가 줄 위에 서 있으면 쥐가 "SQUEEK!"
 *  하고 고양이는 떨어진다.
 * ------------------------------------------------------------------------- */
static int cat_meets_mouse(void)
{
    int m = mouse_turn;
    uint16_t t, dst;

    if (!rects_overlap(mouse_x(m), 0x10, mouse_y(m), 0x08, cat_x, 0x18, cat_y, 0x0E))
        return 0;
    if (mouse_caught(m) || cat_foot_y < 0x26)
        return 1;
    if (cat_standing) {
        cat_standing = 0;
        cat_jump_delay = 0x11;
        cat_vdir = 1;
        cat_hdir = 0;
        dst = mouse_scr(m);
        if (mouse_x(m) >= 0x10)
            dst -= 4;
        squeek_scr = dst;
        draw_sprite(dst, SQUEEK_SPR, SCRATCH, 0x0806);
        mice_ticks = (uint16_t)sys_ticks();
        do {
            squeek_sound();
        } while ((uint16_t)((uint16_t)sys_ticks() - mice_ticks) < 8);
        speaker_off();
        blit(squeek_scr, SCRATCH, 0x0806);
        return 1;
    }
    /* 잡았다 */
    t = (uint16_t)sys_ticks();
    mouse_caught(m) = 1;
    mouse_dir(m) = 1;
    mouse_caught_ticks(m) = t;
    restore_under_cat();
    draw_sprite(mouse_scr(m), mouse_points_spr(m), SCRATCH, 0x0802);
    save_under_cat();
    add_score(mouse_points(m));
    start_effect(0x3E8, 0x2EE);
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 237B  쥐 움직이기 (틱마다 한 마리씩 차례로)
 * ------------------------------------------------------------------------- */
void move_line_mice(void)
{
    uint16_t t, x;
    int m;
    uint8_t d, lim, a;

    t = (uint16_t)sys_ticks();
    if (t == mice_ticks)
        return;
    mice_ticks = t;
    if (cat_knocked_down)
        return;
    m = mouse_turn + 1;
    if (m >= 3)
        m = 0;
    mouse_turn = m;
    if (thrown_over_mouse())
        return;
    if (cat_meets_mouse())
        return;

    if (mouse_caught(m)) {
        if ((uint16_t)((uint16_t)sys_ticks() - mouse_caught_ticks(m)) < 0x36)
            return;
        x = 0;
        d = 1;
        if (cat_x <= 0xA0) {
            x = 0x12C;
            d = 0xFF;
        }
        mouse_x(m) = x;
        mouse_caught(m) = 0;
        mouse_dir(m) = d;
    }
    mouse_prev_dir(m) = mouse_dir(m);

    if (mouse_under_window) {
        mouse_speed = 0x0C;
    } else {
        mouse_speed = (cat_y > 0x60) ? 4 : 8;
        if (m != active_line)
            goto near_cat;
    }
    if (mouse_dir(m) == 0) {
        a = (uint8_t)random16();
        goto random_dir;
    }
near_cat:
    if (cat_standing && mouse_y(m) <= cat_y && (uint8_t)(mouse_y(m) + 0x10) >= cat_y &&
        (uint8_t)random16() <= mouse_flee_chance(level)) {
        /* 고양이가 같은 줄에 서 있으면 달려든다 */
        mouse_speed = 0x0C;
        mouse_dir(m) = (mouse_x(m) >= cat_x) ? 0xFF : 1;
        goto move;
    }
    lim = 0x18;
    if (cat_y > 0x60) {
        lim = 0x28;
        if (mouse_dir(m) == 0)
            lim = 0x10;
    }
    a = (uint8_t)random16();
    if (a > lim)
        goto move;
    if (mouse_dir(m) != 0) {
        mouse_dir(m) = 0;
        goto move;
    }
random_dir:
    mouse_dir(m) = (a & 1) ? 1 : 0xFF;

move:
    d = mouse_dir(m);
    x = mouse_x(m);
    if (d == 1) {
        x += mouse_speed;
        if (x >= 0x12F) {
            x = 0x12E;
            d = 0xFF;
        }
    } else if (d != 0) {
        if (x < mouse_speed) {
            x = 0;
            d = 1;
        } else {
            x -= mouse_speed;
        }
    }
    mouse_x(m) = x;
    mouse_dir(m) = d;
    mouse_new_scr = screen_offset(x, mouse_y(m));
    if (mouse_hidden(m) == 0 && (mouse_dir(m) | mouse_prev_dir(m)))
        erase_mouse();
    if (thrown_over_mouse())
        return;
    if (cat_meets_mouse())
        return;
    mouse_hidden(m) = 0;
    if (mouse_dir(m) == 0) {
        if (mouse_prev_dir(m) == 0)
            return;
        mouse_scr(m) = mouse_new_scr;
        ACTOR_BEGIN(2 + m);
        draw_sprite_and(mouse_new_scr, MOUSE_SIT_SPR, mouse_save(m), 0x0802);
        ACTOR_END(2 + m, mouse_new_scr, x, MOUSE_SIT_SPR);
        return;
    }
    mouse_anim(m)++;
    mouse_scr(m) = mouse_new_scr;
    {
        uint16_t spr = (uint16_t)(MOUSE_RUN_SPR + ((mouse_anim(m) & 1) ? 0 : 0x20)
                                  + (mouse_dir(m) != 1 ? 0x40 : 0));
        ACTOR_BEGIN(2 + m);
        draw_sprite_and(mouse_new_scr, spr, mouse_save(m), 0x0802);
        ACTOR_END(2 + m, mouse_new_scr, x, spr);
    }
}
