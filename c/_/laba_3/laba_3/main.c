// Ќапишите программу, котора€ ожидает ввода парол€ с клавиатуры (длина парол€ минимум 8 символов).
// ≈сли пароль верный, то зажигаетс€ зеленый светодиод на одну секунду, а потом гаснет,
//если пароль не верный, то зажигаетс€ красный светодиод на одну секунду, а потом гаснет и ожидает ввода парол€ снова. —корость передачи данных 19 200 бит/с.//
#define  F_CPU  8000000UL
#define BAUD_RATE 19200

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

uint8_t counter = 0;
uint8_t counter_arr = 0;
uint8_t sys;
char array[] = {'1', '2', '3', '4', '5', '6', '7', '8', 0x0D};
uint16_t ubrr_value = F_CPU / 16 / BAUD_RATE - 1;

void setup(){
	DDRA |= (1 << 0);
	DDRB |= (1 << 0);
	
	UBRRH = (ubrr_value >> 8) & 0xFF;
	UBRRL = ubrr_value & 0xFF;
	
	//UBRRL = 0x33;
	//UBRRH = 0x00;
	
	UCSRB = (1 << RXCIE) | (1 << TXCIE) | (0 << UDRIE) | (1 << RXEN) | (1 << TXEN);
	UCSRC = (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	
	sei();
}

int main(){
	setup();
	while(1){}
}

ISR(USART_RXC_vect){
	sys = UDR;
	if (array[counter_arr] == sys){
		counter++;
	}
	counter_arr++;
		
	if (sys == 0x0D){
		if ((counter == 9) & (counter_arr == 9)){
			PORTB = (1 << 0);
			PORTA = (0 << 0);
		}
		
		else{
			PORTB = (0 << 0);
			PORTA = (1 << 0);
		}
		
		counter = 0;
		counter_arr = 0;
		sys = 0;
	}
	
}