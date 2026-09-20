/* ============================================================================
 *  vidcga.c  -  원판 화면: CGA 320x200 4색을 VGA 모드 13h 에 그대로  -> ALLEY.EXE
 * ----------------------------------------------------------------------------
 *  CGA 메모리(vram)는 짝수 줄(0000..)과 홀수 줄(2000..)로 나뉘고 한 바이트에
 *  점 4개다.  이것을 320x200 한 점 한 바이트로 풀어 A0000 에 복사한다.
 *  색 0..3 은 VGA 팔레트 0..3 에 두고, 원본이 포트 3D9h 로 팔레트/밝기/바탕색을
 *  바꿀 때마다 팔레트만 새로 넣는다.
 * ========================================================================== */
#include <stdio.h>
#include <string.h>
#include <dos.h>
#include <go32.h>
#include <pc.h>
#include <sys/movedata.h>

#include "allycat.h"
#include "platform.h"

volatile int quit_requested;

/* CGA 16색 (RGBI) - VGA DAC 6비트 */
const uint8_t cga_rgb[16][3] = {
    {0x00, 0x00, 0x00}, {0x00, 0x00, 0x2A}, {0x00, 0x2A, 0x00}, {0x00, 0x2A, 0x2A},
    {0x2A, 0x00, 0x00}, {0x2A, 0x00, 0x2A}, {0x2A, 0x15, 0x00}, {0x2A, 0x2A, 0x2A},
    {0x15, 0x15, 0x15}, {0x15, 0x15, 0x3F}, {0x15, 0x3F, 0x15}, {0x15, 0x3F, 0x3F},
    {0x3F, 0x15, 0x15}, {0x3F, 0x15, 0x3F}, {0x3F, 0x3F, 0x15}, {0x3F, 0x3F, 0x3F},
};

/* 포트 3D9h 값 -> 네 색의 CGA 색 번호 */
void cga_palette_colors(uint8_t sel, int out[4])
{
    int hi = (sel & 0x10) ? 8 : 0;

    out[0] = sel & 0x0F;
    if (sel & 0x20) {
        out[1] = 3 + hi;
        out[2] = 5 + hi;
        out[3] = 7 + hi;
    } else {
        out[1] = 2 + hi;
        out[2] = 4 + hi;
        out[3] = 6 + hi;
    }
}

int video_open(void)
{
    union REGS r;

    r.x.ax = 0x0013;
    int86(0x10, &r, &r);
    r.x.ax = 0x0F00;
    int86(0x10, &r, &r);
    if ((r.h.al & 0x7F) != 0x13)
        return 0;
    video_palette_changed();
    return 1;
}

void video_close(void)
{
}

void video_palette_changed(void)
{
    int c[4], i;

    cga_palette_colors(cga_color_select, c);
    outportb(0x3C8, 0);
    for (i = 0; i < 4; i++) {
        outportb(0x3C9, cga_rgb[c[i]][0]);
        outportb(0x3C9, cga_rgb[c[i]][1]);
        outportb(0x3C9, cga_rgb[c[i]][2]);
    }
}

static uint8_t frame[64000];

/* 320x200 8비트 BMP (팔레트는 6비트 DAC 값) */
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
    h[46] = 0; h[47] = 1;                       /* 색 256 */
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
    uint8_t pal[4][3];
    int c[4], i;

    cga_palette_colors(cga_color_select, c);
    for (i = 0; i < 4; i++)
        memcpy(pal[i], cga_rgb[c[i]], 3);
    write_bmp(name, frame, (const uint8_t (*)[3])pal, 4);
}

void video_present(void)
{
    uint8_t *p = frame;
    int y, x;
    uint16_t base;
    uint8_t b;

    for (y = 0; y < 200; y++) {
        base = (uint16_t)((y >> 1) * 80 + ((y & 1) ? 0x2000 : 0));
        for (x = 0; x < 80; x++) {
            b = vram[base + x];
            *p++ = b >> 6;
            *p++ = (b >> 4) & 3;
            *p++ = (b >> 2) & 3;
            *p++ = b & 3;
        }
    }
    _dosmemputb(frame, 64000, 0xA0000);
}

void extra_init(void)
{
}

void extra_poll(void)
{
}
