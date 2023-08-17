.include "m16def.inc"

ldi r16, low(RAMEND);
out SPL, r16;
ldi r16, HIGH(RAMEND);
out SPH, r16; 

ldi r16, (1 << 0);
out DDRA, r16;

_main:
    sbi PORTA, 0;
    rcall _250_ms;
    cbi PORTA, 0; 
    rcall _250_ms;
    rjmp _main;

_250_ms:
            ldi  R17, 167
WGLOOP0:  ldi  R18, 29
WGLOOP1:  ldi  R19, 85
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0