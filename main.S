; Group Project 2
; Author: Ryan Govreau
; Date: May 8, 2019

#include "config.h"

	.section .data
dummy: 	.byte 0		; dummy global variable

        .section .text
        .global     main
		.extern     ledcontrol
		.extern     sonic
		.extern     infrared
        .org        0x0000


main:
	; clear the SREG register
        eor     r1, r1                  ; cheap zero
        out     _(SREG), r1                ; clear flag register


        ; set up the stack
        ldi         r28, (RAMEND & 0x00ff)
        ldi         r29, (RAMEND >> 8)
        out         _(SPH), r29
        out         _(SPL), r28

	; initialize the CPU clock to run at full speed
	    ldi         r24, 0x80
        sts         CLKPR, r24              ; allow access to clock setup
        sts         CLKPR, r1               ; run at full speed
		
		; set up the sensor ports
		cbi         INPUT_DIR, infraPin  ; set infrared sensor to input
		sbi         INPUT_DIR, trigPin   ; set trigPin sensor to output
		cbi         INPUT_DIR, echoPin   ; set echo sensor to input
		cbi         INPUT_PORT, infraPin  ; start with the trigPin off
		cbi         INPUT_PORT, trigPin  ; start with the trigPin off
		cbi         INPUT_PORT, echoPin  ; start with the trigPin off
        
        ; set up the LED port
        sbi         LED_DIR, LED1        ; set LED pin to output
		sbi         LED_DIR, LED2        ; set LED pin to output
        cbi         LED_PORT, LED1       ; start with the LED off
		cbi         LED_PORT, LED2       ; start with the LED off

		
       

        ; enter the blink loop
1:      rcall       infrared
		rcall       LED1_ON
		rcall       sonic
		rcall       delay100
        rjmp        1b
		

