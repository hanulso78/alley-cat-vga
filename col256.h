/* col256.h - 개선판 256색 (col256.c) */
#ifndef COL256_H
#define COL256_H

extern uint8_t pal256[256][3];          /* 0..63 */
extern int theme_room;                  /* 지금 화면에 그려진 방 (색 테마) */
extern short col256_lx[200], col256_rx[200];   /* col256_compose 가 칠한 줄 구간 */
#define COL_SPRITE  144                 /* 144 부터는 그림에서 새로 칠한 색 */
extern uint8_t theme_tab[200][16];      /* [줄][ (x&3)*4 + 원래색 ] -> 팔레트 번호 */
void col256_theme_refresh(void);
extern uint8_t cga_remaster[16][3];

/* 사이 동작 그림 (ALLEY256.SPR 뒤의 "TWEN"): 원판 그림 from 다음에 to 를 그릴 때 사이에 */
typedef struct {
    uint16_t from, to;
    uint8_t w, h;
    uint8_t *pix;               /* 팔레트 번호, 0 = 투명 */
} tween_t;
#define MAX_TWEENS 64
extern tween_t tweens[MAX_TWEENS];
extern int tween_count;
const tween_t *tween_find(uint16_t from, uint16_t to);

int col256_load(const char *fn);        /* 1 = 읽었다 */
void col256_update_cga(void);           /* 포트 3D9h 가 바뀌면 */
void col256_compose(uint8_t *frame);    /* 320x200 색 번호 */
uint8_t col256_nearest(int r, int g, int b);   /* 0..63 성분 */

#endif
