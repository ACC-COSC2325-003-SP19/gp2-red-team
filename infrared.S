#include "config.h"

	.section	.text
	.extern     delay
	.extern     sonic
	.extern     ledcontrol
	.global     infrared

infrared:
	  rcall       delay10
      in          r16, INPUT
	  andi        r16, 0b00000010
	  cpi         r16, 0b00000010
      brne        inputOff
      ret
	  
inputOff:
	  rcall      LED1_OFF
	  rjmp       infrared
	 