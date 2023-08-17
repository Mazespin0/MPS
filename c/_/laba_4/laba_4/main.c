//Напишите программу, которая, используя таймер опрашивает не менее 8-ми кнопок.
//Количество опросов каждой кнопки в секунду не менее 4 раз. По прошествии 3-х секунд
//в СОМ-порт выводиться информация о общем количестве нажатий всех кнопок.

#define  F_CPU  8000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

uint8_t count = 0;
uint8_t count_r = 0;
uint8_t port_stat = 0;
uint8_t port_stat_l = 0;
uint8_t sys;

void setup(){
	DDRA |= (1 << 0);
	DDRB |= (1 << 0);
	
	UBRRL = 0x33;
	UBRRH = 0x00;
	
	UCSRB = (0 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (0 << RXEN) | (1 << TXEN);
	UCSRC = (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	
	DDRA = 0;
	
	TCCR1B = (1 << CS11) | (1 << CS10);
	TIMSK = (1 << TOIE1);
	TIFR = (1 << TOIE1);
	
	TCNT1H = 207;
	TCNT1L = 43;
	
	DDRB = (1 << 0);
	
	sei();
}

void uart_send(char c){
	while(!( UCSRA & (1<<UDRE)));
	UDR = c;
	
	count_r = 0;
}

int main(){
	setup();
	while(1){
	}
}

ISR(TIMER1_OVF_vect)
{
	cli();
	
	port_stat = PINA;
	if (port_stat != port_stat_l)
		count++;
	port_stat_l = port_stat;
	
	if (count_r == 30)
		uart_send(count/2);
	count_r++;
	
	TCNT1H = 207;
	TCNT1L = 43;
}