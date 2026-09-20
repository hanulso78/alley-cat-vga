/* ============================================================================
 *  hosttest.c  -  원판 대조 시험용 플랫폼 (PC 에서 바로 돌린다)
 * ----------------------------------------------------------------------------
 *  tools/emu.py (unicorn 으로 원본 ALLYCAT.EXE 를 돌리는 것) 와 똑같은 규칙으로
 *  가상 시간을 흘려서, 사건(시계, 3DAh, PIT, 키 기다림)마다 데이터 세그먼트와
 *  화면 메모리의 CRC 를 원본의 기록(trace)과 맞춰 본다.
 *
 *      hosttest script.txt trace.bin font.bin [덤프 폴더]
 *
 *  다르면 처음 다른 사건 번호를 찍고 ds.bin, vram.bin 을 덤프 폴더에 남긴다.
 * ========================================================================== */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../allycat.h"
#ifdef CATVGA
#include "../col256.h"

/* 미리보기에는 음악이 없다 */
void music_play(int song, int restart) { (void)song; (void)restart; }
void music_stop(void) { }
void music_pause(int on) { (void)on; }
#endif

#define TICK_US 54925

static uint64_t vtime;
static uint32_t events;
static int64_t tick_base;
static uint8_t port61;
static uint8_t font[256 * 8];

static struct { uint64_t t; int cmd; int key; unsigned off, val; char name[32]; } script[65536];
static int script_n, script_i;

static FILE *trace;
static const char *dump_dir = ".";

static const char *KEYS[] = { "alt", "up", "right", "down", "left", "pgup", "pgdn", "end",
    "home", "esc", "y", "n", "k", "h", "t", "a", "s", "r", "ctrl", "del", "m", "9" };

static uint32_t crc_table[256];

static void crc_init(void)
{
    uint32_t c;
    int n, k;
    for (n = 0; n < 256; n++) {
        c = (uint32_t)n;
        for (k = 0; k < 8; k++)
            c = (c & 1) ? 0xEDB88320u ^ (c >> 1) : c >> 1;
        crc_table[n] = c;
    }
}

static uint32_t crc32(uint32_t crc, const uint8_t *p, size_t n)
{
    crc = ~crc;
    while (n--)
        crc = crc_table[(crc ^ *p++) & 0xFF] ^ (crc >> 8);
    return ~crc;
}

/* 원본에만 있는 임시 변수 (C 판은 지역 변수로 썼다) - 비교하지 않는다 */
static const struct { uint16_t from, to; } IGNORE[] = {
    { 0x2AC7, 0x2AD0 }, { 0x2AE0, 0x2AE4 }, { 0x2AE9, 0x2AEB }, { 0x3287, 0x3289 },
};

uint32_t state_crc(void)
{
    static uint8_t buf[DS_IMAGE_SIZE];
    uint32_t c;
    size_t i;

    memcpy(buf, ds, DS_IMAGE_SIZE);
    for (i = 0; i < sizeof IGNORE / sizeof IGNORE[0]; i++)
        memset(buf + IGNORE[i].from, 0, IGNORE[i].to - IGNORE[i].from + 1);
    c = crc32(0, buf, DS_IMAGE_SIZE);
    c = crc32(c, vram, VRAM_SIZE);
    c = crc32(c, &cga_color_select, 1);
    return c;
}

static void dump(void)
{
    char fn[512];
    FILE *f;

    snprintf(fn, sizeof fn, "%s/c_ds.bin", dump_dir);
    f = fopen(fn, "wb"); fwrite(ds, 1, 0x10000, f); fclose(f);
    snprintf(fn, sizeof fn, "%s/c_vram.bin", dump_dir);
    f = fopen(fn, "wb"); fwrite(vram, 1, VRAM_SIZE, f); fclose(f);
}

static void apply(int i)
{
    int k = script[i].key;

#ifdef CATVGA
    if (script[i].cmd == 's') {
        static uint8_t frame[64000];
        char fn[512];
        FILE *f;
        int y, x;

        col256_update_cga();
        col256_compose(frame);
        snprintf(fn, sizeof fn, "%s/%s.ppm", dump_dir, script[i].name);
        f = fopen(fn, "wb");
        fprintf(f, "P6 320 200 255\n");
        for (y = 0; y < 200; y++)
            for (x = 0; x < 320; x++) {
                const uint8_t *c = pal256[frame[y * 320 + x]];
                fputc(c[0] * 255 / 63, f); fputc(c[1] * 255 / 63, f); fputc(c[2] * 255 / 63, f);
            }
        fclose(f);
        return;
    }
#endif
    if (script[i].cmd == 'q') {
        printf("quit at event %u\n", events);
        exit(0);
    }
    if (script[i].cmd == 'p') {
        DB(script[i].off) = (uint8_t)script[i].val;
        return;
    }
    if (script[i].cmd == 'w') {
        DW(script[i].off) = (uint16_t)script[i].val;
        return;
    }
    if (script[i].cmd == 'd') {
        key_count++;
        if (k >= 0)
            key_state(k) = 0;
    } else if (k >= 0) {
        key_state(k) = 0x80;
    }
}

static void advance(unsigned us, int kind)
{
    uint8_t rec[5];
    uint32_t want, have;

    vtime += us;
    events++;
    while (script_i < script_n && script[script_i].t <= vtime)
        apply(script_i++);
#ifdef CATVGA
    (void)rec; (void)want; (void)have;
    return;
#endif
    if (fread(rec, 1, 5, trace) != 5) {
        printf("trace end: %u events all matched\n", events - 1);
        exit(0);
    }
    want = rec[1] | rec[2] << 8 | rec[3] << 16 | (uint32_t)rec[4] << 24;
    have = state_crc();
    if (rec[0] != kind || want != have) {
        printf("MISMATCH at event %u: kind %d (want %d), crc %08X (want %08X)\n",
               events, kind, rec[0], have, want);
        dump();
        exit(1);
    }
}

uint32_t sys_ticks(void)
{
    advance(1000, 1);
    return (uint32_t)(vtime / TICK_US + tick_base);
}

void sys_set_ticks(uint32_t t)
{
    tick_base = (int64_t)t - (int64_t)(vtime / TICK_US);
}

int sys_in_retrace(void)
{
    advance(200, 2);
    return (vtime % 16667) < 1500;
}

uint16_t sys_pit_counter_raw(void)
{
    uint16_t cnt;

    advance(20, 3);
    cnt = (uint16_t)(0x10000 - (vtime * 1193182 / 1000000) % 0x10000);
    return (uint16_t)(((cnt & 0xFF) << 8) | (cnt >> 8));
}

void sys_idle(void)                 { advance(1000, 4); }
uint8_t sys_in61(void)              { return port61; }
void sys_out61(uint8_t v)           { port61 = v; }
void sys_out42(uint8_t v)           { (void)v; }
void sys_out43(uint8_t v)           { (void)v; }
uint8_t sys_in201(void)             { return 0xF0; }
void sys_out201(void)               { }
void sys_cpu_loop(unsigned n)       { (void)n; }
uint16_t sys_equipment(void)        { return 0x0021; }
uint8_t sys_machine_model(void)     { return 0xFF; }
void sys_install_keyboard(void)     { }
void sys_remove_keyboard(void)      { }
void sys_exit(void)                 { printf("exit at event %u\n", events); exit(0); }
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
        if (!strcmp(cmd, "shot")) {
#ifdef CATVGA
            script[script_n].t = (uint64_t)(sec * 1000000.0 + 0.5);
            script[script_n].cmd = 's';
            script[script_n].key = -1;
            snprintf(script[script_n].name, sizeof script[script_n].name, "%s", arg);
            script_n++;
#endif
            continue;
        }
        script[script_n].t = (uint64_t)(sec * 1000000.0 + 0.5);
        if (!strcmp(cmd, "poke") || !strcmp(cmd, "pokew")) {
            sscanf(line, "%lf %31s %x %x", &sec, cmd, &off, &val);
            script[script_n].cmd = cmd[4] == 'w' ? 'w' : 'p';
            script[script_n].off = off;
            script[script_n].val = val;
            script[script_n].key = -1;
            script_n++;
            continue;
        }
        script[script_n].cmd = cmd[0] == 'd' ? 'd' : cmd[0] == 'u' ? 'u' : 'q';
        script[script_n].key = -1;
        for (k = 0; k < KEY_COUNT; k++)
            if (!strcmp(arg, KEYS[k]))
                script[script_n].key = k;
        script_n++;
    }
    fclose(f);
}

int main(int argc, char **argv)
{
    FILE *f;

    if (argc < 4) {
        fprintf(stderr, "hosttest script trace font [dumpdir]\n");
        return 2;
    }
    crc_init();
    load_script(argv[1]);
#ifdef CATVGA
    col256_load(argv[2]);               /* 미리보기: 두 번째 인자는 ALLEY256.SPR */
    trace = stdin;
#else
    trace = fopen(argv[2], "rb");
#endif
    f = fopen(argv[3], "rb");
    if (!trace || !f) { perror("open"); return 2; }
    fread(font, 1, sizeof font, f);
    fclose(f);
    if (argc > 4)
        dump_dir = argv[4];
    game_main();
    return 0;
}
