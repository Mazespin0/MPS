.include "m16def.inc";
.def temp = r16;
.def sys = r17;
.def count = r18;
.def count_r = r19;

.equ Bitrate = 19200;
.equ BAUD = 8000000 / (16 * Bitrate) - 1;

.cseg;
.org 0;
	jmp _reset;
.org $016;
	jmp USART_RXC;
.org $01A;
	jmp USART_TXC;	

arrayLetters: .DB "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZàáâãäå¸æçèéêëìíîïğñòóôõö÷øùúûüışÿ";
arrayNumbers: .DB $31, $32, $33, $34, $35, $36, $37, $38;

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
	out DDRB, temp;

	ldi temp, (1 << RXCIE) | (1 << TXCIE) | (0 << UDRIE) | (1 << RXEN) | (1 << TXEN);
	out UCSRB, temp;
	ldi temp, (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	out UCSRC, temp;


_main:
	rjmp _main;



	
USART_RXC:
	cli;
	sbis UCSRA, RXC;
		rjmp USART_RXC;
	
	in sys, UDR;
	out UDR, sys
	out PORTA, sys

	sei;
	reti;

USART_TXC:
	cli;
	sbis UCSRA, UDRE;
		rjmp USART_TXC;
	clr sys;

	sei;
	reti;

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
				ret;








	
	 
	

