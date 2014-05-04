#define FFMPEG_CONFIGURATION ""
#define FFMPEG_LICENSE ""
#define CONFIG_MEMORY_POISONING 0
#define CONFIG_FTRAPV 0
#define av_restrict restrict

#ifndef FF_MEMORY_POISON
#define FF_MEMORY_POISON 0x2a
#endif

#ifndef MAKE_ACCESSORS
#define MAKE_ACCESSORS(str, name, type, field) \
    type av_##name##_get_##field(const str *s) { return s->field; } \
    void av_##name##_set_##field(str *s, type v) { s->field = v; }
#endif
