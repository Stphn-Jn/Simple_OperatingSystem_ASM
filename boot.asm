[org 0x7c00]
KERNEL_OFFSET equ 0x1000    ; Memory address where we will load the kernel

mov [BOOT_DRIVE], dl        ; BIOS stores boot drive info in DL; save it

; 1. Set up the Stack (important for calling functions)
mov bp, 0x9000
mov sp, bp

; 2. Read Kernel from Disk
mov ah, 0x02                ; BIOS read sectors function
mov al, 1                   ; Number of sectors to read (increase as kernel grows)
mov ch, 0x00                ; Cylinder 0
mov dh, 0x00                ; Head 0
mov cl, 0x02                ; Sector 2 (Sector 1 is this bootloader)
mov dl, [BOOT_DRIVE]        ; Read from the drive we booted from
mov bx, KERNEL_OFFSET       ; Destination address in RAM
int 0x13                    ; Disk Controller Interrupt

jc disk_error               ; If carry flag is set, there was an error

; 3. Jump to Kernel
jmp KERNEL_OFFSET           ; Transfer control to your kernel code

disk_error:
    mov ah, 0x0e
    mov al, 'E'
    int 0x10
    jmp $

BOOT_DRIVE db 0
times 510-($-$$) db 0
dw 0xaa55