/* ============================================================================
 *  movie.c  -  개선판(ALLEYVGA)을 PC 에서 돌려 플레이 영상 재료를 만든다
 * ----------------------------------------------------------------------------
 *  도스 판(sys_dos.c)처럼 원판이 IBM PC(8088 4.77MHz)에서 썼을 시간(cpu_clocks)을
 *  그대로 가상 시간으로 쓴다.  그래서 게임 속도, 효과음 높이가 실제 PC 와 같다.
 *
 *      movie plan   script spr font snaps.bin t1,t2,...
 *          화면 없이 돌리고, 적은 시각마다 데이터 세그먼트를 snaps.bin 에 남긴다
 *          (tools/movieplay.py 가 입력을 찾을 때 쓴다)
 *      movie render script spr font frames.raw events.bin
 *          60fps 로 320x200 RGB 를 frames.raw 에, 스피커 포트와 음악 사건을
 *          events.bin 에 쓴다 (tools/audiomix.c 가 소리로 만든다)
 *
 *  스크립트는 hosttest 와 같다:  초 down|up 키 / poke 자리 값 / quit
 * ========================================================================== */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <io.h>
#include <fcntl.h>
#include "../allycat.h"
#include "../col256.h"

#define TICK_US     54925.0
#define CPU_HZ      4772727.0

static double vtime;                    /* 마이크로초 */
extern double actor_clock;
static int64_t tick_base;
static uint8_t port61;
static uint8_t font[256 * 8];
static int rendering;

static struct { double t; int cmd; int key; unsigned off, val; } script[200000];
static int script_n, script_i;

static const char *KEYS[] = { "alt", "up", "right", "down", "left", "pgup", "pgdn", "end",
    "home", "esc", "y", "n", "k", "h", "t", "a", "s", "r", "ctrl", "del", "m", "9" };

/* ---- plan: 스냅샷 ---- */
static double snap_t[4096];
static int snap_n, snap_i;
static FILE *snap_f;

/* ---- render: 화면과 사건 ---- */
static FILE *frame_f, *event_f;
static double next_frame;
#define FRAME_US    (1000000.0 / 60.0)

static void log_event(int kind, int a, int b)
{
    double t = vtime;
    int16_t v[2];

    if (!event_f)
        return;
    v[0] = (int16_t)a;
    v[1] = (int16_t)b;
    fwrite(&t, sizeof t, 1, event_f);
    fputc(kind, event_f);
    fwrite(v, sizeof v[0], 2, event_f);
}

void music_play(int song, int restart) { log_event('M', song, restart); }
void music_stop(void)                  { log_event('M', SONG_NONE, 1); }
void music_pause(int on)               { log_event('P', on, 0); }

static void emit_frame(void)
{
    static uint8_t frame[64000], rgb[64000 * 3];
    int i;

    col256_update_cga();
    if (getenv("MOVIE_FULL"))
        vram_dirty_all();               /* 검수: 늘 화면 전체를 칠한 것과 대조 */
    col256_compose(frame);
    for (i = 0; i < 64000; i++) {
        const uint8_t *c = pal256[frame[i]];
        rgb[i * 3] = (uint8_t)(c[0] * 255 / 63);
        rgb[i * 3 + 1] = (uint8_t)(c[1] * 255 / 63);
        rgb[i * 3 + 2] = (uint8_t)(c[2] * 255 / 63);
    }
    fwrite(rgb, 1, sizeof rgb, frame_f);
}

/* plan 에서 MOVIE_SHOTS=폴더 를 주면 스냅샷 때마다 화면도 PPM 으로 */
static const char *shot_dir;

static void write_shot(double t)
{
    static uint8_t frame[64000];
    char fn[512];
    FILE *f;
    int i;

    col256_update_cga();
    col256_compose(frame);
    snprintf(fn, sizeof fn, "%s/%09.4f.ppm", shot_dir, t);
    f = fopen(fn, "wb");
    if (!f)
        return;
    fprintf(f, "P6 320 200 255\n");
    for (i = 0; i < 64000; i++) {
        const uint8_t *c = pal256[frame[i]];
        fputc(c[0] * 255 / 63, f); fputc(c[1] * 255 / 63, f); fputc(c[2] * 255 / 63, f);
    }
    fclose(f);
}

static void finish(void)
{
    if (frame_f)
        fclose(frame_f);
    if (event_f)
        fclose(event_f);
    if (snap_f)
        fclose(snap_f);
    exit(0);
}

static void apply(int i)
{
    int k = script[i].key;

    switch (script[i].cmd) {
    case 'q':
        finish();
        break;
    case 'p':
        DB(script[i].off) = (uint8_t)script[i].val;
        break;
    case 'w':
        DW(script[i].off) = (uint16_t)script[i].val;
        break;
    case 'd':
        key_count++;
        if (k >= 0)
            key_state(k) = 0;
        break;
    case 'u':
        if (k >= 0)
            key_state(k) = 0x80;
        break;
    }
}

/* 8088 에서 사건 사이에 쓴 시간 (sys_dos.c 와 같은 표) */
enum { EV_TICK, EV_RETRACE, EV_PIT, EV_IDLE };
static const unsigned base_cost[4][4] = {
    {    600,    145,  650,  142 },
    {    500,    165,  300,  300 },
    {    400,    317,  128,  300 },
    {   1062,    300,  300,   29 },
};
static int last_kind = EV_TICK;

static void sync_time(void)
{
    static unsigned long last_clocks;
    unsigned long d = cpu_clocks - last_clocks;

    last_clocks = cpu_clocks;
    vtime += (double)d * 1000000.0 / CPU_HZ;
    actor_clock = vtime;
    while (script_i < script_n && script[script_i].t <= vtime)
        apply(script_i++);
    while (snap_i < snap_n && snap_t[snap_i] * 1000000.0 <= vtime) {
        double t = snap_t[snap_i++];
        fwrite(&t, sizeof t, 1, snap_f);
        fwrite(ds, 1, DS_IMAGE_SIZE, snap_f);
        if (shot_dir)
            write_shot(t);
    }
    if (rendering)
        while (next_frame <= vtime) {
            emit_frame();
            next_frame += FRAME_US;
        }
}

static void advance(int kind)
{
    CPU(base_cost[last_kind][kind]);
    last_kind = kind;
    sync_time();
}

uint32_t sys_ticks(void)
{
    advance(EV_TICK);
    return (uint32_t)((int64_t)(vtime / TICK_US) + tick_base);
}

void sys_set_ticks(uint32_t t)
{
    tick_base = (int64_t)t - (int64_t)(vtime / TICK_US);
}

int sys_in_retrace(void)
{
    advance(EV_RETRACE);
    return (uint64_t)vtime % 16667 < 1500;
}

uint16_t sys_pit_counter_raw(void)
{
    uint64_t n;
    uint16_t cnt;

    advance(EV_PIT);
    n = (uint64_t)(vtime * 1193182.0 / 1000000.0) * 2;
    cnt = (uint16_t)(0x10000 - (n & 0xFFFF));
    return (uint16_t)(((cnt & 0xFF) << 8) | (cnt >> 8));
}

void sys_idle(void)                 { advance(EV_IDLE); }
void sys_cpu_loop(unsigned n)       { CPU(n * 17); sync_time(); }
uint8_t sys_in61(void)              { return port61; }
void sys_out61(uint8_t v)           { port61 = v; log_event('S', 0x61, v); }
void sys_out42(uint8_t v)           { log_event('S', 0x42, v); }
void sys_out43(uint8_t v)           { log_event('S', 0x43, v); }
uint8_t sys_in201(void)             { return 0xF0; }
void sys_out201(void)               { }
uint16_t sys_equipment(void)        { return 0x0021; }
uint8_t sys_machine_model(void)     { return 0xFF; }
void sys_install_keyboard(void)     { }
void sys_remove_keyboard(void)      { }
void sys_exit(void)                 { finish(); }
const uint8_t *sys_font8x8(void)    { return font; }
void sys_cga_port_changed(void)     { }

static void load_script(const char *fn)
{
    FILE *f = fopen(fn, "r");
    char line[256], cmd[32], arg[32];
    double sec;
    int n, k;
    unsigned off, val;

    if (!f) { perror(fn); exit(2); }
    while (fgets(line, sizeof line, f)) {
        char *h = strchr(line, '#');
        if (h) *h = 0;
        arg[0] = 0;
        n = sscanf(line, "%lf %31s %31s", &sec, cmd, arg);
        if (n < 2)
            continue;
        script[script_n].t = sec * 1000000.0;
        script[script_n].key = -1;
        if (!strcmp(cmd, "poke") || !strcmp(cmd, "pokew")) {
            sscanf(line, "%lf %31s %x %x", &sec, cmd, &off, &val);
            script[script_n].cmd = cmd[4] == 'w' ? 'w' : 'p';
            script[script_n].off = off;
            script[script_n].val = val;
        } else if (!strcmp(cmd, "down") || !strcmp(cmd, "up")) {
            script[script_n].cmd = cmd[0];
            for (k = 0; k < KEY_COUNT; k++)
                if (!strcmp(arg, KEYS[k]))
                    script[script_n].key = k;
        } else if (!strcmp(cmd, "quit")) {
            script[script_n].cmd = 'q';
        } else {
            continue;
        }
        script_n++;
    }
    fclose(f);
    /* 시각 순서로 (안정 정렬: 삽입) */
    for (n = 1; n < script_n; n++) {
        int j = n;
        while (j > 0 && script[j - 1].t > script[j].t) {
            __typeof__(script[0]) tmp = script[j];
            script[j] = script[j - 1];
            script[j - 1] = tmp;
            j--;
        }
    }
}

int main(int argc, char **argv)
{
    FILE *f;

    if (argc < 7) {
        fprintf(stderr, "movie plan script spr font snaps.bin t1,t2,...\n"
                        "movie render script spr font frames.raw events.bin\n");
        return 2;
    }
    load_script(argv[2]);
    col256_load(argv[3]);
    f = fopen(argv[4], "rb");
    if (!f) { perror(argv[4]); return 2; }
    fread(font, 1, sizeof font, f);
    fclose(f);
    if (getenv("MOVIE_TRACE")) {
        extern void *actor_trace;
        actor_trace = fopen(getenv("MOVIE_TRACE"), "w");
    }
    if (!strcmp(argv[1], "plan")) {
        char *p = argv[6];
        snap_f = fopen(argv[5], "wb");
        shot_dir = getenv("MOVIE_SHOTS");

        while (*p) {
            snap_t[snap_n++] = strtod(p, &p);
            if (*p == ',')
                p++;
            else
                break;
        }
    } else {
        rendering = 1;
        if (!strcmp(argv[5], "-")) {             /* ffmpeg 로 바로 */
            _setmode(_fileno(stdout), _O_BINARY);
            frame_f = stdout;
        } else {
            frame_f = fopen(argv[5], "wb");
        }
        event_f = fopen(argv[6], "wb");
    }
    game_main();
    finish();
    return 0;
}
