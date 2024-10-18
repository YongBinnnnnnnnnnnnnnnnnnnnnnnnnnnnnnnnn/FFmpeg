#!/bin/bash

export LDFLAGS="-lc -lcfe -lc -EL -z max-page-size=32"
export CXX_LDFLAGS="-EL -Wl,--gc-sections --static -z max-page-size=32"

export CFLAGS="-EL -Os -G0 -mno-abicalls -fno-pic -ffunction-sections -fdata-sections -I ../../libs/libretro-common/include"
export PATH=/opt/mips32-mti-elf/2019.09-03-2/bin/:$PATH
export LD_LIBRARY_PATH=/opt/mips32-mti-elf/2019.09-03-2/lib 
./configure --arch=mips --target-os=none --cross-prefix=mips-mti-elf- --disable-asm
sed -i config.h -e "s|#define getenv(x) NULL|inline char* getenv(const char *a){return (char*)0;}|" -e "s|HAVE_CBRT 0|HAVE_CBRT 1|" -e "s|HAVE_RINT 0|HAVE_RINT 1|" -e "s|HAVE_LRINT 0|HAVE_LRINT 1|" -e "s|HAVE_LRINTF 0|HAVE_LRINTF 1|" -e "s|HAVE_ROUND 0|HAVE_ROUND 1|" -e "s|HAVE_TRUNC 0|HAVE_TRUNC 1|" -e "s|HAVE_ISINF 0|HAVE_ISINF 1|" -e "s|HAVE_ISNAN 0|HAVE_ISNAN 1|"


sed -i libavutil/time_internal.h -e "s|static inline|inline|g"
sed -i ffmpeg.c -e "s|.*3 system signals.*||g"
make
export CC=/opt/mips32-mti-elf/2019.09-03-2/bin/mips-mti-elf-gcc
cd libretro
platform=sf2000 make
