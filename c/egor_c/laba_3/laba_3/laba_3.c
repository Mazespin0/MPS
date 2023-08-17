//	Напишите программу, которая раз вывод состояния порта А в com-port в формате (“1 button -1” “2 button -0, где 0 или 1 это состояние кнопки,	//
//	нажата или нет, если состояние порта А изменилось. К порту А подключены кнопки. Скорость передачи данных 19 200 бит/с.	//

#define  F_CPU  8000000UL
#define BAUD_RATE 19200

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

uint16_t ubrr_value = F_CPU / 16 / BAUD_RATE - 1;

uint8_t port_stat = 0;
uint8_t port_stat_l = 0;
char c;

void setup(){
	DDRA = 0x00;
	DDRC = (1 << 0);
	UBRRH = (ubrr_value >> 8) & 0xFF;
	UBRRL = ubrr_value & 0xFF;
	
	UCSRB = (0 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (0 << RXEN) | (1 << TXEN);
	UCSRC = (1 << URSEL) | (1 << UCSZ0) | (1 << UCSZ1);
	
	port_stat = PINA;
	port_stat_l = PINA;
}

int main(){
	while(1){
		setup();
		port_stat = PINA;
	
		while (port_stat == port_stat_l){
			port_stat = PINA;
			PORTC = (0 << 0);
		}
	
		PORTC = (1 << 0);
		port_stat_l = port_stat;
		_pins_handler();
	}
}

void _pins_handler(void){
	for(int i=0; i<=7; i++){
		int j = i + 1;
		c = j + '0';
		USART_sendLine("Button ");
		USART_sendChar(c);
		USART_sendLine(" - ");
		
		if (PINA & (1 << i))
			USART_sendChar('1');				
		else
			USART_sendChar('0');
			
		USART_sendChar('\r');
	}
	USART_sendChar('\r');
}

void USART_sendChar(char character){
	while( !((UCSRA >> UDRE) & 1) );
	UDR = character;
}

void USART_sendLine(char *string){
	while ( *string ){
		USART_sendChar(*string);
		string++;
	}
}