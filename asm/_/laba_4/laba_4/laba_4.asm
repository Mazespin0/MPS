 // Напишите программу, которая, используя таймер опрашивает не менее 8-ми кнопок.                          //
 // Количество опросов каждой кнопки в секунду не менее 4 раз.                                              //
 // По прошествии 3-х секунд в СОМ-порт выводиться информация о общем количестве нажатий всех кнопок.       //
 // ------------------------------------------------------------------------------------------------------- //


.include "m16def.inc";
.def temp = r16;
.def sys = r17;
.def count = r18;
.def count_r = r19;
.def port_stat = r20;
.def port_stat_l = r21;

.equ Bitrate = 19200;
.equ BAUD = 8000000 / (16 * Bitrate) - 1;

.equ TIM1 = 53035;

.cseg;
.org 0;
	jmp _reset;
.org $010
	jmp TIM1_OVF
;.org $016;
	;jmp USART_RXC;
;.org $01A;
	;jmp USART_TXC;
	
_reset:
	ldi temp, high(RAMEND);
	out SPH, temp;
	ldi temp, low(RAMEND);
	out SPL, temp;

	ldi temp, high(BAUD);
	out UBRRH, temp;
	ldi temp, low(BAUD);
	out UBRRL, temp;

	ldi temp, (0 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (1 << RXEN) | (1 << TXEN);
	out UCSRB, temp;
	ldi temp, (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	out UCSRC, temp;

	ldi temp, (1 << TOIE1);
	out TIMSK, temp;
	out TIFR, temp;
	ldi temp, (1 << CS11) | (1 << CS10);
	out TCCR1B, temp

	ldi temp, high(TIM1)
	out TCNT1H, temp
	ldi temp, low(TIM1)
	out TCNT1L, temp

	ldi temp, 0x0;
	out DDRA, temp;

	sei;

_main:
	cpi count_r, 30;
		breq _uart_send
	rjmp _main;

_uart_send:
	sbis UCSRA, UDRE;
			rjmp PC - 1;
	mov temp, count;
	lsr temp;
	out UDR, temp;
	clr count_r;
	rjmp _main;

_handler:
	in port_stat, PINA;
	cp port_stat, port_stat_l
		breq _m;
	inc count;
	mov port_stat_l, port_stat;	
	ret;

_m:
	ret;

TIM1_OVF:
	cli;
	rcall _handler;

	mov port_stat_l, port_stat;	
	ldi temp, high(TIM1);
	out TCNT1H, temp;
	ldi temp, low(TIM1);
	out TCNT1L, temp;

	inc count_r;

	sei;
	reti;

	 

