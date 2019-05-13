#include "config.h"

	.section	.text
	.global		LED1_OFF
	.global		LED1_ON
	.global		LED2_OFF
	.global		LED2_ON


LED1_OFF:
        in          r24, LED_PORT           ; get current bits
        ldi         r24, (0 << LED1)        ; LED is pin 5
        out         LED_PORT, r24           ; write the bits back
        ret
		
LED1_ON:
        in          r24, LED_PORT           ; get current bits
        ldi         r24, (1 << LED1)        ; LED is pin 5
        out         LED_PORT, r24           ; write the bits back
        ret

LED2_OFF:
        in          r24, LED_PORT           ; get current bits
        ldi         r24, (0 << LED2)        ; LED is pin 5
        out         LED_PORT, r24           ; write the bits back
        ret
		
LED2_ON:
        in          r24, LED_PORT           ; get current bits
        ldi         r24, (1 << LED2)        ; LED is pin 5
        out         LED_PORT, r24           ; write the bits back
        ret
		