/* ============================================================================
 *  draw.c  -  골목과 방 그리기
 * ----------------------------------------------------------------------------
 *  원본 코드 2790..29F6 (방), 2A00..2CA5 (골목), 5400..5447 (창문 장식).
 *
 *  방 그림은 대부분 "그림 목록"(draw_list)으로 그린다.  목록마다 기준 위치를
 *  더해서 같은 가구를 다른 곳에 놓는다.
 * ========================================================================== */
#include "allycat.h"

/* 원래: 2945  목록 2개 (2384, 238C) */
static void draw_lists_2(uint16_t base)
{
    room_list_base = base;
    draw_list(0x2384, base);
    draw_list(0x238C, room_list_base);
}

/* 원래: 2958  목록 4개 (2636..263C 표) */
static void draw_lists_a(uint16_t base)
{
    int si;

    room_list_base = base;
    for (si = 8; si; si -= 2)
        draw_list(DW(0x2634 + si), room_list_base);
}

/* 원래: 2970  목록 5개 (263E..2646 표) */
static void draw_lists_b(uint16_t base)
{
    int si;

    room_list_base = base;
    for (si = 0x0A; si; si -= 2)
        draw_list(DW(0x263C + si), room_list_base);
}

/* 원래: 2988  목록 4개 (2648..264E 표) */
static void draw_lists_c(uint16_t base)
{
    int si;

    room_list_base = base;
    for (si = 8; si; si -= 2)
        draw_list(DW(0x2646 + si), room_list_base);
}

/* ---------------------------------------------------------------------------
 *  원래: 29A0  방 벽과 바닥 (base 만큼 아래로 옮겨서)
 * ------------------------------------------------------------------------- */
static void draw_room_frame(uint16_t base)
{
    room_frame_base = base;
    draw_list(0x251C, base);
    vram_fill_word(room_frame_base + 0x284, 0, 0x24);
    vram_fill_word(room_frame_base + 0x1184, 0, 0x24);
    draw_column(room_frame_base + 0x2284, 0x2A);
    draw_column(room_frame_base + 0x22CB, 0xA8);
}

/* ---------------------------------------------------------------------------
 *  원래: 2790  방 그리기.  나가는 곳(창문) 위치도 정한다.
 * ------------------------------------------------------------------------- */
void draw_room(void)
{
    uint16_t r;

    SET_THEME(room);
    if (room == ROOM_FISHBOWL) {
        /* 어항 속: 위 두 줄 수면과 물결 */
        vram_fill_word(0, 0xAAAA, 0x50);
        vram_fill_word(0x2000, 0xAAAA, 0x50);
        for (wave_draw_col = 0; wave_draw_col < 0x28; wave_draw_col++) {
            do {
                r = random16() & 0x18;
            } while ((uint8_t)r == wave_last);
            wave_last = (uint8_t)r;
            wave_phase(wave_draw_col) = (uint8_t)r;
            blit((uint16_t)(wave_draw_col * 2 + 0xA0), (uint16_t)(r + WAVE_SPR), 0x0401);
        }
        return;
    }
    if (room == ROOM_LOVE) {
        draw_love_room();
        return;
    }
    if (room == ROOM_DOGS) {
        draw_room_frame(0);
        draw_list(0x2570, 0x064A);
        room_exit_x = 0x48;
        room_exit_y = 0x38;
        draw_lists_a(0x0DD2);
        draw_lists_b(0x0DF6);
        blit(0x067E, 0x1FA0, 0x1002);
        draw_list(0x2344, 0x0B84);
        reset_dogs();
        return;
    }
    if (room == ROOM_BIRDCAGE) {
        draw_room_frame(0x640);
        draw_list(0x2570, 0x0CB6);
        room_exit_x = 0xF8;
        room_exit_y = 0x60;
        draw_lists_a(0x140E);
        draw_lists_b(0x1434);
        draw_lists_b(0x143E);
        draw_lists_c(0x16A0);
        draw_list(0x2344, 0x1184);
        blit(0x0DD6, 0x1FE0, 0x1002);
        return;
    }
    if (room == ROOM_MICE) {
        draw_room_frame(0x640);
        draw_list(0x2570, 0x0CBA);
        room_exit_x = 0x108;
        room_exit_y = 0x60;
        draw_lists_a(0x1439);
        draw_lists_2(0x16C0);
        draw_cheese();
        return;
    }
    if (room == ROOM_SPIDER) {
        draw_room_frame(0x640);
        draw_list(0x2570, 0x0C90);
        room_exit_x = 0x60;
        room_exit_y = 0x60;
        draw_lists_a(0x140C);
        draw_lists_b(0x1418);
        draw_list(0x2344, 0x1184);
        draw_list(0x2344, 0x11A2);
        draw_list(0x2624, 0);
        draw_bookshelf();
        return;
    }
    /* 방 1: 탁자 위 어항 */
    draw_room_frame(0x640);
    draw_list(0x2570, 0x0CA0);
    room_exit_x = 0xA0;
    room_exit_y = 0x60;
    draw_lists_a(0x1406);
    draw_list(0x2344, 0x11C4);
    draw_lists_b(0x1422);
    draw_lists_c(0x1690);
    draw_lists_2(0x16B6);
}

/* ============================================================================
 *  골목
 * ========================================================================== */

/* 원래: 2A68  난이도 표시 (골목 왼쪽 아래) */
static void draw_skill_badge(void)
{
    blit(0x1902, DW(SKILL_BADGES + ((skill & 3) << 1)), 0x0801);
}

/* 원래: 2B71  창문 네 개 한 줄 */
static void draw_window_row(uint16_t dst)
{
    for (alley_count = 4; alley_count; alley_count--) {
        blit(dst, WINDOW_SPR, 0x1005);
        dst += 0x14;
    }
}

/* 원래: 2B8B */
static void draw_windows(void)
{
    draw_window_row(0x03C5);
    draw_window_row(0x08C5);
    draw_window_row(0x0DC5);
}

/* ---------------------------------------------------------------------------
 *  원래: 2B9E  담장 (위 끝은 난수로 다른 판자), 담장의 얼룩, 바닥의 뼈다귀
 * ------------------------------------------------------------------------- */
static void draw_fence(void)
{
    uint16_t r;

    for (alley_ptr = 0x1040; alley_ptr < 0x1090; alley_ptr += 2) {
        do {
            r = random16() & 0x30;
        } while ((uint8_t)r == alley_count);
        alley_count = (uint8_t)r;
        blit(alley_ptr, (uint16_t)(r + FENCE_TOP_SPR), 0x0801);
    }
    alley_ptr = 0x1090;
    vram_fill_word(0x1180, 0x5655, 0x500);
    vram_fill_word(0x3180, 0x5655, 0x500);
    for (alley_ptr = 0x2944; alley_ptr < 0x296C; alley_ptr += 0x0A) {
        for (alley_count = 9; alley_count; alley_count--)
            blit((uint16_t)((random16() & 0x776) + 0x12C0), alley_ptr, 0x0501);
    }
    for (alley_count = 5; alley_count; alley_count--)
        blit((uint16_t)((random16() & 0x3E) + 0x3A98), BONE_SPR, 0x0501);
}

/* 원래: 2C3D  쓰레기통 하나 (뚜껑, 몸통 3칸(아래쪽 줄이면 2칸), 바닥) */
static void draw_trash_can(uint16_t dst)
{
    alley_ptr = dst;
    alley_count = (dst >= 0x1720) ? 2 : 3;
    alley_ptr += 0x1E0;
    blit(dst, TRASH_LID_SPR, 0x0C05);
    do {
        dst = alley_ptr;
        alley_ptr += 0x140;
        blit(dst, TRASH_BODY_SPR, 0x0804);
    } while (--alley_count);
    blit(alley_ptr, TRASH_BOTTOM_SPR, 0x0B04);
}

/* 원래: 2C84  판마다의 쓰레기통 배치 */
static void draw_trash_cans(void)
{
    uint16_t i = DB(TRASH_LAYOUT_FIRST + level), dst;

    for (;;) {
        trash_draw_i = i;
        dst = DW(TRASH_LAYOUT + i);
        if (dst == 0)
            return;
        draw_trash_can(dst);
        i = trash_draw_i + 2;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 2A00  골목 그리기
 * ------------------------------------------------------------------------- */
void draw_alley(void)
{
    SET_THEME(ROOM_ALLEY);
    vram_fill_word(0, 0xAAAA, 0xFA0);
    vram_fill_word(0x2000, 0xAAAA, 0xFA0);
    draw_fence();
    draw_list(0x28A0, 0);
    draw_skill_badge();
    draw_trash_cans();
    draw_windows();
    reset_clotheslines();
}

/* 원래: 2A30  타이틀의 골목 (창문, 빨랫줄 없이, 쓰레기통은 1판 배치) */
void draw_title_alley(void)
{
    uint16_t save;

    SET_THEME(ROOM_ALLEY);
    vram_fill_word(0, 0xAAAA, 0xFA0);
    vram_fill_word(0x2000, 0xAAAA, 0xFA0);
    draw_fence();
    draw_list(0x28A0, 0);
    draw_skill_badge();
    save = level;
    level = 1;
    draw_trash_cans();
    level = save;
}

/* ---------------------------------------------------------------------------
 *  원래: 5400  창문마다 커튼, 화분 같은 장식을 난수로
 * ------------------------------------------------------------------------- */
void draw_window_decor(void)
{
    uint16_t list = DW(DECOR_LISTS + ((level & 7) << 1)), dst, k;

    decor_base = (uint16_t)((level & 7) << 4);
    for (;;) {
        dst = DW(list);
        if (dst == 0xFFFF)
            return;
        k = DW(DECOR_INDEX + (random16() & 0x0E) + decor_base);
        blit(dst, DW(DECOR_SPRITES + k), DW(DECOR_SIZES + k));
        list += 2;
    }
}
