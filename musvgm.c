/* ============================================================================
 *  musvgm.c  -  배경음악, 애드립(OPL2) VGM 재생  ->  ALLEYVGA.EXE
 * ----------------------------------------------------------------------------
 *  원판의 음악은 PC 스피커였다: 타이틀 곡, 골목과 방에서 난수로 만드는 걷는
 *  베이스, 판 끝/실패 때의 짧은 곡.  이 판은 tools/mkmusic.py 가 만든 곡
 *  (SOUND.DAT) 을 애드립으로 연주하고, 그 자리의 스피커 음악은 소리만 끈다
 *  (박자를 재던 기다림은 그대로 둔다 - 게임 속도가 원판과 같도록).
 *  효과음은 원판 그대로 PC 스피커.
 *
 *      SOUND.DAT   0..7 "ACSND10"+0,  8..9 곡 수,
 *                  곡마다 20바이트 (이름 12 / 시작 위치 4 / 길이 4), 그 뒤 VGM 자료
 *
 *  Ctrl-S 로 소리를 끄면(sound_on = 0) 음악도 멈추고, 켜면 곡 처음부터.
 *  일시정지(Esc) 동안은 멈췄다가 이어서 울린다.
 *  애드립이 없거나 파일이 없으면 조용히 넘어간다.
 * ========================================================================== */
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <pc.h>
#ifdef CAT_TEST
#include <stdio.h>
#endif

#include "allycat.h"
#include "platform.h"

uclock_t sys_uclock(void);           /* sys_dos.c: BIOS 시계를 되돌려도 앞으로만 가는 시계 */
uclock_t sys_now(void);              /* 고리 한 바퀴 안에서 이미 읽어 둔 시각 */

#define OPL_ADDR    0x388
#define OPL_DATA    0x389
#define SOUND_DAT   "sound.dat"
#define SOUND_MAGIC "ACSND10"

static const char *const song_file[SONGS] = {
    NULL, "ACTITLE.VGM", "ACALLEY.VGM", "ACROOM.VGM", "ACFISH.VGM", "ACLOVE.VGM",
    "ACHEARTS.VGM", "ACWIN.VGM", "ACBONUS.VGM", "ACSAD.VGM", "ACCAUGHT.VGM"
};

typedef struct {
    unsigned char *buf;
    long           len, pos, loop;
    uclock_t       next;
    int            loaded;                  /* 0 아직, 1 읽음, -1 없음 */
} vgm_stream;

static int        opl_found = -1;
static vgm_stream track[SONGS];
static int        song = SONG_NONE;         /* 지금 울리는 곡 */
static int        muted;                    /* sound_on == 0 이라 멈춤 */
static int        paused;

static void opl_wait(int n)
{
    int i;
    for (i = 0; i < n; i++)
        (void)inportb(OPL_ADDR);
}

static void opl_write(int reg, int val)
{
    outportb(OPL_ADDR, (unsigned char)reg);
    opl_wait(6);
    outportb(OPL_DATA, (unsigned char)val);
    opl_wait(35);
}

static int opl_detect(void)
{
    unsigned char s1, s2;

    opl_write(4, 0x60);
    opl_write(4, 0x80);
    s1 = inportb(OPL_ADDR);
    opl_write(2, 0xFF);
    opl_write(4, 0x21);
    opl_wait(400);
    s2 = inportb(OPL_ADDR);
    opl_write(4, 0x60);
    opl_write(4, 0x80);
    return (s1 & 0xE0) == 0x00 && (s2 & 0xE0) == 0xC0;
}

static void opl_silence(void)
{
    int i;

    for (i = 0xB0; i <= 0xB8; i++)
        opl_write(i, 0x00);
    opl_write(0xBD, 0x00);
    for (i = 0x40; i <= 0x55; i++)
        opl_write(i, 0x3F);
}

static void opl_reset(void)
{
    int i;

    opl_silence();
    for (i = 0x01; i <= 0xF5; i++)
        opl_write(i, 0x00);
}

static unsigned long le32(const unsigned char *p)
{
    return p[0] | (unsigned long)p[1] << 8 | (unsigned long)p[2] << 16 | (unsigned long)p[3] << 24;
}

static uclock_t samples_to_uclock(long n)
{
    return (uclock_t)((double)n * UCLOCKS_PER_SEC / 44100.0);
}

/* SOUND.DAT 목차에서 이름을 찾아 읽어 온다 */
static int stream_load(vgm_stream *s, const char *name)
{
    unsigned char head[10], entry[20];
    unsigned long off = 0, size = 0;
    int fd, count, i, found = 0;

    s->loaded = -1;
    fd = open(SOUND_DAT, O_RDONLY | O_BINARY);
    if (fd == -1)
        return 0;
    if (read(fd, head, 10) != 10 || memcmp(head, SOUND_MAGIC, 8) != 0) {
        close(fd);
        return 0;
    }
    count = head[8] | head[9] << 8;
    for (i = 0; i < count && !found; i++) {
        if (read(fd, entry, 20) != 20)
            break;
        if (strncmp((char *)entry, name, 12) == 0) {
            off = le32(entry + 12);
            size = le32(entry + 16);
            found = 1;
        }
    }
    if (!found || size < 0x40 || size > 1024L * 1024L ||
        lseek(fd, off, SEEK_SET) != (off_t)off || (s->buf = malloc(size)) == NULL) {
        close(fd);
        return 0;
    }
    s->len = read(fd, s->buf, size);
    close(fd);
    if (s->len < 0x40 || memcmp(s->buf, "Vgm ", 4) != 0) {
        free(s->buf);
        s->buf = NULL;
        return 0;
    }
    s->loaded = 1;
    return 1;
}

static void stream_rewind(vgm_stream *s)
{
    unsigned long loop = le32(s->buf + 0x1C), data = le32(s->buf + 0x34);

    s->loop = loop ? (long)(0x1C + loop) : 0;
    if (s->loop >= s->len)
        s->loop = 0;
    s->pos = data ? (long)(0x34 + data) : 0x40;
    s->next = sys_uclock();
}

/* 시각이 된 명령을 칩에 보낸다.  끝나면 0 */
static int stream_poll(vgm_stream *s)
{
    uclock_t now = sys_now();
    const unsigned char *b = s->buf;
    unsigned char c;

    if (now > s->next + UCLOCKS_PER_SEC / 4)
        s->next = now;
    while (now >= s->next) {
        if (s->pos >= s->len) {
            if (!s->loop)
                return 0;
            s->pos = s->loop;
        }
        c = b[s->pos];
        if (c == 0x5A) {
            opl_write(b[s->pos + 1], b[s->pos + 2]);
            s->pos += 3;
        } else if (c == 0x61) {
            s->next += samples_to_uclock(b[s->pos + 1] | b[s->pos + 2] << 8);
            s->pos += 3;
        } else if (c == 0x62) {
            s->next += samples_to_uclock(735);
            s->pos++;
        } else if (c == 0x63) {
            s->next += samples_to_uclock(882);
            s->pos++;
        } else if (c >= 0x70 && c <= 0x7F) {
            s->next += samples_to_uclock((c & 15) + 1);
            s->pos++;
        } else if (c == 0x66) {
            if (!s->loop)
                return 0;
            s->pos = s->loop;
        } else if (c >= 0x51 && c <= 0x5F) {
            s->pos += 3;
        } else {
            s->pos++;
        }
        now = sys_now();
    }
    return 1;
}

static void music_exit(void)
{
    if (opl_found == 1)
        opl_reset();
}

void extra_init(void)
{
    opl_found = opl_detect();
#ifdef CAT_TEST
    fprintf(stderr, "adlib %s\n", opl_found ? "found" : "not found");
#endif
    if (opl_found) {
        opl_reset();
        opl_write(0x01, 0x20);
        atexit(music_exit);
    }
}

/* ---------------------------------------------------------------------------
 *  곡 고르기.  restart 가 0 이고 같은 곡이 울리는 중이면 그대로 둔다.
 * ------------------------------------------------------------------------- */
void music_play(int which, int restart)
{
    vgm_stream *s;

    if (opl_found != 1)
        return;
    if (which == song && !restart)
        return;
    if (song != SONG_NONE)
        opl_silence();
    song = SONG_NONE;
    if (which <= SONG_NONE || which >= SONGS)
        return;
    s = &track[which];
    if (s->loaded == 0)
        stream_load(s, song_file[which]);
    if (s->loaded < 0)
        return;
    stream_rewind(s);
    opl_write(0x01, 0x20);
    song = which;
    muted = 0;
#ifdef CAT_TEST
    fprintf(stderr, "music %s at %.2fs (%ld bytes)\n", song_file[which],
            (double)sys_uclock() / UCLOCKS_PER_SEC, s->len);
#endif
}

void music_stop(void)
{
    music_play(SONG_NONE, 1);
}

/* 일시정지: 멈춘 동안 시각을 미뤄 두었다가 이어서 */
void music_pause(int on)
{
    static uclock_t paused_at;

    if (opl_found != 1 || song == SONG_NONE || on == paused)
        return;
    paused = on;
    if (on) {
        paused_at = sys_uclock();
        opl_silence();
    } else {
        /* 멈출 때 음색 크기를 지웠으니, 곡 머리(음색 설정, 첫 기다림까지)를 다시 보낸다 */
        vgm_stream *s = &track[song];
        long keep = s->pos;
        uclock_t next = s->next + (sys_uclock() - paused_at);

        stream_rewind(s);
        while (s->pos < s->len && s->buf[s->pos] == 0x5A) {
            opl_write(s->buf[s->pos + 1], s->buf[s->pos + 2]);
            s->pos += 3;
        }
        s->pos = keep;
        s->next = next;
    }
}

/* 기다리는 곳마다(sys_dos.c) 부른다 */
void extra_poll(void)
{
    if (opl_found != 1 || song == SONG_NONE || paused)
        return;
    if (sound_on == 0) {
        if (!muted) {
            muted = 1;
            opl_silence();
        }
        return;
    }
    if (muted) {                                /* 다시 켜면 처음부터 */
        stream_rewind(&track[song]);
        muted = 0;
    }
    if (!stream_poll(&track[song])) {
        opl_silence();
        song = SONG_NONE;
    }
}
