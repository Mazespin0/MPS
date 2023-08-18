// Напишите программу, которая, используя таймер измеряет длительность нажатия кнопки пользователем,
// длительность нажатия выводить в СОМ-порт в миллисекундах, после отпускания кнопки пользователем.

#define  F_CPU  8000000UL
#define BAUD_RATE 19200

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

uint16_t ubrr_value = F_CPU / 16 / BAUD_RATE - 1;
uint16_t TIM1 = 31250;
unsigned long durationMillis = 0;

void setup(){
	DDRD = (0 << 2);
	
	UBRRH = (ubrr_value >> 8) & 0xFF;
	UBRRL = ubrr_value & 0xFF;
	
	UCSRB = (0 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (0 << RXEN) | (1 << TXEN);
	UCSRC = (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	
	TIMSK = (1 << TOIE1);
	TIFR = (1 << TOIE1);
	TCCR1B = (1 << CS12) | (0 << CS11) | (0 << CS10);
	GICR = (1 << INT0);
	MCUCR = (0 << ISC00) | (1 << ISC01);
}

int main(){
	setup();
	
	while (1){
		while(PIND == 0x00);
	
		TCNT1 = TIM1;
		sei();
		while(1);	
	}
}

ISR(TIMER1_OVF_vect){
	cli();
	durationMillis++;
	TCNT1 = TIM1;
	sei();
}

ISR(INT0_vect){
	cli();
	char buffer[100];
    snprintf(buffer, sizeof(buffer), "Duration: %lu ms\r\n", durationMillis);
    for (int i = 0; buffer[i] != '\0'; i++) {
		USART_sendChar(buffer[i]);
	}
	durationMillis = 0;
	//USART_sendChar('\r');
	sei();
}


void USART_sendChar(char character){
	while( !((UCSRA >> UDRE) & 1) );
	UDR = character;
}