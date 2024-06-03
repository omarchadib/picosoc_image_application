# Makefile

RISCV_GNU_TOOLCHAIN_GIT_REVISION = 8c969a9
RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /home/omar/lowrisc-toolchain-rv32imcb-20220524-1
TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)/bin/riscv32-unknown-elf-

PYTHON = /usr/bin/python3

GCC_ARGS = -mcmodel=medlow

COMPRESSED_ISA = 

CC      = /usr/bin/gcc
CFLAGS  = -Wall -O3
LDFLAGS = -Os #-pg -g 

BUILDDIR = build
SOURCEDIR = src
HEADERDIR = src
TOOLS = ../../tools

SOURCES = $(wildcard $(SOURCEDIR)/*.c)
SOURCES_A = $(wildcard $(SOURCEDIR)/*.S)
OBJECTS = $(patsubst $(SOURCEDIR)/%.c, $(BUILDDIR)/%.o, $(SOURCES))
OBJECTS_A = $(patsubst $(SOURCEDIR)/%.S, $(BUILDDIR)/%.o, $(SOURCES_A))

BINARY = firmware.elf

RM = rm -rf
MKDIR = mkdir

ARCHITECTURE = rv32i$(subst C,c,$(COMPRESSED_ISA))

.PHONY: all clean sizes setup

################################################################################

all: firmware.hex firmware.objdump

################################################################################

%.objdump: %.elf
	$(TOOLCHAIN_PREFIX)objdump -D $< > $@

%.bin: %.elf
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@

%.hex: %.bin
	$(PYTHON) $(TOOLS)/makehex.py $^ 2048 > $@

# LINKING ######################################################################
$(BINARY): $(OBJECTS) $(OBJECTS_A)
	$(TOOLCHAIN_PREFIX)gcc -ffreestanding -nostdlib -o $@ $^ $(GCC_ARGS) --std=gnu99 -Wl,-Bstatic,-T,firmware.lds,-Map,firmware.map,--strip-debug -lgcc

# COMPILING ####################################################################
$(BUILDDIR)/%.o: $(SOURCEDIR)/%.c
	$(TOOLCHAIN_PREFIX)gcc -c -march=$(ARCHITECTURE) -O3 --std=c99 $(GCC_WARNS) -ffreestanding -nostdlib -o $@ $<

# MAIN STRUCTURE
$(BUILDDIR)/start.o: $(SOURCEDIR)/start.S
	$(TOOLCHAIN_PREFIX)gcc -c -march=$(ARCHITECTURE) -o $@ $<


################################################################################

sizes: firmware.elf
	$(TOOLCHAIN_PREFIX)size $^

setup:
	$(MKDIR) -p $(BUILDDIR)

clean:
	$(RM) firmware*.elf firmware*.bin firmware*.hex firmware*.map firmware*.objdump
	$(RM) $(BINARY) $(OBJECTS) $(OBJECTS_A)
	$(RM) -f simulation_output.dat

report: simulation_output.dat
	$(PYTHON) $(TOOLS)/parse_simulation.py $<
