/* ============================================================================
 *  spider.c  -  방 3: 책장과 거미
 * ----------------------------------------------------------------------------
 *  원본 코드 3B30..3E88.
 *
 *  책장 위쪽(y=18)에 물건 세 개가 있고 고양이가 닿으면 하나씩 없어진다.
 *  셋 다 없애면 방을 깬다.  천장의 거미는 고양이 위에 오면 줄을 타고 내려오고,
 *  고양이를 물면 "BYTE!" - 잡힌 것.  고양이는 책장 칸에 설 수 있다.
 * ========================================================================== */
#include "allycat.h"

/* 원래: 3B30 */
void reset_shelf_targets(void)
{
    shelf_targets_left = 3;
    shelf_target(0) = 1;
    shelf_target(1) = 1;
    shelf_target(2) = 1;
}

/* 원래: 3BA3  물건 하나 없애기 (배경색으로 덮는다) */
static void remove_shelf_target(int n)
{
    shelf_target(n) = 0;
    ds_fill_word(SCRATCH, 0xAAAA, 0x20);
    blit(shelf_target_scr(n), SCRATCH, 0x1002);
    if (--shelf_targets_left == 0 && cat_caught == 0)
        room_cleared = 1;
}

/* 원래: 3E38  거미 지우기 */
static void erase_spider(void)
{
    if (spider_hidden == 0)
        blit(spider_scr, SPIDER_SAVE, 0x0E03);
}

/* 원래: 3E14  거미 그리기 */
static void draw_spider(void)
{
    spider_scr = spider_new_scr;
    spider_hidden = 0;
    draw_sprite(spider_new_scr, (uint16_t)(spider_frame + SPIDER_SPR), SPIDER_SAVE, 0x0E03);
}

/* ---------------------------------------------------------------------------
 *  원래: 3B42  고양이가 책장 위 물건에 닿았나 (틱마다)
 * ------------------------------------------------------------------------- */
void touch_shelf_targets(void)
{
    uint16_t t = (uint16_t)sys_ticks();

    if (t == shelf_ticks)
        return;
    shelf_ticks = t;
    shelf_check = 4;
    for (;;) {
        if (DW(SHELF_TARGET + shelf_check) &&
            rects_overlap(DW(SHELF_TARGET_X + shelf_check), 0x10, 0x18, 0x10,
                          cat_x, 0x18, cat_y, 0x0E)) {
            start_effect(0x0C00, 0x08FD);
            restore_under_cat();
            erase_spider();
            remove_shelf_target(shelf_check / 2);
            save_under_cat();
            draw_spider();
            return;
        }
        if ((uint16_t)((shelf_check -= 2) + 2) < 2)
            return;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 3BDB  책장 그리기: 16줄 x 15칸 책 + 끝 조각.  책은 난수로 고른다.
 * ------------------------------------------------------------------------- */
void draw_bookshelf(void)
{
    int rows, col;
    uint8_t tile, r;

    shelf_row_scr = 0x066A;
    for (rows = 0x10; rows; rows--) {
        tile = 0;
        col = 0;
        for (;;) {
            shelf_tile = tile;
            blit((uint16_t)(shelf_row_scr + col), (uint16_t)(tile + BOOK_SPR), 0x0801);
            col += 2;
            if (col > 0x1E)
                break;
            if (col == 0x1E) {
                tile = 0x20;                    /* 칸 끝 */
                continue;
            }
            if (shelf_tile != 0x50 && !(rows & 1) && (uint8_t)random16() >= 0x40) {
                tile = 0x10;
                continue;
            }
            r = (uint8_t)random16();
            tile = (uint8_t)(((r - col) & 0x30) + 0x30);
        }
        shelf_row_scr += 0x140;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 3C43  책장 칸에 설 수 있나 (x 0A4..118, 칸 높이마다)
 * ------------------------------------------------------------------------- */
int spider_shelf_support(void)
{
    uint16_t x = cat_x & 0xFFFC;
    uint8_t y;

    if (x < 0xA4 || x > 0x118)
        return 0;
    y = (uint8_t)((cat_y - 2) & 0xF8);
    if (!(y & 8) || y < 0x28 || y > 0xA0)
        return 0;
    cat_x = x;
    y += 2;
    cat_y = y;
    cat_foot_y = y + 0x32;
    return 1;
}

/* 원래: 3C90 */
void reset_spider(void)
{
    spider_y = 8;
    spider_hidden = 1;
    spider_vdir = 0;
    spider_frame_delay = 2;
    spider_x = 0x118;
    spider_frame = 0;
}

/* 원래: 3E52, 3E6E */
static int spider_touches_broom(void)
{
    return rects_overlap(spider_x, 0x18, spider_y, 0x0E, broom_x, 0x10, broom_y, 0x1E);
}

static int spider_touches_cat(void)
{
    return rects_overlap(spider_x, 0x18, spider_y, 0x0E, cat_x, 0x18, cat_y, 0x0E);
}

/* ---------------------------------------------------------------------------
 *  원래: 3CB1  거미 움직이기 (2틱마다)
 *  천장(y=8)에서는 고양이 x 로 기어가고, 고양이 바로 위면 내려간다.
 *  고양이보다 내려갔거나 멀어지면 올라온다.
 * ------------------------------------------------------------------------- */
void move_spider(void)
{
    uint16_t t = (uint16_t)sys_ticks(), x, cx, d;
    uint8_t y, step;

    if ((uint16_t)(t - spider_ticks) < 2)
        return;
    spider_ticks = t;
    if (spider_touches_broom())
        return;
    if (spider_touches_cat())
        goto bite;

    spider_speed = spider_speeds(level);
    spider_old_x = spider_x;
    spider_old_y = spider_y;
    if (spider_y == 8) {
        x = spider_x & 0xFFF8;
        cx = cat_x & 0xFFF8;
        if (x == cx) {
            spider_vdir = 1;
            spider_climb = 1;
        } else {
            x = spider_x;
            if ((spider_x & 0xFFF8) < cx)
                x += spider_speed;
            else
                x = (x >= spider_speed) ? x - spider_speed : 0;
            spider_x = x;
            goto moved;
        }
    }
    y = spider_y;
    spider_climb++;
    step = (uint8_t)(((spider_climb >> 2) & 3) + 2);
    if (spider_vdir != 1) {
        if (y < step || (uint8_t)(y - step) < 9) {
            y = 8;
            spider_vdir = 0;
        } else {
            y -= step;
        }
    } else {
        y = (uint8_t)(y + step);
        if (y > cat_y)
            goto go_up;
        d = (spider_x >= cat_x) ? spider_x - cat_x : (uint16_t)~(uint16_t)(spider_x - cat_x);
        if (d > 0x30)
            goto go_up;
        if (y >= 0xA0) {
            y = 0x9F;
go_up:
            spider_vdir = 0xFF;
        }
    }
    spider_y = y;

moved:
    if (spider_touches_broom()) {
        spider_x = spider_old_x;
        spider_y = spider_old_y;
        return;
    }
    if (!spider_touches_cat()) {
        spider_new_scr = screen_offset(spider_x, spider_y);
        erase_spider();
        if (--spider_frame_delay == 0) {
            spider_frame_delay = 2;
            spider_frame ^= 0x54;
        }
        draw_spider();
        return;
    }

bite:
    if (room_cleared)
        return;
    x = (cat_x >= 0x0C) ? cat_x - 0x0C : 0;
    if (x >= 0x10F)
        x = 0x10E;
    y = (cat_y >= 4) ? cat_y - 4 : 0;
    draw_sprite(screen_offset(x, y), BYTE_SPR, SCRATCH, 0x1506);
    reset_bite_sound();
    spider_ticks = (uint16_t)sys_ticks();
    do {
        bite_sound();
    } while ((uint16_t)((uint16_t)sys_ticks() - spider_ticks) < 9);
    cat_caught = 1;
}
