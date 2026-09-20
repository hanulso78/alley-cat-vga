/* ============================================================================
 *  cheese.c  -  방 4: 커다란 치즈의 쥐구멍
 * ----------------------------------------------------------------------------
 *  원본 코드 3E90..433F.
 *
 *  치즈에는 구멍이 16개 있고, 고양이가 구멍 발판에 서서 단추(Alt)를 누르면
 *  구멍으로 들어가 짝지어진 다른 구멍으로 나온다 (hole_link).
 *  쥐 네 마리가 구멍에서 들락날락하는데, 나와 있을 때 잡으면 된다.
 *  넷 다 잡으면 방을 깬다.
 * ========================================================================== */
#include "allycat.h"

/* 원래: 4065  빗자루가 고양이에 닿았나 */
static int broom_on_cat(void)
{
    return rects_overlap(broom_x, 0x10, broom_y, 0x1E, cat_x, 0x18, cat_y, 0x0E);
}

/* ---------------------------------------------------------------------------
 *  원래: 3E90  구멍으로 들어가기 / 나오기
 *  hole_anim 0E 에서 2씩 줄어든다.  8 이상이면 들어가는 구멍, 아래면 나오는
 *  구멍에 그림을 바꿔 그리고 그때 고양이를 나오는 구멍 발판으로 옮긴다.
 * ------------------------------------------------------------------------- */
void cat_in_hole(void)
{
    uint16_t t, dst, ofs;
    int in, out;

    if (hole_anim) {
        t = (uint16_t)sys_ticks();
        if (t == hole_ticks)
            return;
        goto animate;
    }
    if (cat_bounced || fire || hole_index == 0)
        return;
    if (broom_on_cat())
        return;
    t = (uint16_t)sys_ticks();
    if ((uint16_t)(t - hole_delay_ticks) < 0x0C)
        return;
    hole_delay_ticks = t;
    cat_standing = 0;
    in = hole_index - 1;
    hole_in_scr = DW(HOLE_LIST_DST + in * 4);
    hole_in_ofs = (in < 3) ? 0x80 : 0;
    out = hole_link(in);
    hole_out_scr = DW(HOLE_LIST_DST + out * 4);
    hole_out_ofs = (out < 3) ? 0x80 : 0;
    hole_out_y = plat_y(0x27 + out);
    hole_out_x = plat_x(0x27 + out) + 8;
    restore_under_cat();
    hole_anim = 0x0E;
    fire = 0x10;

animate:
    if (dog_running == 0)
        erase_broom();
    hole_anim -= 2;
    if (hole_anim >= 8) {
        dst = hole_in_scr;
        ofs = hole_in_ofs;
    } else {
        dst = hole_out_scr;
        cat_y = hole_out_y;
        cat_foot_y = hole_out_y + 0x32;
        cat_x = hole_out_x;
        ofs = hole_out_ofs;
    }
    blit(dst, (uint16_t)(ofs + DW(HOLE_ANIM_SPRITES + hole_anim)), 0x1002);
    if (dog_running == 0)
        draw_broom();
    hole_ticks = (uint16_t)sys_ticks();
    if (hole_anim == 0)
        resave_cat();
}

/* ---------------------------------------------------------------------------
 *  원래: 3F9E  치즈와 구멍 그리기, 구멍 짝 정하기
 * ------------------------------------------------------------------------- */
void draw_cheese(void)
{
    int n, col;
    uint16_t spr;
    uint8_t r;
    int i, k;

    hole_index = 0;
    hole_anim = 0;
    cheese_row_scr = 0x0506;
    for (cheese_row = 0; cheese_row < 0x11; cheese_row++) {
        n = cheese_row_len(cheese_row);
        for (col = 0; n; n--, col += 2) {
            spr = CHEESE_SPR;
            r = (uint8_t)random16();
            if (r <= 0x30)
                spr = (r & 4) ? CHEESE_BUMP_SPR : CHEESE_PIT_SPR;
            blit((uint16_t)(cheese_row_scr + col), spr, 0x0801);
        }
        cheese_row_scr += 0x140;
    }
    draw_list(0x3C22, 0);
    draw_list(0x3C3E, 0);
    draw_list(0x3C9A, 0);
    draw_list(HOLE_LIST, 0);
    draw_sprite_and(0x08EC, 0x3CAA, SCRATCH, 0x0102);

    k = (level & 3) * 8;
    for (i = 0; i < 0x10; i += 2, k++) {
        r = hole_pairs(k);
        hole_link(i) = r >> 4;
        DB(0x3CF3 + i) = 0;
        hole_link(i + 1) = r & 0x0F;
        DB(0x3CF4 + i) = 0;
    }
}

/* ============================================================================
 *  쥐 네 마리
 *      m4_timer  14h 이상: 구멍 속 / 13h,12h: 나오는 중 / 11h..2: 나와서 움직임 /
 *                1, 0: 들어가는 중.  0 이 되면 다른 구멍으로.
 * ========================================================================== */

/* 원래: 42B4  쥐를 구멍 발판 위치로 */
static void mouse_to_hole(int m)
{
    int h = m4_hole(m);
    uint8_t lift = (h >= 3) ? 0x0A : 0;

    m4_y(m) = (uint8_t)(plat_y(0x27 + h) - lift + 3);
    m4_x(m) = plat_x(0x27 + h) + 8;
}

/* 원래: 42DB  쥐가 고양이에 닿았나 */
static int mouse4_touches_cat(int m)
{
    return rects_overlap(m4_x(m), 0x10, m4_y(m), 0x0C, cat_x, 0x18, cat_y, 0x0E);
}

/* 원래: 42FC  쥐가 빗자루에 닿았나 */
static int mouse4_touches_broom(int m)
{
    return rects_overlap(m4_x(m), 0x10, m4_y(m), 0x0C, broom_x, 0x10, broom_y, 0x1E);
}

/* 원래: 431C  쥐와 고양이의 거리(가로+세로)가 limit 보다 가깝나 */
static int mouse4_near_cat(int m, uint16_t limit)
{
    uint16_t dx = (uint16_t)(m4_x(m) - cat_x);
    uint8_t dy = (uint8_t)(m4_y(m) - cat_y);

    if (m4_x(m) < cat_x)
        dx = ~dx;
    if (m4_y(m) < cat_y)
        dy = ~dy;
    return (uint16_t)(dx + dy) < limit;
}

/* ---------------------------------------------------------------------------
 *  원래: 4277  쥐 m 의 새 구멍 (다른 쥐와 겹치지 않게, 되도록 고양이에서 멀리)
 * ------------------------------------------------------------------------- */
static void pick_mouse_hole(int m)
{
    uint16_t r;
    int o;

    m4_tries = 0x20;
    for (;;) {
retry:
        r = random16() & 0x0F;
        for (o = 0; o < 4; o++)
            if (o != m && r == m4_hole(o))
                goto retry;
        m4_hole(m) = r;
        mouse_to_hole(m);
        if (m4_tries == 0 || !mouse4_near_cat(m, 0x32))
            return;
        m4_tries--;
    }
}

/* 원래: 4254  쥐 지우기 */
static void erase_mouse4(void)
{
    int m = m4_turn;

    if (m4_hidden(m) == 0)
        blit(m4_scr(m), m4_save(m), 0x0C02);
}

/* 원래: 4090 */
void reset_cheese_mice(void)
{
    int n, m;

    for (n = 4; n > 0; n--) {
        m = n - 1;
        m4_hidden(m) = 1;
        m4_caught(m) = 0;
        pick_mouse_hole(m);
        m4_timer(m) = (uint8_t)((random16() & 0x0F) + 0x14);
    }
    m4_turn = 0;
    mice4_left = 4;
}

/* ---------------------------------------------------------------------------
 *  원래: 40C2  쥐 움직이기 (틱마다 두 마리씩)
 * ------------------------------------------------------------------------- */
void move_cheese_mice(void)
{
    uint16_t t = (uint16_t)sys_ticks(), spr;
    int m;
    uint8_t a, add;

    if (t == m4_ticks)
        return;
    m = ++m4_turn;
    if (m > 2) {
        if (m < 4)
            goto go;
        m = 0;
        m4_turn = 0;
    }
    m4_ticks = t;
go:
    if (m4_caught(m))
        return;
    if (mouse4_touches_cat(m))
        goto touched;
    if (mouse4_touches_broom(m))
        return;
    if (m4_timer(m) == 0) {
        pick_mouse_hole(m);
        m4_timer(m) = (uint8_t)((random16() & 7) + 0x14);
    }
    m4_timer(m)--;
    if (!mouse4_touches_cat(m))
        goto move;

touched:
    if (m4_hidden(m) || m4_timer(m) >= 0x14)
        return;
    /* 잡았다 */
    restore_under_cat();
    erase_mouse4();
    m = m4_turn;
    m4_caught(m) = 1;
    save_under_cat();
    cat_standing = 0;
    if (--mice4_left == 0)
        room_cleared = 1;
    draw_sprite_and((uint16_t)(((uint8_t)(4 - mice4_left) << 2) + 0x51), MOUSE4_SPR,
                    SCRATCH, 0x0C02);
    start_effect(0x3E8, 0x2EE);
    return;

move:
    mouse_to_hole(m);
    if (mouse4_near_cat(m, m4_near(level)) && m4_timer(m) >= 2) {
        /* 고양이가 가까우면 숨는다 */
        a = 1;
        if (m4_timer(m) <= 0x11 || m4_timer(m) < 0x14) {
            if (m4_timer(m) > 0x11)
                a = 0;
            m4_timer(m) = a;
        }
    }
    a = m4_timer(m);
    if (a <= 1) {
        add = (m4_hole(m) < 3) ? 3 : 1;
        m4_y(m) += add;
        spr = (m4_timer(m) >= 1) ? MOUSE4_SPR + 0x60 : MOUSE4_SPR + 0x90;
    } else if (a < 0x12) {
        spr = DW(MOUSE4_WALK + (((a << 1) & 2)));
    } else {
        add = (m4_hole(m) < 3) ? 3 : 1;
        m4_y(m) += add;
        if (m4_timer(m) < 0x13)
            spr = MOUSE4_SPR + 0x60;
        else if (m4_timer(m) == 0x13)
            spr = MOUSE4_SPR + 0x90;
        else
            spr = 0;
    }
    m4_sprite = spr;
    m4_new_scr = screen_offset(m4_x(m), m4_y(m));
    erase_mouse4();
    m = m4_turn;
    if (mouse4_touches_broom(m))
        return;
    if (m4_sprite == 0) {
        m4_hidden(m) = 1;
        return;
    }
    m4_hidden(m) = 0;
    m4_scr(m) = m4_new_scr;
    ACTOR_BEGIN(5 + m);
    draw_sprite_and(m4_new_scr, m4_sprite, m4_save(m), 0x0C02);
    ACTOR_END(5 + m, m4_new_scr, m4_x(m), m4_sprite);
}
