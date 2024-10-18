#!/bin/bash

export LDFLAGS="-lc -lcfe -lc -EL -z max-page-size=32"
export CXX_LDFLAGS="-EL -Wl,--gc-sections --static -z max-page-size=32"

export CFLAGS="-EL -Os -G0 -mno-abicalls -fno-pic -ffunction-sections -fdata-sections -I ../../libs/libretro-common/include"
export PATH=/opt/mips32-mti-elf/2019.09-03-2/bin/:$PATH
export LD_LIBRARY_PATH=/opt/mips32-mti-elf/2019.09-03-2/lib
./configure --arch=mips --target-os=none --cross-prefix=mips-mti-elf- --disable-asm --disable-programs --disable-everything --enable-demuxer=aac,ac3,hevc,h264,mp3,ogg --enable-decoder=aac,ac3,hevc,h264,mp3,ogg --enable-filter=null --enable-parsers

sed -i config.h -e "s|#define getenv(x) NULL|inline char* getenv(const char *a){return (char*)0;}|"

sed -i libavutil/time_internal.h -e "s|static inline|inline|g"
make
cd libretro
platform=sf2000 make
