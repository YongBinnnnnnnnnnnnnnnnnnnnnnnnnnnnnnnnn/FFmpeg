OPENGL = 1
BAKE_IN_FFMPEG = 0

ifeq ($(platform),)
platform = unix
ifeq ($(shell uname -a),)
   platform = win
else ifneq ($(findstring MINGW,$(shell uname -a)),)
   platform = win
else ifneq ($(findstring Darwin,$(shell uname -a)),)
   platform = osx
else ifneq ($(findstring win,$(shell uname -a)),)
   platform = win
endif
endif

system = $(shell uname -m)

TARGET_NAME := ffmpeg

ifneq (,$(findstring unix,$(platform)))
	ARCH_X86 = 1
   TARGET := $(TARGET_NAME)_libretro.so
   fpic := -fPIC
   SHARED := -shared -Wl,--version-script=link.T -Wl,--no-undefined -fPIC
ifeq ($(OPENGL),1)
   GL_LIB := -lGL
   CFLAGS += -DHAVE_GL
   HAVE_GL := 1
endif
   HAVE_SSA := 1

   LIBS = $(shell pkg-config libavcodec libavformat libswscale libass --libs) -pthread
   CFLAGS += $(shell pkg-config libavcodec libavformat libswscale libass --cflags) -pthread
ifeq ($(BAKE_IN_FFMPEG),0)
   LIBS += $(shell pkg-config libavutil libswresample --libs)
   CFLAGS += $(shell pkg-config libavutil libswresample --cflags)
endif
else ifneq (,$(findstring osx,$(platform)))
	ARCH_X86 = 1
   TARGET := $(TARGET_NAME)_libretro.dylib
   fpic := -fPIC
   SHARED := -dynamiclib
ifeq ($(OPENGL),1)
   GL_LIB := -framework OpenGL
   HAVE_GL := 1
   CFLAGS += -DHAVE_GL
endif
   HAVE_SSA := 1
OSXVER = `sw_vers -productVersion | cut -c 4`
ifneq ($(OSXVER),9)
   fpic += -mmacosx-version-min=10.5
endif

   LIBS = $(shell pkg-config libavcodec libavformat libswscale libass --libs) -pthread
   CFLAGS += $(shell pkg-config libavcodec libavformat libswscale libass --cflags) -pthread
ifeq ($(BAKE_IN_FFMPEG),0)
   LIBS += $(shell pkg-config libavutil libswresample --libs)
   CFLAGS += $(shell pkg-config libavutil libswresample --cflags)
endif
else ifneq (,$(findstring win,$(platform)))
	ARCH_X86 = 1
   CC = gcc
   TARGET := $(TARGET_NAME)_libretro.dll
   SHARED := -shared -static-libgcc -static-libstdc++ -s -Wl,--version-script=link.T -Wl,--no-undefined
   CFLAGS += -Iffmpeg
ifeq ($(OPENGL),1)
   GL_LIB := -lopengl32
   CFLAGS += -DHAVE_GL
   HAVE_GL := 1
endif
   LIBS += -L. -Lffmpeg -lavcodec -lavformat -lswscale
ifeq ($(BAKE_IN_FFMPEG),0)
	LIBS += -lavutil -lswresample
endif
endif

ifeq ($(HAVE_SSA), 1)
   LIBS += $(shell pkg-config libass --libs)
   CFLAGS += -DHAVE_SSA
endif

SOURCE := libretro.c fifo_buffer.c thread.c

ifeq ($(BAKE_IN_FFMPEG),1)
LIBS += -lm

ifeq ($(HAVE_BIGENDIAN),1)
CPUOPTS += -DHAVE_BIGENDIAN=1
else
CPUOPTS += -DHAVE_BIGENDIAN=0
endif

CPUOPTS += -DHAVE_MMX=0 -DARCH_X86=1 -DARCH_BFIN=0 -DHAVE_ALTIVEC=0 -DHAVE_MMXEXT=0 -DHAVE_MMX_INLINE=0 -DHAVE_MMXEXT_INLINE=0
CPUOPTS += -DHAVE_AMD3DNOW_INLINE=0
ifeq ($(ARCH_X86),1)
endif

#This is ARMv8/NEON
ifeq ($(ARCH_AARCH64),1)
CPUOPTS += -DARCH_AARCH64=1
else
CPUOPTS += -DARCH_AARCH64=0
endif

ifeq ($(ARCH_ARM),1)
CPUOPTS += -DARCH_ARM=1
else
CPUOPTS += -DARCH_ARM=0
endif
ifeq ($(ARCH_PPC),1)
CPUOPTS += -DARCH_PPC=1
else
CPUOPTS += -DARCH_PPC=0
endif

ifeq ($(HAVE_ALTIVEC),1)
CPUOPTS += -DHAVE_ALTIVEC=1
else
CPUOPTS += -DHAVE_ALTIVEC=0
endif
CFLAGS += -I$(BASE_DIR) -I. -DHAVE_CBRT -DHAVE_CBRTF -DHAVE_ISINF -DHAVE_ISNAN -DHAVE_RINT -DHAVE_LRINT -DHAVE_LRINTF -DHAVE_ROUND -DHAVE_ROUNDF -DHAVE_TRUNC -DHAVE_TRUNCF -DHAVE_YASM=0 $(CPUOPTS)  -DHAVE_AV_CONFIG_H -DHAVE_SWSCALE_H
CFLAGS += -DCONFIG_SWSCALE_ALPHA=1

#libswresample
AVUTIL_DIR   := ../libavutil
SWSCALE_DIR  := ../libswscale
SWRESAMPLE_DIR  := ../libswresample
BASE_DIR := ../

SOURCE += $(AVUTIL_DIR)/atomic.c \
			 $(AVUTIL_DIR)/avstring.c \
			 $(AVUTIL_DIR)/buffer.c \
			 $(AVUTIL_DIR)/dict.c \
			 $(AVUTIL_DIR)/eval.c \
			 $(AVUTIL_DIR)/error.c \
			 $(AVUTIL_DIR)/frame.c \
			 $(AVUTIL_DIR)/mathematics.c \
			 $(AVUTIL_DIR)/mem.c \
			 $(AVUTIL_DIR)/channel_layout.c \
			 $(AVUTIL_DIR)/opt.c \
			 $(AVUTIL_DIR)/sha.c \
			 $(AVUTIL_DIR)/bprint.c \
			 $(AVUTIL_DIR)/parseutils.c \
			 $(AVUTIL_DIR)/random_seed.c \
			 $(AVUTIL_DIR)/pixdesc.c \
			 $(AVUTIL_DIR)/rational.c \
			 $(AVUTIL_DIR)/imgutils.c \
			 $(AVUTIL_DIR)/samplefmt.c \
			 $(AVUTIL_DIR)/log.c \
			 $(AVUTIL_DIR)/cpu.c \
			 $(AVUTIL_DIR)/time.c

#SOURCE += $(SWSCALE_DIR)/input.c \
			 $(SWSCALE_DIR)/options.c \
			 $(SWSCALE_DIR)/output.c \
			 $(SWSCALE_DIR)/rgb2rgb.c \
			 $(SWSCALE_DIR)/swscale.c \
			 $(SWSCALE_DIR)/utils.c \
			 $(SWSCALE_DIR)/yuv2rgb.c

ifeq ($(ARCH_X86),1)
			 SOURCE += $(AVUTIL_DIR)/x86/cpu.c
			 #SOURCE += $(SWSCALE_DIR)/x86/rgb2rgb.c \
				 			$(SWSCALE_DIR)/x86/swscale.c \
							$(SWSCALE_DIR)/x86/yuv2rgb.c
endif

ifeq ($(ARCH_PPC),1)
			SOURCE += $(AVUTIL_DIR)/ppc/cpu.c \
						 $(AVUTIL_DIR)/ppc/float_dsp_init.c
endif

ifeq ($(HAVE_ALTIVEC),1)
			SOURCE += $(AVUTIL_DIR)/ppc/float_dsp_altivec.c
endif

ifeq ($(ARCH_ARM),1)
			 SOURCE += $(AVUTIL_DIR)/arm/cpu.c
			 #SOURCE += $(SWSCALE_DIR)/arm/swscale_unscaled.c
endif

SOURCE += $(SWRESAMPLE_DIR)/audioconvert.c \
			 $(SWRESAMPLE_DIR)/dither.c \
			 $(SWRESAMPLE_DIR)/rematrix.c \
			 $(SWRESAMPLE_DIR)/resample.c \
			 $(SWRESAMPLE_DIR)/swresample.c
endif

CFLAGS += -Wall -std=gnu99 -pedantic $(fpic)

ifeq ($(DEBUG), 1)
   CFLAGS += -O0 -g
else
   CFLAGS += -O3
endif

ifeq ($(HAVE_GL), 1)
   ifeq ($(GLES), 1)
      LIBS += -lGLESv2
      CFLAGS += -DGLES
   else
      LIBS += $(GL_LIB)
   endif
   SOURCE += glsym.c
endif

OBJECTS := $(SOURCE:.c=.o)

all: $(TARGET)

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

$(TARGET): $(OBJECTS)
	$(CC) -o $@ $^ $(LIBS) $(SHARED)

clean:
	rm -f $(OBJECTS)
	rm -f $(TARGET)

.PHONY: clean

