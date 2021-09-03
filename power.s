			AREA power, CODE, READONLY
			ENTRY
			
;==========================================================<MAIN>===================================================================

			ADR SP, stack					;assigning the address of the stack to SP (stack pointer ---> r13)
			MOV r1, #x						;storing x value in r1
			MOV r0, #n						;storing n value in r0
			STR r1, [SP,#-4]!				;parameter x is then pushed onto the stack
			STR r0, [SP,#-4]!				;parameter n is then pushed onto the stack
			SUB SP, SP, #4					;reserving the stack space where the return value will be stored
			
			BL power						;the power function subroutine call (x, n) is invoked at this step
			
			LDR r0, [SP], #4				;the result is loaded in r0 and popped off the stack afterwards
			ADD SP, SP, #8					;the parameters are then deleted from the stack
			ADR r11, result					;assigning the result to r11
			STR r0, [r11]					;the end result is then stored in the early created result variable
		
LOOP 		B LOOP							;infinite loop ---> end of execution 

;=======================================================<Power Function>============================================================

power		STMFD SP!,{r0,r1,FP,LR}			;n,x,FP (frame pointer) and LR (link register) are pushed onto the stack. Way to create a stack frame because ARM lacks link/unlink instructions
			MOV FP,SP						;FP is set up for this call invocation 
			LDR r1,[FP,#0x18]				;x is then loaded from the stack
			LDR r0,[FP,#0x14]				;n is then loaded from the stack 
				
			CMP r0,#0						;comparing n and zero. In case n is equal to zero, value 1 is returned 
			MOVEQ r0,#1						;if the above case is true and n is equal to zero, then value one is stored as the reult in this step 
			STREQ r0,[FP,#0x10]				;the return value is then pushed into the stack 
			
			BEQ return 						;branching off to the return 
		
			AND r0,#1						;using AND for the case if n is odd
			CMP r0,#1						;if n is odd ---> 1 in r0, if n is even ---> 0 in r0
			LDR r0,[FP]						;then taking paramter n from the stack and storing back to r0
			
			BNE TOELSE						;this step is executed whenever value stored in r0 is even (going to TOELSE skipping all the prior steps)
			
			SUB r0,#1						;value 1 is then subtracted from n
			STR r0,[SP]						;the parameter is being put back onto the stack, therfore overwriting previously stored n
			SUB SP,SP,#4					;reserving the stack space where the return value will be stored
			
			BL power						;the power function subroutine call (x, n - 1) is invoked at this step
			
			LDR r0,[SP],#4					;the reult is then loaded in r0 and popped off the stack
			ADD SP,SP,#8					;the parameters are then removed from the stack
			MUL r0,r1,r0					;the result is then multiplied by x to acheive ---> x * power(x, n - 1)
			STR r0,[FP,#0x10]				;finally, the return value is stored inside the stack
			
			B return						;return
		
TOELSE		MOV r0,r0,LSR #1				;here, n is divided by the value two (in case when n is even)
			STR r0,[SP]						;the parameter is then being put back onto the stack, therfore overwriting previously stored n
			SUB SP,SP,#4					;reserving the stack space where the return value will be stored
			
			BL power						;the power function subroutine call y = power(x, n >> 1) is invoked at this step
			
			LDR r0,[SP],#4					;the reult is then loaded in r0 and popped off the stack
			ADD SP,SP,#8					;the parameters are then removed from the stack
			MUL r1,r0,r0					;the result is then multiplied by y to acheive ---> y * y
			STR r1,[FP,#0x10]				;finally, the return value is stored inside the stack
		
return 		MOV SP,FP						;shrinking the stack frame
			LDMFD SP!,{r0,r1,FP,PC}			;finally restoring the registers, FP and return 

;===========================================================<DATA DECLARATION>=======================================================

			AREA power, DATA, READWRITE
				
x			EQU 3							;value for x
n			EQU 4							;value for n
result		DCD 0							;result variable where the final result for x^n will be stored
			SPACE 200						;space for the stack (big enough to calculate x^n for various n values)
stack		DCD 0							;start of the stack
			
			END
		