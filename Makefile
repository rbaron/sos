# Filenames
OUTPUT_IMAGE=sos.img

# Compiler, assembler, linker, linker script

CC=i586-elf-gcc
LD=i586-elf-gcc
#AS=i586-elf-as
AS=nasm

LINKERSCRIPT=linker/linker.ld

# Flags

CFLAGS=-c -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS=-T $(LINKERSCRIPT) -ffreestanding -O2 -nostdlib -lgcc
ASFLAGS= -felf

# Directories

SRCDIR=src
ASDIR=asm
OBJDIR=obj

# Actual filenames for sources (.c and .asm with leading path)
CSRC=$(wildcard $(SRCDIR)/*.c)
ASSRC=$(wildcard $(ASDIR)/*.asm)

# Guess objects before they exist, so that sos depends on them
# {src/.c, asm/.asm) -> obj/.o
OBJC=$(patsubst $(SRCDIR)/%,$(OBJDIR)/%,$(patsubst %.c,%.o,$(CSRC)))
OBJAS=$(patsubst $(ASDIR)/%,$(OBJDIR)/%,$(patsubst %.asm,%.o,$(ASSRC)))

# Concatenate foreguessed object names
OBJ=$(OBJC) $(OBJAS)

# DEBUG
#$(info $(OBJ))
#$(info $(ASSRC))

all: sos

sos: $(OBJ)
	$(LD) $(LDFLAGS) $^ -o $(OUTPUT_IMAGE)

# Assembly

$(OBJDIR)/%.o: $(ASDIR)/%.asm
	$(AS) $(ASFLAGS) $< -o $@

# C

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -rf $(OBJDIR)/* $(OUTPUT_IMAGE)

