MOV  AH,3          ;номер функции
   MOV  DX,1          ;выбираем COM2
   INT  14H           ;получаем байт статуса
   TEST AH,10000B     ;обнаружен перерыв?
   JNZ  BREAK_DETECT  ;если да, то на процедуру обработки