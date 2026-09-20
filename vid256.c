/* ============================================================================
 *  vid256.c  -  개선판 화면: 256색 VGA 모드 13h  -> ALLEYVGA.EXE
 * ----------------------------------------------------------------------------
 *  게임은 원판과 똑같이 CGA 메모리에 그리고, gfx.c 가 점마다 색 번호를
 *  따라가게 해 둔다 (vram_col).  여기서는 그 색 번호를 그대로 A0000 에 복사하고
 *  팔레트를 ALLEY256.SPR 의 것으로 둔다.
 * ========================================================================== */
#include <stdio.h>
#include <string.h>
#include <dos.h>
#include <go32.h>
#include <pc.h>
#include <sys/movedata.h>
#include <sys/nearptr.h>

#include "allycat.h"
#include "platform.h"
#include "col256.h"

volatile int quit_requested;
static uint8_t frame[64000];
static uint8_t *vga;            /* 가까운 포인터가 되면 A0000 에 바로 쓴다 */

static void load_dac(int from, int to)
{
    int i;

    outportb(0x3C8, from);
    for (i = from; i <= to; i++) {
        outportb(0x3C9, pal256[i][0]);
        outportb(0x3C9, pal256[i][1]);
        outportb(0x3C9, pal256[i][2]);
    }
}

int video_open(void)
{
    union REGS r;

    col256_load("alley256.spr");
    /* 화면 메모리를 가까운 포인터로 (안 되면 _dosmemputb 로 옮긴다) */
    if (__djgpp_nearptr_enable())
        vga = (uint8_t *)(0xA0000 + __djgpp_conventional_base);
    r.x.ax = 0x0013;
    int86(0x10, &r, &r);
    r.x.ax = 0x0F00;
    int86(0x10, &r, &r);
    if ((r.h.al & 0x7F) != 0x13)
        return 0;
    col256_update_cga();
    load_dac(0, 255);
    return 1;
}

void video_close(void)
{
}

void video_palette_changed(void)
{
    col256_update_cga();
    load_dac(0, 3);
}

/* 바뀐 줄 구간만 화면 메모리로 (거의 한 줄 전체면 줄 묶음으로 한 번에) */
void video_present(void)
{
    int y, run0 = -1;

    col256_compose(frame);
    for (y = 0; y < 200; y++) {
        int x0 = col256_lx[y], x1 = col256_rx[y], wide = x1 >= x0 && x1 - x0 >= 280;

        if (wide) {
            if (run0 < 0)
                run0 = y;
            continue;
        }
        if (run0 >= 0) {                        /* 모여 있는 넓은 줄들을 한 번에 */
            unsigned off = (unsigned)run0 * 320, n = (unsigned)(y - run0) * 320;
            if (vga)
                memcpy(vga + off, frame + off, n);
            else
                _dosmemputb(frame + off, n, 0xA0000 + off);
            run0 = -1;
        }
        if (x1 >= x0) {
            unsigned off = (unsigned)y * 320 + x0, n = (unsigned)(x1 - x0 + 1);
            if (vga)
                memcpy(vga + off, frame + off, n);
            else
                _dosmemputb(frame + off, n, 0xA0000 + off);
        }
    }
    if (run0 >= 0) {
        unsigned off = (unsigned)run0 * 320, n = (unsigned)(200 - run0) * 320;
        if (vga)
            memcpy(vga + off, frame + off, n);
        else
            _dosmemputb(frame + off, n, 0xA0000 + off);
    }
}

void write_bmp(const char *name, const uint8_t *pixels, const uint8_t pal[][3], int colors)
{
    char fn[80];
    FILE *f;
    uint8_t h[54 + 1024];
    int i, y, hs = 54 + 1024;
    long size = hs + 64000;

    snprintf(fn, sizeof fn, "%s.bmp", name);
    f = fopen(fn, "wb");
    if (!f)
        return;
    memset(h, 0, sizeof h);
    h[0] = 'B'; h[1] = 'M';
    h[2] = size; h[3] = size >> 8; h[4] = size >> 16;
    h[10] = hs; h[11] = hs >> 8;
    h[14] = 40;
    h[18] = 320 & 0xFF; h[19] = 320 >> 8;
    h[22] = 200;
    h[26] = 1; h[28] = 8;
    h[47] = 1;
    for (i = 0; i < colors; i++) {
        h[54 + i * 4] = (uint8_t)(pal[i][2] * 255 / 63);
        h[55 + i * 4] = (uint8_t)(pal[i][1] * 255 / 63);
        h[56 + i * 4] = (uint8_t)(pal[i][0] * 255 / 63);
    }
    fwrite(h, 1, hs, f);
    for (y = 199; y >= 0; y--)
        fwrite(pixels + y * 320, 1, 320, f);
    fclose(f);
}

void video_dump(const char *name)
{
    write_bmp(name, frame, (const uint8_t (*)[3])pal256, 256);
}
