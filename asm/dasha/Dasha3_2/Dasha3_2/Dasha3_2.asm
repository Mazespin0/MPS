.include "m16def.inc";
.def temp = r16;
.def sys = r17;

.equ Bitrate = 9600;
.equ BAUD = 8000000 / (16 * Bitrate) - 1;

.cseg;
.org 0;
	jmp _reset;
.org $016;
	jmp USART_RXC;
.org $01A;
	jmp USART_TXC;	

_reset:
	ldi temp, high(RAMEND);
	out SPH, temp;
	ldi temp, low(RAMEND);
	out SPL, temp;

	ldi temp, high(BAUD);
	out UBRRH, temp;
	ldi temp, low(BAUD);
	out UBRRL, temp;

	ldi temp, 0xFF;
	out DDRA, temp;

	ldi temp, (1 << RXCIE) | (1 << TXCIE) | (0 << UDRIE) | (1 << RXEN) | (1 << TXEN);
	out UCSRB, temp;
	ldi temp, (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	out UCSRC, temp;
	sei;

_main:
	rjmp _main;

_handler:
	cpi sys, $31;
		breq _led_on;
	cpi sys, $32;
		breq _led_on;
	cpi sys, $33;
		breq _led_on;
	cpi sys, $34;
		breq _led_on;
	cpi sys, $35;
		breq _led_on;
	cpi sys, $36;
		breq _led_on;
	cpi sys, $37;
		breq _led_on;
	cpi sys, $38;
		breq _led_on;
	cpi sys, $39;
		breq _led_on;
	cpi sys, $30;
		breq _led_on;

	rjmp _led_error;

_led_on:
	SUBI sys, $30
	out PORTA, sys;
	ret;

_led_error:
	ldi temp, 0xFF
	out PORTA, temp;
	rcall _delay;
	ldi temp, 0
	out PORTA, temp;
	rcall _delay;

	ldi temp, 0xFF
	out PORTA, temp;
	rcall _delay;
	ldi temp, 0
	out PORTA, temp;
	rcall _delay;

	ret;
	
USART_RXC:
	cli;
	sbis UCSRA, RXC;
		rjmp USART_RXC;
	
	in sys, UDR;

	ldi temp, 0xff;
	out PORTA, temp;

	sei;
	reti;

USART_TXC:
	cli;
	sbis UCSRA, UDRE;
	rjmp USART_TXC;
	clr sys;

	sei;
	reti;

_delay:
				ldi r17, 36; 72
	_1k_loop0:	ldi r18, 188; 188
	_1k_loop1:	ldi r19, 196; 196;
	_1k_loop2:	dec r19;
				brne _1k_loop2;
				dec r18;
				brne _1k_loop1;
				dec r17;
				brne _1k_loop0;
				ret








	
	 
	

