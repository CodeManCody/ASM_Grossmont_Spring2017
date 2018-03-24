; CSIS 165 - Assembly Language / Machine Architecture
; Student:      ICE6-solution
; Instructor:   Bochsler
; Assignment #: ICE6
; Due Date:     9 March 2017
;
; Description:
; This program implements the solution to ICE6

.386P           ; use 80386 instruction set
.MODEL flat,C     ; use flat memory model

.DATA           ; declare initialzed data here

.STACK          ; use default 1k stack space

.CODE           ; contains our code

; 
;
_myAsmFunc PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	; add your code here

	MOV		eax, [ebp + 8]
	CMP		eax, 3
	JA		L1
	JMP		false
	
	L1:
	MOV		eax, [ebp + 12]
	CMP		eax, 9
	JB		L2
	JMP		false

	L2:
	MOV		eax, [ebp + 16]
	CMP		eax, 7
	JAE		final
	JMP		false

	final:
	MOV		eax, [ebp + 12]
	ADD		eax, 2
	JMP		alltr

	false:
	MOV		eax, [ebp + 16]

	alltr:

	

	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
_myAsmFunc ENDP

END _myAsmFunc