/* ============================================================================
 *  sys_dos.c  -  도스(djgpp) 플랫폼: 원본이 하드웨어를 만지던 곳
 * ----------------------------------------------------------------------------
 *  키보드   원본은 INT 9 를 가로채 포트 60h 를 직접 읽고 키 22개의 상태와
 *           누른 횟수만 기록했다 (BIOS 키 버퍼로 넘기지 않는다).  같은 일을
 *           보호 모드 인터럽트 처리기로 한다.  Ctrl-Alt-Del 로 재부팅하던 것은
 *           도스로 나가게 바꿨다.
 *  시계     BIOS 틱(0040:006C)을 그대로 읽고 쓴다.
 *  타이머 0 원본은 BIOS 가 둔 모드 3 카운터를 읽어 짧은 시간을 쟀다.  djgpp 의
 *           sys_uclock() 은 카운터를 모드 2 로 바꾸므로, uclock 으로 잰 시간에서
 *           모드 3 카운터 값을 계산해 돌려준다.
 *  수직 귀선  VGA 포트 3DAh 를 그대로 읽고, 화면이 바뀌었으면 이때 내보낸다.
 *  스피커, 게임 포트  포트를 그대로.
 *  8088 빈 루프  "loop $" 한 바퀴 = 17 클럭 / 4.77MHz = 3.56 마이크로초.
 * ========================================================================== */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <bios.h>
#include <crt0.h>
#include <dpmi.h>
#include <go32.h>
#include <pc.h>
#include <time.h>
#include <sys/exceptn.h>
#include <sys/farptr.h>

#include "allycat.h"
#include "platform.h"

/* 인터럽트 처리기가 건드리는 메모리를 스왑되지 않게 전부 잠근다 */
int _crt0_startup_flags = _CRT0_FLAG_LOCK_MEMORY;


/* ---------------------------------------------------------------------------
 *  늘 앞으로만 가는 시계.  게임이 BIOS 시계(0040:006C)를 되돌리면(일시정지를 풀 때)
 *  djgpp 의 uclock() 은 뒤로 가거나 자정을 넘긴 줄 알고 하루를 건너뛴다.  그 차이를
 *  빼 주지 않으면 속도 맞추기, 화면 내보내기, 부드러운 움직임, 음악이 모두 어긋난다.
 * ------------------------------------------------------------------------- */
static uclock_t clock_adjust;
static uclock_t now_cached;

uclock_t sys_uclock(void)
{
    now_cached = uclock() + clock_adjust;
    return now_cached;
}

/* 고리 한 바퀴 안에서는 시계를 한 번만 읽는다 (타이머 포트를 읽는 값비싼 일이다).
   음악과 화면 내보내기는 이 값을 쓴다. */
uclock_t sys_now(void)
{
    return now_cached;
}

static _go32_dpmi_seginfo old_int9, new_int9;
static int keyboard_installed;
static volatile int keyboard_ready;     /* 키 표를 초기화한 뒤 (첫 키 누름부터) */
static uclock_t last_present;
static uclock_t present_gap;    /* 화면을 다시 내보내기까지 최소 시간 (그리기 값만큼) */
static uint8_t font[256 * 8];

/* ---------------------------------------------------------------------------
 *  원래: 14B3  키보드 인터럽트
 * ------------------------------------------------------------------------- */
static void keyboard_isr(void)
{
    uint8_t code = inportb(0x60), make = code & 0x7F, v;
    int i;

    if (!(code & 0x80)) {
        key_count++;
        keyboard_ready = 1;
    }
    for (i = 0; i < KEY_COUNT; i++) {
        if (DB(KEY_SCANCODES + i) == make) {
            key_state(i) = code & 0x80;
            break;
        }
    }
    v = inportb(0x61);                  /* XT 키보드 확인 */
    outportb(0x61, v | 0x80);
    outportb(0x61, v);
    outportb(0x20, 0x20);
    if (code == 0x53 && keyboard_ready && KEY_DOWN(KEY_CTRL) && KEY_DOWN(KEY_ALT))
        quit_requested = 1;             /* 원본은 여기서 재부팅했다 */
#ifdef CATVGA
    if ((code == 0x10 || code == 0x2D) && keyboard_ready && KEY_DOWN(KEY_CTRL))
        quit_requested = 1;             /* 개선판: Ctrl-Q, Ctrl-X 는 언제든 끝내기 */
    if (code >= 0x02 && code <= 0x08 && KEY_DOWN(KEY_ALT))
        warp_room = code - 1;           /* 개선판: Alt+1..7 은 그 방으로 */
#endif
}

void sys_install_keyboard(void)
{
    if (keyboard_installed)
        return;
    _go32_dpmi_get_protected_mode_interrupt_vector(9, &old_int9);
    new_int9.pm_offset = (unsigned long)keyboard_isr;
    new_int9.pm_selector = _go32_my_cs();
    _go32_dpmi_allocate_iret_wrapper(&new_int9);
    _go32_dpmi_set_protected_mode_interrupt_vector(9, &new_int9);
    keyboard_installed = 1;
}

void sys_remove_keyboard(void)
{
    if (!keyboard_installed)
        return;
    keyboard_installed = 0;
    _go32_dpmi_set_protected_mode_interrupt_vector(9, &old_int9);
    _go32_dpmi_free_iret_wrapper(&new_int9);
}

static void shutdown(void)
{
    union REGS r;

    sys_remove_keyboard();
    outportb(0x61, inportb(0x61) & 0xFC);
    video_close();
    r.x.ax = 0x0003;
    int86(0x10, &r, &r);
}

void sys_exit(void)
{
    shutdown();
    exit(0);
}

#ifdef CAT_TEST
/* ---------------------------------------------------------------------------
 *  시험판 (-DCAT_TEST): ALLEYTST.TXT 의 줄을 시간 순서대로 실행한다.
 *      <초> down|up <키>      키 (tools/emu.py 와 같은 이름, 표에 없는 키는 누른 횟수만)
 *      <초> shot <이름>       화면을 <이름>.BMP 로
 *      <초> quit
 * ------------------------------------------------------------------------- */
static const char *const TEST_KEYS[KEY_COUNT] = { "alt", "up", "right", "down", "left",
    "pgup", "pgdn", "end", "home", "esc", "y", "n", "k", "h", "t", "a", "s", "r", "ctrl",
    "del", "m", "9" };
static FILE *test_file;
static uclock_t test_start;
static double test_next = -1;
static char test_line[128];
/* 검수: 키를 누른 뒤 고양이가 움직일 때까지, 화면 내보내기에 걸린 시간 */
static uclock_t lat_t;
static unsigned lat_x, lat_y;
static uclock_t pres_sum, pres_max;
static unsigned long pres_n;
static unsigned long svc_n, wait_n;
static int test_full;           /* 시험: 늘 화면 전체를 다시 칠한다 (옛 방식 재기) */      /* 고리 바퀴 수, 8088 시간을 기다린 횟수 */

static void test_log(const char *fmt, double a, double b, double c)
{
    FILE *lg = fopen("alleylog.txt", "a");
    if (lg) {
        fprintf(lg, fmt, a, b, c);
        fclose(lg);
    }
}

static void test_latency(void)
{
    if (lat_t && (cat_x != lat_x || cat_y != lat_y)) {
        test_log("key->move %.1f ms x=%.0f y=%.0f\n", (double)(sys_uclock() - lat_t) * 1000.0 / UCLOCKS_PER_SEC,
                 (double)cat_x, (double)cat_y);
        lat_t = 0;
    }
}

static void test_poll(void)
{
    char cmd[16], arg[64];
    double now;
    int k;

    if (!test_file)
        return;
    now = (double)(sys_uclock() - test_start) / UCLOCKS_PER_SEC;
    for (;;) {
        if (test_next < 0) {
            if (!fgets(test_line, sizeof test_line, test_file)) {
                fclose(test_file);
                test_file = NULL;
                return;
            }
            if (sscanf(test_line, "%lf", &test_next) != 1) {
                test_next = -1;
                continue;
            }
        }
        if (now < test_next)
            return;
        test_next = -1;
        arg[0] = 0;
        if (sscanf(test_line, "%*f %15s %63s", cmd, arg) < 1)
            continue;
        if (!strcmp(cmd, "down") || !strcmp(cmd, "up")) {
            for (k = 0; k < KEY_COUNT && strcmp(arg, TEST_KEYS[k]); k++)
                ;
            if (cmd[0] == 'd') {
                if (k >= 1 && k <= 8) {
                    lat_t = sys_uclock();
                    lat_x = cat_x;
                    lat_y = cat_y;
                }
                key_count++;
                if (k < KEY_COUNT)
                    key_state(k) = 0;
            } else if (k < KEY_COUNT) {
                key_state(k) = 0x80;
            }
        } else if (!strcmp(cmd, "shot")) {
            video_present();
            video_dump(arg);
        } else if (!strcmp(cmd, "shown")) {
            video_dump(arg);                    /* 마지막으로 내보낸 화면 그대로 */
#ifdef CATVGA
        } else if (!strcmp(cmd, "warp")) {
            warp_room = atoi(arg);
#endif
        } else if (!strcmp(cmd, "poke")) {
            unsigned off, val;
            if (sscanf(test_line, "%*f %*s %x %x", &off, &val) == 2)
                DB(off) = (uint8_t)val;
        } else if (!strcmp(cmd, "full")) {
            test_full = 1;
        } else if (!strcmp(cmd, "log")) {
            FILE *lg = fopen("alleylog.txt", "a");
            if (lg) {
                fprintf(lg, "%.3f cat_x=%u cat_y=%u room=%u lives=%u\n", now, cat_x, cat_y, room, lives);
                fclose(lg);
            }
        } else if (!strcmp(cmd, "quit")) {
            if (pres_n)
                test_log("present n=%.0f avg %.2f ms max %.2f ms\n", (double)pres_n,
                         (double)pres_sum * 1000.0 / UCLOCKS_PER_SEC / pres_n,
                         (double)pres_max * 1000.0 / UCLOCKS_PER_SEC);
            test_log("loop n=%.0f wait %.0f%% 8088시간 %.0f ms\n", (double)svc_n,
                     svc_n ? 100.0 * wait_n / svc_n : 0.0,
                     (double)cpu_clocks * 1000.0 / 4772727.0);
            sys_exit();
        }
    }
}
#else
#define test_poll()
#define test_latency()
#endif

/* ---------------------------------------------------------------------------
 *  8088 속도 맞추기
 *  원판은 빠른 PC 에서 너무 빨라진다 (고양이는 시계 한 틱 안에서도 고리를 32번
 *  돌 때마다 한 번 더 움직인다).  그래서 원판이 IBM PC 에서 썼을 시간을
 *  cpu_clocks 로 세어 두고, 하드웨어를 만지는 곳(사건)마다 실제 시간이 그만큼
 *  흐를 때까지 기다린다.  사건과 사건 사이의 그리기 밖 시간은 사건 종류에 따라
 *  원본을 재서 얻은 값(tools/cpucost.py, 4분위 75% 쯤)을 쓴다.
 * ------------------------------------------------------------------------- */
enum { EV_TICK, EV_RETRACE, EV_PIT, EV_IDLE };
static const unsigned base_cost[4][4] = {
    /*  -> tick  retrace  pit  idle      (이전 사건) */
    {    600,    145,  650,  142 },     /* tick */
    {    500,    165,  300,  300 },     /* retrace */
    {    400,    317,  128,  300 },     /* pit */
    {   1062,    300,  300,   29 },     /* idle */
};
static int pace_last = EV_TICK;
static unsigned long pace_clocks;
static uclock_t pace_target;

static void pace_wait(void)
{
    unsigned long d = cpu_clocks - pace_clocks;
    uclock_t now = sys_uclock();

    pace_clocks = cpu_clocks;
    pace_target += d >> 2;              /* 8088 클럭 / 4 = 타이머 눈금 (1.193MHz) */
    if (now > pace_target + UCLOCKS_PER_SEC / 20) {
        pace_target = now;                      /* 50ms 넘게 뒤졌으면 따라잡지 않는다 */
        return;
    }
#ifdef CAT_TEST
    if (now < pace_target)
        wait_n++;
#endif
    while (now < pace_target) {
        extra_poll();
        now = sys_uclock();
    }
}

static void pace(int kind)
{
    CPU(base_cost[pace_last][kind]);
    pace_last = kind;
    pace_wait();
}

/* 기다리는 곳마다: 화면 내보내기, 음악, Ctrl-Alt-Del */
static void service(int in_retrace)
{
    uclock_t now = sys_now();           /* pace() 가 방금 읽었다 */

#ifdef CAT_TEST
    svc_n++;
#endif

    if (quit_requested)
        sys_exit();
    test_poll();
    extra_poll();
#ifdef CATVGA
    {
        /* 고양이와 불독의 사이 동작 (actor.c): 시각을 넣고, 움직이는 동안은 계속 내보낸다 */
        extern double actor_clock;
        int actor_busy(double now);
        actor_clock = (double)now * 1000000.0 / UCLOCKS_PER_SEC;
        if (actor_busy(actor_clock))
            vram_dirty = 1;
    }
#endif
    /* 느린 기계(486 등)에서 그리기가 게임을 늦추지 않게: 게임이 8088 시간보다
       뒤처지지 않았을 때만 그린다 (뒤처졌으면 게임이 먼저 따라잡는다).
       그래도 0.1초마다 한 장은 그린다. */
    if (vram_dirty && now - last_present >= present_gap &&
        (now < pace_target + UCLOCKS_PER_SEC / 100 || now - last_present > UCLOCKS_PER_SEC / 10) &&
        (in_retrace || now - last_present > UCLOCKS_PER_SEC / 60)) {
        uclock_t cost;

        vram_dirty = 0;
        last_present = now;
#if defined(CAT_TEST) && defined(CATVGA)
        if (test_full)
            vram_dirty_all();
#endif
        video_present();
        cost = sys_uclock() - now;
        present_gap = (present_gap * 3 + cost) / 4;
#ifdef CATVGA
        /* 한 장 그리는 데 오래 걸리는 기계(486 등)에서는 모양 섞기를 건너뛴다 */
        actor_fast = present_gap > UCLOCKS_PER_SEC / 90;
#endif
        if (present_gap > UCLOCKS_PER_SEC / 20)
            present_gap = UCLOCKS_PER_SEC / 20;
#ifdef CAT_TEST
        {
            uclock_t d = sys_uclock() - now;
            pres_sum += d;
            pres_n++;
            if (d > pres_max)
                pres_max = d;
        }
#endif
    }
    test_latency();
}

/* ---- 시계 ------------------------------------------------------------------ */
uint32_t sys_ticks(void)
{
    pace(EV_TICK);
    service(0);
    return _farpeekl(_dos_ds, 0x46C);
}

void sys_set_ticks(uint32_t t)
{
    uclock_t before = sys_uclock();

    _farpokel(_dos_ds, 0x46C, t);
    clock_adjust += before - sys_uclock();      /* 시계는 멈춘 것처럼 이어 간다 */
}

int sys_in_retrace(void)
{
    int r;

    pace(EV_RETRACE);
    r = (inportb(0x3DA) & 8) != 0;
    service(r);
    return r;
}

uint16_t sys_pit_counter_raw(void)
{
    /* 모드 3: 한 틱(65536) 동안 두 번 내려간다 -> 1193182Hz 에 2씩 */
    uint32_t n;
    uint16_t cnt;

    pace(EV_PIT);
    n = (uint32_t)((sys_uclock() * 1193182ULL / UCLOCKS_PER_SEC) * 2);
    cnt = (uint16_t)(0x10000 - (n & 0xFFFF));
    return (uint16_t)(((cnt & 0xFF) << 8) | (cnt >> 8));
}

void sys_idle(void)
{
    pace(EV_IDLE);
    service(0);
    __dpmi_yield();
}

void sys_cpu_loop(unsigned n)
{
    CPU(n * 17);
    pace_wait();
}

/* ---- 포트 ------------------------------------------------------------------ */
uint8_t sys_in61(void)          { return inportb(0x61); }
void sys_out61(uint8_t v)       { outportb(0x61, v); }
void sys_out42(uint8_t v)       { outportb(0x42, v); }
void sys_out43(uint8_t v)       { outportb(0x43, v); }
uint8_t sys_in201(void)         { return inportb(0x201); }
void sys_out201(void)           { outportb(0x201, 0); }
uint16_t sys_equipment(void)    { return (uint16_t)biosequip(); }
uint8_t sys_machine_model(void) { return 0xFF; }        /* IBM PC 로 친다 */

const uint8_t *sys_font8x8(void)
{
    return font;
}

void sys_cga_port_changed(void)
{
    video_palette_changed();
#ifdef CATVGA
    vram_dirty_all();                   /* 바탕색이 바뀌었다: 화면 전체를 다시 */
#endif
    vram_dirty = 1;
}

/* BIOS 8x8 글꼴 (int 10h AX=1130h, BH=3: 0..127) */
static void load_font(void)
{
    __dpmi_regs r;
    unsigned long addr;

    memset(&r, 0, sizeof r);
    r.x.ax = 0x1130;
    r.h.bh = 3;
    __dpmi_int(0x10, &r);
    addr = ((unsigned long)r.x.es << 4) + r.x.bp;
    _dosmemgetb(addr, 128 * 8, font);
}

int main(int argc, char **argv)
{
    (void)argc;
    (void)argv;
#ifdef CAT_TEST
    freopen("alleyerr.txt", "w", stderr);
#endif
    __djgpp_set_ctrl_c(0);
    signal(SIGINT, SIG_IGN);
    pace_target = sys_uclock();
    load_font();
    if (!video_open()) {
        fprintf(stderr, "VGA 가 필요합니다.\n");
        return 1;
    }
    atexit(shutdown);
    extra_init();
#ifdef CAT_TEST
    test_file = fopen("alleytst.txt", "r");
    test_start = sys_uclock();
#endif
    game_main();
    return 0;
}
