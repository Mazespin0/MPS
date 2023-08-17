.include "m16def.inc";
.def temp = r16;
.def sys = r17;
.def count = r18;

.equ Bitrate = 19200;
.equ BAUD = 8000000 / (16 * Bitrate) - 1;

.cseg;
.org 0;
	jmp _reset;
.org $016;
	jmp USART_RXC;
.org $01A;
	jmp USART_TXC;

array: .DB $31, $32, $33, $34, $35, $36, $37, $38;

_reset:
	ldi temp, high(RAMEND);
	out SPH, temp;
	ldi temp, low(RAMEND);
	out SPL, temp;

	ldi temp, high(BAUD);
	out UBRRH, temp;
	ldi temp, low(BAUD);
	out UBRRL, temp;

	ldi temp, (1 << 0);
	out DDRA, temp;

	ldi ZL, low(array * 2);	
	ldi ZH, high(array * 2);

	ldi temp, (1 << RXCIE) | (1 << TXCIE) | (0 << UDRIE) | (1 << RXEN) | (1 << TXEN);
	out UCSRB, temp;
	ldi temp, (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	out UCSRС, temp;
	sei

_xu:
	nop;
	rjmp _xu;

_r_main:
	clr temp;
	clr count;
	ldi ZL, low(array * 2);
	ldi ZH, high(array * 2);
	rjmp _xu;
	
_handler:
	CPI sys, $0D;
		breq _result;
	LPM temp, Z+;
	CP sys, temp;
		breq _inc;
	ret;

_inc:
	inc count;
	rjmp _handler;

_result:
	cpi count, 3;
		breq _led;
	rjmp _r_main;

_led:
	sbi PORTA, 0;
	rjmp _r_main;

USART_RXC:
	cli;
	sbis UCSRA, RXC;
		rjmp USART_RXC;
	
	in sys, UDR;
	;out UDR, temp;

	rcall _handler

	sei;
	reti;

USART_TXC:
	cli;
	sbis UCSRA, UDRE;
	rjmp USART_TXC;
	clr sys;

	sei;
	reti;







	
	 
	

