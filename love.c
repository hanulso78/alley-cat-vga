/* ============================================================================
 *  love.c  -  방 7: 사랑의 방
 * ----------------------------------------------------------------------------
 *  원본 코드 2E60..314E (층과 선물), 4C10..5051 (다른 고양이), 6100..62EA (화살).
 *
 *  7층짜리 방.  맨 위층의 암고양이(7번째 고양이)에게 가면 판을 깬다.
 *  층마다 18칸이 있고 구멍 난 칸으로는 떨어진다.  큐피드 화살이 날아와 칸을
 *  뚫거나 메우고, 고양이에 맞으면 고양이가 떨어진다.
 *  층마다 수컷 고양이가 오가며 고양이를 밀쳐 낸다.  골목에서 깬 방 수만큼
 *  선물이 바닥에 있는데, 선물을 들고(닿으면 집는다) 단추로 내려놓으면
 *  수컷 고양이가 선물에 닿아 잠깐 사라진다.
 * ========================================================================== */
#include "allycat.h"

/* 원래: 30E3  층 칸 그리기 (tile 0 = 막힘, 2 = 구멍) */
static void draw_floor_tile(uint8_t tile, uint16_t x, uint8_t y)
{
    blit(screen_offset(x, y), DW(FLOOR_TILE_SPRITES + tile), 0x0802);
}

/* ---------------------------------------------------------------------------
 *  원래: 300F  사랑의 방 그리기: 벽, 층 (맨 아래층은 막힘, 나머지는 난수), 선물
 * ------------------------------------------------------------------------- */
void draw_love_room(void)
{
    int n, i;
    uint16_t idx;
    uint8_t tile;

    draw_list(LOVE_ROOM_LIST, 0);
    floor_draw_y = 0xBF;
    floor_draw_i = 0;
    do {
        floor_draw_x = 0x20;
        do {
            tile = 0;
            if (floor_draw_y != 0xBF)
                tile = random16() & 2;
            draw_floor_tile(tile, floor_draw_x, floor_draw_y);
            idx = floor_draw_x >> 4;
            idx = (idx >= 2) ? idx - 2 : 0;
            if (idx >= 0x12)
                idx = 0x11;
            floor_hole(floor_row(floor_draw_i) + idx) = tile;
            floor_draw_x += 0x10;
        } while (floor_draw_x < 0x111);
        floor_draw_i++;
        floor_draw_y -= 0x18;
    } while (floor_draw_y >= 0x2F);

    gift_carried = 0xFFFF;
    gift_dropped = 0xFFFF;
    DW(GIFT_PRESENT) = 0;
    DW(GIFT_PRESENT + 2) = 0;
    DW(GIFT_PRESENT + 4) = 0;
    DW(GIFT_PRESENT + 6) = 0;
    n = rooms_won;
    if (n == 0) {
        n = 1;
        rooms_won = 1;
    }
    if (n > 8)
        n = 8;
    for (; n; n--) {
        i = n - 1;
        gift_present(i) = 1;
        gift_y(i) = 0xB0;
        gift_x(i) = gift_start_x(i);
        blit(screen_offset(gift_x(i), 0xB0), GIFT_SPR, 0x0F03);
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 30FA  사랑의 방에서 디딜 층 (구멍이 아니면 1)
 * ------------------------------------------------------------------------- */
int love_find_support(void)
{
    uint8_t y = (uint8_t)((cat_y - 5) & 0xF8);
    uint16_t idx;
    int f;

    for (f = 6; f >= 0; f--)
        if (y == floor_y(f))
            break;
    if (f < 0)
        return 0;
    idx = (uint16_t)(cat_x + 7) >> 4;
    idx = (idx >= 2) ? idx - 2 : 0;
    if (idx >= 0x12)
        idx = 0x11;
    if (floor_hole(floor_row(f) + idx))
        return 0;
    y += 5;
    cat_y = y;
    cat_foot_y = y + 0x32;
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 2F66  선물 집기 (닿으면, 들고 있지 않을 때).  들고 있으면 바탕이 파랗다
 * ------------------------------------------------------------------------- */
void love_gift_touch(void)
{
    uint16_t t = (uint16_t)sys_ticks();
    int n, g;

    if (t == gift_ticks)
        return;
    gift_ticks = t;
    if (gift_carried < 8)
        goto none;
    for (n = 8; n; n--) {
        g = n - 1;
        if (gift_present(g) == 0)
            continue;
        if (rects_overlap(gift_x(g), 0x18, gift_y(g), 0x0F, cat_x, 0x18, cat_y, 0x0E))
            goto touched;
    }
none:
    gift_dropped = 0xFFFF;
    return;

touched:
    if (g == gift_dropped)
        return;
    restore_under_cat();
    if (arrow_active)
        erase_arrow();
    gift_present(g) = 0;
    gift_carried = (uint16_t)g;
    blit(screen_offset(gift_x(g), gift_y(g)), GIFT_BG_SPR, 0x0F03);
    if (arrow_active)
        draw_arrow();
    draw_cat();
    bios_set_color(0, 1);
    start_effect(0x3E8, 0x349);
}

/* ---------------------------------------------------------------------------
 *  원래: 2E60  들고 있는 선물을 내려놓기 (단추).  가장 가까운 층에.
 * ------------------------------------------------------------------------- */
void love_gift_drop(void)
{
    int n, f, g;
    uint8_t dy;
    uint16_t x;

    if (gift_carried >= 8 || fire)
        return;
    gift_best_floor = 0xFFFF;
    gift_best_dy = 0xFF;
    for (n = 7; n; n--) {
        f = n - 1;
        dy = (uint8_t)(cat_y - floor_y(f));
        if (cat_y < floor_y(f))
            dy = ~dy;
        if (dy <= gift_best_dy) {
            gift_best_dy = dy;
            gift_best_floor = (uint16_t)f;
        }
    }
    if (gift_best_floor == 0xFFFF)
        gift_best_floor = 0;
    g = gift_carried;
    gift_y(g) = floor_y(gift_best_floor);
    gift_drop_y = gift_y(g);
    x = cat_x;
    if (x >= 0x108)
        x = 0x107;
    x &= 0x0FFC;
    gift_x(g) = x;
    gift_drop_x = x;
    for (n = 8; n; n--) {
        f = n - 1;
        if (f == gift_carried || gift_present(f) == 0)
            continue;
        if (rects_overlap(gift_x(f), 0x18, gift_y(f), 0x0F,
                          gift_drop_x, 0x18, gift_drop_y, 0x0F))
            return;                     /* 다른 선물 위에는 못 놓는다 */
    }
    restore_under_cat();
    if (arrow_active)
        erase_arrow();
    g = gift_carried;
    gift_dropped = (uint16_t)g;
    gift_present(g) = 1;
    blit(screen_offset(gift_x(g), gift_y(g)), GIFT_SPR, 0x0F03);
    gift_carried = 0xFFFF;
    bios_set_color(0, 0);
    suitors_check_gifts();
    if (arrow_active)
        draw_arrow();
    draw_cat();
    start_effect(0x3E8, 0x4A5);
}

/* ============================================================================
 *  수컷 고양이 7마리 (층마다 한 마리, 6번은 맨 위층의 암고양이)
 *  한 마리씩 SUITOR (12바이트) 로 불러와 움직이고 다시 저장한다.
 * ========================================================================== */

/* 원래: 4FBB, 4FCD */
static void save_suitor(int n)
{
    ds_copy(DW(SUITOR_RECORDS + 2 * n), SUITOR, 12);
}

static void load_suitor(int n)
{
    ds_copy(SUITOR, DW(SUITOR_RECORDS + 2 * n), 12);
}

/* 원래: 4FDF  OR 그리기 (3워드 x 12줄, 배경 저장 없음) */
static void draw_suitor_sprite(uint16_t dst, uint16_t src)
{
    draw_sprite_or(dst, src, 0, 0x0C03);
}

/* 원래: 5008  배경색(1)으로 지우기 */
static void clear_suitor_place(uint16_t dst)
{
    int rows;

    for (rows = 12; rows; rows--) {
        vram_fill_word(dst, 0x5555, 3);
        dst ^= 0x2000;
        if (!(dst & 0x2000))
            dst += 0x50;
    }
}

/* 원래: 4F4A */
static void erase_suitor(void)
{
    if (suitor_hidden == 0)
        clear_suitor_place(suitor_scr);
}

/* 원래: 4F10 */
static void draw_suitor(void)
{
    uint16_t spr = SUITOR_STAND_SPR, n;

    suitor_hidden = 0;
    if (suitor_dir != 0) {
        n = suitor_frame;
        if (suitor_stun)
            n = (uint16_t)((n & 0xFF00) | (uint8_t)((n & 2) + 0x0C));
        if (suitor_dir == 0xFF)
            n += 0x10;
        spr = DW(SUITOR_SPRITES + n);
    }
    suitor_scr = suitor_new_scr;
    ACTOR_BEGIN_KEY(0x30000u + suitor_turn);    /* 개선판: 수컷 고양이도 부드럽게 */
    draw_suitor_sprite(suitor_new_scr, spr);
    ACTOR_END(99, suitor_new_scr, suitor_x, spr);
}

/* 원래: 502D  화살이 이 고양이에 닿았나 */
static int arrow_hits_suitor(void)
{
    if (arrow_active == 0)
        return 0;
    return rects_overlap(arrow_x, 0x10, arrow_y, 0x08, suitor_x, 0x18, suitor_y, 0x0C);
}

/* ---------------------------------------------------------------------------
 *  원래: 4DD0  고양이를 만났나 (만나면 1)
 *  6번(암고양이)이면 방을 깬 것.  아니면 고양이를 튕겨 내고 잠깐 멍해진다.
 * ------------------------------------------------------------------------- */
static int suitor_meets_cat(void)
{
    if (!rects_overlap(cat_x, 0x18, cat_y, 0x0E, suitor_x, 0x18, suitor_y, 0x0C))
        return 0;
    if (suitor_turn == 6) {
        room_cleared = 1;
        restore_under_cat();
        erase_suitor();
        return 1;
    }
    restore_under_cat();
    erase_suitor();
    draw_cat();
    cat_jump_delay = 4;
    cat_vdir = 1;
    cat_vy = 4;
    cat_vy_rate = 8;
    suitor_stun = 4;
    suitor_dir = (suitor_x > cat_x) ? 1 : 0xFF;
    start_effect(0x0CE4, 0x123B);
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 4E75  이 고양이가 선물에 닿았나.  닿으면 선물은 없어지고 고양이는
 *  잠깐 사라진다 (암고양이는 바로 돌아온다).
 * ------------------------------------------------------------------------- */
static void suitor_hits_gift(void)
{
    int n, g;
    uint16_t t;

    for (n = 8; n; n--) {
        g = n - 1;
        if (gift_present(g) == 0)
            continue;
        if (rects_overlap(gift_x(g), 0x18, gift_y(g), 0x0F, suitor_x, 0x18, suitor_y, 0x0C))
            goto hit;
    }
    return;
hit:
    if (suitor_quiet == 0) {
        restore_under_cat();
        if (arrow_active)
            erase_arrow();
    }
    erase_suitor();
    gift_present(g) = 0;
    blit(screen_offset(gift_x(g), gift_y(g)), GIFT_BG_SPR, 0x0F03);
    if (suitor_quiet == 0) {
        if (arrow_active)
            draw_arrow();
        draw_cat();
    }
    t = 0;
    if (suitor_turn != 6) {
        t = (uint16_t)sys_ticks();
        if (t == 0)
            t--;
    }
    suitor_wait = t;
}

/* 원래: 4E3E  선물을 내려놓은 뒤 모든 고양이와 선물 확인 */
void suitors_check_gifts(void)
{
    uint16_t save;

    suitor_quiet = 1;
    save = suitor_turn;
    for (suitor_turn = 0; suitor_turn < 7; suitor_turn++) {
        load_suitor(suitor_turn);
        if (suitor_wait == 0) {
            suitor_hits_gift();
            save_suitor(suitor_turn);
        }
    }
    suitor_turn = save;
}

/* ---------------------------------------------------------------------------
 *  원래: 4F59  고양이들 놓기 (0번만 기다렸다 나온다)
 * ------------------------------------------------------------------------- */
void reset_suitors(void)
{
    uint16_t t;

    for (suitor_turn = 0; suitor_turn < 7; suitor_turn++) {
        suitor_x = (random16() & 0x7F) + 0x60;
        suitor_dir = 0;
        suitor_hidden = 1;
        suitor_frame = 0;
        suitor_stun = 0;
        t = 0;
        if (suitor_turn == 0) {
            t = (uint16_t)sys_ticks();
            if (t == 0)
                t--;
        }
        suitor_wait = t;
        suitor_y = (uint8_t)(floor_y(suitor_turn) + 3);
        save_suitor(suitor_turn);
    }
    suitor_turn = 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 4C10  고양이 움직이기 (틱마다, 7마리를 나눠서)
 * ------------------------------------------------------------------------- */
void move_suitors(void)
{
    uint16_t t = (uint16_t)sys_ticks(), x, lim, cx;
    int n;
    uint8_t d;

    if (t == suitor_ticks)
        return;
    n = ++suitor_turn;
    if (n == 1 || n == 4) {
        suitor_ticks = t;
    } else if (n >= 7) {
        n = 0;
        suitor_turn = 0;
        suitor_ticks = t;
    }
    load_suitor(n);
    if (arrow_hits_suitor())
        return;

    if (suitor_wait) {
        lim = suitor_wait_time(level);
        if (suitor_turn == 0)
            lim <<= 1;
        if ((uint16_t)((uint16_t)sys_ticks() - suitor_wait) < lim)
            return;
        suitor_wait = 0;
        suitor_hidden = 1;
        suitor_x = (cat_x <= 0xA0) ? 0x108 : 0x24;
        suitor_dir = 0;
    }
    if (suitor_meets_cat()) {
        save_suitor(suitor_turn);
        return;
    }

    if (suitor_stun) {
        if (--suitor_stun == 0)
            suitor_dir = (suitor_dir == 0xFF) ? 1 : 0xFF;
    } else if (suitor_y <= cat_y) {
        if (!(suitor_turn == 6 && cat_y < 0x28) &&
            (uint8_t)random16() > suitor_chase(level))
            goto move;
        d = 0;
        x = suitor_x & 0x0FF8;
        cx = cat_x & 0x0FF8;
        if (x != cx)
            d = (x < cx) ? 1 : 0xFF;
        suitor_dir = d;
        if (cat_y >= 0x28 && suitor_turn == 6)
            suitor_dir = (d == 0xFF) ? 1 : 0xFF;   /* 암고양이는 달아난다 */
    }

move:
    suitor_speed = suitor_stun ? 4 : 8;
    x = suitor_x;
    if (suitor_dir < 1) {
        d = (uint8_t)random16();
        if (d <= 0x10) {
            d &= 1;
            suitor_dir = d ? d : 0xFF;
        }
        goto place;
    }
    if (suitor_dir == 1) {
        x += suitor_speed;
        if (x >= 0x10B) {
            x = 0x10A;
            suitor_dir = 0xFF;
            suitor_stun = 0;
        }
    } else {
        if (x < suitor_speed || (x -= suitor_speed) <= 0x24) {
            x = 0x25;
            suitor_dir = 1;
            suitor_stun = 0;
        }
    }
    suitor_x = x;
    suitor_frame += 2;
    if (suitor_frame >= 0x0C)
        suitor_frame = 0;
    if (suitor_stun == 0 && (uint8_t)random16() <= 8)
        suitor_dir = 0;

place:
    suitor_new_scr = screen_offset(suitor_x, suitor_y);
    if (arrow_hits_suitor())
        return;
    if (!suitor_meets_cat()) {
        erase_suitor();
        draw_suitor();
        suitor_quiet = 0;
        suitor_hits_gift();
    }
    save_suitor(suitor_turn);
}

/* ============================================================================
 *  큐피드 화살
 * ========================================================================== */

/* 원래: 6100 */
void reset_arrow(void)
{
    arrow_active = 0;
}

/* 원래: 622B  화살 지우기 */
void erase_arrow(void)
{
    if (arrow_hidden == 0)
        blit(arrow_scr, ARROW_SAVE, 0x0802);
}

/* 원래: 61FA  화살 그리기 (날아갈수록 깃이 바뀐다) */
void draw_arrow(void)
{
    uint16_t spr = (uint16_t)((arrow_frame & 0x1E0) + ARROW_SPR);

    arrow_hidden = 0;
    if (arrow_dir != 0xFF)
        spr += 0xC0;
    arrow_scr = arrow_new_scr;
    draw_sprite(arrow_new_scr, spr, ARROW_SAVE, 0x0802);
}

/* 원래: 62A6  화살이 고양이에 맞았나 (맞으면 고양이가 떨어진다) */
static int arrow_hits_cat(void)
{
    if (arrow_active == 0)
        return 0;
    if (!rects_overlap(arrow_x, 0x10, arrow_y, 0x08, cat_x, 0x18, cat_y, 0x0E))
        return 0;
    cat_vdir = 1;
    cat_vy = 2;
    cat_vy_rate = 0x20;
    cat_jump_delay = 8;
    start_effect(0x091D, 0x0CE4);
    return 1;
}

/* 원래: 6245  화살이 지나는 층 칸을 뚫거나 메운다 (같은 칸은 한 번만) */
static void arrow_hits_floor(void)
{
    uint8_t y = (uint8_t)((arrow_y - 8) & 0xF8), tile;
    int f, col;
    uint16_t idx;

    for (f = 6; f >= 0; f--)
        if (y == floor_y(f))
            break;
    if (f < 0)
        return;
    col = arrow_x >> 4;
    if (col < 2 || col - 2 >= 0x10)
        return;
    col -= 2;
    idx = (uint16_t)(col + floor_row(f));
    if (idx == arrow_last_tile)
        return;
    arrow_last_tile = idx;
    floor_hole(idx) ^= 2;
    tile = floor_hole(idx);
    erase_arrow();
    draw_floor_tile(tile, DW(FLOOR_TILE_X + 2 * col), floor_tile_y(f));
    draw_arrow();
}

/* ---------------------------------------------------------------------------
 *  원래: 6106  화살 날리기.  없으면 새로 쏜다 - 위에서 대각선으로, 또는 옆에서.
 * ------------------------------------------------------------------------- */
void move_arrow(void)
{
    uint16_t t = (uint16_t)sys_ticks();
    uint8_t n;

    if (t == arrow_ticks)
        return;
    arrow_ticks = t;
    if (arrow_hits_cat()) {
        restore_under_cat();
        erase_arrow();
        draw_cat();
        arrow_active = 0;
        return;
    }
    if (arrow_active == 0) {
        for (;;) {
            n = (uint8_t)random16() & 0x1F;
            if (n < 0x10)
                break;
            n -= 0x10;
            if (n > 9)
                continue;
            arrow_dir = (n < 5) ? 1 : 0xFF;
            arrow_y = 6;
            arrow_x = arrow_top_x(n) + 4;
            goto shoot;
        }
        if (n & 8) {
            arrow_x = 0x120;
            arrow_dir = 0xFF;
        } else {
            arrow_x = 0x0C;
            arrow_dir = 1;
        }
        arrow_y = (uint8_t)(arrow_side_y(n & 7) + 8);
shoot:
        arrow_active = 1;
        arrow_hidden = 1;
        arrow_frame = 0;
        arrow_last_tile = 0xFFFF;
    }
    if (arrow_frame < 0xA0)
        arrow_frame += 4;
    arrow_y += 2;
    if (arrow_y > 0xBF)
        goto gone;
    if (arrow_dir != 1) {
        if (arrow_x < 5)
            goto gone_sub;
        arrow_x -= 5;
    } else {
        arrow_x += 5;
        if (arrow_x >= 0x12C)
            goto gone;
    }
    arrow_new_scr = screen_offset(arrow_x, arrow_y);
    if (arrow_hits_cat())
        goto gone;
    arrow_hits_floor();
    erase_arrow();
    draw_arrow();
    return;

gone_sub:
    arrow_x -= 5;
gone:
    arrow_active = 0;
    erase_arrow();
}
