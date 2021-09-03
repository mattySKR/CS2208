			AREA Assignment_2, CODE, READONLY
			ENTRY
			
			ADR r0, STRING2			;setting up the space for STRING2 in r0
			ADR	r1, STRING1			;putting the address of STRING1 in r1
			LDRB r3, E0S			;the end (null) of the string value is loaded in r3
			MOV r4, #0				;position counter for STRING1
			LDRB r5, [r1,r4]		;the first position of STRING1 is put into r5
			MOV r7, #0				;if any changes occur, they will be counted and stored in r7
			
LOOP 		CMP r5, #ASCII_space	;ASCII space comparison with the string position
			MOVEQ r8, #1			;if position ends up being a space, then 1 will be stored in r8
			CMP r5, #t				;the string position is compared with character t in ASCII
			MOVEQ r8, #1			;if the position ends up being a character t, then 1 will be stored in r8
			CMP r5, #h				;the string position is compared with character h in ASCII
			MOVEQ r8, #1			;if the position ends up being a character h, then 1 will be stored in r8
			CMP r5, #e				;the string position is compared with character e in ASCII
			MOVEQ r8, #1			;if the position ends up being a character e, then 1 will be stored in r8
			CMP r5, r3				;the string position is compared with the end of the string (null) that is stored in r3
			MOVEQ r8, #1			;if the position ends up being the end (null) of the string, then 1 will be stored in r8
			CMP r8, #0				;if the value in r8 ends up being a zero, then it is not any of the above characters (space,t,h,e,EOS)
			MOVEQ r7, #0			;the counter that was previosuly made for counting changes is now reloaded
			MOVEQ r6, #0			;the character t is reloaded into r6 as the first letter for string checking (case where character to be removed is a part of other string)
			BEQ CONT				;here, the next string position (if any) will be jumped over to prevent loading the chracters that do not need to be removed 
			
			CMP r5, #ASCII_space 	;ASCII space comparison with the string position 
			ADDEQ r7, #1			;if the position ends up being a space, then the changes counter will increment 
			CMPEQ r7, #5			;checking if "the" was found
			CMPEQ r6, #0			;check for t being the first character
			SUBEQ r0, #1			;if not the first character, then the position of STRING2 is decremented 
			BEQ STOP				;STOP if character t is not the first character of the string
			CMP r5, #t				;the string position is compared with character t in ASCII
			ADDEQ r7, #1			;if character t matches the string position, then the changes counter will increment
			CMPEQ r4, #0			;check for if the first character of STRING1 is chracter t
			ADDEQ r7, #1			;if it ends up being the first character, then the changes counter will increment to take care of the case when we have " the "
			MOVEQ r6, #1			;since t is the first character, r6 will take value 1
			BEQ STOP				;STOP if character t was the first one
			CMP r5, #h				;the string position is compared with character h in ASCII
			ADDEQ r7, #1			;if it ends up being character h, then the changes counter will increment
			BEQ STOP				;STOP if character h was found
			CMP r5, #e				;the string position is compared with character e in ASCII
			ADDEQ r7, #1			;if it ends up being character e, then the changes counter will increment
			CMP r7, #4				;checking the changes counter if 4 changes occured
			CMPEQ r5, r3			;if so, then we have a case with " the" and the current string position is EOS
			SUBEQ r0, #3			;the position of STRING2 is decremented so that null can be stored
			
STOP 		CMP r7, #5				;if we have 5 in r7, then "the" was finally found
			MOVEQ r7, #0			;reloading r7 with 0 if we have more reoccurences of "the"
			SUBEQ r0, #3			;the position of STRING2 is decremented to go over cases " the " or "the "
			
CONT 		CMP r5, r3				;the end of the string is compared with the string position 
			STRBNE r5, [r0], #1		;the string position is stored in r0 (STRING2) and the incrememnt is demonstrated
			ADDNE r4, #1			;the counter for the string position is incremented
			LDRBNE r5, [r1, r4]		;new string position is put into r5
			MOVNE r8, #0			;resetting with 0
			BNE LOOP				;if executions are not finished, the loop will start over again
			
			STRB r3, [r0]			;the end of the string is stored in the new one
			
;~~~~~~~~~TESTING~~~~~~~~~~~~

			ADR r9, STRING2			;the address of the updated string is put into r9
			MOV r10, #0				;setting the counter for string positions
			LDRB r11, [r9,r10]		;the first value of the updated string is loaded
TESTL		CMP r11, r3				;the string value is compared with the end of the string
			LDRBNE r11,[r9,r10]		;next value of the string is loaded
			ADDNE r10, #1			;the position counter is incremented
			BNE TESTL				;if not done, the loop will run again 
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ELOOP 		B ELOOP					;inifnite loop that will end execution process when finished		
			
			
			AREA Assignment_2, DATA, READONLY
			
STRING1		DCB "and the man said they must go"		;STRING1 defining (more can be defined later for testing)
EOS			DCB	0x00  								;end of STRING1
STRING2		SPACE 0xFF  							;just allocating 255 bytes 
ASCII_space EQU 32									;space in ASCII
t			EQU 116									;character t in ASCII
h 			EQU 104									;character h in ASCII
e           EQU 101									;character e in ASCII
	
			END

		