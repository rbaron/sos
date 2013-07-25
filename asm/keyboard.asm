[bits 32]

extern term_put_string

global keyboard_init
global keyboard_test

keyboard_test_string: db 'keyboard was pressed!', 0

; Setup IRQ1 on Interrupt Descriptor Table Slot 21
keyboard_init:
  pushad

  mov ecx, keyboard_test 
  
  ; IDT 0x21 location (8 byte per entry)
  mov eax, 0x21 << 3  
  ;add eax, 0x000fd3e6 << 32

  ; Lower 4 bytes of callback addr
  mov [eax], cx

  ;add eax, 2
  ;mov ebx, 0x000000e1
  ;mov [eax], ebx

  add eax, 6
  shr ecx, 16
  mov [eax], cx

  popad
  ret

  
keyboard_test:
  pushad
  mov ecx, keyboard_test_string
  ;call term_put_string
  popad
  ;ret
  iret

