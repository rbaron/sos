# Filenames
OUTPUT_IMAGE=kernel.img

# Compiler, assembler, linker, linker script

CC=i586-elf-gcc
LD=i586-elf-gcc
AS=i586-elf-as

LINKERSCRIPT=linker/linker.ld

# Flags

CFLAGS=-c -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS=-T $(LINKERSCRIPT) -ffreestanding -O2 -nostdlib -lgcc
ASFLAGS=

all: kernel

kernel: kernel.o boot.o 
	$(LD) $(LDFLAGS) kernel.o boot.o -o $(OUTPUT_IMAGE)

boot.o: boot.s
	$(AS) $(ASFLAGS) boot.s -o boot.o

kernel.o: kernel.c

	$(CC) $(CFLAGS) kernel.c 

clean:
	rm -rf *.o *.img

