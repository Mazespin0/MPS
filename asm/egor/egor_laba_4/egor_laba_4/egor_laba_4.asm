//Напишите программу, которая, используя таймер измеряет длительность нажатия кнопки пользователем,
//длительность нажатия выводить в СОМ-порт в миллисекундах, после отпускания кнопки пользователем.

.include "m16def.inc"
.def temp = r16
.def sys = r17
.def ofv_count = r18
.def count0 = r19
.def count1 = r20
.def count2 = r21

.equ Bitrate = 19200
.equ BAUD = 8000000 / (16 * Bitrate) - 1

.equ TIM1 = 31250

.cseg
.org 0
	jmp _reset
.org $002
	jmp EXT_INT0
.org $010
	jmp TIM1_OVF

_reset:
	ldi temp, high(RAMEND)
	out SPH, temp
	ldi temp, low(RAMEND)
	out SPL, temp

	ldi temp, high(BAUD)
	out UBRRH, temp
	ldi temp, low(BAUD)
	out UBRRL, temp

	ldi temp, (0 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (0 << RXEN) | (1 << TXEN)
	out UCSRB, temp
	ldi temp, (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1)
	out UCSRC, temp

	ldi temp, (1 << TOIE1)
	out TIMSK, temp
	out TIFR, temp
	ldi temp, (1 << CS12) | (0 << CS11) | (0 << CS10)
	out TCCR1B, temp

	ldi temp, (1 << INT0)
	out GICR, temp
	ldi temp, (0 << ISC00) | (1 << ISC01)
	out MCUCR, temp

_main_r:
	rcall _delay
	sbis PIND, 2
		rjmp _main_r

	ldi temp, high(TIM1)
	out TCNT1H, temp
	ldi temp, low(TIM1)
	out TCNT1L, temp
	sei

_main:
	rjmp _main

_handler:
	sei
	rjmp _handler
	

_uart_send:
	sbis UCSRA, UDRE
			rjmp PC - 1
	out UDR, temp
	ret

	
EXT_INT0:
	cli
	mov temp, count1
	rcall _uart_send
	mov temp, count0
	rcall _uart_send
	ldi count0, '0'
	ldi count1, '0'
	ldi temp, '\r'
	rcall _uart_send
	sei
	reti
	


TIM1_OVF:
	cli
	
	cpi count0, '9'
		breq _count1
	;cpi count1, '9'
		;breq _count2+
	inc count0
_m:

	ldi temp, high(TIM1)
	out TCNT1H, temp
	ldi temp, low(TIM1)
	out TCNT1L, temp

	sei
	reti

_count1:
	ldi count0, '0'
	inc count1
	rjmp _m;
	

_delay:
			    ldi  R17, $E1
	WGLOOP0:    ldi  R18, $EC
	WGLOOP1:    dec  R18
				brne WGLOOP1
				dec  R17
				brne WGLOOP0
				ret
	