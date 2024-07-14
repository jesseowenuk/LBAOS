;
; bootsector.asm
; Prints a single character to the screen
;
    ;------------------------------------------------------------------
    ; Print a Character
    ;------------------------------------------------------------------
    mov ah, 0x0e                    ; ah 0x0e = tele-type
    mov al, 'P'                     ; move a 'P' into AL register
    int 0x10                        ; call interrupt 0x10 to display the character in AL

    ;------------------------------------------------------------------
    ; Bootloader End
    ;------------------------------------------------------------------

    cli                             ; disable interrupts
    hlt                             ; halt the system

    ;-----------------------------------------------------------------
    ; Magic Number and padding
    ;-----------------------------------------------------------------
    times 510 - ($-$$) db 0         ; pad out the file with 0's to 510
    dw 0xAA55                       ; the magic number!!!
