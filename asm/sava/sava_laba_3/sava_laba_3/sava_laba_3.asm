//		Напишите программу, которая ожидает любой ASCII символ с компьютера. Если
//		этот символ относится к буквам латинского или русского алфавита, то
//		необходимо включить светодиод в разряде 0. Если этот символ относится к
//		цифрам, то необходимо зажечь светодиод в разряде 1. В любом другом случае
//		ошибку можно отметить, как в задании 1. Программа должна быть написана
//		максимально коротко (проверки символов). Порт настройте на скорость 2400 
//		бит/с


.include "m16def.inc";
.def temp = r16;
.def sys = r17;
.def count = r18;
.def count_r = r19;

.equ Bitrate = 2400;
.equ BAUD = 8000000 / (16 * Bitrate) - 1;

.cseg;
.org 0;
	jmp _reset;
.org $016;
	jmp USART_RXC;

arrayLetters: .DB "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZабвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ", $00;
arrayNumbers: .DB "0123456789", $00;

_reset:
	ldi temp, high(RAMEND);
	out SPH, temp;
	ldi temp, low(RAMEND);
	out SPL, temp;

	ldi temp, high(BAUD);
	out UBRRH, temp;
	ldi temp, low(BAUD);
	out UBRRL, temp;

	ldi temp, (1 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (1 << RXEN) | (1 << TXEN);
	out UCSRB, temp;
	ldi temp, (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	out UCSRC, temp;

	ldi temp, (1 << 0) | (1 << 1);
	out DDRA, temp;
	sei;

_main:
	rjmp _main;

_handler:
	clr count;
	rcall _rhandlerLatters;
	rcall _rhandlerNumbers;
	cpi count, 0;
		breq _error;
	ret;

_error:
	_led_error:
	ldi temp, (1 << 0) | (1 << 1)
	out PORTA, temp;
	rcall _delay;
	ldi temp, 0
	out PORTA, temp;
	rcall _delay;

	ldi temp, (1 << 0) | (1 << 1)
	out PORTA, temp;
	rcall _delay;
	ldi temp, 0
	out PORTA, temp;
	rcall _delay;

	ret;

_rhandlerLatters:
	ldi ZL, low(arrayLetters * 2);
	ldi ZH, high(arrayLetters * 2);

_handlerLatters:
	LPM temp, Z+;
	CPI temp, $00;
		breq _m;
	CP sys, temp;
		breq _ledLetters;
	rjmp _handlerLatters;


_rhandlerNumbers:
	ldi ZL, low(arrayNumbers * 2);
	ldi ZH, high(arrayNumbers * 2);

_handlerNumbers:
	LPM temp, Z+;
	CPI temp, $00;
		breq _m;
	CP sys, temp;
		breq _ledNumbers;
	rjmp _handlerNumbers;

		
_m:
	ret;

_ledLetters:
	sbi PORTA, 0;
	cbi PORTA, 1;
	inc count;
	ret;

_ledNumbers:
	sbi PORTA, 1;
	cbi PORTA, 0;
	inc count;
	ret
	

USART_RXC:
	cli;
	sbis UCSRA, RXC;
		rjmp USART_RXC;

	in sys, UDR;

	rcall _handler;

	sei;
	reti;


_delay:
				ldi r17, $24; 72
	_500_loop0:	ldi r18, $BC; 188
	_500_loop1:	ldi r19, $C4; 196;
	_500_loop2:	dec r19;
				brne _500_loop2;
				dec r18;
				brne _500_loop1;
				dec r17;
				brne _500_loop0;
				ret
