/* ============================================================================
 *  sound.c  -  PC 스피커 소리와 음악
 * ----------------------------------------------------------------------------
 *  원본 코드 53B0..53F5 (타이틀 곡), 5450..5BD0 (나머지).
 *
 *  골목과 방의 배경음악은 곡이 아니라 난수로 만드는 걷는 베이스다
 *  (play_music).  한 박자마다 PIT 로 잰 짧은 소리 하나를 내고 멈춘다.
 *  효과음은 대부분 "소리를 켜고 두 틱 뒤에 끈다" (start_effect).
 *  몇몇 효과음은 스피커 비트를 빠르게 뒤집는 CPU 속도 소리라, 도스 판에서는
 *  8088 한 바퀴 시간(sys_cpu_loop)을 넣어 원래 음높이에 가깝게 한다.
 * ========================================================================== */
#include "allycat.h"

/* 원래: 5B21 */
void speaker_off(void)
{
    sys_out61(sys_in61() & 0xFC);
}

/* 원래: 5889  분주비만 넣고 스피커 켜기 */
void speaker_divisor(uint16_t div)
{
    sys_out42((uint8_t)div);
    sys_out42((uint8_t)(div >> 8));
    sys_out61(sys_in61() | 3);
}

/* out 43h,B6h 를 먼저 하고 소리 */
void speaker_tone(uint16_t div)
{
    sys_out43(0xB6);
    speaker_divisor(div);
}

/* 원판의 음악(곡과 걷는 베이스)만 이것으로 울린다.
   개선판은 같은 자리에서 애드립 곡이 울리므로 스피커를 건드리지 않는다. */
void tune_tone(uint16_t div)
{
    if (TUNE_SPEAKER)
        speaker_tone(div);
}

void tune_off(void)
{
    if (TUNE_SPEAKER)
        speaker_off();
}

/* ---------------------------------------------------------------------------
 *  원래: 5B28  music_pitch 음을 music_length (PIT 카운트) 동안 울리고 끈다
 * ------------------------------------------------------------------------- */
static void play_note_on(int speaker)
{
    uint16_t start, now;

    if (speaker)
        speaker_tone(music_pitch);
    start = pit_counter();
    do {
        now = pit_counter();
    } while ((uint16_t)(start - now) < music_length);
    if (speaker)
        speaker_off();
}

static void play_note(void)
{
    play_note_on(1);
}

/* 원래: 5450 */
void reset_dog_sound(void)
{
    siren_rise = 0x0C;
    siren_mode = 1;
    siren_pitch = 0x1FF;
    siren_mask = 0x0F;
    siren_delay = 1;
}

/* 원래: 58BD */
void reset_music(void)
{
    beat_bit = 0x80;
    beat_count = 0;
    beat_phrase = 0;
    music_pitch = 0x500;
    music_dir = 0xFF;
    beat_rest = 0;
    effect_ticks_left = 0;
    after_effect = 0;
    bubble_pitch = 0;
    siren_mode = 1;
    siren_delay = 1;
    MUSIC(room == ROOM_ALLEY ? SONG_ALLEY : room == ROOM_FISHBOWL ? SONG_FISH :
          room == ROOM_LOVE ? SONG_LOVE : SONG_ROOM, 0);
}

/* ---------------------------------------------------------------------------
 *  원래: 546D  배경음악 (고리마다)
 *      개가 고양이를 물고 가면: 사이렌 같은 소리
 *      효과음 중이면: 효과음 두 번째 음과 끄기
 *      아니면: 박자마다 베이스 한 음 (골목 0, 방 1, 던진 물건 2, 개/효과음 뒤 3)
 * ------------------------------------------------------------------------- */
void play_music(void)
{
    uint16_t t, i, n;
    int mode, m2;
    uint8_t a, r;

    if (sound_on == 0)
        return;
    if (dog_has_cat) {
        t = (uint16_t)sys_ticks();
        if (siren_rise == 0) {
            if (t == siren_ticks)
                return;
            siren_ticks = t;
            speaker_tone((uint16_t)((siren_pitch & 0x1FF) + 0xC8));
            siren_pitch -= 0x4B;
            return;
        }
        if (t != siren_ticks) {
            siren_ticks = t;
            siren_rise--;
        }
        if (--siren_delay)
            return;
        siren_delay = 2;
        if ((uint8_t)random16() <= 4)
            siren_mode++;
        if (siren_mode & 1)
            siren_mask += 7;
        sys_out43(0xB6);
        speaker_divisor((uint16_t)((random16() & siren_mask & 0x1FF) + 0x190));
        return;
    }

    t = (uint16_t)sys_ticks();
    if (effect_ticks_left) {
        if (t == effect_ticks)
            return;
        effect_ticks = t;
        if (--effect_ticks_left == 0) {
            speaker_off();
            return;
        }
        speaker_tone(effect_second);
        return;
    }
    if (t == beat_ticks)
        return;

    if (dog_running | after_effect) {
        mode = 3;
    } else if (room != ROOM_ALLEY) {
        mode = 1;
    } else {
        mode = thrown_y ? 2 : 0;
    }
    m2 = mode * 2;
    if ((cat_bounced | after_effect) == 0) {
        if ((uint16_t)(t - beat_ticks) < DW(BEAT_TICKS + m2))
            return;
    }
    beat_ticks = t;

    if (dog_running == 0) {
        if (after_effect == 0)
            goto bass;
        after_effect--;
    }
    /* 개가 뛰거나 효과음 뒤: 짧은 똑딱 */
    music_length = 0x1200;
    i = dog_bark_step;
    if (i >= 6) {
        i = 0;
        dog_bark_step = 0;
    }
    dog_bark_step += 2;
    music_pitch = DW(BARK_PITCHES + i);
    play_note();
    return;

bass:
    if (mode == 2) {
        /* 던진 물건이 떨어지는 소리 (높이에 따라) */
        music_pitch = (uint16_t)((thrown_y << 4) + 0x200);
        music_length = 0x1800;
        play_note();
        return;
    }
    music_length = DW(NOTE_LENGTH + m2);
    a = beat_bit;
    beat_bit >>= 1;
    if (a & 1) {
        /* 마디 시작 */
        music_length = 0x1000;
        beat_bit = 0x80;
        beat_count++;
        a = beat_count & DB(PHRASE_MASK + mode);
        if (a == 0) {
            beat_phrase += DB(PHRASE_STEP + mode);
            r = (uint8_t)random16();
            if (r <= DB(REST_CHANCE + mode))
                beat_rest = r & 7;
            n = (uint16_t)((random16() & 0xFF) << 1);
            music_dir = 1;
            if (n & 2) {
                music_dir = 0xFF;
                n += 0x300;
            }
            music_pitch = n;
        }
        beat_count = a | (beat_phrase & DB(PHRASE_KEEP + mode));
    }
    if (music_dir != 0xFF) {
        walk_step += 2;
        music_pitch = DW(BARK_PITCHES + (walk_step & 0x0E));
    } else {
        if (music_pitch <= 0xC8)
            music_pitch = 0x500;
        music_pitch -= 0x19;
    }
    if (cat_bounced) {
        music_length = 0x2000;
        music_dir = 0xFF;
        goto play;
    }
    i = (uint16_t)(beat_count + DW(RHYTHM_TABLE + m2));
    if (DB(RHYTHM_BITS + i) & beat_bit)
        goto play;
    if (beat_rest == 0)
        return;
    beat_rest--;
    music_length = DW(REST_LENGTH + m2);
play:
    play_note_on(TUNE_SPEAKER);                 /* 걷는 베이스 */
}

/* ---------------------------------------------------------------------------
 *  원래: 5691  개들이 깰 때 으르렁 (배경이 잠깐 빨갛다)
 * ------------------------------------------------------------------------- */
void growl_sound(void)
{
    uint16_t i;

    speaker_off();
    bios_set_color(0, 4);
    growl_ticks = (uint16_t)sys_ticks();
    growl_pos = 0;
    growl_shift = 2;
    do {
        if (sound_on) {
            growl_pos++;
            i = (growl_pos >> growl_shift) & 0x1F;
            sys_out61(sys_in61() ^ DB(GROWL_WAVE + i));
        }
        sys_cpu_loop(20);
    } while ((uint16_t)((uint16_t)sys_ticks() - growl_ticks) < 2);
    bios_set_color(0, 0);
    after_effect = 0x0C;
    speaker_off();
}

/* 원래: 56F4, 5704  거미가 물 때 */
void reset_bite_sound(void)
{
    bite_phase = 0x200;
}

void bite_sound(void)
{
    uint16_t i;
    uint8_t v;

    bite_phase++;
    i = (bite_phase >> ((bite_phase >> 9) & 0x0F)) & 0x0F;
    v = DB(BITE_WAVE + i) & sound_on;
    sys_out61((sys_in61() & 0xFC) | v);
    sys_cpu_loop(15);
}

/* ---------------------------------------------------------------------------
 *  원래: 572E, 576E  하트를 타고 올라갈 때 (내렸다 올렸다)
 * ------------------------------------------------------------------------- */
static void rising_step(void)
{
    sys_cpu_loop(0x1000);
    if (sound_on)
        speaker_tone(rising_pitch);
}

void rising_sound(void)
{
    for (rising_pitch = 0x1F4; ; ) {
        rising_step();
        rising_pitch -= 0x1E;
        if (rising_pitch <= 0xC8)
            break;
    }
    for (rising_pitch = 0x1F4; ; ) {
        rising_step();
        rising_pitch -= 0x14;
        if (rising_pitch <= 0x12C)
            break;
    }
    for (;;) {
        rising_step();
        rising_pitch += 0x1E;
        if (rising_pitch >= 0x320)
            break;
    }
    speaker_off();
}

/* 원래: 5797, 57A6  뱀장어 감전 */
void reset_zap_sound(void)
{
    speaker_off();
    zap_count = 0;
    zap_width = 8;
}

void zap_sound(void)
{
    uint8_t a, v = 0;

    zap_count++;
    a = zap_count & 0x3F;
    if (a == 0)
        zap_width++;
    if (a >= ((zap_width >> 2) & 0x1F))
        v = 2;
    v &= sound_on;
    sys_out61((sys_in61() & 0xFD) | v);
    sys_cpu_loop(10);
}

/* 원래: 57D5, 57E4  방에서 실패했을 때의 곡 */
void reset_sad_tune(void)
{
    sad_pos = 0;
    sad_ticks = (uint16_t)sys_ticks();
}

void sad_tune(void)
{
    uint16_t t, div;
    int i;

    if (sound_on == 0)
        return;
    t = (uint16_t)sys_ticks();
    if ((uint16_t)(t - sad_ticks) < 2)
        return;
    sad_ticks = t;
    i = sad_pos;
    sad_pos += 2;
    if (cat_caught) {
        div = DW(CAUGHT_TUNE + i);
        if (div == 0) {
            tune_off();
            return;
        }
    } else {
        div = DW(SAD_TUNE + i);
    }
    tune_tone(div);
}

/* 원래: 5829, 5835, 5869  보너스 */
void reset_tick_sound(void)
{
    tick_pos = 0;
    bonus_beat = 0;
}

void bonus_tune(void)
{
    uint16_t t, i;

    if (sound_on == 0)
        return;
    t = (uint16_t)sys_ticks();
    if (t == bonus_tune_ticks)
        return;
    bonus_tune_ticks = t;
    bonus_beat++;
    if (!TUNE_SPEAKER)
        return;
    sys_out43(0xB6);
    i = tick_pos;
    if (!(bonus_beat & 1))
        i += 2;
    speaker_divisor(DW(TICK_PITCHES + i));
}

void tick_sound(void)
{
    uint16_t i;

    if (sound_on == 0)
        return;
    sys_out43(0xB6);
    i = tick_pos;
    tick_pos += 2;
    speaker_divisor(DW(TICK_PITCHES + i));
}

/* 원래: 5896 (아무것도 안 함), 5897  화면 바꿀 때 */
void wipe_stub(void)
{
}

void wipe_sound(void)
{
    uint16_t i;

    if (sound_on == 0)
        return;
    sys_out43(0xB6);
    i = wipe_pos & 6;
    wipe_pos += 2;
    speaker_divisor(DW(WIPE_PITCHES + i));
}

/* ---------------------------------------------------------------------------
 *  원래: 59A3  bx 분주비로 cx 번 도는 동안 울리기
 * ------------------------------------------------------------------------- */
static void beep(uint16_t div, uint16_t loops)
{
    if (sound_on == 0)
        return;
    speaker_tone(div);
    sys_cpu_loop(loops);
    speaker_off();
}

/* 원래: 58F8  쓰레기통에서 뛰어내릴 때 */
void leave_trash_can(void)
{
    if (dog_running == 0)
        beep(0x390, 0x1800);
    on_trash_can = 0;
}

/* 원래: 590E  쓰레기통에 내려앉을 때 */
void trash_can_sound(void)
{
    if (dog_running == 0)
        beep(0x400, 0x1800);
}

/* 원래: 591F  쓰레기통 놈에게 치였을 때 */
void popper_sound(void)
{
    beep(0x7D0, 0x1800);
    beep(0xA6E, 0x1800);
    beep(0xDEC, 0x1800);
}

/* ---------------------------------------------------------------------------
 *  원래: 593B  효과음: first 를 바로 울리고 두 틱 뒤 second, 그 다음 끈다
 *  (play_music 이 이어서 처리한다)
 * ------------------------------------------------------------------------- */
void start_effect(uint16_t first, uint16_t second)
{
    if (sound_on == 0)
        return;
    effect_second = second;
    speaker_tone(first);
    effect_ticks_left = 2;
    effect_ticks = (uint16_t)sys_ticks();
}

/* 원래: 595D  새 소리 */
void chirp_sound(void)
{
    uint16_t d;

    if (sound_on == 0 || effect_ticks_left)
        return;
    d = (random16() & 0x7F) + 0xAA;
    start_effect(d + 0x1E, d);
}

/* 원래: 597F  물속 거품 (점점 낮아진다) */
void bubble_sound(void)
{
    if (sound_on == 0)
        return;
    start_effect(0x1200 + bubble_pitch, 0x1312 + bubble_pitch);
    bubble_pitch += 0x15E;
    after_effect = 0x18;
}

/* ---------------------------------------------------------------------------
 *  원래: 59CB  담장 뒤로 떨어질 때 (점점 느려지는 잡음, 5틱쯤)
 * ------------------------------------------------------------------------- */
void fall_sound(void)
{
    uint16_t n, d;

    sys_out61(sys_in61() & 0xFE);
    fall_ticks = (uint16_t)sys_ticks();
    fall_step = 0;
    for (;;) {
        n = fall_step >> 6;
        if (n == 0)
            n = 1;
        for (;;) {
            d = (uint16_t)((uint16_t)sys_ticks() - fall_ticks);
            sys_cpu_loop(8);
            if (d < 2)
                continue;
            if (d >= 7) {
                speaker_off();
                return;
            }
            if (--n == 0)
                break;
        }
        sys_out61(sys_in61() ^ ((uint8_t)random16() & 2 & sound_on));
        fall_step += 7;
    }
}

/* ---------------------------------------------------------------------------
 *  원래: 5A1C  "BONK!" 소리 (PIT 로 잰 간격마다 음을 바꾼다)
 * ------------------------------------------------------------------------- */
void hit_sound(void)
{
    uint16_t now, d, a, i;

    if (sound_on == 0)
        return;
    now = pit_counter();
    if (hit_sound_last >= now && (uint16_t)(hit_sound_last - now) <= 0x260) {
        sys_cpu_loop(12);
        return;
    }
    hit_sound_last = now;
    sys_out43(0xB6);
    hit_sound_frame++;
    i = hit_sound_frame & 0x1E;
    a = hit_sound_phase & 0x3FF;
    if (a >= 0x180)
        a = (uint16_t)(0x180 - a);
    a >>= 2;
    a += DW(HIT_PITCHES + i);
    hit_sound_step += 1;
    hit_sound_phase += 4;
    d = hit_sound_step >> 3;
    speaker_divisor((uint16_t)(a + d));
}

/* 원래: 5A90  쥐 "SQUEEK!" */
void squeek_sound(void)
{
    uint16_t t;

    if (sound_on == 0)
        return;
    t = (uint16_t)sys_ticks();
    if (t == squeek_ticks)
        return;
    squeek_ticks = t;
    sys_out43(0xB6);
    speaker_divisor((uint16_t)((random16() & 0x70) + 0x200));
}

/* ---------------------------------------------------------------------------
 *  원래: 5AC2  발판에 내려앉을 때 (PIT 간격마다 낮아지는 잡음, 2틱)
 * ------------------------------------------------------------------------- */
void land_sound(void)
{
    uint16_t now;

    land_pitch = 0x338;
    land_ticks = (uint16_t)sys_ticks();
    land_last = pit_counter();
    do {
        now = pit_counter();
        if ((uint16_t)(now - land_last) >= 0x9C40) {
            land_last = now;
            if (sound_on) {
                sys_out43(0xB6);
                speaker_divisor((uint16_t)((random16() & 0x7FF) + land_pitch));
                land_pitch -= 2;
            }
        }
        sys_cpu_loop(20);
    } while ((uint16_t)((uint16_t)sys_ticks() - land_ticks) < 2);
    speaker_off();
}

/* ---------------------------------------------------------------------------
 *  원래: 5B54, 5B63, 5BBF  사랑의 곡 (판을 깼을 때)
 * ------------------------------------------------------------------------- */
void reset_love_tune(void)
{
    love_pos = 0;
    love_ticks = (uint16_t)sys_ticks();
}

void love_tune(void)
{
    uint16_t t, i, div, prev;

    if (sound_on == 0)
        return;
    t = (uint16_t)sys_ticks();
    if ((uint16_t)(t - love_ticks) < 2)
        return;
    love_ticks = t;
    i = love_pos & 0xFE;
    if (i >= 0x86) {
        i = 0;
        love_pos = 0;
    }
    love_pos += 2;
    div = DW(LOVE_TUNE + i);
    prev = love_note;
    love_note = div;
    if (div == prev) {
        tune_off();
        return;
    }
    tune_tone(div);
}

void finish_love_tune(void)
{
    if (sound_on == 0)
        return;
    do {
        love_tune();
    } while (love_pos < 0x7C);
}

/* ---------------------------------------------------------------------------
 *  원래: 53B0  타이틀 곡 (틱마다 한 음, 0 은 쉼, 66h 는 끝)
 * ------------------------------------------------------------------------- */
void title_tune(void)
{
    uint16_t t;
    uint8_t n;

    if (sound_on == 0)
        return;
    t = (uint16_t)sys_ticks();
    if (t == title_tune_ticks)
        return;
    title_tune_ticks = t;
    n = DB(TITLE_TUNE + title_tune_pos);
    if (n == 0x66) {
        tune_off();
        return;
    }
    title_tune_pos++;
    if (n == 0) {
        tune_off();
        return;
    }
    tune_tone(DW(TITLE_PITCHES + n));
}
