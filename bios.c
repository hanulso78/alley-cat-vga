/* ============================================================================
 *  bios.c  -  원본이 쓴 BIOS 화면 기능 (int 10h) 흉내
 * ----------------------------------------------------------------------------
 *      AH=00h  모드 4 (320x200 4색)          -> bios_set_mode4
 *      AH=0Bh  바탕색(BH=0) / 팔레트(BH=1)   -> bios_set_color
 *      AH=02h  커서                          -> bios_set_cursor
 *      AH=0Eh  텔레타이프 (그래픽 화면, BL=색) -> bios_putc
 *
 *  CGA 색 선택 레지스터(포트 3D9h): 비트 0-3 바탕색, 비트 4 밝게, 비트 5 팔레트.
 *  BIOS 는 마지막에 쓴 값을 기억해 두고(0040:0066) 거기서 비트를 바꾼다.
 *  원본은 처음에 3D9h 에 20h 를 바로 써서 어두운 팔레트 1 로 만든다.
 * ========================================================================== */
#include <string.h>
#include "allycat.h"

uint8_t cga_color_select = 0x30;        /* 포트 3D9h 실제 값 */
static uint8_t bios_palette = 0x30;     /* BIOS 가 기억하는 값 (0040:0066) */
static uint8_t cursor_row, cursor_col;

void cga_color_select_out(uint8_t value)
{
    cga_color_select = value;
    sys_cga_port_changed();
}

void bios_set_mode4(void)
{
    memset(vram, 0, VRAM_SIZE);
#ifdef CATVGA
    {
        extern uint8_t vram_col[VRAM_SIZE * 4];
        memset(vram_col, 0, sizeof vram_col);
        actor_reset_all();
        vram_dirty_all();
    }
#endif
    vram_dirty = 1;
    bios_palette = 0x30;
    cursor_row = cursor_col = 0;
    cga_color_select_out(0x30);
}

#ifdef CATVGA
uint8_t text_col256;
#endif

void bios_set_color(uint8_t bh, uint8_t bl)
{
    uint8_t v = bios_palette;

    if (bh == 0)
        v = (uint8_t)((v & 0xE0) | (bl & 0x1F));
    else
        v = (uint8_t)((v & 0xDF) | ((bl & 1) ? 0x20 : 0));
    bios_palette = v;
    cga_color_select_out(v);
}

void bios_set_cursor(uint8_t row, uint8_t col)
{
    cursor_row = row;
    cursor_col = col;
}

/* 글자 하나를 커서 자리에 (글자 칸 8x8) */
static void draw_char(uint8_t ch, uint8_t color)
{
    const uint8_t *glyph = sys_font8x8() + ch * 8;
    uint8_t c = color & 3;
    uint16_t off, row;
    int y, x;

    for (y = 0; y < 8; y++) {
        int py = cursor_row * 8 + y;
        off = (uint16_t)((py / 2) * 80 + ((py & 1) ? 0x2000 : 0) + cursor_col * 2);
        row = 0;
        for (x = 0; x < 8; x++)
            row = (uint16_t)((row << 2) | ((glyph[y] & (0x80 >> x)) ? c : 0));
        if (color & 0x80) {
            vram_set(off, vram[off & 0x3FFF] ^ (uint8_t)(row >> 8));
            vram_set(off + 1, vram[(off + 1) & 0x3FFF] ^ (uint8_t)row);
        } else {
            vram_set(off, (uint8_t)(row >> 8));
            vram_set(off + 1, (uint8_t)row);
#ifdef CATVGA
            /* 개선판: 글자 점만 읽기 좋은 색으로 (바탕은 그대로) */
            if (text_col256) {
                extern uint8_t vram_col[VRAM_SIZE * 4];
                uint8_t *vc = vram_col + (unsigned)(off & 0x3FFF) * 4;
                for (x = 0; x < 8; x++)
                    if (glyph[y] & (0x80 >> x))
                        vc[x] = text_col256;
            }
#endif
        }
    }
}

/* 화면을 글자 한 줄(8점) 올리기 */
static void scroll_up(void)
{
    int plane;

    for (plane = 0; plane < 2; plane++) {
        uint16_t base = plane ? 0x2000 : 0;
        vram_move(base, base + 4 * 80, 96 * 80, +1);
        vram_fill_word(base + 96 * 80, 0, 160);
    }
}

void bios_putc(uint8_t ch, uint8_t color)
{
    switch (ch) {
    case 13:
        cursor_col = 0;
        return;
    case 10:
        cursor_row++;
        break;
    case 8:
        if (cursor_col)
            cursor_col--;
        return;
    case 7:
        return;
    default:
        draw_char(ch, color);
        if (++cursor_col >= 40) {
            cursor_col = 0;
            cursor_row++;
        }
    }
    if (cursor_row >= 25) {
        scroll_up();
        cursor_row = 24;
    }
}
