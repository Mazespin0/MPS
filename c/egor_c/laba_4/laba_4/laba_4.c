#define  F_CPU  8000000UL
#define BAUD_RATE 19200

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

uint16_t ubrr_value = F_CPU / 16 / BAUD_RATE - 1;
uint16_t TIM1 = 31250; 

void setup(){
	DDRA = (0 << 0);
	
	UBRRH = (ubrr_value >> 8) & 0xFF;
	UBRRL = ubrr_value & 0xFF;
	
	UCSRB = (0 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (0 << RXEN) | (1 << TXEN);
	UCSRC = (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	
	TIMSK = (1 << TOIE1);
	TIFR = (1 << TOIE1);
	TCCR1B = (1 << CS12) | (0 << CS11) | (0 << CS10);
}

int main(){
	setup();
	while ( 1 ){
		while (PINA == 0);
		
		
	}
}

ISR(TIMER1_OVF_vect)
{
	
}