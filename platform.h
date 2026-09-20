/* ============================================================================
 *  platform.h  -  도스 판 내부 연결 (sys_dos.c <-> 화면/음악 백엔드)
 * ----------------------------------------------------------------------------
 *  원판(ALLEY.EXE)     vidcga.c   CGA 4색을 VGA 320x200(모드 13h)에 그대로
 *  개선판(ALLEYVGA.EXE) vid256.c   그림마다 색을 따라간 256색 화면
 *                      musvgm.c   애드립 배경음악 (SOUND.DAT)
 * ========================================================================== */
#ifndef PLATFORM_H
#define PLATFORM_H

extern volatile int quit_requested;     /* Ctrl-Alt-Del */

int video_open(void);
void video_close(void);
void video_present(void);
void video_palette_changed(void);
void video_dump(const char *name);      /* 시험판: 지금 화면을 <name>.BMP 로 */
void write_bmp(const char *name, const uint8_t *pixels, const uint8_t pal[][3], int colors);

void extra_init(void);                  /* 개선판의 음악 등 */
void extra_poll(void);

#endif
