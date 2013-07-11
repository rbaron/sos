[bits 32]

TERM_WIDTH: equ 1
TERM_HEIGHT: equ 8


global term_clear
global term_write


section .data

term_bg_color: db 0x5
term_fg_color: db 0x3

section .bss

section .text

term_clear:
  pushad
  
  mov edx, 0
  mov ebx, 0
  mov eax, 0xB8000

  loop:
    mov ebx, [term_bg_color]
    mov ecx, [term_fg_color]
    shl ecx, 4
    or ebx, ecx
    shl ebx, 8

    ; Space char (ASCII 0x20)
    or ebx, 0x22

    mov [eax+edx], ebx

    inc edx 
    ;cmp ax, TERM_WIDTH*TERM_HEIGHT
    cmp edx, 0x1
    jl loop

  popad
  ret
