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
    ; Bootloader End
    ;------------------------------------------------------------------

    cli                             ; disable interrupts
    hlt                             ; halt the system

    ;------------------------------------------------------------------
    ; Helpful includes
    ;------------------------------------------------------------------
    %include "print_string.asm" 

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
    db gdt_end - gdt
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