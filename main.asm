[org 0x7c00]

; 1. Switch to Video Mode
mov ah, 0x00    ; Set video mode function
mov al, 0x13    ; Mode 13h: 320x200 graphics, 256 colors
int 0x10        ; BIOS video interrupt

; 2. Draw a Pixel
; We use Interrupt 10h, Function 0Ch
mov ah, 0x0c    ; Write graphics pixel function
mov al, 0x0e    ; Color: Yellow (Color index 14)
mov bh, 0x00    ; Page number
mov cx, 160     ; X coordinate (Center: 320 / 2)
mov dx, 100     ; Y coordinate (Center: 200 / 2)
int 0x10

jmp $           ; Infinite loop

times 510-($-$$) db 0
dw 0xaa55