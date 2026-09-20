/* ============================================================================
 *  score.c  -  점수, 최고 점수, 목숨, 방을 깼을 때의 보너스
 * ----------------------------------------------------------------------------
 *  원본 코드 2690..2788 (점수), 38B0..3B20 (보너스).
 *
 *  점수는 7자리 BCD (한 바이트에 숫자 하나, 앞자리부터).  화면에는
 *  "000-0000" 모양으로 숫자 그림(8점 x 8줄)을 찍는다.
 * ========================================================================== */
#include "allycat.h"

/* ---------------------------------------------------------------------------
 *  8086 의 adc + aaa 를 그대로 (한 자리 더하기).  *carry 는 들어오고 나가는 CF.
 *  al 은 더하기 전 값, 반환은 aaa 뒤의 al.
 * ------------------------------------------------------------------------- */
static uint8_t bcd_digit_add(uint8_t a, uint8_t b, int *carry)
{
    int af = ((a & 0x0F) + (b & 0x0F) + *carry) > 0x0F;
    uint8_t sum = (uint8_t)(a + b + *carry);

    if ((sum & 0x0F) > 9 || af) {
        sum = (uint8_t)((sum + 6) & 0x0F);
        *carry = 1;
    } else {
        sum &= 0x0F;
        *carry = 0;
    }
    return sum;
}

/* 원래: 271E  7자리 BCD 더하기  dst += src */
void bcd_add(uint16_t dst, uint16_t src)
{
    int carry = 0, i;

    for (i = 6; i >= 0; i--)
        DB(dst + i) = bcd_digit_add(DB(dst + i), DB(src + i), &carry);
}

/* ---------------------------------------------------------------------------
 *  원래: 2706  점수에 더하기 (points 는 십의 자리 값)
 * ------------------------------------------------------------------------- */
void add_score(uint8_t points)
{
    int i, c;
    uint8_t a = points;

    for (i = 5; i >= 0; i--) {
        c = 0;
        DB(SCORE + i) = bcd_digit_add(a, DB(SCORE + i), &c);
        a = (uint8_t)c;                 /* aaa 가 올린 ah (0 또는 1) */
    }
    draw_score();
}

/* 원래: 2690  점수가 최고 점수보다 크면 옮기기 */
void update_high_score(void)
{
    int i;

    for (i = 0; i < 7; i++) {
        if (DB(SCORE + i) != DB(HIGH_SCORE + i)) {
            if (DB(SCORE + i) > DB(HIGH_SCORE + i))
                ds_copy(HIGH_SCORE, SCORE, 7);
            return;
        }
    }
}

/* 원래: 26B3  목숨 수 (바뀌었을 때만) */
void draw_lives(void)
{
    if (lives == lives_shown)
        return;
    lives_shown = lives;
    blit(0x1260, (uint16_t)(lives * 16 + DIGIT_SPR), 0x0801);
}

/* 원래: 26DA, 26E1, 26E8 */
void clear_score(void)
{
    int i;
    for (i = 0; i < 7; i++)
        DB(SCORE + i) = 0;
}

void clear_high_score(void)
{
    int i;
    for (i = 0; i < 7; i++)
        DB(HIGH_SCORE + i) = 0;
}

/* 원래: 2739  숫자 7개 찍기 (세 자리 뒤에 한 칸 띈다) */
static void draw_digits(uint16_t digits, uint16_t dst)
{
    digit_scr = dst;
    digit_ptr = digits;
    for (digit_count = 0; ; ) {
        blit(digit_scr, (uint16_t)(DB(digit_ptr) * 16 + DIGIT_SPR), 0x0801);
        digit_scr += 2;
        digit_ptr++;
        digit_count++;
        if (digit_count == 7)
            return;
        if (digit_count == 3)
            digit_scr += 2;
    }
}

/* 원래: 26F2, 26FC */
void draw_high_score(void)
{
    draw_digits(HIGH_SCORE, 0x12CA);
}

void draw_score(void)
{
    draw_digits(SCORE, 0x143C);
}

/* ============================================================================
 *  방을 깼을 때 (원래 38B0)
 *      시간 보너스 = (남은 시간) -> 십진수로 바꿔서 방마다의 기본 점수를 더한다.
 *      골목 방: "BONUS" 그림이 아래에서 올라오고 점수를 찍는다.
 *      사랑의 방(판 끝): 판 시간 보너스 x 판마다의 배수 ("BONUS MULTIPLIER").
 * ========================================================================== */

/* 원래: 3A96  보너스 그림을 mask 로 걸러 SCRATCH 로 */
static void mask_bonus_sprite(uint16_t mask)
{
    ds_and_words(SCRATCH, BONUS_SPR, mask, 0x1E);
}

/* 원래: 3AF4  2진 시간 -> 7자리 BCD (BONUS_DIGITS).  비트마다 2의 거듭제곱을 더한다 */
static void time_to_bcd(uint16_t value)
{
    uint16_t bit = 0x1000, pow = BCD_POW2 + 12 * 7;
    int i;

    bonus_time_bits = value;
    for (i = 0; i < 8; i++)
        DB(BONUS_DIGITS + i) = 0;
    for (;;) {
        if (bonus_time_bits & bit)
            bcd_add(BONUS_DIGITS, pow);
        pow -= 7;
        if (bit & 1)
            break;
        bit >>= 1;
    }
}

/* 원래: 3AAC  보너스 그림 목록을 아래에서 위로 올리기 (stop 까지) */
static void raise_bonus(uint16_t stop)
{
    bonus_stop = stop;
    reset_tick_sound();
    bonus_base = 0x1B80;
    for (;;) {
        draw_list(BONUS_LIST, bonus_base);
        if (bonus_with_sound) {
            tick_sound();
            bonus_ticks = (uint16_t)sys_ticks();
            while ((uint16_t)((uint16_t)sys_ticks() - bonus_ticks) < 2)
                ;
        }
        if (bonus_base < 0x280 || (uint16_t)(bonus_base - 0x280) < bonus_stop)
            break;
        bonus_base -= 0x280;
    }
    speaker_off();
}

/* 원래: 3A3A  보너스 점수 네 자리 찍기 (BIOS 글자) */
static void print_bonus(void)
{
    bios_set_cursor((uint8_t)(bonus_row >> 3), 0x12);
    for (bonus_print_i = 3; bonus_print_i < 7; bonus_print_i++)
        bios_putc((uint8_t)(DB(BONUS_DIGITS + bonus_print_i) + '0'), 3);
}

/* 원래: 3A6C  "BONUS MULTIPLIER: nn" */
static void print_multiplier(void)
{
    int i;

    bios_set_cursor(10, 10);
    DW(MULTIPLIER_TEXT + 0x12) = DW(MULTIPLIER_DIGITS + multiplier_index);
    for (i = 0; i < 0x14; i++)
        bios_putc(DB(MULTIPLIER_TEXT + i), 3);
}

/* 원래: 3A1C  수직 귀선에 맞춰 배경색 깜빡이기.  시계를 돌려준다 */
static uint16_t flash_background(void)
{
    uint16_t t = (uint16_t)sys_ticks();

    while (!sys_in_retrace())
        ;
    bios_set_color(0, (t & 4) ? 0 : bonus_flash_color);
    return t;
}

/* 원래: 39FA  보너스 글자가 덮을 곳 저장 */
static void save_bonus_area(void)
{
    save_rect(SCRATCH, 0x08E4, 0x0804);
    save_rect(SCRATCH + 0x40, 0x0C94, 0x0814);
}

/* 원래: 38B0 */
void room_bonus(void)
{
    uint16_t t, v, count;
    int i;

    if (prev_room != ROOM_LOVE) {
        MUSIC(SONG_BONUS, 1);
        rooms_won++;
        love_room_next = 1;
        mask_bonus_sprite(0xAAAA);
        bonus_with_sound = 0;
        raise_bonus(0);
    }
    t = (uint16_t)sys_ticks();
    if (prev_room == ROOM_LOVE) {
        t -= level_start_ticks;
        v = (0x2A30 >= t) ? 0x2A30 - t : 0;
        v >>= 1;
    } else {
        t -= room_start_ticks;
        v = 0x546;
        if (prev_room == ROOM_DOGS)
            v <<= 1;
        v = (v >= t) ? v - t : 0;
        if (prev_room != ROOM_DOGS)
            v <<= 1;
    }
    bonus_time = v;
    time_to_bcd(v);
    bcd_add(BONUS_DIGITS, room_base_bonus(prev_room));

    if (prev_room == ROOM_LOVE) {
        multiplier_index = level * 2;
        count = level_multiplier(level);
        if (gift_carried < 8) {
            count <<= 1;
            multiplier_index += 0x10;
        }
        for (i = count; i; i--)
            bcd_add(SCORE, BONUS_DIGITS);
        save_bonus_area();
        bonus_row = 0x38;
        bonus_flash_color = 1;
        bonus_show_ticks = 0x44;
        print_bonus();
        print_multiplier();
    } else {
        bcd_add(SCORE, BONUS_DIGITS);
        bonus_flash_color = 2;
        bonus_show_ticks = 0x1E;
        mask_bonus_sprite(0xFFFF);
        bonus_row = (uint8_t)(((uint16_t)(0xA8C - bonus_time) >> 4) & 0xF0);
        bonus_with_sound = 1;
        raise_bonus((uint16_t)(bonus_row * 0x28));
        print_bonus();
    }

    bonus_ticks = (uint16_t)sys_ticks();
    do {
        if (prev_room == ROOM_LOVE)
            love_tune();
        else
            bonus_tune();
    } while ((uint16_t)(flash_background() - bonus_ticks) < bonus_show_ticks);
    bios_set_color(0, 0);
    if (prev_room != ROOM_LOVE) {
        speaker_off();
        return;
    }
    blit(0x08E4, SCRATCH, 0x0804);
    blit(0x0C94, SCRATCH + 0x40, 0x0814);
}
