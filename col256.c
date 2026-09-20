/* ============================================================================
 *  col256.c  -  개선판 256색: ALLEY256.SPR 읽기와 화면 합성 (도스/PC 공용)
 * ----------------------------------------------------------------------------
 *  ALLEY256.SPR (tools/mkspr256.py 가 만든다)
 *      0..7      "ALLEY256"
 *      8..775    팔레트 256색 x RGB (0..63).  16 번부터 새로 칠한 색
 *      776..823  CGA 16색을 대신할 색 16 x RGB (원래 CGA 색 그대로인 점에 쓴다)
 *      824..     데이터 세그먼트 점마다의 색 번호 (DS_IMAGE_SIZE x 4 바이트)
 *
 *  화면 합성: vram_col 의 색 번호가 0..3 이면 지금 CGA 팔레트(포트 3D9h)의
 *  네 색 중 하나 -> VGA 0..3 번에 그 색을 넣어 둔다.  16 이상은 그대로.
 * ========================================================================== */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "allycat.h"
#include "col256.h"

extern uint8_t ds_col[0x10000 * 4];
extern uint8_t vram_col[VRAM_SIZE * 4];

uint8_t pal256[256][3];
uint8_t cga_remaster[16][3] = {
    {0x00, 0x00, 0x00}, {0x00, 0x00, 0x2A}, {0x00, 0x2A, 0x00}, {0x00, 0x2A, 0x2A},
    {0x2A, 0x00, 0x00}, {0x2A, 0x00, 0x2A}, {0x2A, 0x15, 0x00}, {0x2A, 0x2A, 0x2A},
    {0x15, 0x15, 0x15}, {0x15, 0x15, 0x3F}, {0x15, 0x3F, 0x15}, {0x15, 0x3F, 0x3F},
    {0x3F, 0x15, 0x15}, {0x3F, 0x15, 0x3F}, {0x3F, 0x3F, 0x15}, {0x3F, 0x3F, 0x3F},
};

/* 원래 CGA 색 그대로 (파일이 없을 때) */
static void logical_colors(void)
{
    unsigned o;

    for (o = 0; o < 0x10000; o++) {
        uint8_t v = ds[o], *c = ds_col + o * 4;
        c[0] = v >> 6;
        c[1] = (v >> 4) & 3;
        c[2] = (v >> 2) & 3;
        c[3] = v & 3;
    }
    memset(vram_col, 0, sizeof vram_col);
}

tween_t tweens[MAX_TWEENS];
int tween_count;

const tween_t *tween_find(uint16_t from, uint16_t to)
{
    int i;
    for (i = 0; i < tween_count; i++)
        if (tweens[i].from == from && tweens[i].to == to)
            return &tweens[i];
    return NULL;
}

int col256_load(const char *fn)
{
    off_table_init();
    FILE *f = fopen(fn, "rb");
    char magic[8];
    int ok = 0;

    logical_colors();
    if (!f)
        return 0;
    if (fread(magic, 1, 8, f) == 8 && !memcmp(magic, "ALLEY256", 8) &&
        fread(pal256, 1, sizeof pal256, f) == sizeof pal256 &&
        fread(cga_remaster, 1, sizeof cga_remaster, f) == sizeof cga_remaster &&
        fread(ds_col, 1, DS_IMAGE_SIZE * 4, f) == DS_IMAGE_SIZE * 4)
        ok = 1;
    /* 덧붙임: 사이 동작 그림 "TWEN" (tools/tweens.py) */
    if (ok && fread(magic, 1, 4, f) == 4 && !memcmp(magic, "TWEN", 4)) {
        uint8_t n[2], hd[6];
        int i, cnt;
        if (fread(n, 1, 2, f) == 2) {
            cnt = n[0] | n[1] << 8;
            for (i = 0; i < cnt && tween_count < MAX_TWEENS; i++) {
                tween_t *t = &tweens[tween_count];
                if (fread(hd, 1, 6, f) != 6)
                    break;
                t->from = (uint16_t)(hd[0] | hd[1] << 8);
                t->to = (uint16_t)(hd[2] | hd[3] << 8);
                t->w = hd[4];
                t->h = hd[5];
                t->pix = malloc((size_t)t->w * t->h);
                if (!t->pix || fread(t->pix, 1, (size_t)t->w * t->h, f) != (size_t)t->w * t->h)
                    break;
                tween_count++;
            }
        }
    }
    fclose(f);
    if (!ok)
        logical_colors();
    return ok;
}

/* 지금 CGA 팔레트의 네 색 -> 팔레트 0..3 */
void col256_update_cga(void)
{
    uint8_t sel = cga_color_select;
    int hi = (sel & 0x10) ? 8 : 0, c[4], i;

    c[0] = sel & 0x0F;
    c[1] = ((sel & 0x20) ? 3 : 2) + hi;
    c[2] = ((sel & 0x20) ? 5 : 4) + hi;
    c[3] = ((sel & 0x20) ? 7 : 6) + hi;
    for (i = 0; i < 4; i++)
        memcpy(pal256[i], cga_remaster[c[i]], 3);
}

/* ---------------------------------------------------------------------------
 *  원래 CGA 색 그대로인 점(0..3)은 지금 보이는 방(theme_room)의 색 테마로 칠한다.
 *  테마는 팔레트 16 + 방*16 + 띠*4 + 색 (띠 = 화면 높이를 넷으로 나눈 것).
 *  바탕색을 바꿔 깜빡이는 동안(포트 3D9h 아래 4비트가 0 이 아님)의 색 0 은
 *  CGA 색 그대로 둔다.
 * ------------------------------------------------------------------------- */
int theme_room;
short col256_lx[200], col256_rx[200];   /* 마지막으로 칠한 줄 구간 */

static const signed char bayer[4][4] = {
    { 0, 8, 2, 10 }, { 12, 4, 14, 6 }, { 3, 11, 1, 9 }, { 15, 7, 13, 5 }
};

/* ---------------------------------------------------------------------------
 *  테마 색 표: 줄(y)과 위상(x&3)마다 원래 CGA 색 0..3 을 어떤 팔레트 번호로 칠할지.
 *  그릴 때(gfx.c) 바로 이 번호를 색판에 적는다.  그래서 화면을 합칠 때는 복사만 한다.
 * ------------------------------------------------------------------------- */
uint8_t theme_tab[200][16];

static void theme_build(void)
{
    uint8_t map[4][4];
    int band, v, y, k, yy;

    for (band = 0; band < 4; band++)
        for (v = 0; v < 4; v++)
            map[band][v] = (uint8_t)(16 + ((theme_room & 7) << 4) + (band << 2) + v);
    if (cga_color_select & 0x0F)
        for (band = 0; band < 4; band++)
            map[band][0] = 0;           /* 바탕색을 바꿔 깜빡이는 동안은 CGA 색 그대로 */
    for (y = 0; y < 200; y++)
        for (k = 0; k < 4; k++) {
            /* 띠 경계는 16줄에 걸쳐 4x4 순서 디더로 섞는다 */
            yy = y + bayer[y & 3][k] - 8;
            band = yy < 0 ? 0 : yy >= 150 ? 3 : yy / 50;
            for (v = 0; v < 4; v++)
                theme_tab[y][k * 4 + v] = map[band][v];
        }
}

/* 방(색 테마)이나 바탕색이 바뀌었다: 화면에 이미 칠해 둔 테마 색을 다시 계산한다.
   그림에서 온 색(144 이상)은 그대로 둔다. */
void col256_theme_refresh(void)
{
    unsigned o;

    theme_build();
    for (o = 0; o < VRAM_SIZE; o++) {
        uint8_t *c = vram_col + o * 4, b = vram[o];
        int y = off_row[o & 0x1FFF] + ((o & 0x2000) ? 1 : 0), k;

        if (y >= 200)
            continue;
        for (k = 0; k < 4; k++)
            if (c[k] < COL_SPRITE)
                c[k] = theme_tab[y][k * 4 + ((b >> (6 - 2 * k)) & 3)];
    }
    vram_dirty_all();
}

void col256_compose(uint8_t *frame)
{
    extern double actor_clock;
    void actor_compose(uint8_t *frame, double now);

    static uint8_t *last_frame;
    static int last_theme = -1, last_sel = -1;
    int y, x0, x1;

    /* 다시 칠할 곳: 게임이 바꾼 줄 구간 + 배우가 있던/있을 자리 */
    actor_prepare(actor_clock);
    if (theme_room != last_theme || (int)cga_color_select != last_sel) {
        last_theme = theme_room;
        last_sel = cga_color_select;
        col256_theme_refresh();
    }
    if (frame != last_frame) {
        last_frame = frame;
        vram_dirty_all();
    }
    for (y = 0; y < 200; y++) {
        x0 = dirty_lx[y];
        x1 = dirty_rx[y];
        col256_lx[y] = (short)x0;
        col256_rx[y] = (short)x1;
        if (x1 >= x0)
            memcpy(frame + y * 320 + x0,
                   vram_col + (((y >> 1) * 80 + ((y & 1) ? 0x2000 : 0)) * 4) + x0,
                   (size_t)(x1 - x0 + 1));
    }
    vram_dirty_clear();
    actor_compose(frame, actor_clock);         /* 고양이와 불독 (actor.c) */
}

/* 팔레트에서 가장 가까운 색 (0..63 성분, 테마 색 0..15 는 빼고) */
uint8_t col256_nearest(int r, int g, int b)
{
    int i, best = COL_SPRITE, bd = 1 << 30;

    for (i = COL_SPRITE; i < 256; i++) {
        int d = (pal256[i][0] - r) * (pal256[i][0] - r) + (pal256[i][1] - g) * (pal256[i][1] - g) +
                (pal256[i][2] - b) * (pal256[i][2] - b);
        if (d < bd) {
            bd = d;
            best = i;
        }
    }
    return (uint8_t)best;
}
