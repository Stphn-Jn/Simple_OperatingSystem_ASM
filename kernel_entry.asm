; kernel_entry.asm - Bridge between ASM and C
[bits 32]
[extern _main]   ; Link to the main function in kernel.c

global _start
_start:
    call _main   ; Execute the C kernel
    jmp $        ; Stay here if kernel returns