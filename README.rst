Group Project 2
###############
:Group Name: RED Team
:Group Members: Ryan Govreau

Project
*******
..  image:: /gp2-red-team/images/project.jpg


Hardware
********

Ultrasonic Range Sensor HC-SR04
===============================

**Chosen Device Description:**

- Source: https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf

- Basic Features:
    - Input Voltage Range (DC): 5v
    - Output Voltage: High 3.3V / Low 0V
    - Trigger Frequency: 40,000Hz
    - Minimum Trigger Time: 10uS
    - Operating angle: <15 degrees
    - Induction distance: 2-500cm


**Controlling the device:**

- Required input/output signals:


Passive Infrared Sensor HC-SR505
================================

**Chosen Device Description:**

- Source: https://www.elecrow.com/wiki/index.php?title=HC-SR505_Mini_PIR_Motion_Sensor

- Basic Features:
    - Input Voltage Range (DC): 4.5-20V
    - Output Voltage: High 3.3V / Low 0V
    - Trigger: repeatable
    - Delay time: 8 seconds + -30%
    - Induction angle: <100 degree cone angle
    - Induction distance: 3 meters


**Controlling the device:**

- Required input/output signals:


Device Demonstration
********************

When the passive infrared sensor is tripped, it turns on an LED to indicate that it is on and it also turns on the ultrasonic sensor.

When the unltrasonic sensor is turned on, it sends out a pulse and receivces it back. The feedback is then sent to a buzzer to indicate a relative distance based on the pitch. The higher the pitch, the closer the waves are bouncing off.

Once the infrared sensor stops senseing movement (it usually takes 5-11 seconds after the last movement to stop) all of devices turn off again.

Code
****

config.h

..  code-block:: c

	#include <avr/io.h>

	#define infraPin    1
	#define trigPin     2
	#define echoPin     3
	#define INPUT_DIR   _(DDRB)
	#define INPUT_PORT  _(PORTB)
	#define INPUT       _(PINB)

	#define LED1        2
	#define LED2        3
	#define LED3        4
	#define LED4        5
	#define LED5        6
	#define LED_DIR     _(DDRD)
	#define LED_PORT    _(PORTD)

	#

	#define _(s)    _SFR_IO_ADDR(s)

main.S

..  code-block:: text

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


ledcontrol.S

..  code-block:: text

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


infrared.S

..  code-block:: text

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



sonic.S

..  code-block:: text

	#include "config.h"

		.section	.text
		.extern     delay
		.extern     toggle
		.global     sonic
		.global     sonic_off
		.global     sonic_on

	sonic:
			rcall     sonic_on
			rcall     delay100
			rcall     sonic_off
			rcall     delay100
			rcall     delay100
			rcall     delay100
			rcall     delay100
			rcall     delay100
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


delay.S

..  code-block:: text

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


INPUT / OUTPUT
**************





        Chosen Device Description
                Source
                Basic Features

        Controlling the device
                Required input/output signals

        Device demonstration
                How will you show off this device

        Project Code
                Any code your team authored. SOurces for other parts are fine

