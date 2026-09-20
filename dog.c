/* ============================================================================
 *  dog.c  -  불독
 * ----------------------------------------------------------------------------
 *  원본 코드 1E40..220A.
 *
 *  골목 바닥으로 뛰어다니는 불독.  고양이가 바닥에 있을 때 가끔 가장자리에서
 *  들어와(dog_entering) 달리고(dog_running), 가장자리에 닿으면 나간다
 *  (dog_leaving).  고양이를 물면(dog_has_cat = 달아나는 방향) 고양이를 물고
 *  가장자리로 달려가는데, 골목이면 목숨 하나, 방이면 방에서 쫓겨난다.
 *  방에서는 빗자루 대신 나오기도 한다 (방 6).
 *
 *  고양이를 물었을 때는 그림을 투명하게 그리지 않고 통째로 복사한다.
 * ========================================================================== */
#include "allycat.h"

/* 원래: 1E40 */
void reset_dog(void)
{
    dog_running = 0;
    dog_steps = 0;
    dog_entering = 0;
    dog_leaving = 0;
    dog_has_cat = 0;
    dog_y = 0xB1;
    reset_dog_sound();
}

/* ---------------------------------------------------------------------------
 *  원래: 2022  달리는 그림 고르기
 * ------------------------------------------------------------------------- */
static void pick_dog_sprite(void)
{
    uint8_t n;

    if (dog_has_cat) {
        dog_frame++;
        n = (dog_frame & 6) | 8;
    } else {
        dog_frame += 2;
        n = dog_frame & 2;
        if (dog_dir == 1)
            n |= 4;
    }
    dog_sprite = dog_sprites(n >> 1);
}

/* ---------------------------------------------------------------------------
 *  원래: 2059  가장자리에 걸친 개: steps 워드만 보이게 잘라 SCRATCH 로
 * ------------------------------------------------------------------------- */
static void clip_dog(uint8_t steps, uint8_t dir)
{
    uint16_t size = 0x0F04 - steps;

    dog_size = size;
    if (dir != 0xFF) {
        dog_sprite += (uint16_t)(steps * 2);
        dog_x = 0;
    } else {
        dog_x = (uint16_t)(steps * 8 + 0x120);
    }
    extract_rows(SCRATCH, dog_sprite, 4, size);
    dog_sprite = SCRATCH;
}

/* 원래: 209B  개 그리기 */
static void draw_dog(void)
{
    dog_save_size = dog_size;
    if (dog_has_cat == 0) {
        ACTOR_BEGIN(1);
        draw_sprite(dog_scr, dog_sprite, DOG_SAVE, dog_size);
        ACTOR_END(1, dog_scr, dog_x, dog_sprite);
        return;
    }
    save_rect(DOG_SAVE, dog_scr, dog_size);
    ACTOR_BEGIN(1);
    blit(dog_scr, dog_sprite, dog_size);
    ACTOR_END(1, dog_scr, dog_x, dog_sprite);
}

/* 원래: 20E1  개 지우기 */
void erase_dog(void)
{
    blit(dog_scr, DOG_SAVE, dog_save_size);
}

/* ---------------------------------------------------------------------------
 *  원래: 1E63  개 움직이기
 * ------------------------------------------------------------------------- */
void move_dog(void)
{
    uint16_t t = (uint16_t)sys_ticks(), x;
    uint8_t d;

    if ((uint16_t)(t - dog_ticks) < (uint16_t)((dog_steps & 1) + 1))
        return;
    if (!sys_in_retrace())
        return;
    dog_ticks = t;
    dog_steps++;

    if (dog_leaving) {
        if (--dog_leaving == 0) {
            speaker_off();
            if (dog_has_cat) {
                if (room != ROOM_ALLEY) {
                    /* 방에서 쫓겨난다 */
                    cat_caught = 0xDD;
                    cat_x = 0xA0;
                    cat_y = 0x60;
                    return;
                }
                if (lives)
                    lives--;
            }
            erase_dog();
            reset_dog();
            return;
        }
        pick_dog_sprite();
        d = (dog_dir != 0xFF) ? 0xFF : 1;
        clip_dog((uint8_t)(4 - dog_leaving), d);
        goto draw;
    }

    if (dog_has_cat) {
        /* 고양이를 물고 가장자리로 (잠깐 이리저리 흔들며) */
        d = dog_has_cat;
        if (dog_wiggle) {
            dog_wiggle--;
            d = (random16() & 1) ? 1 : 0xFF;
        }
        dog_dir = d;
        x = dog_x;
        goto run;
    }

    if (dog_running)
        goto running;
    if (dog_entering == 0) {
        if (popper_woke_dog == 0) {
            if (cat_y < 0xB4 || cat_enter_steps)
                return;
            if ((uint8_t)random16() >= dog_start_chance(level))
                return;
        }
        /* 고양이 반대쪽 가장자리에서 들어온다 */
        dog_bark_step = 0;
        dog_dir = (cat_x < 0xA0) ? 0xFF : 1;
        dog_entering = 4;
    }
    if (--dog_entering == 0) {
        dog_running = 1;
        goto running;
    }
    pick_dog_sprite();
    clip_dog(dog_entering, dog_dir);
    goto draw;

running:
    popper_woke_dog = 0;
    x = dog_x;
    if (cat_y >= 0xB4 && cat_enter_steps == 0) {
        if ((uint8_t)random16() <= dog_turn_chance(level))
            dog_dir = (x <= cat_x) ? 1 : 0xFF;
    }
run:
    if (dog_dir == 0)
        goto moved;
    if (dog_dir == 1) {
        x += 8;
        if (x < 0x11E)
            goto moved;
        x = 0x11E;
    } else {
        if (x >= 8) {
            x -= 8;
            goto moved;
        }
        x = 0;
    }
    /* 가장자리에 닿았다 */
    if (dog_has_cat) {
        if (dog_wiggle)
            goto moved;
    } else if (cat_y >= 0xB4 && cat_enter_steps == 0) {
        goto moved;
    }
    dog_leaving = 4;
moved:
    dog_x = x;
    pick_dog_sprite();
    dog_size = 0x0F04;

draw:
    dog_new_scr = screen_offset(dog_x, dog_y);
    if (dog_entering != 3)
        erase_dog();
    if (dog_catches_cat())
        return;
    dog_scr = dog_new_scr;
    draw_dog();
}

/* ---------------------------------------------------------------------------
 *  원래: 20F5  개가 고양이를 무나 (물면 1)
 * ------------------------------------------------------------------------- */
int dog_catches_cat(void)
{
    uint16_t x;

    if (dog_has_cat)
        return 0;
    if ((dog_running | dog_entering | dog_leaving) == 0)
        return 0;
    if (cat_y < 0xA3 || cat_enter_steps)
        return 0;
    x = dog_x + 0x20;
    if (x < cat_x)
        return 0;
    x = (x >= 0x38) ? x - 0x38 : 0;
    if (x > cat_x)
        return 0;
    dog_grab_cat();
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 2136  개가 고양이를 물었다
 *  고양이와 개 사이로 개를 옮기고, 가까운 가장자리로 달아나게 한다.
 *  방 6(개 방)에서는 고양이 자리에서 개가 일어난다.
 * ------------------------------------------------------------------------- */
void dog_grab_cat(void)
{
    uint16_t x, d;
    uint8_t save;

    if (room == ROOM_DOGS) {
        dog_y = cat_y;
        dog_x = cat_x;
    }
    x = (uint16_t)((uint16_t)(dog_x + cat_x) >> 1);
    if (x >= 0x118)
        x = 0x117;
    dog_x = x;
    if (x <= 0xA0) {
        dog_has_cat = 0xFF;
        d = (uint16_t)(0xA1 - x);
    } else {
        dog_has_cat = 1;
        d = (uint16_t)(x - 0x9F);
    }
    dog_running = 1;
    dog_leaving = 0;
    dog_wiggle = d >> 3;
    if (room == ROOM_DOGS) {
        restore_under_cat();
        save = dog_has_cat;
        dog_has_cat = 0;
        dog_size = 0x0F04;
        dog_sprite = dog_sprites(0);
        dog_scr = screen_offset(dog_x, dog_y);
        draw_dog();
        dog_has_cat = save;
    }
    erase_dog();
    restore_under_cat();
    cat_x = (cat_x < 0xA0) ? 0x122 : 0;
    if (room == ROOM_ALLEY)
        reset_cat();
#ifdef CATVGA
    /* 개선판: 고양이를 문 그림을 바로 그린다 (원판은 개가 다음 걸음을 뗄 때까지
       고양이도 개도 안 보였다) */
    pick_dog_sprite();
    dog_size = 0x0F04;
    dog_scr = screen_offset(dog_x, dog_y);
    draw_dog();
#endif
}

/* 원래: 21E0  개가 빗자루에 닿았나 */
int dog_touches_broom(void)
{
    if ((dog_running | dog_entering | dog_leaving) == 0)
        return 0;
    return rects_overlap(broom_x, 0x10, broom_y, 0x1E, dog_x, 0x20, dog_y, 0x0F);
}
