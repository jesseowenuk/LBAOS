;
; kernel.asm
; Simple file which prints out a mesage - will be loaded by the boot sector code.
;
    ;------------------------------------------------------------------
    ; Reset the registers to point at our new place in memory
    ;------------------------------------------------------------------
    mov ax, 0x0500                  ; set the AX register at our new memory location so we can
    mov ds, ax                      ; reset the data segment to our new location in memory
    mov es, ax                      ; point our extra segment at our new location in memory
    mov ss, ax                      ; point our stack segment to our new location in memory
    mov sp, ax                      ; point our stack poinuter at our new location in memory

    ;------------------------------------------------------------------
    ; Load the GDT
    ;------------------------------------------------------------------
    cli                             ; disable interrupts whilst we load the GDT
    lgdt [gdt_descriptor]           ; load up our GDT into the GDT register
    sti                             ; renable interrupts

    ;------------------------------------------------------------------
    ; Print a Hello Message :)
    ;------------------------------------------------------------------
    mov si, hello_message
    call print_string

    ;------------------------------------------------------------------
    ; Enable the A20 line via the keyboard controller
    ;------------------------------------------------------------------
    call enable_a20

    ;------------------------------------------------------------------
    ; Enter protected mode
    ;------------------------------------------------------------------
    cli                             ; clear interrupts
    mov eax, cr0                    ; move the contents of the cr0 register into the EAX register
    or eax, 1                       ; set bit 0 by or'ing EAX register with 1
    mov cr0, eax                    ; move contents of EAX register back onto CR0 (this changes the protected mode bit to set - sending us head first into protected mode)

    jmp 0x8:clear_pipe              ; do a far jump to a code segment to clear the 16-bit garbage instructions

    ;------------------------------------------------------------------
    ; Bootloader End
    ;------------------------------------------------------------------

    cli                             ; disable interrupts
    hlt                             ; halt the system

    ;------------------------------------------------------------------
    ; Helpful includes
    ;------------------------------------------------------------------
    %include "print_string.asm" 
    %include "a20.asm"

    ;------------------------------------------------------------------
    ; GDT
    ;------------------------------------------------------------------
gdt:

gdt_null:                           ; null segment
    dq 0                            ; define 8 bytes with 0 (required)

gdt_code:
    dw 0xFFFF                       ; limit low (max address for our segment)
    dw 0                            ; base low 
    db 0                            ; base middle
    db 10011010b                    ; Access byte 
    db 11001111b                    ; Granularity byte
    db 0                            ; last part of the base address

gdt_data:
    dw 0xFFFF                       ; segment limit
    dw 0                            ; base address
    db 0                            ; base middle
    db 10010010b                    ; Access byte
    db 11001111b                    ; Granularity byte
    db 0                            ; last part of the base address

gdt_end:

gdt_descriptor:
    db gdt_end - gdt - 1
    dw gdt

    ;------------------------------------------------------------------
    ; Data
    ;------------------------------------------------------------------
hello_message:
    db 'Hello LBAOS! :)', 13, 10, 0

    ;-----------------------------------------------------------------
    ; Magic Number and padding
    ;-----------------------------------------------------------------
    times 512 - ($-$$) db 0         ; pad out the file with 0's to 512

    ;------------------------------------------------------------------
    ; 32-bit Protected Mode
    ;------------------------------------------------------------------

[bits 32]                           ; instructions are now in 32-bit
clear_pipe:


 