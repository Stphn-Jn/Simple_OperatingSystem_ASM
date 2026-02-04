[bits 32]
[extern _kmain] ; Note: MinGW adds an underscore to C functions

global _start
_start:
    call _kmain ; Call the C function kmain
    jmp $