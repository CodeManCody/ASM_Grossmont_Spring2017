; CSIS 165 - Assembly Language / Machine Architecture
; Student:      Cody Morgan
; Instructor:   Bochsler
; Assignment #: ICE8
; Due Date:     24 March 2017
;
; Description:
; Implement functions that combine pure Assembler Library and C/C++

.386P           ; use 80386 instruction set
.MODEL flat,C     ; use flat memory model

printf PROTO C, :VARARG

.DATA           ; declare initialzed data here
fmt			db	"%d ", 0

.STACK          ; use default 1k stack space

.CODE           ; contains our code

; 
;
isBitCountEven PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		ecx, 32				; set counter of 32 bits
	MOV		eax, 1				; assume true/even
	MOV		ebx, 0				; register to store bits of 1
	MOV		esi, [ebp + 8]		; move int32_t arg into esi

L1:
	SHL		esi, 1				; shift left to accumulate bits of 1
	JNC		L2					; if zero bit, loop
	INC		ebx					; INC bit of 1 count

L2:	
	Loop	L1


	SHR		ebx, 1				; shift right to test LSB bool		
	JNC		L3					; bit count is even, jump to end
	MOV		eax, 0				; false/odd bit count

L3:


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
isBitCountEven ENDP

END isBitCountEven
