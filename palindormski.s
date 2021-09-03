		AREA palindormski, CODE, READONLY
		ENTRY
start		LDR	 r1,=STRING  		;loading string at address to r0
		MOV	 r2,r1			;copying the same string to r1
loop		LDRB 	 r3,[r2],#1		;cycling through string in r2 one byte 
						;at a time and storing in r3, pointer like
		CMP  	 r3,#EoS		;checking if end of string
		BNE	 loop			;if not, keep going
		SUB	 r2,r2,#2		;if is, go to end of the string in r2							
repeat		LDRB 	 r4,[r1],#1		;cycling through string in r1 one byte 
						;at a time and storing in r5
		LDRB 	 r5,[r2],#1		;cycling through string in r2 one byte 
						;at a time and storing in r4
		CMP	 r4,r5			;compare those characters, we are trying 
						;to go from the end to the middle
		BNE	 fail			;if not equal, then not palindrome
		CMP	 r1,r2			;compare vals at adresses in r1 and r2 
						;to see if we reached the middle, aka if we 
						;point to the same address
		BEQ  	 good			;if so, then palindrome
		ADD	 r3,r1,#1		;if not, then we add what we point to 
						;at r1 to r3
		CMP	 r3,r2			;compare if we point to the same as r2
		BEQ	 good			;if so, the palindrome
		ADD	 r1,r1,#1		;if not, then point right to the next char 
						;in the string
		SUB	 r2,r2,#1		;and then, point left to the previous char in 
						;the string
		B	 repeat			;keep going until done
good		MOV	 r0,#1			;if palindrome, then store 1 in r0
fail		MOV	 r0,#2			if not, then store 2 in r0
		
		AREA palindormski, DATA, READWRITE
STRING	DCB	"mam"
EoS		DCB 0x00				
		END