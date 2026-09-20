/* ============================================================================
 *  clothes.c  -  골목의 빨랫줄 세 가닥
 * ----------------------------------------------------------------------------
 *  원본 코드 04A0..06FF, 17AD..1829, 2A80..2B23.
 *
 *  빨랫줄은 화면 위쪽에 세 줄(행 y=08, 28, 48 근처) 있고, 한 번에 한 줄만
 *  옆으로 한 바이트(4점)씩 흘러간다.  0, 2번 줄은 오른쪽으로, 1번 줄은 왼쪽으로.
 *  빨래 조각은 4바이트 x 16줄짜리 그림(데이터 세그먼트 04D7)을 만들어 두고
 *  들어오는 가장자리에 한 바이트 열씩 그려 넣는다.
 *
 *  고양이가 빨래를 딛고 설 수 있도록 줄마다 40비트(5바이트)짜리 지도를
 *  가진다 (line_bits, 원래 1016).  빨래 조각 하나 = 2비트 (왼쪽 반, 오른쪽 반).
 *  줄이 흐르면 이 지도도 한 비트씩 밀어 넣는다 (원본은 CF 를 rcr/rcl 로 흘렸다).
 *  고양이가 서 있는 줄이 흐르면 고양이도 같이 실려 간다.
 * ========================================================================== */
#include "allycat.h"

/* ---------------------------------------------------------------------------
 *  원래: 0658  이 줄을 흘려도 되나
 *  고양이 발이 줄 높이에 없으면 된다.  줄 높이에 있으면 줄에 서 있을 때만
 *  되고, 그때는 cat_on_line 을 켜서 고양이도 같이 옮긴다.
 *  (원본은 ZF 로 돌려주었다: 1 = ZF)
 * ------------------------------------------------------------------------- */
static int line_can_scroll(int line)
{
    cat_on_line = 0;
    if (cat_foot_y < line_foot_min(line) || cat_foot_y >= line_foot_max(line))
        return 1;
    if (cat_standing < 1)
        return 0;
    cat_on_line = 1;
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 0633  빨래 비트 하나를 줄 지도에 밀어 넣기 (bit = 원본의 CF)
 *  오른쪽으로 흐르는 줄(0, 2)은 앞 바이트의 윗비트로, 왼쪽으로 흐르는
 *  줄(1)은 뒷 바이트의 아랫비트로 넣어서 5바이트를 한 칸씩 민다.
 * ------------------------------------------------------------------------- */
static void push_line_bit(int bit)
{
    int i = line_bits_insert(active_line), n;
    uint8_t v;

    if (i == 9) {
        for (n = 0; n < 5; n++, i--) {
            v = line_bits(i);
            line_bits(i) = (uint8_t)((v << 1) | bit);
            bit = v >> 7;
        }
    } else {
        for (n = 0; n < 5; n++, i++) {
            v = line_bits(i);
            line_bits(i) = (uint8_t)((v >> 1) | (bit << 7));
            bit = v & 1;
        }
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 06DE  빨래 조각 한쪽 반 (1워드 x 8줄, 한 줄 걸러) - 없으면 0
 * ------------------------------------------------------------------------- */
static uint8_t make_half_item(uint16_t dst)
{
    uint16_t r = random16() & 6, src;
    int n;

    if ((uint8_t)r == 6)
        return 0;
    src = clothes_item_sprite(r / 2);
    for (n = 0; n < 8; n++) {
        ds_copy(dst, src, 2);
        src += 2;
        dst += 4;
    }
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 067D  빨래 조각 하나 만들기 -> CLOTHES_PIECE (2워드 x 16줄)
 *      chance   난이도별 문턱 (원래 bl)   rate  줄별 문턱 (원래 bh)
 *  빈 배경에 줄(4444)만 긋고, 난수가 문턱을 넘으면 빨래를 건다.
 *  piece_bits = 걸린 빨래 (비트1 왼쪽 반, 비트0 오른쪽 반)
 * ------------------------------------------------------------------------- */
static void make_clothes_piece(uint8_t chance, uint8_t rate)
{
    uint16_t dst = CLOTHES_PIECE, r;

    piece_bits = 0;
    ds_fill_word(dst, 0xAAAA, 0x20);
    ds_fill_word(dst + 4, 0x4444, 2);                   /* 줄 */
    r = random16();
    if ((uint8_t)r < chance || (uint8_t)(r >> 8) <= rate)
        return;
    r = random16();
    if ((uint8_t)r < 0x18) {
        ds_copy(dst, CLOTHES_BIG_SPR, 0x40);            /* 큰 빨래 (이불) */
        piece_bits = 3;
    } else if ((uint8_t)r < 0x60) {
        ds_copy(dst, CLOTHES_TOP_SPR, 0x20);            /* 윗부분만 넓은 빨래 */
        piece_bits = 3;
    } else {
        piece_bits = (uint8_t)(make_half_item(dst) << 1);
        piece_bits |= make_half_item(dst + 2);
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 04A0  빨랫줄 흘리기 (골목 고리에서 매번)
 * ------------------------------------------------------------------------- */
void scroll_clotheslines(void)
{
    uint16_t t, x, src, dst, col;
    int line, rows;
    uint8_t d;

    if (--line_scroll_delay)
        return;
    line_scroll_delay++;
    if (sys_in_retrace())
        return;
    if (cat_knocked_down || thrown_y)
        return;
    t = (uint16_t)sys_ticks();
    if (t == line_scroll_ticks)
        return;
    line_scroll_ticks = t;

    d = line_scroll_speed(level);
    if (cat_y <= 0x60)
        d >>= 2;                        /* 고양이가 위에 있으면 빨리 */
    line_scroll_delay = d;

    line = active_line;
    if (!line_can_scroll(line)) {
        /* 고양이가 줄에 걸쳐 있어 못 흘린다: 조각 경계면 다른 줄로 */
        if ((uint8_t)(line_column + line_column_step(line)) < 4)
            return;
        do {
            line = random16() & 3;
        } while (line == (active_line & 0xFF) || line == 3);
        goto new_line;
    }

    line_column += line_column_step(line);
    if (line_column < 4)
        goto scroll;
    /* 조각 하나를 다 넣었다: 새 조각 (가끔 다른 줄로 바꾼다) */
    if ((uint8_t)random16() > 0x40)
        goto new_piece;
    do {
        do {
            line = random16() & 3;
        } while (line == 3);
    } while (!line_can_scroll(line));

new_line:
    active_line = line;
new_piece:
    line_column = line_column_start(line);
    make_clothes_piece(clothes_rate(level), line_clothes_chance(line));
    if (active_line != 1) {
        /* 오른쪽 반 먼저 넣어서 왼쪽 반이 앞으로 */
        push_line_bit(piece_bits & 1);
        piece_bits >>= 1;
        push_line_bit(piece_bits & 1);
        piece_bits >>= 1;
    } else {
        push_line_bit((piece_bits >> 1) & 1);
        push_line_bit(piece_bits & 1);
        piece_bits >>= 1;
    }
    line = active_line;

scroll:
    if (cat_on_line) {
        /* 고양이도 줄과 같이 */
        x = cat_x;
        if ((uint8_t)line == 1) {
            cat_scr--;
            if (x < 4 || (x -= 4) < 8)
                goto fall_off;
        } else {
            cat_scr++;
            x += 4;
            if (x >= 0x123)
                goto fall_off;
        }
        cat_x = x;
        goto move;
fall_off:
        cat_jump_delay = 0x11;
        cat_vdir = 1;
        cat_vy = 1;
        cat_vy_rate = 0x18;
        cat_speed_x = (cat_speed_x & 0xFF00) | 1;
        cat_standing = 0;
    }
move:
    line_entry = line_entry_offset(line);
    src = line_scroll_start(line);
    if (line == 1) {
        vram_move(src - 1, src, 0x27F, +1);
        vram_move(src + 0x2000 - 1, src + 0x2000, 0x280, +1);
        ACTOR_LINE_SCROLL(line, src, -1);       /* 개선판: 줄 띠를 1점씩 이어서 */
    } else {
        vram_move(src + 1, src, 0x27F, -1);
        vram_move(src + 0x2000 + 1, src + 0x2000, 0x280, -1);
        ACTOR_LINE_SCROLL(line, src - 0x27E, +1);  /* 띠의 첫 바이트 (src 는 끝 바이트) */
    }
    /* 개선판: 줄을 탄 고양이는 옮겨진 자리로 모양을 다시 뜬다 (다른 줄이면 그대로) */
    ACTOR_END(0, cat_scr, cat_x, cat_sprite);
    /* 들어오는 가장자리에 조각의 한 열 */
    dst = line_entry;
    col = CLOTHES_PIECE + line_column;
    for (rows = 0; rows < 16; rows++) {
        vram_put(dst, col, 1);
        col += 4;
        dst ^= 0x2000;
        if (!(dst & 0x2000))
            dst += 0x50;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 2AC6  줄 하나를 빨래 조각 20개로 채우기 (골목을 새로 그릴 때)
 * ------------------------------------------------------------------------- */
static void fill_line(uint16_t dst, uint8_t rate, int bits_base)
{
    int k;

    for (alley_count = 0; alley_count < 20; alley_count++) {
        k = alley_count;
        make_clothes_piece(clothes_rate(level), rate);
        blit(dst, CLOTHES_PIECE, 0x1002);
        line_bits(bits_base + (k >> 2)) |= (uint8_t)(piece_bits << ((~k & 3) * 2));
        dst += 4;
    }
}

/* 원래: 2A80  빨랫줄 세 가닥 새로 채우기 */
void reset_clotheslines(void)
{
    int i;

    for (i = 15; i > 0; i--)
        line_bits(i - 1) = 0;
    fill_line(0x140, 0x80, 0);
    fill_line(0x640, 0x30, 5);
    fill_line(0xB40, 0x00, 10);
    line_column = 0x10;
    active_line = 0;
    line_scroll_delay = 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 17AD  떨어지는 고양이가 빨래를 딛나 (디디면 1)
 *  고양이 발 높이가 줄 높이(08, 28, 48)일 때 x 위치의 비트를 본다.
 *  지금 흐르는 줄이면 들어오다 만 조각 몫만큼 x 를 보정한다.
 * ------------------------------------------------------------------------- */
int cat_land_on_line(void)
{
    uint8_t y = cat_y & 0xF8;
    uint16_t x, idx;
    int line;

    if (y == 0x08)
        line = 0;
    else if (y == 0x28)
        line = 1;
    else if (y == 0x48)
        line = 2;
    else
        return 0;

    x = cat_x;
    if (line == active_line && line_column <= 3) {
        if (line == 1)
            x -= (uint16_t)((line_column + 1) * 4);
        else
            x += (uint16_t)((4 - line_column) * 4);
    }
    idx = (uint16_t)(x + 10) >> 3;
    if (!(line_bits(line_bits_base(line) + (idx >> 3)) & (0x80 >> (idx & 7))))
        return 0;

    cat_y = y;
    cat_foot_y = y + 0x32;
    cat_x &= 0xFFF8;
    cat_standing = 1;
    return 1;
}
