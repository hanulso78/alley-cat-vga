#!/bin/sh
# 대조 시험용 hosttest.exe (MSYS2 mingw gcc)
export PATH=/c/MSYS2/mingw64/bin:$PATH
cd "$(dirname "$0")"
gcc -O1 -g -Wall -Wno-unused-function -fno-strict-aliasing -o hosttest.exe \
    main.c clothes.c cat.c alley.c dog.c screen.c score.c draw.c broom.c fishbowl.c \
    spider.c cheese.c birdcage.c dogs.c love.c win.c sound.c title.c gfx.c bios.c data.c \
    tools/hosttest.c

# 개선판 화면 미리보기 (preview256.exe 스크립트 ALLEY256.SPR font.bin 폴더)
gcc -O2 -Wall -Wno-unused-function -fno-strict-aliasing -DCATVGA -o preview256.exe \
    main.c clothes.c cat.c alley.c dog.c screen.c score.c draw.c broom.c fishbowl.c \
    spider.c cheese.c birdcage.c dogs.c love.c win.c sound.c title.c gfx.c bios.c data.c \
    col256.c actor.c tools/hosttest.c
