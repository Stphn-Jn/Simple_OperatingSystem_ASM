// kernel.c - Minimal Safety Version
void __main() {} 

void kmain() {
    // Direct pointer to VGA memory
    char* vga = (char*)0xb8000;
    
    // Print 'P' in the top left corner (Cyan on Black)
    vga[0] = 'P';
    vga[1] = 0x0B;
    
    // Print 'I' next to it
    vga[2] = 'I';
    vga[3] = 0x0B;

    while(1); 
}