		AREA REMOVE, CODE, READONLY
		ENTRY
				
		ADR r0,STR2						;Set the space for the new string in r0
		ADR r1,STR1						;Store the address of string 1 in r1
		LDRB r3,EOS						;Load the end of string value in r3
		MOV r4,#0						;Start a counter for the position of string 1
		LDRB r5,[r1,r4]					;Load the first position of string 1 into r5
		MOV r7,#0						;Counter for possible changes
		
LOOP	CMP r5,#spc						;Compare the string position with ASCII space
		MOVEQ r8,#1						;If it is a space, trigger to store 1 in r8
		CMP r5,#t						;Compare the string position with ASCII t
		MOVEQ r8,#1						;If it is a t, trigger to store 1 in r8
		CMP r5,#h						;Compare the string position with ASCII h
		MOVEQ r8,#1						;If it is a h, trigger to store 1 in r8
		CMP r5,#e						;Compare the string position with ASCII e
		MOVEQ r8,#1						;If it is an e, trigger to store 1 in r8
		CMP r5,r3						;Compare the string position with end of string
		MOVEQ r8,#1						;If it is the end, trigger to store 1 in r8
		CMP r8,#0						;If the value of r8 is 0, is means it is not the end, t, h, e, or space
		MOVEQ r7,#0						;So resent the possible changes counter
		MOVEQ r6,#0						;Resent the t is the first letter of the sentence tracker
		BEQ CONT						;Then skip to load the next string position if there is one
		
		CMP r5,#spc						;Compare the string position with ASCII space
		ADDEQ r7,#1						;If the string position is a space increment the possible changes counter
		CMPEQ r7,#5						;Check to see if we have found "the"
		CMPEQ r6,#0						;Check to see if t was the first letter
		SUBEQ r0,#1						;If it wasn't decrement one position of the new string
		BEQ STOP						;Jump to STOP if t was not the first letter in the string
		CMP r5,#t						;Compare the string position with ASCII t
		ADDEQ r7,#1						;If the string position is a t increment the possible changes counter
		CMPEQ r4,#0						;Check the see if t is the first letter of string 1
		ADDEQ r7,#1						;If it is the first letter increment the possible changes counter to account for the space the would be there if it was " the "
		MOVEQ r6,#1						;Set the trigger for r6 since t was the first letter
		BEQ STOP						;Jump to stop if t was the first letter
		CMP r5,#h						;Compare the string position with ASCII h
		ADDEQ r7,#1						;Increment the possible changes counter if it was an h
		BEQ STOP						;Jump to STOP if we found an h
		CMP r5,#e						;Compare the string position with ASCII e
		ADDEQ r7,#1						;Increment the possible changes counter if it was an e
		CMP r7,#4						;Compare the possible changes counter to see if was have 4
		CMPEQ r5,r3						;If we have four in it, that means we have " the", so if the current string position is the end
		SUBEQ r0,#3						;Decrement the position of the new string to store null and cut the string short 
		
STOP	CMP r7,#5						;If r7 is equal to five, we have found "the"
		MOVEQ r7,#0						;Resent r7 to 0, in case the are more "the"'s
		SUBEQ r0,#3						;Decrement the position of the new string to write over "the " or " the "
				
CONT	CMP r5,r3						;Compare the string position with the end of string
		STRBNE r5,[r0],#1				;Store the string position in the new string in r0 and post increment 
		ADDNE r4,#1						;Increment the counter for the string position
		LDRBNE r5,[r1,r4]				;Load the new string position in r5
		MOVNE r8,#0						;Reset the trigger
		BNE LOOP						;Go back to the top of the loop if we have not finished 
		
		STRB r3,[r0]					;Lastly store the end of string in the new string 
		
;-------TEST-LOOP-----------------------------------------------------------------------
		ADR r9,STR2						;Store the address of the new string in r9
		MOV r10,#0						;Start a counter for the position of the string
		LDRB r11,[r9,r10]				;Load the first value of the new string
TESTL	CMP r11,r3						;Compare the string value with the end of string
		LDRBNE r11,[r9,r10]				;Load the next value of the string
		ADDNE r10,#1					;Increment the position counter
		BNE TESTL						;Loop back if we are not finished
;---------------------------------------------------------------------------------------
		
ELOOP 	B ELOOP							;Infinite loop symbolizes we are done
		
		AREA REMOVE, DATA, READONLY

STR1	DCB ""
;STR1	DCB "and the man said they must go"		;String 1
;STR1	DCB "the woman and The man said the"	;String 3		
;STR1	DCB "and they took breathe"				;String 4
EOS		DCB 0x00								;End of string 1
spc		EQU 32									;ASCII value for space
t		EQU	116									;ASCII value for t
h		EQU 104									;ASCII value for h
e		EQU	101									;ASCII value for e
STR2	SPACE 0xFF								;Space for the new string
		
		END