sos
===

sos is a protected mode, multiboot compliant, 32 bit, completely useless operating system written in assembly. As of now, it boots using GRUB2 and shows the following screen (here emulated with qemu):

![sos](http://raphaelbaron.net/files/sosv0.1.png)

Some parts of it (namely asm/boot.asm and linker/linker.ld) are highly influencied - or even a carbon copy - from [OSDev Wiki](http://wiki.osdev.org/Bare_Bones), which provides a great number of resources for learning about operating systems development.

Why?
-----

To learn low-level stuff and understand how an operating system deals with the underlying hardware, as well as using a libc-free development enviroment.

License
-------

[Creative Commons 3.0](http://creativecommons.org/licenses/by/3.0/)
