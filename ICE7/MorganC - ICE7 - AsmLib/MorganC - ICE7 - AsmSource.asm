; CSIS 165 - Assembly Language / Machine Architecture
; Student:      ICE7a
; Instructor:   Bochsler
; Assignment #: ICE7a
; Due Date:     23 March 2017
;
; Description:
; This program implements the solution to ICE7a

.386P           ; use 80386 instruction set
.MODEL flat,C     ; use flat memory model

printf PROTO C, :VARARG

.DATA           ; declare initialzed data here
fmt		db	"%d", 10, 0

.STACK          ; use default 1k stack space

.CODE           ; contains our code

minOfThree PROC PUBLIC
	PUSH	ebp				; save caller base pointer
	MOV		ebp, esp		; set our base pointer
	PUSH	edi
	PUSH	esi				; end prologue

	MOV		eax, [ebp + 8]		; get arg0
	CMP		eax, [ebp + 12]		; if eax <= arg1
	JLE		L1					; jump to L1
	MOV		eax, [ebp + 12]		; else move arg1 to eax
	
	L1: 
	CMP		eax, [ebp + 16]		; if eax <= arg2
	JLE L2						; jump to L2
	MOV		eax, [ebp + 16]		; else move arg2 to eax
	
	L2:

	PUSH	eax				; push the min
	PUSH	OFFSET fmt		; push the string format
	CALL	printf
	ADD		esp, (2 * 4)	; clear the stack

	POP		esi			; start epilogue
	POP		edi
	MOV		esp, ebp	; deallocate locals
	POP		ebp			; restore caller base pointer
	RET
minOfThree ENDP	; end the procedure

END minOfThree