/* ============================================================================
 *  broom.c  -  방 안의 빗자루와 발자국
 * ----------------------------------------------------------------------------
 *  원본 코드 3150..349B.
 *
 *  골목에서 온 고양이는 방바닥(y>=B4)을 걸으면 진흙 발자국을 남긴다
 *  (바닥 40칸, 칸마다 0..4 단계).  빗자루는 방을 돌아다니며 발자국을 쓸고,
 *  고양이에 닿으면 고양이를 창문 쪽으로 쓸어 낸다.
 *  빗자루는 OR 로 그린다.
 * ========================================================================== */
#include "allycat.h"

/* 원래: 3405 */
void reset_broom(void)
{
    int i;

    for (i = 0; i < 40; i++)
        footprint(i) = 0;
    footprint_col = 0xFF;
    broom_frame = 0;
    broom_x = 0;
    broom_y = 0xA0;
    broom_hidden = 1;
    broom_dx = 0;
    broom_dy = 0;
    broom_mood = (uint8_t)random16();
    broom_count = 0x6C;
}

/* 원래: 347F  발자국 그리기 (칸 col, 단계 n) */
static void draw_footprint(int col, uint8_t n)
{
    blit((uint16_t)(col * 2 + 0x1E00), (uint16_t)(n * 10 + FOOTPRINT_SPR), 0x0501);
}

/* ---------------------------------------------------------------------------
 *  원래: 3445  고양이가 바닥을 걸으면 발자국 (칸마다 4단계까지)
 * ------------------------------------------------------------------------- */
void make_footprint(void)
{
    uint16_t col;
    uint8_t n;

    if (cat_y < 0xB4 || cat_hdir == 0)
        return;
    col = (uint16_t)(cat_x + 0x0C) >> 3;
    if (col > 0x27 || col == footprint_col)
        return;
    footprint_col = col;
    n = footprint(col);
    if (n >= 4)
        return;
    footprint(col) = ++n;
    draw_footprint(col, n);
}

/* 원래: 33A0  빗자루 지우기 */
void erase_broom(void)
{
    if (broom_hidden == 0)
        blit(broom_scr, BROOM_SAVE, 0x1E02);
}

/* 원래: 3339  빗자루 그리기 (다음 그림으로) */
void draw_broom(void)
{
    uint16_t spr;

    for (;;) {
        spr = DW(BROOM_SPRITES + broom_frame);
        if (spr)
            break;
        broom_frame = 0;
    }
    broom_scr = broom_new_scr;
    broom_hidden = 0;
    draw_sprite_or(broom_new_scr, spr, BROOM_SAVE, 0x1E02);
}

/* ---------------------------------------------------------------------------
 *  원래: 33BA  빗자루가 고양이에 닿았나 (닿으면 1, 고양이를 튕긴다)
 * ------------------------------------------------------------------------- */
int broom_hits_cat(void)
{
    if (dog_has_cat)
        return 0;
    if (room == ROOM_DOGS && cat_drinking)
        return broom_near_drinking_cat();
    if (!rects_overlap(broom_x, 0x10, broom_y, 0x1E, cat_x, 0x18, cat_y, 0x0E))
        return 0;
    if (room == ROOM_MICE && hole_anim)
        return 1;
    bounce_cat();
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 3150  빗자루 움직이기 (방마다 정한 틱마다)
 *  발자국이 있는 칸으로 가서 쓸고, 없으면 기분(broom_mood)에 따라 헤매거나
 *  고양이 쪽으로 간다.  시간이 갈수록 고양이를 더 잘 쫓는다.
 * ------------------------------------------------------------------------- */
void move_broom(void)
{
    uint16_t t = (uint16_t)sys_ticks(), d, col, x;
    uint8_t a, b, r, y;

    if ((uint16_t)(t - broom_ticks) < broom_speed(room))
        return;
    broom_ticks = t;
    if (broom_hits_cat())
        return;
    if (dog_touches_broom())
        return;

    broom_count++;
    broom_mood ^= broom_count & (uint8_t)random16();

    if (broom_x >= cat_x) {
        d = (uint16_t)(broom_x - cat_x);
        broom_toward_x = 0xFF;
    } else {
        d = (uint16_t)~(uint16_t)(broom_x - cat_x);
        broom_toward_x = 1;
    }
    b = (uint8_t)(broom_y + 0x14);
    if (b >= cat_y) {
        b = (uint8_t)(b - cat_y);
        broom_toward_y = 0xFF;
    } else {
        b = (uint8_t)~(uint8_t)(b - cat_y);
        broom_toward_y = 1;
    }
    broom_dist = (uint8_t)((uint8_t)(d >> 2) + (b >> 1));

    col = broom_col;
    if (col >= 0x27) {
        col = 0x26;
        broom_col = col;
    }
    if (footprint(col) == 0) {
        broom_col--;
        d = (uint16_t)((uint16_t)sys_ticks() - room_start_ticks) >> 3;
        a = (broom_dist >= (uint8_t)d) ? broom_dist - (uint8_t)d : 0;
        if (a >= broom_mood) {
            broom_dy = 1;
            r = (uint8_t)random16();
            if (r != 0) {
                if (r > 7)
                    goto move;
                r = (r & 1) ? 1 : 0xFF;
            }
            broom_dx = r;
        } else if ((broom_mood & 0x2F) == 0) {
            broom_dx = (random16() & 1) ? 1 : 0xFF;
            broom_dy = (random16() & 1) ? 1 : 0xFF;
        } else if ((broom_mood & 7) == 0) {
            broom_dx = broom_toward_x;
            broom_dy = broom_toward_y;
        }
    } else {
        /* 발자국 칸으로 가서 바닥까지 내려와 쓴다 */
        broom_dy = 1;
        x = (uint16_t)(col << 3);
        if (broom_x != x) {
            broom_dx = (broom_x < x) ? 1 : 0xFF;
        } else {
            broom_dx = 0;
            if (broom_y == 0xA5) {
                broom_dy = 0;
                if (broom_frame == 6 || broom_frame == 0x12) {
                    blit(broom_scr, BROOM_SAVE, 0x1E02);
                    footprint(col)--;
                    draw_footprint(col, footprint(col));
                    broom_hidden = 1;
                }
            }
        }
    }

move:
    x = broom_x;
    y = broom_y;
    broom_old_x = x;
    broom_old_y = y;
    if (broom_dx == 1) {
        x += 8;
        if (x >= 0x131)
            x = 0x130;
    } else if (broom_dx != 0) {
        x = (x >= 8) ? x - 8 : 0;
    }
    x &= 0xFFF8;
    broom_x = x;
    if (broom_dy == 1) {
        y += 2;
        if (y >= 0xA6)
            y = 0xA5;
    } else if (broom_dy != 0) {
        y = (y >= 2) ? y - 2 : 0;
    }
    broom_y = y;
    broom_new_scr = screen_offset(x, y);
    if (broom_hits_cat() || dog_touches_broom()) {
        broom_dx = 0;
        broom_dy = 0;
        broom_x = broom_old_x;
        broom_y = broom_old_y;
        return;
    }
    erase_broom();
    broom_frame += 2;
    draw_broom();
}
