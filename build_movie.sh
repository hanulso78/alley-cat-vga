#!/bin/sh
# 플레이 영상 도구 movie.exe (MSYS2 mingw gcc) - tools/movie.c 참고
export PATH=/c/MSYS2/mingw64/bin:$PATH
cd "$(dirname "$0")"
gcc -O2 -Wall -Wno-unused-function -fno-strict-aliasing -DCATVGA -o movie.exe \
    main.c clothes.c cat.c alley.c dog.c screen.c score.c draw.c broom.c fishbowl.c \
    spider.c cheese.c birdcage.c dogs.c love.c win.c sound.c title.c gfx.c bios.c data.c \
    col256.c actor.c tools/movie.c
