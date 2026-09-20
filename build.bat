@echo off
rem Build ALLEY.EXE / ALLEYVGA.EXE with djgpp (arguments go to make)
call "%~dp0..\..\djgpp\setenv.bat"
cd /d "%~dp0"
make -f alley.mak %*
