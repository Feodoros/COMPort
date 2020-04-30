data segment
coderet db ?
char db 2,?,?
mess db 'Enter symbol forbegin fill',0Dh,0Ah,'$'
portnumber dw 00h              ;номер порта 0h - com1
 
data ends
 
code segment
  assume cs:code,ds:data
start:
mov bx,data
mov ds,bx
 
call clrscr
mov dx,portnumber              ; Инициализация интерфейса RS-232
call initrs232
            
mov   dx,offset mess           ; вывод сообщения 
call     writeln
            
mov dx, offset char
call readln
 
call fill
            
mov dx, offset char
call readln
 
exitproga:
;выход...............
mov al,0
mov ah,4ch
int 21h
 
sendsymbol proc                 ; Передача символа. Символ в al
  push dx
    mov   ah,01h                ; Номер функции 1
    mov   dx,portnumber         ; Номер используемого интерфейса 0-COM1
    int     14h                 ; Передача символа по сети
  pop dx
 
  ret
sendsymbol endp
 
fill proc                       ; Заполняет экран с заданного символа
  push bx
  
  mov bx, offset char
  add bx,2
  
  mov dl,[bx]
  mov dh,dl
  mov ax, 0b800h        ; записать в регистр
  mov   es, ax              ; es адрес начала видеопамяти
  xor   bx, bx              ; смещение символа от начала видеопамяти
  fillbeg:
    mov word ptr es:[bx], dx    ; запись в видеопамять символа и атрибута
     
    add dl,1                    ; ASCII код символа
    cmp dl,255                  ; если байт подходит к концу, присваиваем 1
    jnz notdlbolh               ; переход если не нуль
      mov dl,1
    notdlbolh:
    
    mov al,dl
    call sendsymbol
    
    mov al,dh
    call sendsymbol             ;Вызов процедуры: Передача символа. Символ в al
    
    inc bx          ; смещение для 
    inc bx          ; следующего символа
    
    mov ax,100
    call sleep
  cmp bx,4000
  jnz fillbeg                   ; переход если не нуль
  pop bx
  ret
fill endp
 
include lib.asm
 
code ends
 
end start