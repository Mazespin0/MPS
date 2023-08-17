.include "m16def.inc"

ldi r21, (1 << 0); //маска для мигания, так надо

ldi r16, low(RAMEND);
out SPL, r16;
ldi r16, HIGH(RAMEND);
out SPH, r16; 

ldi r16, (1 << 0) | (0 << 5);
out DDRA,  r16;
out DDRC,  r16;
out DDRB,  r16;

ldi r16, (1 << 5);
out PORTA, r16; 
out PORTC, r16;
out PORTB, r16;

_main:
	ldi r16, (0 << 0);
	out PORTA,  r16;
	out PORTC,  r16;
	out PORTB,  r16;

	clr r23;
	clr r24;
	in r23, PINA; //записываем состояние порта с первой кнопкой
	in r24, PINC; //записываем состояние порта со второй кнопкой
	AND r23, r24; //складываем их
	SUBI r23, 0x20; //если результат == 20, значит оба нажали кнопку раньше начала, значит оба проиграли
		breq _both_lost;

	sbic PINC, 5; //второй нажал кнопку раньше начала, проиграл
		rjmp _player1_wins;
	sbic PINA, 5; //первый нажал кнопку раньше начала, проиграл
		rjmp _player2_wins;
	sbis PINB, 5; //ждем начала игры
		rjmp PC-1;

	rcall _1k_ms; //светодиод загорается через секунду, потом ловим нажатие кнопок
	sbi PORTB, 0;

	_but:
		sbic PINA, 5; //первый нажал раньше, выйграл
			rjmp _player1_wins;

		sbic PINC, 5; //второй нажал раньше, выйграл
			rjmp _player2_wins;

		rjmp _but;

_both_lost: //оба проиграли, частота 2Гц на обоих светодиодах
	cbi PORTB, 0;
	sbic PINB, 5; // мигаем пока не нажмут кнопку начала новой игры
		rjmp _main;
	sbi PINA, 0;
	sbi PINC, 0;
	rcall _250_ms;
	cbi PINA, 0;
	cbi PINC, 0;
	rjmp _both_lost;
	

_player1_wins: // первый выйграл, его светодиод мигает 10Гц, противника 2Гц, разница 5 раз, значит пока первый светодиод мигнет 5 раз, второй - 1 раз 
	cbi PORTB, 0;
	sbic PINB, 5; //мигаем пока не вновь не нажмут кнопку начала игры
		rjmp _main;
	cpi r20, 5; //здесь мигает 2 светодиод, с условием что 1 уже мигнул 5 раз
		breq _blink1;

	_1_led:
		clr r16;
		in r16, PINA;
		eor r16, r21; //искл. или для работы с маской, маска в r21
		out PORTA, r16;
		rcall _50_ms;

		rjmp _player1_wins;

	_blink1:
		in r16, PINC;
		eor r16, r21; //искл. или для работы с маской, маска в r21
		out PORTC, r16; 
	
		clr r20;
		rjmp _1_led;



_player2_wins: // второй выйграл, его светодиод мигает 10Гц, противника 2Гц, разница 5 раз, значит пока первый светодиод мигнет 5 раз, второй - 1 раз 
	cbi PORTB, 0;
	sbic PINB, 5; //мигаем пока не вновь не нажмут кнопку начала игры
		rjmp _main;
	cpi r20, 5; //здесь мигает 2 светодиод, с условием что 1 уже мигнул 5 раз
		breq _blink2;

	_2_led:
	clr r16;
	in r16, PORTC;
	eor r16, r21; //искл. или для работы с маской, маска в r21
	out PORTC, r16;
	rcall _50_ms;
	rjmp _player2_wins;

	_blink2:
		in r16, PORTA;
		eor r16, r21; //искл. или для работы с маской, маска в r21
		out PORTA, r16;

		clr r20;
		rjmp _2_led;


_1k_ms:
				ldi r17, 72; 72
	_1k_loop0:	ldi r18, 188; 188
	_1k_loop1:	ldi r19, 196; 196;
	_1k_loop2:	dec r19;
				brne _1k_loop2;
				dec r18;
				brne _1k_loop1;
				dec r17;
				brne _1k_loop0;
				inc r20
				ret;
	
_50_ms:
				ldi r17, 151; 
	_50_loop0:	ldi r18, 6;
	_50_loop1:	ldi r19, 146;
	_50_loop2:	dec r19;
				brne _50_loop2;
				dec r18;
				brne _50_loop1;
				dec r17;
				brne _50_loop0;
				inc r20
				ret;
			
_20_ms:
				ldi r17, 225; 
	_20_loop0:	ldi r18, 236;
	_20_loop1:	dec r18;
				brne _20_loop1;
				dec r17;
				brne _20_loop0;
				ret;
				
_250_ms:
				ldi r17, 18; 
	_250_loop0:	ldi r18, 188;
	_250_loop1:	ldi r19, 196;
	_250_loop2:	dec r19;
				brne _250_loop2;
				dec r18;
				brne _250_loop1;
				dec r17;
				brne _250_loop0;
				ret;		

