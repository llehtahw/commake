include ../commake.mk
CC := g++
CFLAGS += -O2 -g -std=c++11 -I. -fPIC

$(call c_compile_objs,a_objs,$(wildcard a/*.cpp))
$(call c_compile_objs,b_objs,$(wildcard b/*.cpp))
$(call c_compile_objs,c_objs,$(wildcard c/*.cpp))

$(call link_target_so,b,$(b_objs_OBJS))

$(call link_target_exe,a,$(a_objs_OBJS) $(c_objs_OBJS))

a_FLAGS += -L. -l:$(b_OBJS)

before_comma:

after_comma:
