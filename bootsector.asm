;
; bootsector.asm
; Createa a bootsector binary which we can use to boot from :)
;

    cli                             ; disable interrupts
    hlt                             ; halt the system

    ;-----------------------------------------------------------------
    ; Magic Number and padding
    ;-----------------------------------------------------------------
    times 510 - ($-$$) db 0         ; pad out the file with 0's to 510
    dw 0xAA55                       ; the magic number!!!
