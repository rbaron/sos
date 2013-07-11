sos
===

sos is a protected mode, multiboot compliant, x86 (32 bit), completely useless operating system written in [nasm](http://www.nasm.us/)-flavoured assembly. As of now, it boots using GRUB2 and shows the following screen (here emulated with qemu):

![sos](http://raphaelbaron.net/files/sosv0.1.png)

Some parts of it (namely asm/boot.asm and linker/linker.ld) are highly influencied - or even a carbon copy - from [OSDev Wiki](http://wiki.osdev.org/Bare_Bones), which provides a great number of resources for learning about operating systems development.

When booting with GRUB2, it takes us from a 16 bit [real mode](http://en.wikipedia.org/wiki/Real_mode) and leaves us in a 32 bit [protected mode](http://en.wikipedia.org/wiki/Protected_mode). Among other things, being in protected mode _does not_ allow the use of [bios functions](http://wiki.osdev.org/BIOS#BIOS_functions), which greatly ease some of the input/ouput handling. It means that we need to write and read memory locations directly, such as was done in asm/term.asm.

Why?
-----

To learn low-level stuff and understand how an operating system deals with the underlying hardware, as well as using a libc-free development enviroment.

Next steps
----------

- Handling input (cursos position, chars on the screen)
- Implementing a simple filesystem

License
-------

[Creative Commons 3.0](http://creativecommons.org/licenses/by/3.0/)
