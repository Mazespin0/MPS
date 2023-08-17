#define  F_CPU  8000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

uint8_t counter = 0;

void setup(){
	DDRA |= (1 << 0) | (0 << 5);
	DDRC |= (1 << 0) | (0 << 5);
	DDRB |= (1 << 0) | (0 << 5);

	PORTA |= (1 << 5);
	PORTC |= (1 << 5);
	PORTB |= (1 << 5);
}

void _both_lost(){
	while (!((1 << 5) & PINB)){
		PORTC |= (1 << 0);
		PORTA |= (1 << 0);
		_delay_ms(250);
		PORTC &= ~(1 << 0);
		PORTA &= ~(1 << 0);
		_delay_ms(250);
	}
}

void _player1_wins(){
	counter = 0;
	PORTB = 0;
	while (!((1 << 5) & PINB)){
		PORTA |= (1 << 0);
		_delay_ms(50);
		PORTA &= ~(1 << 0);
		_delay_ms(50);
		if (counter == 5){
			PORTC ^= (1 << 0);
			counter = 0;
		}
		counter++;		
	}
}

void _player2_wins(){
	PORTB = 0;
	counter = 0;
	while (!((1 << 5) & PINB)){
		PORTC |= (1 << 0);
		_delay_ms(50);
		PORTC &= ~(1 << 0);
		_delay_ms(50);
		if (counter == 5){
			PORTA ^= (1 << 0);
			counter = 0;
		}
		counter++;
	}
}


int main(void){
	setup();
	
	PORTB = 0;
	PORTA = 0;
	PORTC = 0;
	
	PORTB |= (0 << 1);
	PORTA |= (0 << 1);
	PORTC |= (0 << 1);

	while (1){
		while (!((1 << 5) & PINB)){
			if (((1 << 5) & PINA) && ((1 << 5) & PINC))
				_both_lost();
			else if (!((1 << 5) & PINA) && ((1 << 5) & PINC))
				_player1_wins();
			else if (((1 << 5) & PINA) && !((1 << 5) & PINC))
				_player2_wins();
		}
		
		_delay_ms(500);
		PORTB |= (1 << 0);
		while (!((1 << 5) & PINB)){
			if ((1 << 5) & PINA){
				_player1_wins();
				break;
			}
			if ((1 << 5) & PINC){
				_player2_wins();
				break;
			}
		}
		PORTA &= (0 << 1);
		PORTC &= (0 << 1);
		PORTB &= (0 << 1);
	}
}