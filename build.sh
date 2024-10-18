#!/bin/bash

export PATH=/opt/mips32-mti-elf/2019.09-03-2/bin/:$PATH
export LD_LIBRARY_PATH=/opt/mips32-mti-elf/2019.09-03-2/lib 
export LDFLAGS=-lcc1
./configure --arch=mips --target-os=none --cross-prefix=mips-mti-elf-
sed -i config.h -e "s|#define getenv(x) NULL|inline char* getenv(const char *a){return (char*)0;}|"
sed -i libavutil/time_internal.h -e "s|static inline|inline|g"
sed -i ffmpeg.c -e "s|.*3 system signals.*||g"
make


