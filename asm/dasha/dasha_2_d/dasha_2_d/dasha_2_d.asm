.include "m16def.inc"

ldi r16, low(RAMEND)  
out SPL, r16
ldi r16, high(RAMEND) 
out SPH, r16 

ldi r16, 0b00000011
out DDRD, r16 ; Установка первый и второй разрядах порта D на вывод
ldi r16, 0b00000000
out PORTD, r16  ; Установка во всех разрядах порта D в логический 0
ldi r16, 0b00000000
out DDRA, r16  ; Установка во всех разрядах порта A на ввод
ldi r16, 0b11111111
out PORTA, r16 ; Установка во всех разрядах порта D в логический 1

Program: ; Код:поочерёдное нажатие кнопок с 0 по 7 разрадов


; Проверка первого нажатия
rcall Delay20 ; Задержка в 20 мс 
sbis PINA, 0
rjmp st2 ; Правильное нажатие, переход на метку st2
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp error
rjmp PC-16 ; возвращение на 16 команд назад
st2: ; Проверка второго нажатия
rcall Delay20 ; Задержка в 20 мс 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp st3 ; Правильное нажатие, переход на метку st3
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp error
rjmp PC-16 ; возвращение на 16 команд назад
st3:; Проверка третьего нажатия
rcall Delay20 ; Задержка в 20 мс 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp st4 ; Правильное нажатие, переход на метку st4
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp error
rjmp PC-16 ; возвращение на 16 команд назад
st4:; Проверка четвёртого нажатия
rcall Delay20 ; Задержка в 20 мс 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp st5 ; Правильное нажатие, переход на метку st5
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp error
rjmp PC-16 ; возвращение на 16 команд назад
st5:; Проверка пятого нажатия
rcall Delay20 ; Задержка в 20 мс 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp st6 ; Правильное нажатие, переход на метку st6
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp error
rjmp PC-16 ; возвращение на 16 команд назад
st6:; Проверка шестого нажатия
rcall Delay20 ; Задержка в 20 мс 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp st7 ; Правильное нажатие, переход на метку st7
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp error
rjmp PC-16 ; возвращение на 16 команд назад
st7:; Проверка седьмого нажатия
rcall Delay20 ; Задержка в 20 мс 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp st8 ; Правильное нажатие, переход на метку st8
sbis PINA, 7
rjmp error
rjmp PC-16 ; возвращение на 16 команд назад
st8:; Проверка восьмого нажатия
rcall Delay20 ; Задержка в 20 мс 
sbis PINA, 0
rjmp error
sbis PINA, 1
rjmp error
sbis PINA, 2
rjmp error
sbis PINA, 3
rjmp error
sbis PINA, 4
rjmp error
sbis PINA, 5
rjmp error
sbis PINA, 6
rjmp error
sbis PINA, 7
rjmp  _main_  ; Были правильно нажаты все кнопки, переход на метку  _main_
rjmp PC-16 ; возвращение на 16 команд назад

rjmp Program 

error:
ldi r16, 0b00000010
out PORTD, r16 ; Загарание светодиода в разряде 1
rcall Delay ; Задержка
ldi r16, 0b00000000
out PORTD, r16 ; Гашение светодиода в разряде 1
rjmp Program 

 _main_:
ldi r16, 0b00000001
out PORTD, r16 ; Загарание светодиода в разряде 0
rcall Delay ; Задержка
ldi r16, 0b00000000
out PORTD, r16 ; Гашение светодиода в разряде 0
rjmp Program 

Delay20:
 ldi r19, 40
D20loop2:
 ldi r18, 100
D20loop1:
 ldi r17, 220
D20loop0:
 dec r17
 brne D20loop0
 dec r18
 brne D20loop1
 dec r19
 brne D20loop2
ret

Delay:
 ldi r19, 50
Dloop2:
 ldi r18, 255
Dloop1:
 ldi r17, 255
Dloop0:
 dec r17
 brne Dloop0
 dec r18
 brne Dloop1
 dec r19
 brne Dloop2
ret

