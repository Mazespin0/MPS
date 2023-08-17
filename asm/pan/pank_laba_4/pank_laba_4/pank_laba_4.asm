.include "m16def.inc";
.def temp = r16;
.def duty = r20;
.def _duty = r21;

.cseg;
.org 0;
	jmp _reset;

_reset:
	ldi temp, high(RAMEND);
	out SPH, temp;
	ldi temp, low(RAMEND);
	out SPL, temp;

	ldi temp, (1 << WGM20) | (1 << WGM21);
	out TCCR2, temp;
	ldi temp, (1 << COM21) | (1 << CS20) | (1 << CS21) | (0 << CS22);
	out TCCR2, temp;

	ldi temp, (1 << WGM00) | (1 << WGM01);
	out TCCR0, temp;
	ldi temp, (1 << COM01) | (1 << CS00) | (1 << CS01) | (0 << CS02);
	out TCCR0, temp;

	ldi temp, (1 << 7);
	out DDRD, temp;
	ldi temp, (1 << 3);
	out DDRB, temp;

	sei;

_main:
	ldi duty, 0;
	ldi _duty, 255;
	//rjmp _main;
_m:
	rcall _20_ms;
	out OCR0, duty;
	out OCR2, _duty;

	inc duty;
	dec _duty;
	
	breq _m1;
	rjmp _m;

_m1:
	rcall _20_ms;
	out OCR0, duty;
	out OCR2, _duty;

	inc _duty;
	dec duty;

	breq _main;
	rjmp _m1;

_20_ms:
				ldi r17, 225; 
	_20_loop0:	ldi r18, 236;
	_20_loop1:	dec r18;
				brne _20_loop1;
				dec r17;
				brne _20_loop0;
				ret;
	




