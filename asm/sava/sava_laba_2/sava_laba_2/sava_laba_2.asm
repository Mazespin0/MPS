//Напишите программу, которая опрашивает две кнопки «Больше» и «Меньше». 
//При нажатии кнопки «Больше» линейка светодиодов должна «заполняться» 
//горящими светодиодами, по одному на каждое нажатие. При нажатии кнопки
//«Меньше» в линейке должен погасать каждый правый горящий светодиод. Для
//устранения дребезга используйте задержку (примерно 20 мс) после опроса
//кнопки.

.include "m16def.inc";
.def temp = r16;
.def sys = r17;

_reset:
	ldi temp, high(RAMEND);
	out SPH, temp;
	ldi temp, low(RAMEND);
	out SPL, temp;

	ldi temp, 0xFF;
	out DDRA, temp;

	ldi temp, (0 << 0) | (0 << 1);
	out DDRB, temp;

_main:
	sbic PINB, 0;
		rjmp _handler_up;
	sbic PINB, 1;
		rjmp _handler_down;
	rjmp _main;

_handler_up:
	in sys, PORTA;
	mov temp, sys
	dec temp;
		brmi _plus;
	cpi sys, 0b10000000;
		breq _main
	LSL sys;
	inc sys;
	out PORTA, sys;
	rcall _delay;
	rjmp _main;

_plus:
	rcall _delay;
	ldi temp, (1 << 0);
	out PORTA, temp;
	rjmp _main;
	
	
_handler_down:
	in sys, PORTA;
	mov temp, sys
	cpi sys, 0b00000000;
		breq _main;
	cpi sys, 0b00000001;
		breq _min;
	cpi sys, 0b11111111;
		breq _minus;
	LSR sys;
	out PORTA, sys;
	rcall _delay;
	rjmp _main;

_min:
	clr sys;
	out PORTA, sys;
	rjmp _main;
	
_minus:
	rcall _delay;
	ldi temp, 0b01111111;
	out PORTA, temp;
	rjmp _main;

_delay:
			  ldi  R17, $0F
	WGLOOP0:  ldi  R18, $CE
	WGLOOP1:  ldi  R19, $E8
	WGLOOP2:  dec  R19
			  brne WGLOOP2
			  dec  R18
			  brne WGLOOP1
			  dec  R17
			  brne WGLOOP0
			  ret;




