#include <avr/io.h>
#include <util/delay.h>

#include "blink.h"

void blink() {
    DDRD = 1 << DD2; 

    PORTD = 1 << PB2;
    _delay_ms(500);
    PORTD = 0;
    _delay_ms(200);
}
