#ifndef FFT_HPP__
#define FFT_HPP__

#include <vector>

#ifndef FFT_H__
#error "Don't include this file directly. Include fft.h first!"
#endif

struct GLFFT
{
   public:
      GLFFT();
      void context_reset(unsigned fft_steps, rglgen_proc_address_t proc, unsigned fft_depth = 256);
      void context_destroy();
      void init_multisample(unsigned width, unsigned height, unsigned samples);

      void step_fft(const GLshort *buffer, unsigned frames);
      void render(GLuint backbuffer, unsigned width, unsigned height);

   private:

      struct Target
      {
         GLuint tex;
         GLuint fbo;
      };

      struct Pass
      {
         Target target;
         GLuint parameter_tex;
      };

      GLuint ms_rb_color;
      GLuint ms_rb_ds;
      GLuint ms_fbo;

      std::vector<Pass> passes;
      GLuint input_tex;
      GLuint window_tex;
      GLuint prog_real;
      GLuint prog_complex;
      GLuint prog_resolve;
      GLuint prog_blur;

      GLuint quad;
      GLuint vao;

      unsigned output_ptr;

      Target output, resolve, blur;

      struct Block
      {
         Block() : prog(0), vao(0), vbo(0), ibo(0), elems(0) {}
         GLuint prog;
         GLuint vao;
         GLuint vbo;
         GLuint ibo;
         unsigned elems;
      } block;

      GLuint pbo;
      std::vector<GLshort> sliding;

      unsigned fft_steps;
      unsigned fft_size;
      unsigned fft_block_size;
      unsigned fft_depth;

      static GLuint compile_shader(GLenum type, const char *source);
      static GLuint compile_program(const char *vertex_source, const char *fragment_source);
      static void build_fft_params(GLuint *buffer, unsigned step, unsigned size);

      void init_quad_vao();
      void init_fft();
      void init_block();

      void init_texture(GLuint &tex, GLenum format, unsigned width, unsigned height, unsigned levels = 1, GLenum mag = GL_NEAREST, GLenum min = GL_NEAREST);
      void init_target(Target &target, GLenum format, unsigned width, unsigned height, unsigned levels, GLenum mag = GL_NEAREST, GLenum min = GL_NEAREST);
};

#endif
