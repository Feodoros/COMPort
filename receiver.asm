data segment
  mess db 'Start listening at COM1...',0Dh,0Ah,'$'
  char db 031h,0Dh,0Ah,'$'
  portnumber dw 01h            ;номер порта 0h - com1
  current dw 0                 
  
  inp db 1,?,?
data ends
 
code segment
  assume cs:code,ds:data
start:
mov bx,data
mov ds,bx
 
  call clrscr
  mov bx, offset mess
  add bx,22
  mov ax,portnumber
  add al,31h
  mov [bx],al
  
  mov   dx, offset mess     ; вывод сообщения 
  call writeln
 
  mov dx,portnumber
  call    initrs232         ; Инициализация интерфейса RS-232 
  
  begloop:
    call getsymbol          ; сначала принимаем символ
    mov dl,al
    
    call getsymbol          ; потом фон символ
    mov dh,al
    
    mov bx,current          ; и отображаем их
    call setpixel
 
    add current,2
    mov ax,current
    cmp ax,4002
  jnz begloop
  
  mov dx, offset inp
  call readln
 
exitproga:
;выход..................
mov al,0
mov ah,4ch
int 21h
 
getsymbol proc
                            ; Прием символа. Символ в al, код состояния в ah
  push dx
  mm:
    mov   ah, 02h           ; Функция чтения символа
    mov   dx, portnumber    ; Читаем из линии 0-СОМ1 (номер используемого интерфйса )
    int      14h            ; Прием символа
    or      ah,ah           ; Проверяем ошибку
  jne    mm                 ; Бесконечный цикл до получения символа 
  pop dx
  ret
getsymbol endp
 
setpixel proc
  ;изменение атрибутов ячейки видеопамяти в bx смещение, dh атрибут, dl символ
  mov ax, 0b800h        ; записать в регистр
  mov   es, ax              ; es адрес начала видеопамяти
  ;mov  dh, 00010100b           ; атрибуты: на голубом фоне красный символ 
  ;mov  dl, 65h             ; ASCII код символа
  mov   word ptr es:[bx], dx    ; запись в видеопамять символа и атрибута 
  ret
endp
 
include lib.asm
 
code ends
 
end start