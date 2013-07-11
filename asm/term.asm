; asm/term.asm
;
; Handles output.


[bits 32]

TERM_WIDTH: equ 80 
TERM_HEIGHT: equ 25
TERM_LENGTH: equ TERM_WIDTH*TERM_HEIGHT


global term_clear
global term_write


section .data

term_header_bg_color: db 0x2
term_header_fg_color: db 0x1
term_bg_color: db 0x5
term_fg_color: db 0x3

term_header_text: db 's','o','s'

section .bss

section .text

term_clear:
  pushad
  
  mov edx, 0
  mov ebx, 0
  mov eax, 0xB8000

  mov ebx, [term_header_bg_color]
  mov ecx, [term_header_fg_color]

  ; Set color and space char for cleanup
  shl ecx, 4
  or ebx, ecx
  shl ebx, 8
  ; % char  (ASCII 0x25)
  or ebx, 0x25

  header_left:

    mov [eax+2*edx], ebx
    inc edx 
    cmp edx, TERM_WIDTH/2-4
    jl header_left

  header_middle:
    and ebx, 0xFFFFFF00
    ; ASCII [
    or ebx, 0x5b
    mov [eax+2*edx], ebx
    inc edx 

    and ebx, 0xFFFFFF00
    ; ASCII s
    or ebx, 0x73
    mov [eax+2*edx], ebx
    inc edx 

    and ebx, 0xFFFFFF00
    ; ASCII o
    or ebx, 0x6f
    mov [eax+2*edx], ebx
    inc edx 

    and ebx, 0xFFFFFF00
    ; ASCII s
    or ebx, 0x73
    mov [eax+2*edx], ebx
    inc edx 

    and ebx, 0xFFFFFF00
    ; ASCII ]
    or ebx, 0x5d
    mov [eax+2*edx], ebx
    inc edx 

  and ebx, 0xFFFFFF00
  ; ASCII %
  or ebx, 0x25
  mov [eax+2*edx], ebx
  inc edx 

  header_bottom:

    mov [eax+2*edx], ebx
    inc edx 
    cmp edx, TERM_WIDTH
    jl header_bottom
    

  mov ebx, [term_bg_color]
  mov ecx, [term_fg_color]

  ; Set color and space char for cleanup
  shl ecx, 4
  or ebx, ecx
  shl ebx, 8
  ; Space char (ASCII 0x20)
  or ebx, 0x20

  body:

    mov [eax+2*edx], ebx
    inc edx 
    cmp edx, TERM_LENGTH
    jl body 

  popad
  ret

