/* ============================================================================
 *  gfx.c  -  그리기 기본 함수, 난수, 사각형 충돌
 * ----------------------------------------------------------------------------
 *  원본 코드 세그먼트 2B24..2E50.
 *
 *  원본은 CGA 화면 메모리(B800:0000)에 바로 그렸다.  320x200 4색, 한 바이트에
 *  점 4개(2비트씩).  짝수 줄은 0000부터, 홀수 줄은 2000부터 한 줄에 80바이트.
 *  그림(스프라이트)은 2바이트("워드") 단위라 한 워드가 점 8개다.
 *  크기는 늘 "cx" 한 값으로 넘겼다 - 아랫바이트(cl)가 한 줄의 워드(또는 바이트)
 *  수, 윗바이트(ch)가 줄 수.
 *
 *  이 판에서는 화면 메모리를 vram[] 로, 데이터 세그먼트를 ds[] 로 두고 원본과
 *  똑같이 그린다.  화면이나 데이터 세그먼트의 그림을 바꾸는 일은 모두 이 파일의
 *  함수만 한다 (256색판이 그림마다 색을 따라가게 하려고).
 * ========================================================================== */
#include <string.h>
#include "allycat.h"
#ifdef CATVGA
#include "col256.h"
#endif

uint8_t vram[VRAM_SIZE];
int vram_dirty;
#ifdef CATVGA
/* 개선판: 바뀐 곳만 다시 칠하려고 줄마다 바뀐 구간(왼쪽, 오른쪽)을 적어 둔다
   (col256.c 가 읽어서 그만큼만 칠하고, vid256.c 가 그만큼만 화면에 옮긴다) */
short dirty_lx[200], dirty_rx[200];
#endif
unsigned long cpu_clocks;

/* ============================================================================
 *  바이트 단위 기본 동작.  화면 위치는 16K 로 돌린다 (CGA 는 16K 가 되풀이된다).
 *
 *  개선판(CATVGA)은 데이터 세그먼트와 화면 메모리의 점마다 색 번호를 하나씩 더
 *  가진다 (ds_col, vram_col - 바이트마다 4개).  0..3 은 "원래 CGA 색 그대로"
 *  이고, 16 이상은 ALLEY256.SPR 에서 그림마다 새로 칠한 색이다.  그림을
 *  옮기면 색도 같이 옮기고, 새로 계산한 점(AND/OR 등)은 결과가 그림에서 왔으면
 *  그림의 색을, 아니면 원래 CGA 색을 쓴다.
 * ========================================================================== */
#define V(o) ((o) & (VRAM_SIZE - 1))

#ifdef CATVGA
/* 화면 메모리 위치 -> 점 좌표 표 (나눗셈을 안 하려고).  느린 486 에서 그리기마다
   나눗셈을 하면 게임이 8088 속도를 못 따라간다. */
short off_row[0x2000], off_col[0x2000];

void off_table_init(void)
{
    int i;

    if (off_row[1])
        return;
    for (i = 0; i < 0x2000; i++) {
        off_row[i] = (short)((i / 80) * 2);
        off_col[i] = (short)((i % 80) * 4);
    }
}

/* 한 줄의 x0..x1 이 바뀌었다 */
void vram_dirty_span(int y, int x0, int x1)
{
    if (y < 0 || y >= 200)
        return;
    if (x0 < 0) x0 = 0;
    if (x1 > 319) x1 = 319;
    if (x1 < x0)
        return;
    if (dirty_rx[y] < dirty_lx[y]) {
        dirty_lx[y] = (short)x0;
        dirty_rx[y] = (short)x1;
    } else {
        if (x0 < dirty_lx[y]) dirty_lx[y] = (short)x0;
        if (x1 > dirty_rx[y]) dirty_rx[y] = (short)x1;
    }
    vram_dirty = 1;
}

/* 화면 한 바이트(점 4개) */
static void mark(uint16_t off)
{
    unsigned o = off & (VRAM_SIZE - 1);
    int y = off_row[o & 0x1FFF] + ((o & 0x2000) ? 1 : 0), x = off_col[o & 0x1FFF];

    vram_dirty_span(y, x, x + 3);
}

/* 이어진 여러 바이트 (줄을 넘어가면 줄마다 나눠서) */
static void mark_range(uint16_t off, int n)
{
    while (n > 0) {
        unsigned o = off & (VRAM_SIZE - 1);
        int y = off_row[o & 0x1FFF] + ((o & 0x2000) ? 1 : 0);
        int col = off_col[o & 0x1FFF] >> 2, take = 80 - col;

        if (take > n)
            take = n;
        vram_dirty_span(y, col * 4, (col + take) * 4 - 1);
        off = (uint16_t)(off + take);
        n -= take;
    }
}

void vram_dirty_all(void)
{
    int y;

    for (y = 0; y < 200; y++) {
        dirty_lx[y] = 0;
        dirty_rx[y] = 319;
    }
    vram_dirty = 1;
}

void vram_dirty_clear(void)
{
    int y;

    for (y = 0; y < 200; y++) {
        dirty_lx[y] = 320;
        dirty_rx[y] = -1;
    }
}
#else
#define mark(off)               ((void)(off))
#define mark_range(off, n)      ((void)(off), (void)(n))
#endif
#ifdef CATVGA
uint8_t ds_col[0x10000 * 4];
uint8_t vram_col[VRAM_SIZE * 4];
#define DSC(o)  (ds_col + (unsigned)(uint16_t)(o) * 4)
#define VC(o)   (vram_col + (unsigned)V(o) * 4)
#define PIX(b, k)   (((b) >> (6 - 2 * (k))) & 3)

/* 화면(vram_col)에는 마지막 팔레트 번호를 바로 적는다 (합칠 때 복사만 하려고).
   원래 CGA 색 0..3 은 그 자리(줄, 위상)의 방 색 테마 번호로 바꾼다. */
static uint8_t th(uint16_t off, int k, uint8_t v)
{
    unsigned o = V(off);
    int y = off_row[o & 0x1FFF] + ((o & 0x2000) ? 1 : 0);

    if (y >= 200)
        y = 199;
    return theme_tab[y][k * 4 + (v & 3)];
}

/* 그림/데이터에서 온 색을 화면 색으로 (16 이상은 새로 칠한 색 그대로) */
static uint8_t th_of(uint16_t off, int k, uint8_t c)
{
    return c < 4 ? th(off, k, c) : c;
}

#ifdef CAT_DEBUG_PIX
#include <stdio.h>
#include <stdlib.h>
/* 검수용: 한 점에 색을 쓰는 곳을 모두 적는다 (환경변수 DBGPIX="x y") */
static int dbg_x = -1, dbg_y = -1;
extern double actor_clock;
static void dbg_note(const char *fn, uint16_t off, int k, int val)
{
    unsigned o = V(off);
    int y, x;
    if (dbg_x < 0) {
        const char *e = getenv("DBGPIX");
        if (!e || sscanf(e, "%d %d", &dbg_x, &dbg_y) != 2)
            dbg_x = dbg_y = -2;
    }
    if (dbg_x < 0)
        return;
    y = off_row[o & 0x1FFF] + ((o & 0x2000) ? 1 : 0);
    x = off_col[o & 0x1FFF] + k;
    if (x == dbg_x && y == dbg_y)
        fprintf(stderr, "%.3f %s val=%d vram=%02x\n", actor_clock / 1e6, fn, val, vram[o]);
}
#define DBG(fn, off, k, val)    dbg_note(fn, off, k, val)
#else
#define DBG(fn, off, k, val)    ((void)0)
#endif

/* 화면의 색을 데이터 세그먼트에 담아 둘 때: 테마 색은 원래 CGA 값(0..3)으로 되돌려
   담는다.  그래야 다른 자리에 되돌려 그려도 그 자리의 테마 색으로 칠해진다. */
static void save_colors(uint16_t save, uint16_t dst)
{
    uint8_t *d = DSC(save), *v = VC(dst), b = vram[V(dst)];
    int k;

    for (k = 0; k < 4; k++)
        d[k] = v[k] < COL_SPRITE ? (uint8_t)((b >> (6 - 2 * k)) & 3) : v[k];
}

/* 화면 한 바이트의 네 점을 원래 CGA 값 v 로 */
static void set_screen(uint16_t off, uint8_t v)
{
    uint8_t *c = VC(off);
    int k;

    for (k = 0; k < 4; k++) {
        c[k] = th(off, k, (uint8_t)((v >> (6 - 2 * k)) & 3));
        DBG("set_screen", off, k, v);
    }
}

static void set_logical(uint8_t *c, uint8_t v)
{
    c[0] = v >> 6;
    c[1] = (v >> 4) & 3;
    c[2] = (v >> 2) & 3;
    c[3] = v & 3;
}

/* 그림의 색이 새로 칠한 색이면 그 색, 원래 색이면 결과 점의 원래 색.
   색 번호 4 는 "투명": 그 점은 칠하지 않는다 (COL_CLEAR) */
#define COL_CLEAR   4
static uint8_t pick(uint8_t src_color, uint8_t result)
{
    return src_color > COL_CLEAR ? src_color : result;
}
#endif

/* 데이터 세그먼트 src 에서 n 바이트를 화면 dst 로 */
void vram_put(uint16_t dst, uint16_t src, int n)
{
    uint16_t dst0 = dst;
    int n0 = n;

    CPU(n * 9);
    while (n--) {
#ifdef CATVGA
        if (actor_capture >= 0) {
            /* 배우(고양이/개)를 그리는 중: 칠한 색 점은 배우 층으로 (actor.c) */
            int k;
            for (k = 0; k < 4; k++) {
                uint8_t c = DSC(src)[k];
                if (c > COL_CLEAR)
                    actor_set(dst, k, c);
                /* 원래 색인 점(그림의 바탕)은 칠하지 않는다 - 배경이 비친다 */
            }
        } else {
            int k;
            actor_touch(dst);
            for (k = 0; k < 4; k++)
                if (DSC(src)[k] != COL_CLEAR) {
                    VC(dst)[k] = th_of(dst, k, DSC(src)[k]);
                    DBG("vram_put", dst, k, DSC(src)[k]);
                }
        }
#endif
        vram[V(dst++)] = ds[src++];
    }
    mark_range(dst0, n0);
}

/* 화면 src 에서 n 바이트를 데이터 세그먼트 dst 로 */
void vram_get(uint16_t dst, uint16_t src, int n)
{
    CPU(n * 9);
    while (n--) {
#ifdef CATVGA
        save_colors(dst, src);
#endif
        ds[dst++] = vram[V(src++)];
    }
}

/* 데이터 세그먼트 안에서 복사 (앞에서부터 한 바이트씩 - rep movsb 와 같다) */
void ds_copy(uint16_t dst, uint16_t src, int n)
{
    CPU(n * 9);
    while (n--) {
#ifdef CATVGA
        memcpy(DSC(dst), DSC(src), 4);
#endif
        ds[dst++] = ds[src++];
    }
}

/* 데이터 세그먼트에 같은 워드를 n 번 (rep stosw) */
void ds_fill_word(uint16_t dst, uint16_t value, int n)
{
    CPU(9 + n * 10);
    while (n--) {
#ifdef CATVGA
        set_logical(DSC(dst), (uint8_t)value);
        set_logical(DSC(dst + 1), (uint8_t)(value >> 8));
#endif
        ds[dst++] = (uint8_t)value;
        ds[dst++] = (uint8_t)(value >> 8);
    }
}

/* 데이터 세그먼트의 워드들을 mask 와 AND 해서 dst 로 (lodsw / and / stosw) */
void ds_and_words(uint16_t dst, uint16_t src, uint16_t mask, int n)
{
    int b;
    uint8_t m, r;

    CPU(n * 45);
    for (n *= 2, b = 0; b < n; b++) {
        m = (uint8_t)(mask >> (8 * (b & 1)));
        r = ds[src] & m;
#ifdef CATVGA
        {
            uint8_t *d = DSC(dst), *sc = DSC(src);
            int k;
            for (k = 0; k < 4; k++)
                d[k] = (PIX(r, k) == PIX(ds[src], k)) ? pick(sc[k], PIX(r, k)) : PIX(r, k);
        }
#endif
        ds[dst++] = r;
        src++;
    }
}

/* 화면 한 바이트 */
void vram_set(uint16_t dst, uint8_t value)
{
    CPU(10);
#ifdef CATVGA
    actor_touch(dst);
    set_screen(dst, value);
#endif
    vram[V(dst)] = value;
    mark(dst);
}

/* 화면에 같은 워드를 n 번 (rep stosw) */
void vram_fill_word(uint16_t dst, uint16_t value, int n)
{
    uint16_t dst0 = dst;
    int n0 = n;

    CPU(9 + n * 10);
    while (n--) {
#ifdef CATVGA
        actor_touch(dst);
        actor_touch(dst + 1);
        set_screen(dst, (uint8_t)value);
        set_screen((uint16_t)(dst + 1), (uint8_t)(value >> 8));
#endif
        vram[V(dst++)] = (uint8_t)value;
        vram[V(dst++)] = (uint8_t)(value >> 8);
    }
    mark_range(dst0, n0 * 2);
}

/* 화면 안에서 n 바이트 옮기기.  step = +1 (cld) 또는 -1 (std), rep movsb 와 같다 */
void vram_move(uint16_t dst, uint16_t src, int n, int step)
{
    uint16_t dst0 = dst;
    int n0 = n;

    CPU(n * 17);
    while (n--) {
#ifdef CATVGA
        actor_move(dst, src);           /* 빨랫줄이 흐를 때 줄 위의 고양이도 같이 */
        {
            uint8_t *d = VC(dst), *sc = VC(src), b = vram[V(src)];
            int k;
            /* 옮긴 자리의 테마 색으로 다시 (그림에서 온 색은 그대로) */
            for (k = 0; k < 4; k++)
                d[k] = sc[k] < COL_SPRITE ? th(dst, k, (uint8_t)((b >> (6 - 2 * k)) & 3)) : sc[k];
        }
#endif
        vram[V(dst)] = vram[V(src)];
        dst += step; src += step;
    }
    mark_range(step < 0 ? (uint16_t)(dst0 - n0 + 1) : dst0, n0);
}

/* 점 하나 (x 0..319, y 0..199, 값 0..3) - 개선판의 타이틀 글자 */
void vram_plot(int x, int y, uint8_t v)
{
    uint16_t off = (uint16_t)((y >> 1) * 80 + ((y & 1) ? 0x2000 : 0) + (x >> 2));
    int shift = 6 - 2 * (x & 3);

#ifdef CATVGA
    actor_touch(off);
    VC(off)[x & 3] = th_of(off, x & 3, v);
#endif
    vram[V(off)] = (uint8_t)((vram[V(off)] & ~(3 << shift)) | (v << shift));
    mark(off);
}

/* 화면 두 바이트 (stosw) */
void vram_set_word(uint16_t dst, uint16_t value)
{
    vram_set(dst, (uint8_t)value);
    vram_set(dst + 1, (uint8_t)(value >> 8));
}

/* 그리기 전에 덮을 화면 바이트를 데이터 세그먼트에 저장 */
static void save_byte(uint16_t save, uint16_t dst)
{
#ifdef CATVGA
    save_colors(save, dst);
#endif
    ds[save] = vram[V(dst)];
}

/* 화면 = 화면 OR 데이터 (lodsw / or / stosw 를 바이트로) */
void put_or(uint16_t dst, uint16_t src)
{
    uint8_t r = vram[V(dst)] | ds[src];

#ifdef CATVGA
    {
        uint8_t *d = VC(dst), *sc = DSC(src);
        int k;
        actor_touch(dst);
        for (k = 0; k < 4; k++)
            if (PIX(ds[src], k)) {
                if (sc[k] != COL_CLEAR) {
                    d[k] = sc[k] > COL_CLEAR ? sc[k] : th(dst, k, PIX(r, k));
                    DBG("put_or", dst, k, sc[k]);
                }
            } else if (d[k] < COL_SPRITE) {
                d[k] = th(dst, k, PIX(r, k));
                DBG("put_or_bg", dst, k, sc[k]);
            }
    }
#endif
    vram[V(dst)] = r;
    mark(dst);
}

/* 화면 = 화면 AND 데이터
   (개선판: 색을 정해 준 점은 원래 값이 그대로여도 칠한다 - 고양이의 테두리와 눈,
    검은 곳 위의 고양이 몸) */
void put_and(uint16_t dst, uint16_t src)
{
    uint8_t v = vram[V(dst)], r = v & ds[src];

#ifdef CATVGA
    {
        uint8_t *d = VC(dst), *sc = DSC(src);
        int k;
        if (actor_capture < 0)
            actor_touch(dst);
        for (k = 0; k < 4; k++)
            if (sc[k] == COL_CLEAR) {
                continue;
            } else if (sc[k] > COL_CLEAR) {
                if (actor_capture >= 0)
                    actor_set(dst, k, sc[k]);
                else
                    d[k] = sc[k];
                DBG("put_and_spr", dst, k, sc[k]);
            } else if (PIX(r, k) != PIX(v, k)) {
                d[k] = th(dst, k, PIX(r, k));
                DBG("put_and_bg", dst, k, sc[k]);
            }
    }
#endif
    vram[V(dst)] = r;
    mark(dst);
}

/* 점마다: 그림이 0 이면 배경, 아니면 그림 */
void put_masked(uint16_t dst, uint16_t src)
{
    uint8_t s = ds[src], mask = s, r;
    int shift;

    for (shift = 6; shift >= 0; shift -= 2)
        if (!((s >> shift) & 3))
            mask |= 3 << shift;
    r = (vram[V(dst)] & mask) | s;
#ifdef CATVGA
    {
        uint8_t *d = VC(dst), *sc = DSC(src);
        int k;
        if (actor_capture < 0)
            actor_touch(dst);
        for (k = 0; k < 4; k++)
            if (PIX(s, k) && sc[k] != COL_CLEAR) {
                if (actor_capture >= 0 && sc[k] > COL_CLEAR)
                    actor_set(dst, k, sc[k]);
                else
                    d[k] = sc[k] > COL_CLEAR ? sc[k] : th(dst, k, PIX(r, k));
                DBG("put_masked", dst, k, sc[k]);
            }
    }
#endif
    vram[V(dst)] = r;
    mark(dst);
}

/* 다음 줄로: 짝수 줄 영역 <-> 홀수 줄 영역을 오가고, 짝수로 돌아오면 80바이트 아래 */
static uint16_t row_down(uint16_t off)
{
    off ^= 0x2000;
    if (!(off & 0x2000))
        off += 80;
    return off;
}

/* ---------------------------------------------------------------------------
 *  원래: 2CB0  (cx=x, dl=y -> ax)
 *  화면 좌표 -> 화면 메모리 위치.  x 는 점 단위지만 바이트 단위로 내린다.
 * ------------------------------------------------------------------------- */
uint16_t screen_offset(uint16_t x, uint8_t y)
{
    uint16_t off = (uint16_t)(y * 40);
    if (y & 1)
        off += 0x1FD8;                  /* (y-1)*40 + 2000h */
    return off + (x >> 2);
}

/* ---------------------------------------------------------------------------
 *  원래: 2CCC  "투명 그리기" - 색 0 인 점은 배경을 그대로 두고, 덮은 배경은
 *  save(데이터 세그먼트)에 워드 단위로 저장한다.
 * ------------------------------------------------------------------------- */
/* 개선판: 저장 버퍼를 둔 그리기는 움직이는 것이다 - 저절로 배우로 (actor.c) */
#ifdef CATVGA
#define AUTO_ACTOR_BEGIN(save)     int auto_act = actor_capture < 0 && (save) && (save) != SCRATCH;     uint16_t auto_dst = dst, auto_src = src;     if (auto_act) actor_auto_begin(save)
#define AUTO_ACTOR_END()     if (auto_act) actor_auto_end(auto_dst, auto_src)
#else
#define AUTO_ACTOR_BEGIN(save)  ((void)0)
#define AUTO_ACTOR_END()        ((void)0)
#endif

void draw_sprite(uint16_t dst, uint16_t src, uint16_t save, uint16_t size)
{
    int w = size & 0xFF, h = size >> 8, i;
    AUTO_ACTOR_BEGIN(save);

    CPU(60 + h * 120 + w * h * 274);

    while (h--) {
        for (i = 0; i < w; i++) {
            save_byte(save, dst);
            save_byte(save + 1, dst + 1);
            put_masked(dst, src);
            put_masked(dst + 1, src + 1);
            dst += 2; src += 2; save += 2;
        }
        dst = row_down(dst - 2 * w);
    }
    AUTO_ACTOR_END();
}

/* ---------------------------------------------------------------------------
 *  원래: 2D35  "AND 그리기" - 화면 = 화면 AND 그림.  배경은 save 에 저장.
 *  (배경색 2 위에서만 쓴다.  그림의 3 은 배경을, 0 은 검은색을 남긴다)
 * ------------------------------------------------------------------------- */
void draw_sprite_and(uint16_t dst, uint16_t src, uint16_t save, uint16_t size)
{
    int w = size & 0xFF, h = size >> 8, i;
    AUTO_ACTOR_BEGIN(save);

    CPU(56 + h * 107 + w * h * 84);

    while (h--) {
        for (i = 0; i < 2 * w; i++) {
            save_byte(save + i, dst + i);
            put_and(dst + i, src + i);
        }
        dst = row_down(dst);
        src += 2 * w; save += 2 * w;
    }
    AUTO_ACTOR_END();
}

/* ---------------------------------------------------------------------------
 *  원래: 3365 (빗자루), 4FE7 (사랑의 방 고양이)  "OR 그리기" - 화면 = 화면 OR 그림.
 *  save 가 0 이 아니면 덮기 전 배경을 저장한다.
 * ------------------------------------------------------------------------- */
void draw_sprite_or(uint16_t dst, uint16_t src, uint16_t save, uint16_t size)
{
    int w = size & 0xFF, h = size >> 8, i;
    AUTO_ACTOR_BEGIN(save);

    CPU(56 + h * 107 + w * h * 84);

    while (h--) {
        for (i = 0; i < 2 * w; i++) {
            if (save)
                save_byte(save + i, dst + i);
            put_or(dst + i, src + i);
        }
        dst = row_down(dst);
        src += 2 * w;
        if (save)
            save += 2 * w;
    }
    AUTO_ACTOR_END();
}

/* ---------------------------------------------------------------------------
 *  원래: 2D70  데이터 세그먼트 안에서 그림 줄 뽑기.
 *  src 에서 한 줄에 w 워드씩 h 줄을 dst 에 이어 붙이는데, 원본 줄은
 *  stride 워드씩 건너뛴다 (넓은 그림에서 일부만 잘라 쓸 때).
 * ------------------------------------------------------------------------- */
void extract_rows(uint16_t dst, uint16_t src, uint8_t stride, uint16_t size)
{
    int w = size & 0xFF, h = size >> 8;

    CPU(93 + h * 124);

    while (h--) {
        ds_copy(dst, src, 2 * w);
        dst += 2 * w;
        src += (uint8_t)(stride * 2);
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 2D9D  데이터 세그먼트의 그림을 화면에 그대로 복사
 * ------------------------------------------------------------------------- */
void blit(uint16_t dst, uint16_t src, uint16_t size)
{
    int w = size & 0xFF, h = size >> 8;

    CPU(56 + h * 124);

    while (h--) {
        vram_put(dst, src, 2 * w);
        dst = row_down(dst);
        src += 2 * w;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 2DCA  화면의 사각형을 데이터 세그먼트로 저장
 * ------------------------------------------------------------------------- */
void save_rect(uint16_t dst, uint16_t src, uint16_t size)
{
    int w = size & 0xFF, h = size >> 8;

    CPU(44 + h * 125);

    while (h--) {
        vram_get(dst, src, 2 * w);
        src = row_down(src);
        dst += 2 * w;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 2B24  그림 목록 그리기.
 *  list: [크기] 다음에 {그림 위치, 화면 위치} 쌍이 FFFF 까지.  크기는 바이트 단위
 *  (아래 = 한 줄 바이트 수, 위 = 줄 수).  화면 위치에는 base 를 더한다.
 * ------------------------------------------------------------------------- */
void draw_list(uint16_t list, uint16_t base)
{
    uint16_t size = DW(list);
    int w = size & 0xFF, rows;
    uint16_t src, dst;

    list += 2;
    while ((src = DW(list)) != 0xFFFF) {
        dst = DW(list + 2) + base;
        CPU(150 + (size >> 8) * (107 + w * 9));
        for (rows = size >> 8; rows; rows--) {
            vram_put(dst, src, w);
            src += w;
            dst = row_down(dst);
        }
        list += 4;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 29E1  한 바이트 값으로 95줄짜리 세로줄 긋기
 * ------------------------------------------------------------------------- */
void draw_column(uint16_t dst, uint8_t value)
{
    int n;

    CPU(0x5F * 30);
    for (n = 0; n < 0x5F; n++) {
        vram_set(dst, value);
        dst = row_down(dst);
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 2DFD  난수.  16비트 시프트 레지스터 (seed 는 DS:2AE5)
 *  반환: 새 seed (원본은 dx 로 돌려주고 호출하는 쪽이 dl 이나 dx 를 썼다)
 * ------------------------------------------------------------------------- */
uint16_t random16(void)
{
    uint8_t lo = (uint8_t)rand_seed, hi = (uint8_t)(rand_seed >> 8);
    uint16_t bit = ((lo ^ hi) >> 1) & 1;

    rand_seed = (uint16_t)((rand_seed >> 1) | (bit << 15));
    return rand_seed;
}

/* 원래: 2E10  타이머 0 카운터로 seed 정하기 (0 이면 FA59) */
void random_seed(void)
{
    uint16_t v = sys_pit_counter_raw();
    rand_seed = v ? v : 0xFA59;
}

/* ---------------------------------------------------------------------------
 *  원래: 2E29  사각형 두 개가 겹치나 (겹치면 1 = CF)
 *      ax=x1 si=w1 dl=y1 cl=h1,  bx=x2 di=w2 dh=y2 ch=h2
 *  x 는 16비트, y 는 8비트로 계산한다 (y+h 가 255 를 넘으면 돌아간다).
 *  x1+w1 < x2 이거나 x1-w2 > x2 (0 아래는 0) 이면 안 겹침, y 도 같은 식.
 * ------------------------------------------------------------------------- */
int rects_overlap(uint16_t x1, uint16_t w1, uint8_t y1, uint8_t h1,
                  uint16_t x2, uint16_t w2, uint8_t y2, uint8_t h2)
{
    uint16_t a;
    uint8_t b;

    a = (uint16_t)(x1 + w1);
    if (a < x2)
        return 0;
    a = (x1 >= w2) ? (uint16_t)(x1 - w2) : 0;
    if (a > x2)
        return 0;
    b = (uint8_t)(y1 + h1);
    if (b < y2)
        return 0;
    b = (uint8_t)(y1 >= h2 ? y1 - h2 : 0);
    if (b > y2)
        return 0;
    return 1;
}
