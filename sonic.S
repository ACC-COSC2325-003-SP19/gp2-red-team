#include "config.h"

	.section	.text
	.extern     delay
	.extern     toggle
	.global     sonic
	.global     sonic_off
	.global     sonic_on
	
sonic:
        rcall     sonic_on
		rcall     delay10
		rcall     sonic_off
		rcall     delay10
		rcall     delay10
		rcall     delay10
		rcall     delay10
		rcall     delay10
		rcall     ECHO
	    ret
		
sonic_off:
        in          r17, INPUT_PORT           ; get current bits
        ldi         r17, (0 << trigPin)        ; LED is pin 5
        out         INPUT_PORT, r17           ; write the bits back
        ret
		
sonic_on:
        in          r18, INPUT_PORT           ; get current bits
        ldi         r18, (1 << trigPin)        ; LED is pin 5
        out         INPUT_PORT, r18           ; write the bits back
        ret
		
ECHO:
2:    sbic	    INPUT, echoPin			
      cbi	    LED_PORT, LED2		
	  sbis	    INPUT, echoPin		
	  sbi	    LED_PORT, LED2			
	  rcall	    delay10
	  ret