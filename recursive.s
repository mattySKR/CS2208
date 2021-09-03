		AREA XTOTHEN, CODE, READONLY
		ENTRY
		
;-------MAIN-------------------------------------------------------------------
		ADR r13,stack					;Assign the address of the stack to the stack pointer
		MOV r1,#x						;Store the value of x in r0
		MOV r0,#n						;Store the value of n in r1
		STR r1,[r13,#-4]!				;Push x parameter on the stack
		STR r0,[r13,#-4]!				;Push n parameter on the stack
		SUB r13,r13,#4 					;Reserve a place in the stack for the return value
		
		BL power						;Call the power subroutine (x, n)
		
		LDR r0,[r13],#4					;Load the result in r0 and pop it from the stack
		ADD r13,r13,#8					;Remove the parameters from the stack
		ADR r11,result					;Assign the result to r11
		STR r0,[r11]					;Store the final result in the result variable

LOOP	B LOOP							;Infinite loop to signify we are done
;------------------------------------------------------------------------------

;-------Power Function---------------------------------------------------------
power	STMFD r13!,{r0,r1,FP,LR}		;Push n,x,frame pointer, and link register on the stack
		MOV FP,r13						;Set the frame pointer for this call
		LDR r1,[FP,#0x18]				;Load x from the stack
		LDR r0,[FP,#0x14]				;Load n from the stack
				
		CMP r0,#0						;Compare n with 0: if (n == 0) return 1
		MOVEQ r0,#1						;Store 1 as the result if n is equal to 0
		STREQ r0,[FP,#0x10]				;Push the return value in the stack
		BEQ return 						;Branch to the return section
		
		AND r0,#1						;AND n with 1: if (n & 1)
		CMP r0,#1						;0 in r0 if n is even, 1 in r0 if n is odd
		LDR r0,[FP]						;Get the n parameter from the stack and put it back in r0
		BNE TOELSE						;if r0 is even go to else
		SUB r0,#1						;Subtract 1 from n
		STR r0,[r13]					;Push the parameter on the stack and write over the old n
		SUB r13,r13,#4					;Reserve a space for the return value
		BL power						;Call the power subroutine: power(x, n - 1)
		LDR r0,[r13],#4					;Load the result in r0 and pop it from the stack
		ADD r13,r13,#8					;Remove the parameters from the stack
		MUL r0,r1,r0					;Multiply the result by x: x * power(x, n-1)
		STR r0,[FP,#0x10]				;Store the return value in the stack
		B return
		
TOELSE	MOV r0,r0,LSR #1				;Divide n by 2: else 
		STR r0,[r13]					;Push the parameter on the stack and write over the old n
		SUB r13,r13,#4					;Reserve a space for the return value
		BL power						;Call the power subroutine: y = power(x, n >> 1)
		LDR r0,[r13],#4					;Load the result and pop it from the stack
		ADD r13,r13,#8					;Remove the parameters from the stack
		MUL r1,r0,r0					;Multiply the result by itself (y*y)
		STR r1,[FP,#0x10]				;Store the return value in the stack
		
return 	MOV r13,FP						;Collapse all working spaces for this function call
		LDMFD r13!,{r0,r1,FP,PC}		;Load all the registers and return to the caller
;------------------------------------------------------------------------------

		AREA XTOTHEN, DATA, READWRITE

n		EQU 4							;Assign the variable n a specific value
x		EQU	3							;Assign the variable x a specific value 
result	DCD 0							;Variable to store the result of x^n in
		SPACE 200						;Space for the stack
stack	DCD 0							;Beginning of the stack

		END