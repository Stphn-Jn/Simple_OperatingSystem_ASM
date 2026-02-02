[org 0x1000]

; 1. Enter Graphics Mode 13h
mov ah, 0x00
mov al, 0x13
int 0x10

; 2. Draw a "Taskbar" at the bottom
; Parameters for draw_rect: X, Y, Width, Height, Color
mov cx, 0       ; X
mov dx, 180     ; Y (Near bottom)
mov si, 320     ; Width
mov di, 20      ; Height
mov al, 0x07    ; Color: Light Gray
call draw_rect

; 3. Draw a "Start Button"
mov cx, 5       ; X
mov dx, 182     ; Y
mov si, 40      ; Width
mov di, 16      ; Height
mov al, 0x01    ; Color: Blue
call draw_rect

jmp $           ; Halt CPU

; --- GUI FUNCTIONS ---

; Function: draw_rect
; Inputs: cx=X, dx=Y, si=Width, di=Height, al=Color
draw_rect:
    pusha               ; Save all registers
    add si, cx          ; si now holds the right boundary (X + Width)
    add di, dx          ; di now holds the bottom boundary (Y + Height)
    mov bx, dx          ; Save starting Y in bx

.row_loop:
    push cx             ; Save starting X
.col_loop:
    mov ah, 0x0c        ; BIOS write pixel
    int 0x10
    inc cx
    cmp cx, si          ; Check if row is finished
    jne .col_loop
    
    pop cx              ; Reset X to start of row
    inc dx              ; Move to next Y line
    cmp dx, di          ; Check if all rows are finished
    jne .row_loop

    popa                ; Restore all registers
    ret