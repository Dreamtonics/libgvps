
PREFIX=/usr
CC ?= gcc
AR ?= ar

FP_TYPE ?= float
CONFIG = Debug

CFLAGS_PLAT =
CFLAGS_COMMON = -DFP_TYPE=$(FP_TYPE) -std=c99 -Wall -fPIC $(CFLAGS_PLAT)
ifeq ($(CXX), emcc)
  CFLAGS_DBG = $(CFLAGS_COMMON) -O1 -g -D_DEBUG
  CFLAGS_REL = $(CFLAGS_COMMON) -O3
else
  CFLAGS_DBG = $(CFLAGS_COMMON) -Og -g -D_DEBUG
  CFLAGS_REL = $(CFLAGS_COMMON) -Ofast
endif
ifeq ($(CONFIG), Debug)
  CFLAGS = $(CFLAGS_DBG)
else
  CFLAGS = $(CFLAGS_REL)
endif
ARFLAGS = -rv
OUT_DIR = ./build
OBJS = $(OUT_DIR)/gvps_sampled.o $(OUT_DIR)/gvps_obsrv.o $(OUT_DIR)/gvps_full.o $(OUT_DIR)/gvps_variable.o
LIBS =

default: $(OUT_DIR)/libgvps.a

$(OUT_DIR)/libgvps.a: $(OBJS)
	$(AR) $(ARFLAGS) $(OUT_DIR)/libgvps.a $(OBJS) $(LIBS)
	@echo Done.

$(OUT_DIR)/gvps_sampled.o : gvps_sampled.c gvps_sampled.hc gvps_viterbi.hc gvps.h
$(OUT_DIR)/gvps_full.o : gvps_full.c gvps_viterbi.hc gvps.h
$(OUT_DIR)/gvps_variable.o : gvps_variable.c gvps_viterbi.hc gvps.h

$(OUT_DIR)/%.o : %.c gvps.h
	mkdir -p $(OUT_DIR)
	$(CC) $(CFLAGS) -o $(OUT_DIR)/$*.o -c $*.c

install: $(OUT_DIR)/libgvps.a
	mkdir -p $(PREFIX)/lib/ $(PREFIX)/include/libgvps
	cp $(OUT_DIR)/libgvps.a $(PREFIX)/lib/
	cp gvps.h $(PREFIX)/include/libgvps
	@echo Done.

clean:
	@echo 'Removing all temporary binaries... '
	@rm -f $(OUT_DIR)/libgvps.a $(OUT_DIR)/*.o
	@echo Done.

clear:
	@echo 'Removing all temporary binaries... '
	@rm -f $(OUT_DIR)/libgvps.a $(OUT_DIR)/*.o
	@echo Done.

