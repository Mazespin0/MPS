//		Напишите программу, которая реализует небольшую коллекцию световых				//
//		эффектов (3 – 5 будет достаточно). Две кнопки («Вперед» и «Назад») должны		//
//		перебирать эффекты по порядку. Две других кнопки («Быстрее» и «Медленнее»)		//
//		должны управлять скоростью переключения светодиодов. Для устранения				//
//		дребезга используйте задержку (примерно 20 мс) после опроса кнопки.				//

.include "m16def.inc";
.def temp = r16;
.def speed = r17;
.def effect = r18;
.def portStatus = r19;
.def lastPortStatus = r20;
.def count = r21;
.def temp_effect = r22;
.def temp_effect1 = r23;
.def temp_effect3 = r24;



.equ LED_PORT = PORTA;
.equ BUTTON_PIN = PINC;

.equ UP_BUTTON = 0;
.equ DOWN_BUTTON = 1;
.equ FASTER_BUTTON = 6;
.equ SLOWER_BUTTON = 7;

.cseg;
.org 0;
	jmp _reset;
.org $002;
	jmp INT0I;
.org $004;
	jmp INT1I;

	


_reset:
	ldi temp, high(RAMEND);
	out SPH, temp;
	ldi temp, low(RAMEND);
	out SPL, temp;

	ldi temp, (1 << ISC11) | (1 << ISC10);
	ldi temp, (1 << ISC01) | (1 << ISC00);
	out MCUCR, temp;

	ldi temp, (1 << INT1) | (1 << INT0);
	out GICR, temp;

	ldi temp, (1 << INTF1) | (1 << INTF0);
	out GIFR, temp;

	ldi temp, 0;
	out DDRD, temp;
	out DDRC, temp;

	ldi temp, 0xFF;
	out DDRA, temp;

	ldi temp_effect1, (1 << 0);
	ldi temp_effect3, (1 << 7);

	ldi r30, 1;
	ldi r25, 5;
	sei;

_main:
	ldi temp_effect, 85;
	rcall _readButtons;
	cpi effect, 85;
		breq _effect_1;
	cpi effect, 170;
		breq _effect_2;
	cpi effect, 255;
		breq _effect_3;
	rjmp _main;

_readButtons:
	in portStatus, BUTTON_PIN;
	cp portStatus, lastPortStatus
		breq _m;

	sbrc portStatus, UP_BUTTON;
		rcall _effect_up;
	sbrc portStatus, DOWN_BUTTON;
		rcall _effect_down;

	mov lastPortStatus, portStatus;	
	ret;

_m:
	ret;

_effect_up:
	cpi effect, 255;
		breq _m;
	add effect, temp_effect;
	ret

_effect_down:
	cpi effect, 0;
		breq _m;
	subi effect, 85;
	ret;


_effect_1:
	rcall _100ms;
	out PORTA, temp_effect1
	rcall _100ms;
	lsl temp_effect1;
	out PORTA, temp_effect1
	cpi temp_effect1, 0x80;
		breq _m1;
	rjmp _main;

_m1:
	ldi temp_effect1, (1 << 0);
	rjmp _main;


_effect_2:
	ldi r23, 0b10101010
	out PORTA, r23
	rcall _100ms
	ldi r23, 0b01010101
	out PORTA, r23
	rcall _100ms
	rcall _readButtons;
	rjmp _main;


_effect_3:
	rcall _100ms;
	out PORTA, temp_effect3
	rcall _100ms;
	lsr temp_effect3;
	out PORTA, temp_effect3
	cpi temp_effect3, 0x01;
		breq _m3;
	rjmp _main;

_m3:
	ldi temp_effect3, (1 << 7);
	rjmp _main;
	
_100ms:
						mov r27, r25
						//ldi r27, 50;
	_100ms_loop0:		ldi  R28, $17
	_100ms_loop1:		ldi  R29, $79
	_100ms_loop2:		dec  R29
						brne _100ms_loop2
						dec  R28
						brne _100ms_loop1
						dec  R27
						brne _100ms_loop0
						ret;

INT0I:
	cli;

	cpi r25, 15;
		breq _m_up;

	add r25, r30;

	sei;
	reti;

_m_up:
	sei;
	reti;

INT1I:
	cli;

	cpi r25, 0;
		breq _m_down;

	sub r25, r30;

	sei;
	reti;

_m_down:
	sei;
	reti;
	