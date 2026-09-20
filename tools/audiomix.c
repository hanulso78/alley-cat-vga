/* ============================================================================
 *  audiomix.c  -  플레이 영상의 소리: 애드립(OPL2) 음악 + PC 스피커 -> WAV
 * ----------------------------------------------------------------------------
 *      audiomix events.bin SOUND.DAT out.wav 길이초
 *
 *  events.bin 은 movie render 가 남긴 사건 (시각 마이크로초, 종류, 값 둘):
 *      'M' 곡 번호, 처음부터    - musvgm.c 의 music_play (0 = 멈춤)
 *      'P' 1/0                 - 일시정지
 *      'S' 포트, 값             - PC 스피커 (42h, 43h, 61h)
 *
 *  OPL2 는 레지스터 뜻대로 간단히 흉내 낸다 (정확한 칩 복제는 아니다):
 *  위상 누산, 배수, 파형 4가지, 되먹임, FM/AM 연결, ADSR (EGT, KSR),
 *  TL, KSL, 떨림(AM/VIB), 리듬 모드 (BD, SD, TOM, CYM, HH).
 * ========================================================================== */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>

#define SR      44100
#define PI2     6.283185307179586

/* ---------------------------------------------------------------- OPL2 ---- */
enum { EG_OFF, EG_ATTACK, EG_DECAY, EG_SUSTAIN, EG_RELEASE };

typedef struct {
    int mult, ksr, egt, vib, am, tl, ksl, ar, dr, sl, rr, ws;
    double phase;               /* 주기 단위 */
    double env;                 /* 감쇠 dB (0 = 최대) */
    int state;
    double out1, out2;          /* 되먹임용 앞 출력 둘 */
} opl_op;

typedef struct {
    int fnum, block, key, fb, cnt;
} opl_ch;

static opl_op op[18];
static opl_ch ch[9];
static int reg_bd, wse;
static double lfo_t;
static uint32_t noise = 1;

static const int slot_op[32] = {        /* 레지스터 슬롯 -> 연산자 번호 (없음 -1) */
    0, 1, 2, 3, 4, 5, -1, -1, 6, 7, 8, 9, 10, 11, -1, -1,
    12, 13, 14, 15, 16, 17, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
};
/* 연산자 번호 -> (채널, 0 모듈레이터 / 1 캐리어) */
static const int op_ch[18]  = { 0, 1, 2, 0, 1, 2, 3, 4, 5, 3, 4, 5, 6, 7, 8, 6, 7, 8 };
static const int op_car[18] = { 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1 };
static int ch_op[9][2];

static const double mult_tab[16] = { 0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 12, 12, 15, 15 };
static const int kslrom[16] = { 0, 32, 40, 45, 48, 51, 53, 55, 56, 58, 59, 60, 61, 62, 63, 64 };
static const int kslshift[4] = { 8, 1, 2, 0 };

static void opl_init(void)
{
    int i;

    memset(op, 0, sizeof op);
    memset(ch, 0, sizeof ch);
    for (i = 0; i < 18; i++) {
        op[i].env = 96;
        op[i].state = EG_OFF;
        op[i].tl = 63;
        ch_op[op_ch[i]][op_car[i]] = i;
    }
    reg_bd = 0;
    wse = 0;
}

static void key_on(int o)
{
    if (op[o].state == EG_OFF || op[o].state == EG_RELEASE) {
        op[o].state = EG_ATTACK;
        op[o].phase = 0;
    }
}

static void key_off(int o)
{
    if (op[o].state != EG_OFF)
        op[o].state = EG_RELEASE;
}

static void opl_write(int reg, int val)
{
    int o, c;

    if (reg == 0x01) {
        wse = (val & 0x20) != 0;
        return;
    }
    if (reg == 0xBD) {
        int old = reg_bd;
        reg_bd = val;
        if (val & 0x20) {
            /* 리듬: BD = 채널 6 두 연산자, HH = 13(ch7 mod), SD = 16(ch7 car),
               TOM = 14(ch8 mod), CYM = 17(ch8 car) */
            static const int bit_ops[5][2] = { { 13, -1 }, { 17, -1 }, { 14, -1 }, { 16, -1 }, { 12, 15 } };
            int b;
            for (b = 0; b < 5; b++) {
                int m = 1 << b, k;
                for (k = 0; k < 2; k++) {
                    int oo = bit_ops[b][k];
                    if (oo < 0)
                        continue;
                    if ((val & m) && !(old & m))
                        key_on(oo);
                    else if (!(val & m) && (old & m))
                        key_off(oo);
                }
            }
        }
        return;
    }
    if (reg >= 0x20 && reg < 0xA0) {
        o = slot_op[reg & 0x1F];
        if (o < 0)
            return;
        switch (reg & 0xE0) {
        case 0x20:
            op[o].am = (val >> 7) & 1; op[o].vib = (val >> 6) & 1;
            op[o].egt = (val >> 5) & 1; op[o].ksr = (val >> 4) & 1; op[o].mult = val & 15;
            break;
        case 0x40:
            op[o].ksl = (val >> 6) & 3; op[o].tl = val & 63;
            break;
        case 0x60:
            op[o].ar = val >> 4; op[o].dr = val & 15;
            break;
        case 0x80:
            op[o].sl = val >> 4; op[o].rr = val & 15;
            break;
        }
        return;
    }
    if (reg >= 0xE0 && reg <= 0xF5) {
        o = slot_op[reg & 0x1F];
        if (o >= 0)
            op[o].ws = val & 3;
        return;
    }
    if (reg >= 0xA0 && reg <= 0xA8) {
        ch[reg & 15].fnum = (ch[reg & 15].fnum & 0x300) | val;
        return;
    }
    if (reg >= 0xB0 && reg <= 0xB8) {
        c = reg & 15;
        ch[c].fnum = (ch[c].fnum & 0xFF) | ((val & 3) << 8);
        ch[c].block = (val >> 2) & 7;
        if ((val & 0x20) && !ch[c].key) {
            key_on(ch_op[c][0]);
            key_on(ch_op[c][1]);
        } else if (!(val & 0x20) && ch[c].key) {
            key_off(ch_op[c][0]);
            key_off(ch_op[c][1]);
        }
        ch[c].key = (val & 0x20) != 0;
        return;
    }
    if (reg >= 0xC0 && reg <= 0xC8) {
        ch[reg & 15].fb = (val >> 1) & 7;
        ch[reg & 15].cnt = val & 1;
    }
}

/* 연산자 한 개의 엔벨로프를 한 샘플 진행 */
static void env_step(opl_op *p, const opl_ch *c)
{
    int ksn = c->block * 2 + ((c->fnum >> 9) & 1);
    int rof = p->ksr ? ksn : ksn >> 2;
    int rate, er;
    double t_ms, sl_db = p->sl == 15 ? 93 : p->sl * 3.0;

    switch (p->state) {
    case EG_ATTACK:
        rate = p->ar;
        if (rate == 0)
            return;
        er = rate * 4 + rof;
        if (er >= 60) {
            p->env = 0;
        } else {
            t_ms = 2826.24 * pow(2.0, -(er - 4) / 4.0);
            p->env -= (p->env + 0.5) * (6.9 / (t_ms * SR / 1000.0));
        }
        if (p->env <= 0.05) {
            p->env = 0;
            p->state = EG_DECAY;
        }
        return;
    case EG_DECAY:
        rate = p->dr;
        if (rate) {
            er = rate * 4 + rof;
            if (er > 63)
                er = 63;
            t_ms = 39280.64 * pow(2.0, -(er - 4) / 4.0);
            p->env += 96.0 / (t_ms * SR / 1000.0);
        }
        if (p->env >= sl_db) {
            p->env = sl_db;
            p->state = EG_SUSTAIN;
        }
        return;
    case EG_SUSTAIN:
        if (p->egt)
            return;
        /* 타악기형: 누르고 있어도 RR 로 사라진다 */
        /* fall through */
    case EG_RELEASE:
        rate = p->rr;
        if (rate) {
            er = rate * 4 + rof;
            if (er > 63)
                er = 63;
            t_ms = 39280.64 * pow(2.0, -(er - 4) / 4.0);
            p->env += 96.0 / (t_ms * SR / 1000.0);
        }
        if (p->env >= 96) {
            p->env = 96;
            if (p->state == EG_RELEASE)
                p->state = EG_OFF;
        }
        return;
    }
}

static double wave(int ws, double ph)
{
    double f = ph - floor(ph);
    double s = sin(PI2 * f);

    if (!wse)
        ws = 0;
    switch (ws) {
    case 1: return s > 0 ? s : 0;
    case 2: return fabs(s);
    case 3: return (f < 0.25 || (f >= 0.5 && f < 0.75)) ? fabs(s) : 0;
    }
    return s;
}

/* 연산자 크기 (감쇠를 모두 더해 선형으로) */
static double op_amp(const opl_op *p, const opl_ch *c, double trem)
{
    double db = p->env + p->tl * 0.75 + (p->am ? trem : 0);
    int k = p->ksl;

    if (k) {
        int v = (kslrom[c->fnum >> 6] << 2) - ((8 - c->block) << 5);
        if (v > 0)
            db += (v >> kslshift[k]) * 0.1875;
    }
    if (db >= 96 || p->state == EG_OFF)
        return 0;
    return pow(10.0, -db / 20.0);
}

static double op_freq(const opl_op *p, const opl_ch *c, double vib)
{
    double f = c->fnum * 49716.0 / (double)(1 << (20 - c->block));
    return f * mult_tab[p->mult] * (p->vib ? vib : 1.0);
}

static double opl_sample(void)
{
    double out = 0, trem, vib;
    int i, rhythm = (reg_bd & 0x20) != 0;
    double tdepth = (reg_bd & 0x80) ? 4.8 : 1.0, vdepth = (reg_bd & 0x40) ? 0.008 : 0.004;

    lfo_t += 1.0 / SR;
    trem = tdepth * (0.5 + 0.5 * sin(PI2 * 3.7 * lfo_t));
    vib = 1.0 + vdepth * sin(PI2 * 6.07 * lfo_t);
    noise = noise * 1664525u + 1013904223u;

    for (i = 0; i < 18; i++)
        env_step(&op[i], &ch[op_ch[i]]);

    for (i = 0; i < 9; i++) {
        opl_ch *c = &ch[i];
        opl_op *m = &op[ch_op[i][0]], *k = &op[ch_op[i][1]];
        double am_m, am_k, fbmod, mo, ko;

        if (rhythm && i >= 7)
            continue;
        am_m = op_amp(m, c, trem);
        am_k = op_amp(k, c, trem);
        m->phase += op_freq(m, c, vib) / SR;
        k->phase += op_freq(k, c, vib) / SR;
        if (am_m == 0 && am_k == 0)
            continue;
        fbmod = c->fb ? (m->out1 + m->out2) * pow(2.0, c->fb - 7) : 0;
        mo = wave(m->ws, m->phase + fbmod) * am_m;
        m->out2 = m->out1;
        m->out1 = mo;
        if (c->cnt) {
            ko = wave(k->ws, k->phase) * am_k;
            out += (mo + ko) * (rhythm && i == 6 ? 2 : 1);
        } else {
            ko = wave(k->ws, k->phase + 4.0 * mo) * am_k;
            out += ko * (rhythm && i == 6 ? 2 : 1);
        }
    }
    if (rhythm) {
        opl_op *hh = &op[13], *sd = &op[16], *tom = &op[14], *cym = &op[17];
        double nz = ((noise >> 16) & 1) ? 1.0 : -1.0;
        double sq13, sq17, a;

        hh->phase += op_freq(hh, &ch[7], 1) / SR;
        sd->phase += op_freq(sd, &ch[7], 1) / SR;
        tom->phase += op_freq(tom, &ch[8], 1) / SR;
        cym->phase += op_freq(cym, &ch[8], 1) / SR;
        sq13 = (hh->phase - floor(hh->phase)) < 0.5 ? 1 : -1;
        sq17 = (cym->phase * 1.47 - floor(cym->phase * 1.47)) < 0.5 ? 1 : -1;
        if ((a = op_amp(hh, &ch[7], trem)) > 0)
            out += 2 * a * (0.55 * nz + 0.45 * sq13 * sq17) * 0.6;
        if ((a = op_amp(sd, &ch[7], trem)) > 0)
            out += 2 * a * (0.6 * nz + 0.4 * sin(PI2 * sd->phase)) * 0.7;
        if ((a = op_amp(tom, &ch[8], trem)) > 0)
            out += 2 * a * sin(PI2 * tom->phase);
        if ((a = op_amp(cym, &ch[8], trem)) > 0)
            out += 2 * a * (0.5 * sq13 * sq17 + 0.3 * nz) * 0.6;
    }
    return out;
}

static void opl_silence(void)
{
    int i;
    for (i = 0; i < 9; i++)
        opl_write(0xB0 + i, 0);
    opl_write(0xBD, 0);
    for (i = 0; i < 18; i++) {
        op[i].tl = 63;
        op[i].state = EG_OFF;
        op[i].env = 96;
    }
}

/* ---------------------------------------------------------------- VGM ----- */
static const char *const song_file[] = {
    NULL, "ACTITLE.VGM", "ACALLEY.VGM", "ACROOM.VGM", "ACFISH.VGM", "ACLOVE.VGM",
    "ACHEARTS.VGM", "ACWIN.VGM", "ACBONUS.VGM", "ACSAD.VGM", "ACCAUGHT.VGM"
};
#define SONGS 11

static uint8_t *snd;
static long snd_len;
static struct { const uint8_t *b; long len; } song_data[SONGS];

static uint32_t le32(const uint8_t *p)
{
    return p[0] | (uint32_t)p[1] << 8 | (uint32_t)p[2] << 16 | (uint32_t)p[3] << 24;
}

static void load_sound(const char *fn)
{
    FILE *f = fopen(fn, "rb");
    int n, i, s;

    if (!f) { perror(fn); exit(2); }
    fseek(f, 0, SEEK_END);
    snd_len = ftell(f);
    fseek(f, 0, SEEK_SET);
    snd = malloc(snd_len);
    fread(snd, 1, snd_len, f);
    fclose(f);
    n = snd[8] | snd[9] << 8;
    for (i = 0; i < n; i++) {
        const uint8_t *e = snd + 10 + i * 20;
        for (s = 1; s < SONGS; s++)
            if (!strncmp((const char *)e, song_file[s], 12)) {
                song_data[s].b = snd + le32(e + 12);
                song_data[s].len = le32(e + 16);
            }
    }
}

static int cur = 0, paused;
static long pos, loop_pos;
static double next_sample, pause_at;

static void song_start(int s, double now)
{
    const uint8_t *b;
    uint32_t loop, data;

    opl_silence();
    cur = 0;
    if (s <= 0 || s >= SONGS || !song_data[s].b)
        return;
    b = song_data[s].b;
    loop = le32(b + 0x1C);
    data = le32(b + 0x34);
    loop_pos = loop ? 0x1C + loop : 0;
    pos = data ? 0x34 + data : 0x40;
    next_sample = now;
    opl_write(0x01, 0x20);
    cur = s;
}

static void song_poll(double now)
{
    const uint8_t *b;
    long len;

    if (!cur || paused)
        return;
    b = song_data[cur].b;
    len = song_data[cur].len;
    while (next_sample <= now) {
        uint8_t c;
        if (pos >= len) {
            if (!loop_pos) { opl_silence(); cur = 0; return; }
            pos = loop_pos;
        }
        c = b[pos];
        if (c == 0x5A) {
            opl_write(b[pos + 1], b[pos + 2]);
            pos += 3;
        } else if (c == 0x61) {
            next_sample += b[pos + 1] | b[pos + 2] << 8;
            pos += 3;
        } else if (c == 0x62) {
            next_sample += 735; pos++;
        } else if (c == 0x63) {
            next_sample += 882; pos++;
        } else if (c >= 0x70 && c <= 0x7F) {
            next_sample += (c & 15) + 1; pos++;
        } else if (c == 0x66) {
            if (!loop_pos) { opl_silence(); cur = 0; return; }
            pos = loop_pos;
        } else {
            pos++;
        }
    }
}

/* 일시정지를 풀 때: 곡 머리의 음색 설정을 다시 보낸다 (musvgm.c 와 같다) */
static void song_resume(double now)
{
    const uint8_t *b = song_data[cur].b;
    uint32_t data = le32(b + 0x34);
    long p = data ? 0x34 + data : 0x40;

    while (b[p] == 0x5A) {
        opl_write(b[p + 1], b[p + 2]);
        p += 3;
    }
    next_sample += now - pause_at;
}

/* ---------------------------------------------------------------- 스피커 --- */
static int pit_div = 0x10000, pit_lsb, pit_expect_lsb = 1;
static uint8_t p61;
static double spk_phase;

static void speaker_port(int port, int val)
{
    if (port == 0x43) {
        pit_expect_lsb = 1;
    } else if (port == 0x42) {
        if (pit_expect_lsb) {
            pit_lsb = val;
            pit_expect_lsb = 0;
        } else {
            pit_div = pit_lsb | val << 8;
            if (pit_div == 0)
                pit_div = 0x10000;
            pit_expect_lsb = 1;
        }
    } else if (port == 0x61) {
        p61 = (uint8_t)val;
    }
}

static double speaker_level(double dt)
{
    if (!(p61 & 2))
        return 0;
    if (!(p61 & 1))
        return 1;
    spk_phase += dt * 1193182.0 / pit_div;
    spk_phase -= floor(spk_phase);
    return spk_phase < 0.5 ? 1 : 0;
}

/* ---------------------------------------------------------------- 본체 ----- */
typedef struct { double t; int kind, a, b; } event;

int main(int argc, char **argv)
{
    FILE *f, *w;
    event *ev = NULL;
    int nev = 0, cap = 0, ei = 0;
    long n, total;
    double secs, hp_x = 0, hp_y = 0, lp = 0, peak = 0;
    int16_t *pcm;
    float *buf;

    if (argc < 5) {
        fprintf(stderr, "audiomix events.bin SOUND.DAT out.wav seconds\n");
        return 2;
    }
    f = fopen(argv[1], "rb");
    if (!f) { perror(argv[1]); return 2; }
    for (;;) {
        double t;
        int16_t v[2];
        int k;
        if (fread(&t, sizeof t, 1, f) != 1)
            break;
        k = fgetc(f);
        fread(v, sizeof v[0], 2, f);
        if (nev == cap) {
            cap = cap ? cap * 2 : 4096;
            ev = realloc(ev, cap * sizeof *ev);
        }
        ev[nev].t = t;
        ev[nev].kind = k;
        ev[nev].a = v[0];
        ev[nev].b = v[1];
        nev++;
    }
    fclose(f);
    load_sound(argv[2]);
    secs = atof(argv[4]);
    total = (long)(secs * SR);
    opl_init();
    buf = malloc(total * sizeof *buf);

    for (n = 0; n < total; n++) {
        double t0 = (double)n * 1e6 / SR, t1 = (double)(n + 1) * 1e6 / SR;
        double spk = 0, sub = t0, music;
        const int OS = 16;
        int k;

        /* 음악 사건 (이 샘플 시작 전) */
        while (ei < nev && ev[ei].t <= t0 && ev[ei].kind != 'S') {
            if (ev[ei].kind == 'M') {
                if (!(ev[ei].a == cur && !ev[ei].b))
                    song_start(ev[ei].a, (double)n);
            } else if (ev[ei].kind == 'P' && cur) {
                if (ev[ei].a && !paused) {
                    paused = 1;
                    pause_at = n;
                    opl_silence();
                } else if (!ev[ei].a && paused) {
                    paused = 0;
                    song_resume((double)n);
                }
            }
            ei++;
        }
        song_poll((double)n);
        music = paused ? 0 : opl_sample();

        /* 스피커: 한 샘플을 16 조각으로 나눠, 조각 안의 포트 사건을 시각대로 */
        for (k = 0; k < OS; k++) {
            double te = t0 + (t1 - t0) * (k + 1) / OS;
            while (ei < nev && ev[ei].t <= te) {
                if (ev[ei].kind == 'S')
                    speaker_port(ev[ei].a, ev[ei].b);
                else
                    break;              /* 음악 사건은 다음 샘플에서 */
                ei++;
            }
            spk += speaker_level((te - sub) / 1e6);
            sub = te;
        }
        spk /= OS;
        /* 스피커: 직류 막기 + 살짝 둥글게 */
        hp_y = 0.995 * (hp_y + spk - hp_x);
        hp_x = spk;
        lp += (hp_y - lp) * 0.45;
        buf[n] = (float)(music * 0.22 + lp * 0.30);
        if (fabs(buf[n]) > peak)
            peak = fabs(buf[n]);
    }

    pcm = malloc(total * 2 * sizeof *pcm);
    {
        double g = peak > 0.95 ? 0.95 / peak : 1.0;
        for (n = 0; n < total; n++) {
            int v = (int)(buf[n] * g * 32767.0);
            if (v > 32767) v = 32767;
            if (v < -32768) v = -32768;
            pcm[n * 2] = pcm[n * 2 + 1] = (int16_t)v;
        }
        fprintf(stderr, "peak %.3f gain %.3f\n", peak, g);
    }
    w = fopen(argv[3], "wb");
    {
        uint32_t data = (uint32_t)(total * 4), v32;
        uint16_t v16;
        fwrite("RIFF", 1, 4, w); v32 = 36 + data; fwrite(&v32, 4, 1, w);
        fwrite("WAVEfmt ", 1, 8, w); v32 = 16; fwrite(&v32, 4, 1, w);
        v16 = 1; fwrite(&v16, 2, 1, w); v16 = 2; fwrite(&v16, 2, 1, w);
        v32 = SR; fwrite(&v32, 4, 1, w); v32 = SR * 4; fwrite(&v32, 4, 1, w);
        v16 = 4; fwrite(&v16, 2, 1, w); v16 = 16; fwrite(&v16, 2, 1, w);
        fwrite("data", 1, 4, w); fwrite(&data, 4, 1, w);
        fwrite(pcm, 4, total, w);
    }
    fclose(w);
    return 0;
}
