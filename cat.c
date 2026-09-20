/* ============================================================================
 *  cat.c  -  고양이 (걷기, 뛰기, 떨어지기, 헤엄치기, 딛기)
 * ----------------------------------------------------------------------------
 *  원본 코드 0700..11F6, 15D0..16C5 (쓰레기통), 16C6..1798 (방의 발판).
 *
 *  위치     cat_x (점, 0..127h), cat_y (위쪽 끝), cat_foot_y = cat_y + 32h
 *  방향     cat_hdir  -1 왼쪽, 0 멈춤, 1 오른쪽
 *           cat_vdir  -1 올라감, 0 섰음, 1 떨어짐
 *  세로 속도 cat_vy 는 cat_vy_frac 에서 cat_vy_rate 를 뺄 때마다(빌림이 나면)
 *  1씩 바뀐다 (올라가면 줄고, 떨어지면 4까지 는다).
 *
 *  그리기   덮을 자리를 CAT_SAVE 에 저장하고 AND 로 그린다.  지울 때는 저장한 것을
 *           되돌린다.  cat_hidden 이 켜져 있으면 지금 화면에 없다는 뜻.
 * ========================================================================== */
#include "allycat.h"

/* 원래: 0700 */
static void reset_cat_ticks(void)
{
    cat_ticks = 0;
    cat_frame_count = 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 070D  골목 바닥 가장자리에서 새로 시작 (목숨을 잃었을 때도)
 *  cat_x 가 화면 가운데보다 오른쪽이면 오른쪽 끝에서 왼쪽을 보고 나온다.
 * ------------------------------------------------------------------------- */
void reset_cat(void)
{
    uint16_t x = 0;
    uint8_t dir = 1;

    if (cat_x >= 0xA0) {
        x = 0x128;
        dir = 0xFF;
    }
    cat_hdir = dir;
    cat_enter_steps = 3;
    cat_enter_delay = 0x0C;
    cat_x = x;
    cat_y = 0xB4;
    cat_foot_y = 0xE6;
    cat_scr = screen_offset(x, 0xB4);
    cat_save_size = 0x0B03;
    save_under_cat();
    cat_vdir = 0;
    cat_speed_x = 2;
    cat_vy = 1;
    cat_jump_delay = 0;
    cat_perch = 0;
    cat_standing = 0;
    cat_knocked_down = 0;
    cat_hidden = 0;
    joy_x = 0;
    joy_y = 0;
    exit_room = 0;
    cat_bounced = 0;
    cat_caught = 0;
    fishbowl_entered = 0;
    room_cleared = 0;
    on_trash_can = 0;
    reset_cat_ticks();
}

/* ---------------------------------------------------------------------------
 *  원래: 07A1  방(또는 골목의 들어갔던 창문)에 고양이 놓기 - 떨어지는 중으로
 * ------------------------------------------------------------------------- */
void place_cat(void)
{
    uint16_t x;
    uint8_t y;

    if (room == ROOM_ALLEY) {
        x = alley_cat_x;
        y = alley_cat_y;
    } else {
        y = room_cat_y(room);
        x = room_cat_x(room);
    }
    cat_x = x;
    cat_y = y;
    cat_foot_y = y + 0x32;
    cat_scr = screen_offset(x, y);
    cat_jump_sprite = cat_jump_sprites(4);
    cat_jump_size = cat_jump_sizes(4);
    cat_save_size = cat_jump_size;
    save_under_cat();
    cat_vdir = 1;
    cat_hdir = 0;
    cat_vy = 1;
    cat_vy_rate = 0x40;
    cat_jump_delay = (room == ROOM_LOVE) ? 0 : 0x0A;
    cat_perch = 0;
    cat_standing = 0;
    cat_knocked_down = 0;
    cat_hidden = 0;
    joy_x = 0;
    joy_y = 0;
    exit_room = 0;
    cat_bounced = 0;
    cat_caught = 0;
    fishbowl_entered = 0;
    room_cleared = 0;
    on_trash_can = 0;
    reset_cat_ticks();
    if (room == ROOM_FISHBOWL) {
        cat_vy = 0x10;
        cat_swim_accel = 0x10;
        air_ticks = (uint16_t)sys_ticks();
        cat_drowning = 0;
        bubble_rise = 5;
        bubble_delay = 1;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 0872  빗자루 등에 맞아 튕겨 나가기 (방의 창문 쪽으로)
 * ------------------------------------------------------------------------- */
void bounce_cat(void)
{
    uint16_t d;
    uint8_t a, b;

    music_pitch = 0x400;
    if (cat_bounced)
        return;
    cat_vy = 8;
    cat_vdir = (cat_y < room_exit_y) ? 1 : 0xFF;
    if (cat_x > room_exit_x) {
        d = (uint16_t)(cat_x - room_exit_x);
        cat_hdir = 0xFF;
    } else {
        d = (uint16_t)~(uint16_t)(cat_x - room_exit_x);
        cat_hdir = 1;
    }
    if (d >> 8)
        d = 0xFF;
    a = (uint8_t)~(uint8_t)d;           /* 가까울수록 세게 */
    if (a < 0x30)
        a = 0x30;
    b = a >> 2;
    a -= b;
    cat_vy_rate = a;
    cat_speed_x = a >> 5;
    cat_standing = 0;
    hole_index = 0;
    cat_vy_frac = 1;
    cat_jump_delay = 0x10;
    cat_bounced = 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 0FC9  가로로 움직이기.  벽에 막히면 1 (원래 CF)
 * ------------------------------------------------------------------------- */
int move_cat_x(void)
{
    uint16_t x;

    cat_min_x = 8;
    cat_max_x = 0x123;
    if (room == ROOM_LOVE) {
        cat_min_x = 0x24;
        cat_max_x = 0x10F;
    }
    x = cat_x;
    if (cat_hdir == 0)
        return 0;
    if (cat_hdir == 1) {
        x += cat_speed_x;
        if (x >= cat_max_x) {
            cat_x = cat_max_x - 1;
            return 1;
        }
    } else {
        if (x < cat_speed_x || (x -= cat_speed_x) < cat_min_x) {
            cat_x = cat_min_x;
            return 1;
        }
    }
    cat_x = x;
    return 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 1020  걷는 그림 고르기 (조금씩 빨라진다)
 * ------------------------------------------------------------------------- */
static uint16_t cat_walk_sprite(void)
{
    uint8_t f;

    if (cat_hdir != cat_prev_hdir)
        cat_speed_x = 2;
    if (cat_speed_x < 8) {
        cat_vy_frac--;
        if (!(cat_vy_frac & 3))
            cat_speed_x++;
    }
    f = cat_walk_frame + 1;
    if (f >= 6)
        f = 0;
    cat_walk_frame = f;
    if (cat_hdir == 0xFF)
        f += 6;
    return cat_walk_sprites(f);
}

/* ---------------------------------------------------------------------------
 *  원래: 0F87  화면 가장자리에서 들어오는 중: 그림을 steps 워드만 보이게 잘라
 *  SCRATCH 에 만든다
 * ------------------------------------------------------------------------- */
static void clip_entering_cat(uint8_t steps, uint8_t dir)
{
    uint16_t size = 0x0B03 - steps;

    cat_sprite_size = size;
    if (dir != 0xFF) {
        cat_sprite += (uint16_t)(steps * 2);
        cat_x = 0;
    } else {
        cat_x = (uint16_t)(steps * 8 + 0x128);
    }
    extract_rows(SCRATCH, cat_sprite, 3, size);
    cat_sprite = SCRATCH;
}

/* ---------------------------------------------------------------------------
 *  원래: 1069  가만히 있을 때 - 가끔 고개와 꼬리를 바꿔 그린다
 * ------------------------------------------------------------------------- */
static void cat_idle(void)
{
    cat_speed_x = 2;
    cat_vy_frac = 8;
    if (cat_save_size == 0x0C02) {
        cat_idle_count++;
        if (cat_idle_count & 7)
            return;
    }
    restore_under_cat();
    if (thrown_hits_cat())
        return;
    if (dog_catches_cat())
        return;
    ACTOR_BEGIN(0);
    draw_sprite_and(cat_scr, cat_idle_heads((random16() & 0x0E) >> 1), CAT_SAVE, 0x0602);
    cat_save_size = 0x0C02;
    draw_sprite_and(cat_scr + 0xF0, cat_idle_tails((random16() & 6) >> 1), CAT_SAVE + 0x18, 0x0602);
    ACTOR_END(0, cat_scr, cat_x, 0);
    cat_hidden = 0;
}

/* ---------------------------------------------------------------------------
 *  원래: 10DD  던진 물건에 맞아 떨어지기 시작
 * ------------------------------------------------------------------------- */
void knock_down_cat(void)
{
    cat_standing = 0;
    cat_vdir = 1;
    cat_vy = 2;
    cat_vy_rate = 1;
    cat_vy_frac = 0xFF;
    cat_hdir = 0;
    cat_knocked_down = 1;
    cat_jump_sprite = cat_jump_sprites(1);
    cat_jump_size = cat_jump_sizes(1);
    cat_perch = 2;
}

/* 원래: 1112  지금 위치로 저장 위치를 다시 잡고 배경 저장 */
void resave_cat(void)
{
    cat_scr = screen_offset(cat_x, cat_y);
    save_under_cat();
}

/* 원래: 1124  고양이 자리 배경 저장 */
void save_under_cat(void)
{
    save_rect(CAT_SAVE, cat_scr, cat_save_size);
    cat_hidden = 0;
}

/* 원래: 1145  고양이 그리기 */
void draw_cat(void)
{
    cat_save_size = cat_sprite_size;
    cat_hidden = 0;
    ACTOR_BEGIN(0);
    draw_sprite_and(cat_scr, cat_sprite, CAT_SAVE, cat_sprite_size);
    ACTOR_END(0, cat_scr, cat_x, cat_sprite);
}

/* ---------------------------------------------------------------------------
 *  원래: 1166  고양이가 맞았다 (펑 그림을 잠깐 보여 주고, 맞은 것이면 목숨 하나)
 * ------------------------------------------------------------------------- */
void cat_hit_flash(void)
{
    uint16_t x = cat_x;

    x = (x >= 0x0C) ? x - 0x0C : 0;
    if (x >= 0x10F)
        x = 0x10E;
    splat_scr = screen_offset(x, cat_y);
    draw_sprite(splat_scr, SPLAT_SPR, SCRATCH, 0x1205);
    cat_ticks_prev = (uint16_t)sys_ticks();
    hit_sound_phase = 0;
    hit_sound_step = 0;
    do {
        hit_sound();
    } while ((uint16_t)((uint16_t)sys_ticks() - cat_ticks_prev) < 10);
    speaker_off();
    cat_hidden = 0;
    blit(splat_scr, SCRATCH, 0x1205);
    if (thrown_is_deadly && lives)
        lives--;
}

/* 원래: 11E3  고양이 지우기 (저장한 배경 되돌리기) */
void restore_under_cat(void)
{
    blit(cat_scr, CAT_SAVE, cat_save_size);
}

/* ---------------------------------------------------------------------------
 *  원래: 08E5  고양이 움직이기 (고리마다)
 * ------------------------------------------------------------------------- */
static void move_cat_swim(void);
static void move_cat_normal(void);

#ifdef CATVGA
static uint16_t swim_pit;       /* 개선판: 어항 속 사이 걸음 (마지막 걸음의 타이머 값) */
static uint8_t swim_extra;
static uint16_t quick_tick;     /* 개선판: 키가 바뀌어 바로 걸은 틱 */
static uint8_t air_steps;       /* 개선판: 뛰기 시작한 뒤 걸음 수 (대각선으로 바꿀 수 있는 동안) */
static uint8_t step_jx, step_jy;
#endif

void move_cat(void)
{
    uint16_t t = (uint16_t)sys_ticks(), n;

#ifdef CATVGA
    /* 개선판: 어항 속에서는 틱 사이에 1/3 틱마다 두 걸음 더 (타이머 0 로 잰다) */
    if (room == ROOM_FISHBOWL && t == cat_ticks && swim_extra < 2) {
        uint16_t now = pit_counter();
        if ((uint16_t)(swim_pit - now) >= 43000) {
            swim_pit = now;
            swim_extra++;
            move_cat_swim();
            return;
        }
    }
#endif
#ifdef CATVGA
    /* 개선판: 땅 위에서 키가 바뀌면(서 있다 걷기, 방향 바꾸기, 멈추기, 뛰기) 다음 틱과
       수직 귀선을 기다리지 않고 바로 한 걸음 (원판은 최대 두 틱 가까이 늦었다) */
    /* 위/아래만 눌렸으면 바로 뛰지 않고 이번 틱이 끝날 때까지 좌/우를 기다린다
       (화살표 두 개로 대각선 뛰기: 두 키가 몇 ms 차이로 들어온다) */
    if (t == cat_ticks && quick_tick != t && room != ROOM_FISHBOWL && cat_vdir == 0 &&
        (joy_x != step_jx || joy_y != step_jy) && (joy_y == 0 || joy_x != 0)) {
        quick_tick = t;
        cat_frame_count = 0;
        n = 0;
        goto step;
    }
#endif
    if (t == cat_ticks) {
        if (cat_frame_count == 0)
            return;
        if (--cat_frame_count)
            return;
        n = cat_frame_count;
    } else {
        n = 0x20;
        cat_frame_count = n;
    }
    /* 한 틱에 32번까지.  움직이지 않을 때(와 헤엄칠 때)는 수직 귀선 때만 */
#ifdef CATVGA
    if (room == ROOM_FISHBOWL || ((cat_vdir | cat_hdir) == 0 && joy_x == step_jx && joy_y == step_jy)) {
#else
    if (room == ROOM_FISHBOWL || (cat_vdir | cat_hdir) == 0) {
#endif
        if (!sys_in_retrace())
            return;
    }
#ifdef CATVGA
step:
    step_jx = joy_x;                    /* 이 걸음이 본 입력 */
    step_jy = joy_y;
#endif
    cat_ticks = t;
    cat_ticks_prev = n;
#ifdef CATVGA
    swim_pit = pit_counter();
    swim_extra = 0;
#endif
    if (room == ROOM_MICE && hole_anim)
        return;
    if (room == ROOM_DOGS && cat_drinking)
        return;
    if (room != ROOM_FISHBOWL)
        move_cat_normal();
    else
        move_cat_swim();
}

/* ---------------------------------------------------------------------------
 *  원래: 0953  어항 속에서 헤엄치기
 *  숨 쉴 시간이 지나면 배경이 파랑/자홍/빨강으로 바뀌며 경고하고, 더 지나면
 *  빠져 죽는다.  물 위(y<=3)에서 숨 쉬는 그림이면 숨 시간을 다시 잰다.
 * ------------------------------------------------------------------------- */
static void move_cat_swim(void)
{
    int s = level * 2;
    uint16_t air = (uint16_t)(cat_ticks - air_ticks), sp, lim, n_swim;
    uint8_t a, y, vy, bg;

    if (air >= DW(AIR_BUBBLE_TIME + s)) {
        if (air >= DW(AIR_DROWN_TIME + s))
            cat_caught = 1;
        if (--bubble_delay == 0) {
            bubble_sound();
            bubble_delay = 6;
            a = bubble_rise;
            if (cat_y >= 0xB3 && a < 0xC8) {
                a += 0x1E;
                bubble_rise = a;
            }
            y = (cat_y >= a) ? cat_y - a : 0;
#ifdef CATVGA
            {
                /* 개선판: 앞 "GLUB" 을 지우고 새로 (원판은 지우지 않아 여러 개가 남았다) */
                static uint16_t glub_scr;
                if (cat_drowning)
                    blit(glub_scr, SCRATCH, 0x0503);
                glub_scr = screen_offset(cat_x, y & 0xF8);
            }
#endif
            draw_sprite_and(screen_offset(cat_x, y & 0xF8), BUBBLE_SPR, SCRATCH, 0x0503);
        }
        cat_hdir = 0;
        cat_vdir = 1;
        cat_drowning = 1;
        cat_vy = 0x20;
        bios_set_color(0, 0);
        goto vertical;
    }

    bg = 0;
    if (air >= DW(AIR_WARN1_TIME + s)) {
        bg = 1;
        if (air >= DW(AIR_WARN2_TIME + s)) {
            bg = 5;
            if (air >= DW(AIR_WARN3_TIME + s))
                bg = 4;
        }
    }
    bios_set_color(0, bg);
    cat_prev_hdir = cat_hdir;
    cat_prev_vdir = cat_vdir;

    /* 가로: 같은 쪽을 누르고 있으면 빨라지고, 놓으면 느려진다 */
    a = joy_x;
    if (a == 0) {
        if (cat_swim_accel >= 0x10) {
            cat_swim_accel -= SWIM_DECEL;
            goto set_speed;
        }
    } else if (a == cat_hdir) {
        if (cat_swim_accel < 0x30)
            cat_swim_accel += 3;
        goto set_speed;
    }
    cat_hdir = a;
    cat_swim_accel = 0x20;
set_speed:
    sp = cat_swim_accel >> 3;
    lim = swim_max_speed(level);
    sp = SWIM_BOOST(sp);
    lim = SWIM_BOOST(lim);
    if (sp > lim)
        sp = lim;
    cat_speed_x = sp;
    move_cat_x();

    /* 세로 */
    a = joy_y;
    if (a == 0) {
        a = 0xFF;                       /* 손을 떼면 떠오른다 */
        if (cat_vy >= 0x10) {
            cat_vy--;
            goto vertical;
        }
    } else if (a == cat_vdir) {
        if (cat_vy < 0x40)
            cat_vy += 4;
        goto vertical;
    }
    cat_vdir = a;
    cat_vy = 0x20;

vertical:
    y = cat_y;
    vy = SWIM_BOOST(cat_vy >> 4);
    if (vy > SWIM_BOOST(swim_max_vy(level)))
        vy = SWIM_BOOST(swim_max_vy(level));
    if (cat_vdir == 1) {
        y += vy;
        if (y >= 0xB4)
            y = 0xB3;
    } else if (cat_vdir != 0) {
        if (y < vy || (uint8_t)(y - vy) <= 3) {
            if (DW(SWIM_SPRITES + 0x12) == cat_sprite)
                air_ticks = cat_ticks;          /* 물 위에서 숨 쉼 */
            y = 2;
        } else {
            y -= vy;
        }
    }
    cat_y = y;
    cat_new_scr = screen_offset(cat_x, y);

    /* 그림 고르기 */
    if (cat_drowning) {
        n_swim = 0x10;
    } else if (cat_hdir != cat_prev_hdir || cat_vdir != cat_prev_vdir) {
        n_swim = 0x18;
    } else {
        cat_swim_frame++;
        n_swim = cat_swim_frame;
        if ((joy_x | joy_y) == 0)
            n_swim = (n_swim & 0xFF00) | ((uint8_t)n_swim >> 1);
        if ((cat_y >= 0xB3 && cat_vdir == 1) ||
            !((cat_y <= 4 && joy_y != 0) || (uint16_t)(cat_vy >> 1) >= cat_swim_accel)) {
            if (cat_hdir != 0) {
                n_swim &= 6;
                if (cat_hdir != 1)
                    n_swim |= 8;
                goto chosen;
            }
        }
        n_swim = (n_swim & 2) | 0x10;
        if (cat_vdir == 1)
            n_swim += 4;
    }
chosen:
    cat_sprite = DW(SWIM_SPRITES + n_swim);
    cat_sprite_size = DW(SWIM_SIZES + n_swim);
    if (cat_y <= 8) {
        /* 물 위에서는 수직 귀선에 맞춰 조금 쉰다 */
        while (sys_in_retrace())
            ;
        while (!sys_in_retrace())
            ;
        sys_cpu_loop(1000);
    }
    restore_under_cat();
    cat_scr = cat_new_scr;
    draw_cat();
    if (fish_touch())
        draw_cat();
}

/* ---------------------------------------------------------------------------
 *  원래: 0BAC  골목과 방에서 고양이 움직이기
 * ------------------------------------------------------------------------- */
static void move_cat_normal(void)
{
    uint8_t a, bl, bh, sy;
    uint16_t sprite, size, sel;

    if (thrown_hits_cat())
        return;
    if (dog_has_cat)
        return;

    /* ---- 화면 가장자리에서 들어오는 중 ---- */
    if (cat_enter_steps) {
        if (cat_enter_delay) {
            if (dog_running == 0)
                cat_enter_delay--;
            return;
        }
        if (--cat_enter_steps == 0) {
            cat_speed_x = 8;
            move_cat_x();
            goto check_standing;
        }
        cat_sprite = cat_walk_sprite();
        clip_entering_cat(cat_enter_steps, cat_hdir);
        if (cat_enter_steps != 2)
            restore_under_cat();
        if (thrown_hits_cat())
            return;
        if (dog_catches_cat())
            return;
        cat_scr = screen_offset(cat_x, cat_y);
        /* 개선판: 왼쪽에서 들어올 때 보이는 것은 몸의 오른쪽 조각이다 - 몸의 실제 자리를 알려
           부드럽게 밀려 나오게 (오른쪽에서는 그린 자리가 곧 몸의 자리) */
        ACTOR_SHIFT(cat_hdir == 0xFF ? 0 : -(int)cat_enter_steps * 8);
        draw_cat();
        return;
    }

check_standing:
    if (cat_standing >= 1) {
        if (cat_standing == 1) {
            /* 막 내려앉았다: 앉은 그림 */
            cat_standing++;
            cat_speed_x = 6;
            cat_new_scr = screen_offset(cat_x, cat_y);
            restore_under_cat();
            if (thrown_hits_cat())
                return;
            if (dog_catches_cat())
                return;
            cat_scr = cat_new_scr;
            cat_sprite_size = 0x0E03;
            cat_sprite = SPR_CAT_CROUCH;
            draw_cat();
        }
        if (joy_y == 0)
            return;
        goto start_move;
    }

    if (cat_vdir == 0)
        goto on_ground;

    /* ---- 공중 ---- */
#ifdef CATVGA
    /* 개선판: 제자리에서 뛴 직후(세 걸음 안)에 좌/우가 들어오면 대각선으로 바꾼다
       (화살표 두 개를 몇 ms 차이로 누르면 먼저 들어온 위/아래로만 뛰던 것) */
    if (air_steps < 3 && cat_hdir == 0 && joy_x != 0 && !cat_knocked_down && !cat_bounced) {
        bl = (uint8_t)((joy_x + 1) << 1);
        if (cat_vdir != 0xFF)
            bl += 6;
        cat_hdir = joy_x;
        cat_jump_sprite = cat_jump_sprites(bl / 2);
        cat_jump_size = cat_jump_sizes(bl / 2);
    }
    if (air_steps < 0xFF)
        air_steps++;
#endif
    if (move_cat_x()) {
        /* 벽에 부딪쳐 떨어진다 */
        cat_hdir = 0;
        cat_vy = 2;
        cat_vdir = 1;
        cat_jump_delay = 0;
    } else {
        a = cat_vy_frac;
        cat_vy_frac -= cat_vy_rate;
        if (a < cat_vy_rate) {
            if (cat_vdir == 1) {
                if (cat_vy < 4)
                    cat_vy++;
            } else if (cat_vy > 1) {
                cat_vy--;
            } else {
                cat_vdir = 1;
            }
        }
    }

    if (cat_knocked_down == 0) {
        if (cat_jump_delay && --cat_jump_delay)
            goto fall;
        if (cat_vdir == 1 && find_support()) {
            a = cat_foot_y;
            goto landed;
        }
    }
fall:
    a = cat_foot_y;
    if (cat_vdir != 1) {
        if (a < cat_vy) {
            a = 0;
            cat_vdir = 1;
            cat_vy = 1;
        } else {
            a -= cat_vy;
        }
        goto new_y;
    }
    a += cat_vy;
    if (a <= 0xE6)
        goto new_y;
    if (room == ROOM_LOVE) {
        if (a < 0xF8)
            goto new_y;
        a = 0xF8;
        exit_room = 1;                  /* 사랑의 방 바닥으로 떨어지면 나간다 */
        goto new_y;
    }
    a = 0xE6;
    cat_perch = 0;
landed:
    cat_vdir = 0;
    cat_bounced = 0;
    cat_speed_x = 2;
    cat_jump_delay = 0;
    cat_knocked_down = 0;
    if (cat_standing)
        land_sound();

new_y:
    cat_foot_y = a;
    cat_y = (a >= 0x32) ? a - 0x32 : 0;
    cat_new_scr = screen_offset(cat_x, cat_y);
    if (cat_hidden == 0)
        restore_under_cat();
    if (thrown_hits_cat() || dog_catches_cat()) {
        cat_hidden = 1;
        return;
    }
    cat_scr = cat_new_scr;
    if (cat_bounced) {
        cat_bounce_frame += 2;
        sel = cat_bounce_frame & 0x0E;
        sprite = DW(CAT_BOUNCE_SPRITES + sel);
        size = DW(CAT_BOUNCE_SIZES + sel);
    } else {
        sprite = cat_jump_sprite;
        size = cat_jump_size;
    }
    cat_sprite = sprite;
    cat_sprite_size = size;

    /* 화면 위로 삐져나가면 위쪽 줄을 잘라서 */
    if (cat_foot_y < 0x32) {
        a = 0x32 - cat_foot_y;
        sys_cpu_loop(0x168);
        bh = size >> 8;
        bl = (uint8_t)size;
        if (bh <= a) {
            cat_hidden = 1;
            return;
        }
        bh -= a;
        cat_sprite_size = (uint16_t)((bh << 8) | bl);
        cat_sprite = (uint16_t)(a * (uint8_t)(bl << 1)) + cat_jump_sprite;
        goto draw;
    }

    /* 바닥 아래로 삐져나가면 아래쪽 줄을 잘라서 */
    if (room == ROOM_LOVE) {
        if (cat_y < 0xBB)
            goto draw;
        sy = cat_y - 0xBB;
    } else {
        if (cat_perch != 2 || cat_y < 0x5E)
            goto draw;
        sy = cat_y - 0x5E;
    }
    bh = size >> 8;
    if (bh <= sy) {
        if (room == ROOM_LOVE) {
            exit_room = 1;
            return;
        }
        reset_cat();                    /* 담장 뒤로 떨어졌다 */
        fall_sound();
        return;
    }
    cat_sprite_size = (uint16_t)(((bh - sy) << 8) | (uint8_t)size);
    cat_vy = 2;
draw:
    draw_cat();
    return;

on_ground:
    /* ---- 섰거나 기대어 있음 ---- */
    if (room == ROOM_LOVE || cat_y < 0xB4) {
        if (!find_support()) {
            cat_hdir = 0;
            cat_vdir = 1;
            goto jump_up_or_fall;           /* 발 밑이 비었다: 떨어진다 */
        }
        if (room == ROOM_ALLEY) {
            if (!popper_hits_cat()) {
                cat_popped = 0;
            } else {
                if (cat_popped == 0)
                    popper_sound();
                joy_y = 1;
                cat_popped = 1;
                a = random16() & 1;
                joy_x = a ? a : 0xFF;
            }
        }
    }

start_move:
    cat_prev_hdir = cat_hdir;
    cat_hdir = joy_x;
    cat_vdir = joy_y;
    if (cat_vdir == 0)
        goto walk;
    if (cat_vdir == 1) {
        if (cat_y >= 0xB4) {
            cat_vdir = 0;
            cat_bounced = 0;
            joy_y = 0;
            goto walk;
        }
jump_up_or_fall:
        /* 아래로: 발판에서 뛰어내리기 */
        bh = 1;
        a = 0x20;
        cat_jump_delay = 8;
        if (cat_perch == 1)
            cat_perch = 0;
    } else {
        /* 위로 뛰기: 빨리 달릴수록 높이 */
        cat_jump_delay = 0;
        bl = (uint8_t)cat_speed_x;
        if (bl > 2)
            cat_speed_x = (cat_speed_x & 0xFF00) | (uint8_t)(bl - 2);
        bh = 8;
        a = (uint8_t)((bl ^ 0x0F) << 4);
        if (cat_perch == 1)
            cat_perch++;
    }
    cat_vy_rate = a;
    cat_vy = bh;
    cat_vy_frac = 1;
    cat_standing = 0;
#ifdef CATVGA
    air_steps = 0;
#endif
    bl = (uint8_t)((cat_hdir + 1) << 1);
    if (cat_vdir != 0xFF)
        bl += 6;
    cat_jump_sprite = cat_jump_sprites(bl / 2);
    cat_jump_size = cat_jump_sizes(bl / 2);
    hole_index = 0;
    if (on_trash_can)
        leave_trash_can();
    return;

walk:
    if (room != ROOM_ALLEY && room != ROOM_LOVE)
        make_footprint();
    move_cat_x();
    cat_new_scr = screen_offset(cat_x, cat_y);
    if ((cat_hdir | cat_vdir) == 0) {
        cat_idle();
        return;
    }
    cat_sprite = cat_walk_sprite();
    restore_under_cat();
    if (thrown_hits_cat())
        return;
    if (dog_catches_cat())
        return;
    cat_scr = cat_new_scr;
    cat_sprite_size = 0x0B03;
    draw_cat();
}

/* ---------------------------------------------------------------------------
 *  원래: 1608  떨어지다가 디딜 것이 있나 (있으면 1, 위치를 맞춘다)
 * ------------------------------------------------------------------------- */
int find_support(void)
{
    uint8_t y;

    if (room == ROOM_LOVE)
        return love_find_support();
    if (room != ROOM_ALLEY)
        return room_find_support();
    y = cat_y & 0xF8;
    if (y != 0x60) {
        if (land_on_trash_can())
            return 1;
        return cat_land_on_line();
    }
    /* 담장 위 */
    if (cat_perch >= 2)
        return 0;
    cat_y = y;
    cat_foot_y = y + 0x32;
    if (cat_perch != 1) {
        cat_perch = 1;
        perch_ticks = (uint16_t)sys_ticks();
    }
    return 1;
}

/* ---------------------------------------------------------------------------
 *  원래: 15D0  쓰레기통 하나 고르기 (바로 앞과 다른 것) -> x, y
 * ------------------------------------------------------------------------- */
uint16_t pick_trash_can(uint8_t *y)
{
    uint8_t n = trash_count(level), i;
    uint8_t v;

    do {
        do {
            i = random16() & 7;
        } while (i > n);
        i += trash_first(level);
    } while (i == last_trash_can);
    last_trash_can = i;
    v = trash_can(i);
    *y = (v & 0x80) ? 0x88 : 0x90;
    return (uint16_t)((v & 0x7F) * 4);
}

/* ---------------------------------------------------------------------------
 *  원래: 1657  쓰레기통 뚜껑에 내려앉기
 *  쓰레기통 표: 아래 7비트 = x/4, 윗비트 = 키 큰 통(위 88h) / 작은 통(90h)
 * ------------------------------------------------------------------------- */
int land_on_trash_can(void)
{
    uint8_t foot = (cat_y + 2) & 0xF8, top, v;
    int i = trash_first(level);
    uint16_t x;

    for (;;) {
        v = trash_can(i);
        if (v == 0) {
            on_trash_can = 0;
            return 0;
        }
        i++;
        top = (v & 0x80) ? 0x88 : 0x90;
        if (foot != top)
            continue;
        x = (uint16_t)((v & 0x7F) * 4);
        if ((cat_x & 0xFFF8) < x)
            continue;
        if ((uint16_t)((cat_x - 0x0F) & 0xFFF8) > x)
            continue;
        top -= 2;
        cat_y = top;
        cat_foot_y = top + 0x32;
        if (on_trash_can == 0) {
            on_trash_can = 1;
            trash_can_sound();
        }
        return 1;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 16C6  방 안에서 디딜 것 (나가는 곳, 방 3 의 책장, 방마다의 발판 표)
 * ------------------------------------------------------------------------- */
int room_find_support(void)
{
    uint8_t foot, py;
    int i;
    uint16_t px, dx;

    hole_index = 0;
    if (cat_vdir == 1) {
        if (rects_overlap(room_exit_x - 4, 0x0C, room_exit_y - 8, 0x10,
                          cat_x, 0x18, cat_y, 0x0E)) {
            exit_room = 1;              /* 나가는 곳(창문)에 닿았다 */
            return 0;
        }
    }
    if (room == ROOM_SPIDER && spider_shelf_support()) {
        cat_standing = 1;
        return 1;
    }
    foot = cat_y & 0xF8;
    i = room_plat_first(room);
    for (;;) {
        py = plat_y(i);
        if (py == 0)
            return 0;
        plat_stand_tmp = plat_stand(i);
        plat_w_tmp = plat_w(i);
        px = plat_x(i);
        i++;
        if (foot != py)
            continue;
        if ((cat_x & 0xFFF8) < px)
            continue;
        dx = (cat_x >= plat_w_tmp) ? cat_x - plat_w_tmp : 0;
        if ((dx & 0xFFFC) > px)
            continue;
        break;
    }
    cat_y = py;
    cat_foot_y = py + 0x32;
    cat_standing = plat_stand_tmp;
    if (plat_stand_tmp)
        cat_x &= 0xFFFC;
    if (room == ROOM_MICE) {
        i--;
        if (i >= 0x27 && i - 0x27 < 0x10)
            hole_index = (uint8_t)(i - 0x27 + 1);
    }
    return 1;
}
