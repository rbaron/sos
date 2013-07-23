; asm/term.asm
;
; Handles output.


[bits 32]

; eqn defines a value, not an address
TERM_WIDTH: equ 80 
TERM_HEIGHT: equ 25
TERM_LENGTH: equ TERM_WIDTH*TERM_HEIGHT


global term_clear
global term_set_cursor
global term_put_char
global term_put_string


section .data

; db defines an address, not a value
term_header_bg_color: db 0x8
term_header_fg_color: db 0x7
term_bg_color: db 0x0
term_fg_color: db 0x2

term_row: db 0x0
term_col: db 0x0

term_header_title: db '-[ sos ]-', 0
; Guess length of half upper bar
term_header_bar: times (TERM_WIDTH-($-term_header_title-1))/2 db '%'
db 0
term_empty_body: times (TERM_WIDTH*(TERM_HEIGHT-1)) db ' '
db 0

section .bss

section .text

; term_put_char: 
;   Writes a ASCII encoded char to a given location
;   @args:
;     bh: row
;     bl: col
;     dh: color (bg:4|fg:4)
;     dl: char
term_put_char:
  pushad
  
  ; dx can be overwritten by a call to mul
  push dx

  ; Write to mem location
  ; Pos = 0xB8000 + 2*(row*2TERM_WIDTH + col)
  ; row
  mov eax, ebx
  and eax, 0xFF00
  shr eax, 8
  mov ecx, TERM_WIDTH
  mul ecx
  ; col
  mov ecx, ebx
  and ecx, 0xFF
  add eax, ecx
  imul eax, 2
  add eax, 0xB8000

  pop dx
  mov [eax], dx

  popad
  
  ret

; term_put_string:
;   Outputs a NULL-ended string
;   @args;
;      ecx: string addr
term_put_string:
  pushad

  ; Initial coords
  mov bh, [term_row]
  mov bl, [term_col]

  ; Copy color to dh
  mov dh, [term_bg_color]
  shl dh, 4
  or dh, [term_fg_color]

  .loop:
    cmp byte [ecx], byte 0x0
    je .ret
    
    ; Put a char
    mov dl, [ecx]
    call term_put_char
    inc ecx
    inc bl

    ; New line?
    cmp bl, TERM_WIDTH
    je .new_line
    jmp .loop

  .ret:

  ; Re-set row and col
  mov [term_row], bh
  mov [term_col], bl
  popad
  ret

  .new_line:
  mov bl, 0x0
  inc bh
  jmp .loop

term_clear:
  pushad 

  ; Reset row, col
  mov [term_row], byte 0
  mov [term_col], byte 0

  ; Backup old color
  mov bh, [term_bg_color]
  mov bl, [term_fg_color]

  mov ch, [term_header_bg_color]
  mov cl, [term_header_fg_color]
  mov [term_bg_color], ch
  mov [term_fg_color], cl

  mov ecx, term_header_bar 
  call term_put_string
  mov ecx, term_header_title
  call term_put_string
  mov ecx, term_header_bar 
  call term_put_string

  ; Restore default term colors
  mov [term_bg_color], bh
  mov [term_fg_color], bl

  mov ecx, term_empty_body
  call term_put_string

  ; Set initial typing position
  mov [term_row], byte 0x1
  mov [term_col], byte 0x1

  call term_refresh_cursor

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

term_refresh_cursor:

  pusha

  mov bh, [term_col]
  mov bl, [term_row]

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

  popa
  ret
