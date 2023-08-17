#define  F_CPU  8000000UL
#include <avr/io.h>
#include <util/delay.h>

void setup(void){
    DDRA |= 1>>0;
    PORTA &= ~(1>>0);
}

int main(void){
    setup();
    while (1){
      PORTA |= (1>>0);
      _delay_ms(250);
      PORTA &= ~(1>>0);
      _delay_ms(250);
    }
}