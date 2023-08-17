#define  F_CPU  8000000UL
#include "avr/io.h"
#include <util/delay.h>
 
void setup(){
	DDRD  |= (1 << PD7);
	DDRB  |= (1 << PB3);
	
	TCCR2 |= (1 << WGM20) | (1 << WGM21);
	TCCR2 |= (1 << COM21) | (1 << CS20)|(0 << CS21) | (0 << CS22);
	
	TCCR0 |= (1 << WGM00) | (1 << WGM01);
	TCCR0 |= (1 << COM01) | (1 << CS00)|(0 << CS01) | (0 << CS02);
}
      
int main ()
{
	setup();
    while (1){
		for(uint8_t duty=0, _duty=128; duty<128, _duty>0; duty++, _duty--){
			OCR0=duty;
			OCR2=_duty;
			_delay_ms(1);
			}
	}			
}