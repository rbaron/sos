[bits 32]

extern term_put_string

global interrupt_init

section .data

interrupt_callback_string:
  db 'hello, interrupt!'

interrupt_idt: 
  times 256*8 db 0x0

interrupt_idtr: 
  dw 255
  dd interrupt_idt

section .text

interrupt_init:
  call interrupt_setup_idt

interrupt_callback:
  pushad
  mov ecx, interrupt_callback_string
  call term_put_string
  popad
  iret
   
interrupt_setup_idt:
  cli
  mov eax,interrupt_callback
  mov [interrupt_idt],ax
  mov word [interrupt_idt+2],0x0008
  mov word [interrupt_idt+4],0x8E00
  shr eax,16
  mov [interrupt_idt+6],ax

  mov eax,interrupt_callback
  mov [interrupt_idt+8],ax
  mov word [interrupt_idt+2+8],0x0008
  mov word [interrupt_idt+4+8],0x8E00
  shr eax,16
  mov [interrupt_idt+6+8],ax

  mov eax,interrupt_callback
  mov [interrupt_idt+16],ax
  mov word [interrupt_idt+2+16],0x0008
  mov word [interrupt_idt+4+16],0x8E00
  shr eax,16
  mov [interrupt_idt+6+16],ax

  mov eax,interrupt_callback
  mov [interrupt_idt+32*8],ax
  mov word [interrupt_idt+32*8+2],0x0008
  mov word [interrupt_idt+32*8+4],0x8E00
  shr eax,16
  mov [interrupt_idt+32*8+6],ax

  lidt [interrupt_idtr]

  ;int 0
  ;int 1
  ;int 2
  ;int 0

  ;sti
  ;int 0x0
  ;int 0

;int_handler:
;    ;mov ax, LINEAR_DATA_SELECTOR
;    mov ax, 0x0
;    ;mov gs, ax
;    mov dword [gs:0xB8000],') : '
;    hlt
;    ;iret
; 
; idt:
;    resd 50*2
; 
; idtr:
;    dw (50*8)-1
;    ;dd LINEAR_ADDRESS(idt)
;    dd idt
; 
; test1:
;    lidt [idtr]
;    mov eax,int_handler
;    ;mov eax, keyboard_test
;    mov [idt+49*8],ax
;    ;mov word [idt+49*8+2],CODE_SELECTOR
;    mov word [idt+49*8+2],0x0000
;    mov word [idt+49*8+4],0x8E00
;    shr eax,16
;    mov [idt+49*8+6],ax
;    int 49

