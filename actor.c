/* ============================================================================
 *  actor.c  -  개선판: 움직이는 것들을 부드럽게 (1점 단위 위치, 사이 동작)
 * ----------------------------------------------------------------------------
 *  원판은 그림을 4점(CGA 한 바이트) 단위로만 놓고, 시계에 맞춰 한 번에 몇 점씩
 *  뚝뚝 옮긴다.  동작 그림도 몇 장 되지 않는다.  게임 규칙(화면 메모리 vram 의
 *  값)은 그대로 두고, 보여 주는 쪽만 이렇게 바꾼다.
 *
 *    1. 움직이는 것("배우")을 그리는 동안 칠한 색 점은 색판(vram_col)이 아니라
 *       배우 층에 받는다.  배우 층은 화면 한 장으로, 점마다 주인 배우와 색을
 *       적는다.  다른 그리기가 그 바이트를 덮으면 배우 층의 그 점도 지운다
 *       (원판에서 덮이는 것과 같다).
 *         - 고양이, 불독, 쥐, 새, 물고기, 수컷 고양이는 그리는 곳에서 직접 잡는다
 *           (ACTOR_BEGIN / ACTOR_END, 실제 x 좌표도 준다)
 *         - 저장 버퍼를 두고 그렸다 지우는 나머지(던진 물건, 쓰레기통 놈, 빗자루,
 *           거미, 화살, 새장 ...)는 gfx.c 가 저장 버퍼 자리를 열쇠로 저절로 잡는다
 *    2. 그리기가 끝나면 모양(점과 색)을 그린 자리 기준으로 떠 둔다.  앞 모양도
 *       하나 남겨 둔다.
 *    3. 화면을 합칠 때(actor_compose)
 *         - 위치: 보이는 자리가 실제 자리를 임계 감쇠 스프링으로 쫓는다
 *           (걸음 간격이 들쭉날쭉해도 멈칫하거나 튀지 않는다)
 *         - 모양: 고양이는 두 모양의 거리장을 섞어 사이 동작을 만들고,
 *           나머지는 새 걸음을 절반 따라왔을 때 그림을 바꾼다.  사이 그림
 *           (tools/tweens.py)이 있으면 그 사이에 보여 준다.
 *    4. 빨랫줄이 흐를 때(4점씩)도 줄 띠를 1점 단위로 이어서 민다.
 * ========================================================================== */
#include <string.h>
#include <stddef.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include "allycat.h"
#include "col256.h"

#define W 320
#define H 200
#define SNAP 56                 /* 모양 하나의 최대 크기 (점).  넘으면 부드럽게 하지 않는다 */
#define MARGIN 3
#define MAX_ACT 40
#define GLIDE_V 110.0           /* 가장자리에서 나올 때 보이는 빠르기 (점/초) */
#define GRACE 40000.0           /* 지웠다 다시 그리는 사이에 앞 모양을 보여 주는 시간 (us) */

enum { AK_CAT, AK_DOG, AK_SMALL };
/* 종류마다: 모양 섞기, 따라가는 시간 (마이크로초) */
static const int kind_morph[3] = { 1, 0, 0 };
static const double kind_tau[3] = { 20000, 80000, 45000 };

typedef struct {
    int n;                      /* 점 수 (0 = 없음) */
    int sdf_ok;
    uint16_t src;               /* 게임이 그린 원판 그림 (사이 그림 찾기, 0 = 모름) */
    int x0, y0, w, h;           /* 그린 자리(org) 기준 상자 */
    double ax, ay;              /* 화면에 놓을 자리 (1점 단위) */
    uint8_t col[SNAP * SNAP];
    uint8_t in[SNAP * SNAP];
    float sd[(SNAP + 2 * MARGIN) * (SNAP + 2 * MARGIN)];
} snap_t;

typedef struct {
    uint32_t key;
    int used, kind;
    int count;                  /* 배우 층에 남은 점 수 */
    int bx0, by0, bx1, by1;     /* 점이 있을 수 있는 상자 */
    int raw;                    /* 너무 커서 모양을 못 떴다: 층의 점을 그대로 */
    snap_t prev, cur;
    double t_prev, t_cur, dt_avg;
    double t_gone, gap;         /* 점이 다 지워진 시각, 다시 그리기 시작할 때 안 보인 시간 */
    int disp_ok;
    double dispx, dispy, velx, vely, td, d0;
    unsigned seq;               /* 마지막으로 그린 순서 (나중 것이 위) */
    int shifted;                /* 앞 모양이 가장자리에서 잘려 들어오던 것 */
    int dx0, dy0, dx1, dy1;     /* 지난 프레임에 그린 자리 (다시 칠할 곳) */
    int glide;                  /* 가장자리에서 나오는 중: 걷는 빠르기로 미끄러지게 */
    double glide_t0;
    double vel;                 /* 최근 걸음의 빠르기 (점/마이크로초) - 고르게 미끄러지게 */
} actor_t;

static actor_t actors[MAX_ACT];
static uint8_t owner[W * H];    /* 점의 주인 (배우 번호 + 1, 0 = 없음) */
static uint8_t ocol[W * H];
static unsigned seq_counter;
int actor_capture = -1;
int actor_title;
int actor_fast;                 /* 느린 기계: 모양 섞기(거리장)를 건너뛴다 */
int actor_shift;                /* 다음 모양의 실제 자리 - 그린 자리 (가장자리에서 잘려 들어오는 고양이) */
int actor_shift_on;             /* 다음 모양은 가장자리에서 들어오는 중 */
double actor_clock;
void *actor_trace;              /* 검수용: FILE * 이면 합칠 때마다 보이는 자리를 적는다 */

/* ---- 빨랫줄 띠 ---- */
typedef struct { int y0, dir; double t, dt; } band_t;
static band_t bands[3];

/* 화면 메모리 위치 -> 점 좌표 (없으면 0) */
static int off_xy(uint16_t off, int *x, int *y)
{
    unsigned o = off & 0x3FFF;

    *y = off_row[o & 0x1FFF] + ((o & 0x2000) ? 1 : 0);
    *x = off_col[o & 0x1FFF];
    return *y < H;
}

static void bbox_add(actor_t *a, int x, int y)
{
    if (x < a->bx0) a->bx0 = x;
    if (x > a->bx1) a->bx1 = x;
    if (y < a->by0) a->by0 = y;
    if (y > a->by1) a->by1 = y;
}

static void slot_clear(actor_t *a, uint32_t key, int kind)
{
    memset(a, 0, offsetof(actor_t, prev));
    a->prev.n = a->cur.n = 0;
    a->t_prev = a->t_cur = a->dt_avg = 0;
    a->disp_ok = 0;
    a->key = key;
    a->kind = kind;
    a->used = 1;
    a->bx0 = a->by0 = 1 << 20;
    a->bx1 = a->by1 = -1;
}

/* 배우 층의 점 하나가 줄었다 */
static void count_dec(int ai)
{
    if (--actors[ai].count == 0)
        actors[ai].t_gone = actor_clock;
}

static int find_key(uint32_t key)
{
    int i;
    for (i = 0; i < MAX_ACT; i++)
        if (actors[i].used && actors[i].key == key)
            return i;
    return -1;
}

/* 열쇠의 배우 칸 (없으면 빈 칸이나 오래 안 쓴 칸) */
static int slot_for(uint32_t key, int kind)
{
    int i = find_key(key), best = -1;
    double oldest = 1e300;

    if (i >= 0)
        return i;
    for (i = 0; i < MAX_ACT; i++) {
        if (!actors[i].used) {
            best = i;
            break;
        }
        if (actors[i].count == 0 && actors[i].t_cur < oldest) {
            oldest = actors[i].t_cur;
            best = i;
        }
    }
    if (best < 0)
        return -1;
    slot_clear(&actors[best], key, kind);
    return best;
}

void actor_set(uint16_t off, int k, uint8_t color)
{
    int x, y, i;
    actor_t *a;

    if (actor_capture < 0 || !off_xy(off, &x, &y))
        return;
    a = &actors[actor_capture];
    x += k;
    i = y * W + x;
    if (owner[i] != actor_capture + 1) {
        if (owner[i])
            count_dec(owner[i] - 1);
        owner[i] = (uint8_t)(actor_capture + 1);
        a->count++;
    }
    ocol[i] = color;
    bbox_add(a, x, y);
}

void actor_touch(uint16_t off)
{
    int x, y, k;
    uint8_t *p;

    if (!off_xy(off, &x, &y))
        return;
    p = owner + y * W + x;
    for (k = 0; k < 4; k++)
        if (p[k]) {
            count_dec(p[k] - 1);
            p[k] = 0;
        }
}

/* 화면 한 바이트를 옮길 때 배우 층의 점도 같이 (vram_move, 복사다) */
void actor_move(uint16_t dst, uint16_t src)
{
    int dx, dy, sx, sy, k;

    if (!off_xy(dst, &dx, &dy) || !off_xy(src, &sx, &sy))
        return;
    for (k = 0; k < 4; k++) {
        int d = dy * W + dx + k, s = sy * W + sx + k;
        if (owner[d])
            count_dec(owner[d] - 1);
        owner[d] = owner[s];
        ocol[d] = ocol[s];
        if (owner[d]) {
            actors[owner[d] - 1].count++;
            bbox_add(&actors[owner[d] - 1], dx + k, dy);
        }
    }
}

void actor_reset_all(void)
{
    memset(owner, 0, sizeof owner);
    memset(actors, 0, sizeof actors);
    memset(bands, 0, sizeof bands);
    actor_capture = -1;
}

static void begin_key(uint32_t key, int kind)
{
    actor_t *a;

    actor_capture = slot_for(key, kind);
    if (actor_capture < 0)
        return;
    a = &actors[actor_capture];
    a->gap = a->count || !a->t_gone ? 0 : actor_clock - a->t_gone;
}

void actor_begin(int id)
{
    begin_key(0x10000u + (uint32_t)id, id == 0 ? AK_CAT : id == 1 ? AK_DOG : AK_SMALL);
}

/* gfx.c: 저장 버퍼를 둔 그리기는 저절로 배우로 (열쇠 = 저장 버퍼 자리) */
void actor_auto_begin(uint16_t save)
{
    begin_key(save, AK_SMALL);
}

/* ---- 거리장 (고양이의 모양 섞기) ------------------------------------------ */
static void chamfer(float *d, int gw, int gh)
{
    int x, y;
    const float D1 = 1.0f, D2 = 1.4142f;

    for (y = 0; y < gh; y++)
        for (x = 0; x < gw; x++) {
            float *p = d + y * gw + x, v = *p;
            if (x > 0 && p[-1] + D1 < v) v = p[-1] + D1;
            if (y > 0) {
                if (p[-gw] + D1 < v) v = p[-gw] + D1;
                if (x > 0 && p[-gw - 1] + D2 < v) v = p[-gw - 1] + D2;
                if (x < gw - 1 && p[-gw + 1] + D2 < v) v = p[-gw + 1] + D2;
            }
            *p = v;
        }
    for (y = gh - 1; y >= 0; y--)
        for (x = gw - 1; x >= 0; x--) {
            float *p = d + y * gw + x, v = *p;
            if (x < gw - 1 && p[1] + D1 < v) v = p[1] + D1;
            if (y < gh - 1) {
                if (p[gw] + D1 < v) v = p[gw] + D1;
                if (x < gw - 1 && p[gw + 1] + D2 < v) v = p[gw + 1] + D2;
                if (x > 0 && p[gw - 1] + D2 < v) v = p[gw - 1] + D2;
            }
            *p = v;
        }
}

static void make_sdf(snap_t *s)
{
    static float din[(SNAP + 2 * MARGIN) * (SNAP + 2 * MARGIN)];
    static float dout[(SNAP + 2 * MARGIN) * (SNAP + 2 * MARGIN)];
    int gw = s->w + 2 * MARGIN, gh = s->h + 2 * MARGIN, gx, gy;

    if (s->sdf_ok)
        return;
    for (gy = 0; gy < gh; gy++)
        for (gx = 0; gx < gw; gx++) {
            int px = gx - MARGIN, py = gy - MARGIN, g = gy * gw + gx;
            int inside = px >= 0 && py >= 0 && px < s->w && py < s->h && s->in[py * s->w + px];
            dout[g] = inside ? 0 : 1e6f;
            din[g] = inside ? 1e6f : 0;
        }
    chamfer(dout, gw, gh);
    chamfer(din, gw, gh);
    for (gy = 0; gy < gh; gy++)
        for (gx = 0; gx < gw; gx++) {
            int g = gy * gw + gx;
            s->sd[g] = din[g] > 0 ? -(din[g] - 0.5f) : (dout[g] - 0.5f);
        }
    s->sdf_ok = 1;
}

static float sdf_at(snap_t *s, int qx, int qy)
{
    int gw = s->w + 2 * MARGIN, gh = s->h + 2 * MARGIN;
    int gx = qx - s->x0 + MARGIN, gy = qy - s->y0 + MARGIN;

    if (!s->n)
        return 99.0f;
    if (gx < 0 || gy < 0 || gx >= gw || gy >= gh) {
        int cx = gx < 0 ? 0 : gx >= gw ? gw - 1 : gx;
        int cy = gy < 0 ? 0 : gy >= gh ? gh - 1 : gy;
        return s->sd[cy * gw + cx] + (float)(abs(gx - cx) + abs(gy - cy));
    }
    return s->sd[gy * gw + gx];
}

static int inside_at(const snap_t *s, int qx, int qy, uint8_t *c)
{
    int x = qx - s->x0, y = qy - s->y0;

    if (!s->n || x < 0 || y < 0 || x >= s->w || y >= s->h || !s->in[y * s->w + x])
        return 0;
    *c = s->col[y * s->w + x];
    return 1;
}

static uint8_t near_color(const snap_t *s, int qx, int qy)
{
    int r, dx, dy;
    uint8_t c;

    for (r = 1; r <= 4; r++)
        for (dy = -r; dy <= r; dy++)
            for (dx = -r; dx <= r; dx++)
                if (inside_at(s, qx + dx, qy + dy, &c))
                    return c;
    return 0;
}

static double actor_alpha(const actor_t *a, double now);

/* ---------------------------------------------------------------------------
 *  그리기가 끝났다: 모양을 떠 둔다.
 *  org_scr: 게임이 그린 자리 (화면 메모리 위치),  exact_x: 실제 x 좌표 (모르면 -1)
 * ------------------------------------------------------------------------- */
static void end_slot(int ai, uint16_t org_scr, int exact_x, uint16_t src)
{
    actor_t *a = &actors[ai];
    snap_t s;
    int ox, oy, x, y, x0, y0, x1, y1, sub, lim, shift = actor_shift, entering = actor_shift_on;

    actor_shift = 0;
    actor_shift_on = 0;
    off_xy(org_scr, &ox, &oy);
    sub = exact_x - ox;
    if (exact_x < 0 || sub < 0 || sub > 3)
        sub = 0;
    /* 이 배우의 점 상자 */
    x0 = y0 = 1 << 20;
    x1 = y1 = -1;
    if (a->count)
        for (y = a->by0 < 0 ? 0 : a->by0; y <= a->by1 && y < H; y++)
            for (x = a->bx0 < 0 ? 0 : a->bx0; x <= a->bx1 && x < W; x++)
                if (owner[y * W + x] == ai + 1) {
                    if (x < x0) x0 = x;
                    if (x > x1) x1 = x;
                    if (y < y0) y0 = y;
                    if (y > y1) y1 = y;
                }
    a->bx0 = x0; a->by0 = y0; a->bx1 = x1; a->by1 = y1;
    a->seq = ++seq_counter;
    if (x1 < 0)
        return;
    if (x1 - x0 >= SNAP || y1 - y0 >= SNAP) {
        a->raw = 1;                     /* 너무 크다: 층의 점을 그대로 */
        a->prev.n = a->cur.n = 0;
        a->disp_ok = 0;
        return;
    }
    a->raw = 0;
    s.n = 0;
    s.src = src == SCRATCH ? 0 : src;   /* 잘라 쓴 그림은 모른다 */
    s.x0 = x0 - ox;
    s.y0 = y0 - oy;
    s.w = x1 - x0 + 1;
    s.h = y1 - y0 + 1;
    s.ax = ox + sub + shift;            /* 잘린 그림은 몸의 실제 자리로 */
    s.ay = oy;
    s.x0 -= shift;
    for (y = 0; y < s.h; y++)
        for (x = 0; x < s.w; x++) {
            int i = (y0 + y) * W + x0 + x, on = owner[i] == ai + 1;
            s.in[y * s.w + x] = (uint8_t)on;
            s.col[y * s.w + x] = on ? ocol[i] : 0;
            s.n += on;
        }
    /* 같은 그림을 같은 자리에 다시 그린 것이면 그대로 (화면의 자리로 비교 - 잘려 들어오는
       고양이를 다른 곳(빨랫줄)에서 다시 떠도 몸의 자리를 잃지 않게) */
    if (a->cur.n == s.n && a->cur.w == s.w && a->cur.h == s.h &&
        a->cur.x0 + a->cur.ax == s.x0 + s.ax && a->cur.y0 + a->cur.ay == s.y0 + s.ay &&
        !memcmp(a->cur.in, s.in, (size_t)(s.w * s.h)) && !memcmp(a->cur.col, s.col, (size_t)(s.w * s.h)))
        return;
    s.sdf_ok = 0;
    if (a->cur.n) {
        double dt = actor_clock - a->t_cur;
        if (s.ax != a->cur.ax || s.ay != a->cur.ay) {
            double d;
            a->dt_avg = a->dt_avg > 0 ? a->dt_avg * 0.6 + dt * 0.4 : dt;
            /* 원판은 같은 거리를 들쭉날쭉한 간격으로 옮긴다 (불독은 50ms, 117ms 번갈아).
               최근 걸음의 평균 빠르기를 재 두었다가 그 빠르기로 고르게 미끄러진다. */
            d = fabs(s.ax - a->cur.ax) + fabs(s.ay - a->cur.ay);
            if (dt > 1000.0 && dt < 400000.0) {
                double v = d / dt;
                a->vel = a->vel > 0 ? a->vel * 0.6 + v * 0.4 : v;
            }
        }
    } else {
        a->dt_avg = 0;
        a->vel = 0;
    }
    /* 순간이동: 멀리 뛰었다, 한동안 안 보이다 다시 나왔다, 불독이 달리기와 이어지지
       않는 그림(싸움 먼지)으로 바뀌었다 -> 새 자리, 새 그림을 바로 */
    lim = a->shifted || a->glide ? 60 : 20;  /* 가장자리에서 나오는 동안은 보이는 자리가 뒤처져 있다 */
    if ((entering || a->shifted) && !a->glide) {
        a->glide = 1;
        a->glide_t0 = actor_clock;
    }
    a->shifted = entering;
    if (!a->disp_ok || fabs(s.ax - a->dispx) > lim || fabs(s.ay - a->dispy) > 20 ||
        a->gap > 250000.0 ||
        (a->kind == AK_DOG && a->cur.n && s.src != a->cur.src &&
         !(s.src && a->cur.src && (tween_find(a->cur.src, s.src) || tween_find(s.src, a->cur.src))))) {
        a->dispx = s.ax;
        a->dispy = s.ay;
        a->velx = a->vely = 0;
        a->disp_ok = 1;
        a->td = actor_clock;
        a->vel = 0;
        a->cur.n = 0;                   /* 앞 모양은 버린다 */
    }
    a->d0 = fabs(s.ax - a->dispx) + fabs(s.ay - a->dispy);
    a->prev = a->cur;
    a->cur = s;
    a->t_prev = a->t_cur;
    a->t_cur = actor_clock;
}

void actor_end(int id, uint16_t org_scr, int exact_x, uint16_t src)
{
    int ai = actor_capture >= 0 ? actor_capture : find_key(0x10000u + (uint32_t)id);

    actor_capture = -1;
    if (ai >= 0)
        end_slot(ai, org_scr, exact_x, src);
}

void actor_auto_end(uint16_t org_scr, uint16_t src)
{
    int ai = actor_capture;

    actor_capture = -1;
    if (ai >= 0)
        end_slot(ai, org_scr, -1, src);
}

/* 열쇠로 직접 (물고기, 수컷 고양이) */
void actor_begin_key(uint32_t key)
{
    begin_key(key, AK_SMALL);
}

/* ---------------------------------------------------------------------------
 *  빨랫줄이 한 칸(4점) 흘렀다: 줄 띠(src 부터 16줄)를 화면에서 1점씩 이어 민다
 *  dir = +1 오른쪽, -1 왼쪽
 * ------------------------------------------------------------------------- */
void actor_line_scroll(int line, uint16_t src, int dir)
{
    band_t *b = &bands[line];
    int x, y;
    double dt = actor_clock - b->t;

    off_xy(src, &x, &y);
    if (b->t > 0 && dt > 0 && dt < 500000.0)
        b->dt = b->dt > 0 ? b->dt * 0.7 + dt * 0.3 : dt;
    else
        b->dt = 0;
    b->y0 = y;
    b->dir = dir;
    b->t = actor_clock;
}

static void compose_bands(uint8_t *frame, double now)
{
    static uint8_t row[W];
    int i, y, x;

    if (theme_room != ROOM_ALLEY)
        return;
    for (i = 0; i < 3; i++) {
        band_t *b = &bands[i];
        double al;
        int o;
        if (b->dt <= 0 || b->t <= 0)
            continue;
        al = (now - b->t) / (b->dt * 1.1);
        if (al >= 1.0 || al < 0)
            continue;
        o = (int)floor(4.0 * (1.0 - al) + 0.5);         /* 아직 덜 온 거리 */
        if (!o)
            continue;
        for (y = b->y0; y < b->y0 + 16 && y < H; y++) {
            uint8_t *r = frame + y * W;
            memcpy(row, r, W);
            for (x = 0; x < W; x++) {
                int sx = x + o * b->dir;              /* 흐르기 전 자리에서 */
                r[x] = row[sx < 0 ? 0 : sx >= W ? W - 1 : sx];
            }
        }
    }
}

/* ---------------------------------------------------------------------------
 *  화면 합치기
 * ------------------------------------------------------------------------- */
static double actor_alpha(const actor_t *a, double now)
{
    double dt = a->dt_avg > 0 ? a->dt_avg * 1.25 : a->t_cur - a->t_prev, al;

    if (!a->prev.n || dt <= 0 || dt > 250000.0)
        return 1.0;
    if (dt < 15000.0)
        dt = 15000.0;
    if (dt > 150000.0)
        dt = 150000.0;
    al = (now - a->t_cur) / dt;
    return al < 0 ? 0 : al > 1 ? 1 : al;
}

/* 움직이는 것이 있나.  게임 고리가 한 바퀴마다 묻기 때문에 값싸게 (느린 486 에서도
   고리가 8088 속도를 따라가야 한다).  실제 판단은 화면을 합칠 때 해 두고, 여기서는
   "언제까지 움직인다"만 본다. */
double actor_busy_until;

int actor_busy(double now)
{
    return now < actor_busy_until;
}

/* 화면을 합치면서: 아직 움직이는 것이 있으면 다음 화면도 내보내게 */
static void busy_check(double now)
{
    int i;

    for (i = 0; i < 3; i++)
        if (bands[i].dt > 0 && now - bands[i].t < bands[i].dt * 1.1) {
            actor_busy_until = now + 34000.0;
            return;
        }
    for (i = 0; i < MAX_ACT; i++) {
        actor_t *a = &actors[i];
        if (!a->used)
            continue;
        if (a->count && a->cur.n &&
            (actor_alpha(a, now) < 1.0 ||
             fabs(a->cur.ax - a->dispx) + fabs(a->cur.ay - a->dispy) > 0.3)) {
            actor_busy_until = now + 34000.0;
            return;
        }
        /* 지워진 뒤 잠깐 앞 모양을 보여 주는 중: 끝난 화면도 한 번 더 내보내야 한다 */
        if (!a->count && !a->raw && a->cur.n && now - a->t_gone < GRACE + 20000.0) {
            actor_busy_until = now + 34000.0;
            return;
        }
    }
}

static double overlap(const snap_t *p, const snap_t *c)
{
    int x, y, both = 0, any = 0;
    uint8_t t;
    int qx0 = p->x0 < c->x0 ? p->x0 : c->x0, qy0 = p->y0 < c->y0 ? p->y0 : c->y0;
    int qx1 = p->x0 + p->w > c->x0 + c->w ? p->x0 + p->w : c->x0 + c->w;
    int qy1 = p->y0 + p->h > c->y0 + c->h ? p->y0 + p->h : c->y0 + c->h;

    for (y = qy0; y < qy1; y++)
        for (x = qx0; x < qx1; x++) {
            int a = inside_at(p, x, y, &t), b = inside_at(c, x, y, &t);
            both += a && b;
            any += a || b;
        }
    return any ? (double)both / any : 0;
}

static uint8_t nearest_pal(int r, int g, int b)
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

/* 임계 감쇠 스프링 (속도까지 이어지게 쫓는다) */
static void smooth_damp(double *x, double *v, double target, double smooth, double dt)
{
    double om = 2.0 / smooth, e = om * dt;
    double ex = 1.0 / (1.0 + e + 0.48 * e * e + 0.235 * e * e * e);
    double ch = *x - target, tmp = (*v + om * ch) * dt;

    *v = (*v - om * tmp) * ex;
    *x = target + (ch + tmp) * ex;
    if ((target - *x) * ch > 0) {
        *x = target;
        *v = 0;
    }
}

/* 고양이가 빨랫줄에 서 있나 (골목, 발이 세 줄 가운데 하나의 높이) */
static int cat_on_clothesline(void)
{
    int i;

    if (room != ROOM_ALLEY || cat_standing < 1)
        return 0;
    for (i = 0; i < 3; i++)
        if (cat_foot_y >= line_foot_min(i) && cat_foot_y < line_foot_max(i))
            return 1;
    return 0;
}

#define GS (SNAP + 8)

static void compose_actor(uint8_t *frame, double now, int ai)
{
    static uint8_t gcol[GS * GS];
    actor_t *a = &actors[ai];
    snap_t *c = &a->cur, *p = &a->prev;
    const tween_t *tw = NULL;
    double al, dx, dy, dtc, dy_prev;
    int x, y, bx, by, qx0, qy0, qx1, qy1, gw, gh, morph;

    if (a->raw) {
        /* 너무 크다: 층의 점을 그대로 */
        for (y = a->by0 < 0 ? 0 : a->by0; y <= a->by1 && y < H; y++)
            for (x = a->bx0 < 0 ? 0 : a->bx0; x <= a->bx1 && x < W; x++)
                if (owner[y * W + x] == ai + 1)
                    frame[y * W + x] = ocol[y * W + x];
        a->dx0 = a->bx0; a->dy0 = a->by0;
        a->dx1 = a->bx1; a->dy1 = a->by1;
        return;
    }
    if (!c->n)
        return;
    al = actor_alpha(a, now);
    morph = kind_morph[a->kind] && !actor_fast && al < 1.0 && overlap(p, c) >= 0.35;
    if (morph) {
        make_sdf(p);
        make_sdf(c);
    }
    /* 보이는 자리: 실제 자리를 스프링으로 쫓는다 */
    dy_prev = a->dispy;
    dtc = now - a->td;
    if (dtc < 0)
        dtc = 0;
    if (dtc > 100000.0)
        dtc = 100000.0;
    a->td = now;
    {
        double ox = a->dispx, oy = a->dispy;
        smooth_damp(&a->dispx, &a->velx, c->ax, kind_tau[a->kind], dtc);
        /* 고양이 말고는 최근 걸음의 빠르기를 넘지 않게 (원판의 들쭉날쭉한 걸음을 고르게) */
        if (a->kind != AK_CAT && a->vel > 0 && !a->glide) {
            double mx = a->vel * 1.35 * dtc + 0.35;
            double rem = fabs(c->ax - ox) + fabs(c->ay - oy);
            if (rem > 20.0)
                mx = a->vel * 3.0 * dtc + 0.35;     /* 많이 뒤처졌으면 빨리 따라간다 */
            if (a->dispx - ox > mx)
                a->dispx = ox + mx;
            else if (ox - a->dispx > mx)
                a->dispx = ox - mx;
        }
        if (a->glide) {
            /* 원판은 머리 조각 뒤에 몸을 50ms 만에 24점 내민다 - 걷는 빠르기로 */
            /* 곧 조작할 수 있으니 조금씩 빨라져 따라잡는다 */
            double mx = actor_title ? GLIDE_V * (1.0 + (now - a->glide_t0) / 250000.0)
                                    : GLIDE_V * 1.8 * (1.0 + (now - a->glide_t0) / 120000.0);
            mx *= dtc / 1000000.0;
            if (a->dispx - ox > mx)
                a->dispx = ox + mx;
            else if (ox - a->dispx > mx)
                a->dispx = ox - mx;
            a->velx = 0;
            if (fabs(c->ax - a->dispx) < 0.5)
                a->glide = 0;
        }
    }
    smooth_damp(&a->dispy, &a->vely, c->ay, kind_tau[a->kind], dtc);
    if (a->kind != AK_CAT && a->vel > 0) {
        double my = a->vel * 1.35 * dtc + 0.35, oy2 = dy_prev;
        if (a->dispy - oy2 > my)
            a->dispy = oy2 + my;
        else if (oy2 - a->dispy > my)
            a->dispy = oy2 - my;
    }
    dx = a->dispx;
    dy = a->dispy;
    /* 섞지 않는 배우: 앞 그림 -> (사이 그림) -> 새 그림 */
    if (!kind_morph[a->kind] && p->n) {
        double rem = fabs(c->ax - dx) + fabs(c->ay - dy);
        double prog = a->d0 > 0.5 ? 1.0 - rem / a->d0 : al;    /* 제자리 걸음은 시간 비율로 */
        const tween_t *t = (p->src && c->src) ? tween_find(p->src, c->src) : NULL;
        if (t && prog > 0.2 && prog < 0.8)
            tw = t;
        else if (prog < 0.5)
            c = p;
    }
    bx = (int)floor(dx + 0.5);
    by = (int)floor(dy + 0.5);
    if (actor_trace)
        fprintf((FILE *)actor_trace, "%.0f %lx %d %d %.0f %.0f %x\n", now, (unsigned long)a->key, bx, by,
                c->ax, c->ay, tw ? 0xFFFF : c->src);

    if (tw) {
        qx0 = 0; qy0 = 0;
        qx1 = tw->w; qy1 = tw->h;
    } else if (morph) {
        qx0 = p->x0 < c->x0 ? p->x0 : c->x0;
        qy0 = p->y0 < c->y0 ? p->y0 : c->y0;
        qx1 = p->x0 + p->w > c->x0 + c->w ? p->x0 + p->w : c->x0 + c->w;
        qy1 = p->y0 + p->h > c->y0 + c->h ? p->y0 + p->h : c->y0 + c->h;
    } else {
        qx0 = c->x0; qy0 = c->y0;
        qx1 = c->x0 + c->w; qy1 = c->y0 + c->h;
    }
    qx0 -= 2; qy0 -= 2; qx1 += 2; qy1 += 2;
    gw = qx1 - qx0;
    gh = qy1 - qy0;
    if (gw > GS || gh > GS)
        return;
    memset(gcol, 0, (size_t)(gw * gh));
    for (y = qy0; y < qy1; y++)
        for (x = qx0; x < qx1; x++) {
            uint8_t col = 0;
            if (tw) {
                if (x >= 0 && y >= 0 && x < tw->w && y < tw->h)
                    col = tw->pix[y * tw->w + x];
            } else if (!morph) {
                inside_at(c, x, y, &col);
            } else {
                float d = (float)((1.0 - al) * sdf_at(p, x, y) + al * sdf_at(c, x, y));
                if (d >= 0)
                    continue;
                if (al >= 0.5) {
                    if (!inside_at(c, x, y, &col) && !inside_at(p, x, y, &col))
                        col = near_color(c, x, y);
                } else {
                    if (!inside_at(p, x, y, &col) && !inside_at(c, x, y, &col))
                        col = near_color(p, x, y);
                }
            }
            gcol[(y - qy0) * gw + (x - qx0)] = col;
        }

    /* 빨랫줄에 매달린 고양이, 방 안과 첫 화면의 고양이는 배경과 구별되게 한 점 테두리 */
    if (a->key == 0x10000u &&
        (actor_title || cat_on_clothesline() || (room != ROOM_ALLEY && theme_room == room))) {
        static uint8_t line_col;
        if (!line_col)
            line_col = nearest_pal(44, 42, 52);
        for (y = 0; y < gh; y++)
            for (x = 0; x < gw; x++) {
                int sx = bx + qx0 + x, sy = by + qy0 + y;
                if (gcol[y * gw + x] || sx < 0 || sx >= W || sy < 0 || sy >= H)
                    continue;
                if ((x > 0 && gcol[y * gw + x - 1]) || (x < gw - 1 && gcol[y * gw + x + 1]) ||
                    (y > 0 && gcol[(y - 1) * gw + x]) || (y < gh - 1 && gcol[(y + 1) * gw + x]))
                    frame[sy * W + sx] = line_col;
            }
    }
    for (y = 0; y < gh; y++)
        for (x = 0; x < gw; x++) {
            int sx = bx + qx0 + x, sy = by + qy0 + y;
            if (gcol[y * gw + x] && sx >= 0 && sx < W && sy >= 0 && sy < H)
                frame[sy * W + sx] = gcol[y * gw + x];
        }
    a->dx0 = bx + qx0 - 1; a->dy0 = by + qy0 - 1;      /* 테두리까지 */
    a->dx1 = bx + qx1 + 1; a->dy1 = by + qy1 + 1;
}

/* ---------------------------------------------------------------------------
 *  화면을 합치기 전에: 이번에 배우 때문에 다시 칠해야 할 사각형 (바뀐 곳만 칠한다)
 *  지난 프레임에 그린 자리와, 이번에 그릴 만한 자리(보이는 자리와 실제 자리 사이)를
 *  모두 넣는다.
 * ------------------------------------------------------------------------- */
void actor_prepare(double now)
{
    int i, y;

    for (i = 0; i < 3; i++) {
        band_t *b = &bands[i];
        if (theme_room == ROOM_ALLEY && b->dt > 0 && b->t > 0 &&
            now - b->t < b->dt * 1.1 + 34000.0)
            for (y = b->y0; y < b->y0 + 16; y++)
                vram_dirty_span(y, 0, W - 1);       /* 흐르는 빨랫줄 띠 */
    }
    for (i = 0; i < MAX_ACT; i++) {
        actor_t *a = &actors[i];
        int bx0, by0, bx1, by1;

        if (!a->used)
            continue;
        if (a->dx1 >= a->dx0)                       /* 지난 프레임에 그린 자리 */
            for (y = a->dy0; y <= a->dy1; y++)
                vram_dirty_span(y, a->dx0, a->dx1);
        if (!a->count && !(!a->raw && a->cur.n && now - a->t_gone < GRACE))
            continue;
        if (a->raw) {
            bx0 = a->bx0; by0 = a->by0;
            bx1 = a->bx1; by1 = a->by1;
        } else {
            snap_t *c = &a->cur, *p = &a->prev;
            double lo = a->dispx < c->ax ? a->dispx : c->ax;
            double hi = a->dispx > c->ax ? a->dispx : c->ax;
            double vlo = a->dispy < c->ay ? a->dispy : c->ay;
            double vhi = a->dispy > c->ay ? a->dispy : c->ay;
            int sx0 = c->x0, sy0 = c->y0, sx1 = c->x0 + c->w, sy1 = c->y0 + c->h;
            if (p->n) {
                if (p->x0 < sx0) sx0 = p->x0;
                if (p->y0 < sy0) sy0 = p->y0;
                if (p->x0 + p->w > sx1) sx1 = p->x0 + p->w;
                if (p->y0 + p->h > sy1) sy1 = p->y0 + p->h;
            }
            bx0 = (int)lo + sx0 - 4;
            by0 = (int)vlo + sy0 - 4;
            bx1 = (int)hi + sx1 + 4;
            by1 = (int)vhi + sy1 + 4;
        }
        if (bx1 < bx0)
            continue;
        if (by0 < 0) by0 = 0;
        if (by1 > H - 1) by1 = H - 1;
        for (y = by0; y <= by1; y++)
            vram_dirty_span(y, bx0, bx1);
    }
}

void actor_compose(uint8_t *frame, double now)
{
    int order[MAX_ACT], n = 0, i, j;

    compose_bands(frame, now);
    for (i = 0; i < MAX_ACT; i++) {
        actor_t *a = &actors[i];
        /* 지웠다 다시 그리는 사이(원판의 깜빡임)에는 앞 모양을 계속 보여 준다 */
        if (a->used && (a->count || (!a->raw && a->cur.n && now - a->t_gone < GRACE)))
            order[n++] = i;
    }
    /* 그린 순서대로 (나중에 그린 것이 위) */
    for (i = 1; i < n; i++)
        for (j = i; j > 0 && actors[order[j - 1]].seq > actors[order[j]].seq; j--) {
            int t = order[j];
            order[j] = order[j - 1];
            order[j - 1] = t;
        }
    for (i = 0; i < MAX_ACT; i++)
        if (actors[i].used)
            actors[i].dx1 = actors[i].dy1 = -1;
    for (i = 0; i < n; i++)
        compose_actor(frame, now, order[i]);
    busy_check(now);
}
