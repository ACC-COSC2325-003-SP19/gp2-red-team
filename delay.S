#include "config.h"
    .global      delay2
	.global      delay10
	.global      delaym50
    .section    .text
	
delay2:
        ldi      r26, 32
1:      dec      r26
        cpi      r26, 0
        brne     1b
        ret

delay10:
        ldi      r26, 160
2:      dec      r26
        cpi      r26, 0
        brne     2b
        ret
		
delay100:
        ldi      r16, 250
3:      rcall    delay3
        dec      r16
        cp       r16, r17
        brne     3b
        ret
        
delay3: 
        ldi      r17, 40
4:      dec      r17
        cpi      r17, 0
        brne     4b
        ret