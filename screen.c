/* ============================================================================
 *  screen.c  -  화면 바꾸기 (고양이 자리에서 퍼지는 사각형), 방 팔레트,
 *               방에서 실패했을 때의 그림
 * ----------------------------------------------------------------------------
 *  원본 코드 1BF0..1E3D.
 * ========================================================================== */
#include "allycat.h"

/* ---------------------------------------------------------------------------
 *  원래: 1C67  고양이 자리에서 사각형을 키워 가며 wipe_fill 로 칠하기
 * ------------------------------------------------------------------------- */
static void wipe_from_cat(void)
{
    uint16_t x, dst;
    uint8_t y, rows, a;
    int n;

    wipe_stub();
    wipe_width = 1;
    wipe_rows = 8;
    x = (uint16_t)((cat_x + 0x0C) & 0xFFF0);
    y = (uint8_t)(cat_y + 8);
    wipe_edges = 0;
    for (;;) {
        wipe_sound();
        wipe_x = x;
        wipe_y = y;
        dst = screen_offset(x, y);
        for (rows = wipe_rows; rows; rows--) {
            vram_fill_word(dst, wipe_fill, wipe_width >> 3);
            n = (wipe_width >> 2) & 0xFE;
            dst = (uint16_t)(dst + ((wipe_width >> 3) * 2) - n);
            dst ^= 0x2000;
            if (!(dst & 0x2000))
                dst += 0x50;
        }
        if (wipe_edges == 0x0F)
            return;
        wipe_width += 0x20;
        wipe_rows += 0x10;
        x = wipe_x;
        y = wipe_y;
        if (x < 0x10) {
            x = 0;
            wipe_edges |= 1;
        } else {
            x -= 0x10;
        }
        if ((uint16_t)(wipe_width + x) >= 0x140) {
            wipe_width = 0x140 - x;
            wipe_edges |= 2;
        }
        if (y < 8) {
            y = 0;
            wipe_edges |= 4;
        } else {
            y -= 8;
        }
        a = (uint8_t)(wipe_rows + y);
        if (a < y || a >= 0xC8) {
            wipe_rows = 0xC8 - y;
            wipe_edges |= 8;
        }
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 1BF0  방에 들어가고 나올 때
 *  검게 지우고, 팔레트를 바꾸고, 골목으로 돌아온 것이면 결과를 보여 준 뒤
 *  새 방의 바탕색(골목 2, 어항과 사랑의 방 1)으로 다시 칠한다.
 * ------------------------------------------------------------------------- */
void room_transition(void)
{
    MUSIC_STOP();
    bios_set_color(0, 0);
    if (prev_room == ROOM_LOVE && room_cleared) {
        level_won();
        cat_x = 0x98;
        cat_y = 0x5F;
    }
    wipe_fill = 0;
    wipe_from_cat();
    speaker_off();
    set_room_palette();
    SET_THEME(ROOM_ALLEY);                      /* 결과 화면(보너스, 실패)은 골목 색으로 */
    if (room == ROOM_ALLEY) {
        if (room_cleared) {
            if (prev_room == ROOM_LOVE)
                love_won_tune();
            else
                room_bonus();
        } else {
            room_failed();
        }
    }
    wipe_fill = (room == ROOM_LOVE || room == ROOM_FISHBOWL) ? 0x5555 : 0xAAAA;
    SET_THEME(room);
    wipe_from_cat();
    speaker_off();
}

/* ---------------------------------------------------------------------------
 *  원래: 1D31  방마다의 팔레트 (PCjr 가 아니면 팔레트 번호만 고르고 바탕은 검정)
 * ------------------------------------------------------------------------- */
void set_room_palette(void)
{
    bios_set_color(1, room_palette(room));
    bios_set_color(0, 0);
}

/* 원래: 1E17  실패 그림을 mask 로 걸러 화면 가운데에 */
static void draw_failed_frame(void)
{
    ds_and_words(SCRATCH, failed_sprite, failed_mask, 0x60);
    blit(0x0ED0, SCRATCH, 0x0C08);
}

/* ---------------------------------------------------------------------------
 *  원래: 1D76  방에서 그냥 나왔거나 실패했을 때
 *  그냥 나왔으면 기본 그림, 잡혔으면(cat_caught) 차례로 네 그림 중 하나를
 *  왼쪽부터 드러내듯 보여 주고 목숨 하나를 잃는다.
 *  개에게 쫓겨났으면 판이 0 이 아닐 때 쫓겨나는 장면을 따로 보여 준다.
 * ------------------------------------------------------------------------- */
void room_failed(void)
{
    uint16_t spr;

    if (prev_room == ROOM_LOVE) {
        love_failed();
        return;
    }
    reset_sad_tune();
    MUSIC(cat_caught ? SONG_CAUGHT : SONG_SAD, 1);
    spr = FAILED_DEFAULT_SPR;
    if (cat_caught) {
        spr = failed_sprites((chased_out_frame & 6) >> 1);
        chased_out_frame += 2;
        if (lives)
            lives--;
        if (cat_caught == 0xDD && level != 0 && lives >= 1) {
            chased_out_scene();
            speaker_off();
            return;
        }
    }
    failed_sprite = spr;
    failed_mask = 0x8080;
    failed_count = 0x1C;
    do {
        draw_failed_frame();
        failed_ticks = (uint16_t)sys_ticks();
        do {
            sad_tune();
        } while ((uint16_t)sys_ticks() == failed_ticks);
        if (failed_count <= 0x14) {
            failed_mask = failed_masks((failed_count & 6) >> 1);
        } else {
            uint8_t a = (uint8_t)((failed_mask >> 1) | 0x80);
            failed_mask = (uint16_t)((a << 8) | a);
        }
    } while (--failed_count);
    speaker_off();
}
