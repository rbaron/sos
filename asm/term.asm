; asm/term.asm
;
; Handles output.


[bits 32]

TERM_WIDTH: equ 80 
TERM_HEIGHT: equ 25
TERM_LENGTH: equ TERM_WIDTH*TERM_HEIGHT


global term_clear
global term_set_cursor
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

  ; Set cursor to 1,0
  mov bh, 0x1
  mov bl, 0x1
  jmp term_set_cursor

  popad
  ret

; term_set_cursor:
;    bl: row position
;    bh: col position
;       ( bx : col | row ) 
;    
;    Writes cursor position to VGA base register (assumed to be on 0x3d4)
;    For info over base addresses and I/0 ports https://en.wikipedia.org/wiki/Input/Output_Base_Address
;    TODO: where can I officially tell if the port is 0x3d4? Which docs to look for?
;
;    The movement is done in two parts. First, write the least significant byte at 0x3d5 (after writing
;    0xff to 0x3d4) and then the most significant (after writing 0x0e to 0x3d4)
;
;    Implementation modified from: http://wiki.osdev.org/Text_Mode_Cursor

term_set_cursor:

  ; Test
  ;mov bh, TERM_WIDTH-1
  ;mov bl, 2

  ;pushad

  ; Set ax to ( col | row )
  mov ax, bx

  ; Only get rows (zero high bytes)
  and ax, 0xFF

  ; Multiply by TERM_WIDTH (set result to ax)
  mov cl, TERM_WIDTH
  mul cl 

  ; Get high bytes (bh)
  mov cx, bx
  ; Move 8 bits right 
  shr cx, 8

  ; Position (ax = row*80 + col)
  add ax, cx

  ; cx = row*80 + col
  mov cx, ax

  ; Write low and high bytes of cx on VGA base address
  mov al,0x0f
  mov dx,0x3d4   
  out dx,al             

  mov ax,cx    
  mov dx,0x3d5
  out dx,al  

  mov al,0x0e
  mov dx,0x3d4
  out dx,al

  mov ax,cx    
  shr ax,8     
  mov dx,0x3d5  
  out dx,al    

  ;popad
  ret
