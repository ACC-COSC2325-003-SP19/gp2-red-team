#include <avr/io.h>

#define infraPin    1
#define trigPin     2
#define echoPin     3
#define INPUT_DIR   _(DDRB)
#define INPUT_PORT  _(PORTB)
#define INPUT       _(PINB)

#define LED1        2
#define LED2        3
#define LED_DIR     _(DDRD)
#define LED_PORT    _(PORTD)

#

#define _(s)    _SFR_IO_ADDR(s)
