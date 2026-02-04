// kernel.c - Core Terminal Logic for PingOS

/* Hardware I/O helper functions */
void outb(unsigned short port, unsigned char val) {
    // Sends a byte to a specific hardware port using inline assembly
    asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

/* Hardware Cursor Management */
void update_cursor(int x, int y) {
    unsigned short pos = y * 80 + x;
    // Tell the VGA controller we are sending the low byte
    outb(0x3D4, 0x0F);
    outb(0x3D5, (unsigned char)(pos & 0xFF));
    // Tell the VGA controller we are sending the high byte
    outb(0x3D4, 0x0E);
    outb(0x3D5, (unsigned char)((pos >> 8) & 0xFF));
}

/* Screen Management Functions */
void clear_screen() {
    char* vga = (char*)0xb8000;
    for (int i = 0; i < 80 * 25 * 2; i += 2) {
        vga[i] = ' ';      // Clear with blank space
        vga[i+1] = 0x07;   // Light gray text on black
    }
    update_cursor(0, 0);
}

void scroll_screen() {
    char* vga = (char*)0xb8000;
    // Move every row up by one
    for (int i = 0; i < 24 * 80 * 2; i++) {
        vga[i] = vga[i + 80 * 2];
    }
    // Clear the very bottom line
    for (int i = 24 * 80 * 2; i < 25 * 80 * 2; i += 2) {
        vga[i] = ' ';
        vga[i+1] = 0x07;
    }
}

/* Global cursor tracking */
int cursor_x = 0;
int cursor_y = 0;

/* Terminal Output */
void kprint(char* str) {
    char* vga = (char*)0xb8000;
    for (int i = 0; str[i] != '\0'; i++) {
        // Handle newline character
        if (str[i] == '\n') {
            cursor_x = 0;
            cursor_y++;
        } else {
            int index = (cursor_y * 80 + cursor_x) * 2;
            vga[index] = str[i];
            vga[index+1] = 0x0B; // Cyan color for PingOS
            cursor_x++;
        }

        // Handle line wrapping
        if (cursor_x >= 80) {
            cursor_x = 0;
            cursor_y++;
        }

        // Handle screen scrolling
        if (cursor_y >= 25) {
            scroll_screen();
            cursor_y = 24;
        }
    }
    update_cursor(cursor_x, cursor_y);
}

/* Main entry point */
void main() {
    // Required call for MinGW generated code
    extern void __main();
    __main(); 
    
    clear_screen();
    
    kprint("Arch-PingOS Kernel Version 1.0\n");
    kprint("------------------------------\n");
    kprint("Status: Booting into Protected Mode... OK\n");
    kprint("Status: VGA Terminal Initialized... OK\n");
    kprint("Status: Hardware Cursor Active... OK\n\n");
    kprint("> ");

    // Infinite loop to keep the kernel running
    while(1);
}