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
    ; Data
    ;------------------------------------------------------------------
hello_message:
    db 'Hello LBAOS! :)', 13, 10, 0

    ;-----------------------------------------------------------------
    ; Magic Number and padding
    ;-----------------------------------------------------------------
    times 512 - ($-$$) db 0         ; pad out the file with 0's to 512