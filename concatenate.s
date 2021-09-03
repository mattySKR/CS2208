		AREA CONCAT, CODE, READONLY
		ENTRY
	
		ADR r9,STR3						;Set the space for the new string in r9
		ADR r0,STR1						;Store the address of string 1 in r0
		ADR r1,STR2						;Store the address of string 2 in r1
		LDRB r3,EOS1					;Store the end of string 1 value in r3
		LDRB r4,EOS2					;Store the end of string 2 value in r4
		MOV r5,#0						;Start a counter for the position of string 1
		MOV r6,#0						;Start a counter for the position of string 2
		
		LDRB r7,[r0,r5]					;Load the first position of string 1 into r7
		LDRB r8,[r1,r6]					;Load the first position of string 2 into r8
		
LOOP1	CMP r7,r3						;Compare the current string 1 position and the EOS1 
		STRBNE r7,[r9],#1				;Store the current string 1 position in r9 and post increment 
		ADDNE r5,#1						;If they are not equal, go to the next position
		LDRBNE r7,[r0,r5]				;Load the next position of string 1 into r7
		BNE LOOP1						;Continue to loop if we have not reached the end of the string
		
LOOP2	CMP r8,r4						;Compare the current string 2 position and the EOS2
		STRBNE r8,[r9],#1				;Store the current string 2 position in r9 and post increment 
		ADDNE r6,#1						;If they are not equal, go to the next position
		LDRBNE r8,[r1,r6]				;Load the next position of string 2 into r8
		BNE LOOP2						;Continue to loop if we have not reached the end of the string
		
		STRB r4,[r9],#1					;Store the null character in r9

;-------TEST-LOOP-----------------------------------------------------------------------
		ADR r9,STR3						;Store the address of the new string in r9
		MOV r11,#0						;Start a counter for the position of the string
		LDRB r10,[r9,r11]				;Load the first value of the new string
LOOP3	CMP r10,r3						;Compare the string value with the end of string
		LDRBNE r10,[r9,r11]				;Load the next value of the string
		ADDNE r11,#1					;Increment the position counter
		BNE LOOP3						;Loop back if we are not finished
;---------------------------------------------------------------------------------------
	
ELOOP 	B ELOOP							;Infinite loop symbolizes we are done
	
		AREA CONCAT, CODE, READONLY
		
STR3	DCB 0x0							;declare a staring point for the new string
		SPACE 255						;declare space for the new string
STR1	DCB "This is a test string 1"	;String1			(length 23 (17 hex) with the null)
EOS1	DCB 0x00						;End of String 1
STR2	DCB "This is a test string 2"	;String2			(length 23 (17 hex) with the null)
EOS2	DCB 0x00						;End of String 2

		END