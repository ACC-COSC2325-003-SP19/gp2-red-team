#include "config.h"
    .global      delay2
	.global      delay10
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