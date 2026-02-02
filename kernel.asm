[org 0x1000]

; 1. Enter Text Mode
mov ax, 0x03
int 0x10

; 2. Print Welcome
mov si, welcome_msg
call print_string

cli_loop:
    mov si, prompt
    call print_string
    call get_input

    ; Command Handling
    mov si, input_buffer
    mov di, cmd_cfdisk
    call strcmp
    jc .do_cfdisk

    mov si, input_buffer
    mov di, cmd_install
    call strcmp
    jc .do_install

    ; Check for empty input (just Enter)
    cmp byte [input_buffer], 0
    je cli_loop

    mov si, unknown_msg
    call print_string
    jmp cli_loop

.do_cfdisk:
    mov si, cfdisk_msg
    call print_string
    mov byte [is_partitioned], 1
    jmp cli_loop

.do_install:
    cmp byte [is_partitioned], 0
    je .no_disk
    mov si, install_msg
    call print_string
    mov cx, 5
.loop:
    mov ah, 0x0e
    mov al, '.'
    int 0x10
    push cx
    mov cx, 0xFFFF
    .delay: loop .delay
    pop cx
    loop .loop
    mov si, done_msg
    call print_string
    jmp cli_loop

.no_disk:
    mov si, err_nodisk
    call print_string
    jmp cli_loop

reboot:
    jmp 0xFFFF:0000

; --- UPDATED CLI UTILITIES ---

get_input:
    mov di, input_buffer
    mov cx, 0           ; Character counter

.loop:
    mov ah, 0x00
    int 0x16            ; Get key

    cmp al, 0x0D        ; ENTER key
    je .done

    cmp al, 0x08        ; BACKSPACE key
    je .backspace

    cmp cx, 63          ; Prevent buffer overflow
    je .loop

    ; Regular character
    mov ah, 0x0e
    int 0x10            ; Echo
    stosb               ; Store in buffer
    inc cx
    jmp .loop

.backspace:
    cmp cx, 0           ; Can't backspace if buffer is empty
    je .loop
    
    dec di              ; Move buffer pointer back
    dec cx              ; Decrease count
    
    ; Visual Erasure: Back-Space-Back
    mov ah, 0x0e
    mov al, 0x08        ; Move cursor back
    int 0x10
    mov al, ' '         ; Print space to "erase"
    int 0x10
    mov al, 0x08        ; Move cursor back again
    int 0x10
    jmp .loop

.done:
    mov al, 0
    stosb               ; Null terminate
    mov si, newline
    call print_string
    ret

print_string:
    mov ah, 0x0e
.lp:
    lodsb
    cmp al, 0
    je .dn
    int 0x10
    jmp .lp
.dn: ret

strcmp:
.loop:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .not_equal
    cmp al, 0
    je .equal
    inc si
    inc di
    jmp .loop
.not_equal:
    clc
    ret
.equal:
    stc
    ret

; --- DATA ---
is_partitioned db 0
newline     db 13, 10, 0
welcome_msg db 'Arch-PingOS Live ISO', 13, 10, 'Commands: cfdisk, pacman', 13, 10, 0
prompt      db '[root@pingos]# ', 0
cmd_cfdisk  db 'cfdisk', 0
cmd_install db 'pacman', 0
cfdisk_msg  db 'Partitioning... OK', 13, 10, 0
install_msg db 'Installing system', 0
done_msg    db ' [OK]', 13, 10, 'Done! Press "r" to reboot.', 13, 10, 0
unknown_msg db 'Unknown command.', 13, 10, 0
err_nodisk  db 'Run cfdisk first!', 13, 10, 0
input_buffer times 64 db 0