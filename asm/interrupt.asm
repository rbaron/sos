[bits 32]

extern term_put_string

global interrupt_init

section .data

interrupt_callback_string:
  db 'hello, interrupt!', 0

; Allocate mem for interrupt decriptor table
; The content at this address will be set to the
; IDTR register via a call to 'lidt' instruction
interrupt_idt: 
  times 256*8 db 0x0

; Pointer argument for lidt
interrupt_idtr: 
  dw 255
  dd interrupt_idt

section .text

interrupt_init:
  popad
  call interrupt_setup_idt
  pushad
  ret

interrupt_callback:
  pushad
  mov ecx, interrupt_callback_string
  call term_put_string
  popad
  iret
   
interrupt_setup_idt:
  pushad 

  mov eax,interrupt_callback
  mov bl, 0x1F
  call interrupt_set_gate

  lidt [interrupt_idtr]

  popad
  ret

; interrupt_set_gate:
;   writes an entry to the IDT vector
;   @args:
;     eax: callback address (ISR)
;     bl: interrupt number 
interrupt_set_gate:
  pushad

  push eax

  ; Calculate entry address at IDT (base addr = interrupt_idt + 8*bl)
  and ebx, 0xFF
  mov eax, ebx
  mov cl, 8
  mul cl
  
  ; Base address
  mov ebx, eax
  add ebx, interrupt_idt

  ; Callback
  pop eax
  mov [ebx], ax ;Lower callback addr
  mov word [ebx+2], 0x0008
  mov word [ebx+4], 0x8E00
  shr eax, 16
  mov [ebx+6], ax ;Higher callback addr

  popad
  ret
