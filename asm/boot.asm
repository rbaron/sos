; Why bits 16 doesnt work? ELF is a 32 bit format?
; Answer: Protected mode is 32 bit!
[bits 32]

; Declare constants used for creating a multiboot header.
MBALIGN:     equ  1<<0                   ; align loaded modules on page boundaries
MEMINFO:     equ  1<<1                   ; provide memory map
FLAGS:       equ  MBALIGN | MEMINFO      ; this is the Multiboot 'flag' field
MAGIC:       equ  0x1BADB002             ; 'magic number' lets bootloader find the header
CHECKSUM:    equ -(MAGIC + FLAGS)        ; checksum of above, to prove we are multiboot

extern term_clear
extern term_clear_2
extern term_set_cursor
extern term_test
extern term_put_char
extern term_put_string

global _start


section .multiboot
align 4
  dd MAGIC
  dd FLAGS
  dd CHECKSUM
 
section .bootstrap_stack
align 4
stack_bottom:
resb 0x1000
;times 16384 db 0
stack_top:

section .data

header_title: db 'abcdefghijklmnopqrst', 0
 

section .text
_start:

  ; Point ESP to stack_top (grows backwars)
  mov esp, stack_top

  ; Write a string
  mov ecx, header_title
  call term_put_string

  call term_clear

  ; Disable interrupts
  ;cli

.hang:
  hlt

  ; If, for whatever reason, we reach here, loop
  jmp .hang
