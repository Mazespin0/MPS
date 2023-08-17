//Ќапишите программу, котора€ ожидает прихода слова одного из словосочетаний УHello worldФ Уhello worldФ, Уhello WorldФ 
//и в ответ отвечает УHiФ,если пришло неверное сообщение, программа выдает сообщение УErrorФ. 
//—корость передачи данных 19 200 бит/с.

.include "m16def.inc";
.def temp = r16;
.def sys = r17;
.def count = r18;
.def count_c = r19;

.equ Bitrate = 19200;
.equ BAUD = 8000000 / (16 * Bitrate) - 1;

.cseg;
.org 0;
	jmp _reset;
.org $016;
	jmp USART_RXC;

array:	.DB "hello world"

trueStr: .DB "Hi", $0;
falseStr: .DB "Error", $0;

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

	ldi temp, (1 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (1 << RXEN) | (1 << TXEN);
	out UCSRB, temp;
	ldi temp, (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	out UCSRC, temp;

	sei;

_r_main:
	ldi ZL, low(array * 2);
	ldi ZH, high(array * 2)
	
	ldi count, 1;
	clr count_c;
	sei;

_main:
	rjmp _main;


_handler:
	CPI sys, $0D;
		breq _result;

	LPM temp, Z+;
	cpi count, 1;
		breq _first_char;
	cpi count, 7;
		breq _seven_char;
	CP sys, temp;
		breq _inc;
	inc count;

	ret;

_first_char:
	cpi sys, 'h';
		breq _inc;
	cpi sys, 'H';
		breq _inc;
	ret;

_seven_char:
	cpi sys, 'w';
		breq _inc;
	cpi sys, 'W';
		breq _inc;
	ret;
	
_inc:
	inc count_c
	inc count;
	ret;

_result:
	cpi count_c, 11;
		breq _true_1;

	rjmp _false;

_true_1:
	cpi count, 12;
		breq _true;
	rjmp _false;

_true:
	ldi ZL, low(trueStr * 2);
	ldi ZH, high(trueStr * 2);
_m_t:
	LPM temp, Z+;
	cpi	temp, $00;
		breq _puts_end;
	rcall _uart;
	rjmp _m_t;


_false:
	ldi ZL, low(falseStr * 2);
	ldi ZH, high(falseStr * 2);
_m_f:
	LPM temp, Z+;
	cpi	temp, $00;
		breq _puts_end;
	rcall _uart;
	rjmp _m_f;

_puts_end:
	ldi temp, '\r';
		rcall _uart;

	ldi ZL, low(array * 2);
	ldi ZH, high(array * 2)
	
	ldi count, 1;
	clr count_c;

	ret;
	
_uart:
	sbis UCSRA, UDRE;
			rjmp PC - 1;
	out UDR, temp;
	ret;
	

USART_RXC:
	cli;
	sbis UCSRA, RXC;
		rjmp USART_RXC;
	
	in sys, UDR;
	rcall _handler;

	sei;
	reti;
