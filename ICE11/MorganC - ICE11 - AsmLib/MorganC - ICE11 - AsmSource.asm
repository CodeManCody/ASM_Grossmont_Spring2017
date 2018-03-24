; CSIS 165 - Assembly Language / Machine Architecture
; Student:      Cody Morgan
; Instructor:   Bochsler
; Assignment #: PA#10
; Due Date:     4/13/17
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


asmGCD PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		eax, [ebp + 8]
	MOV		ebx, [ebp + 12]

L1:
	CMP		eax, 0
	JE		l_End

	MOV		ecx, eax
	MOV		eax, ebx
	MOV		ebx, ecx
	MOV		edx, 0
	DIV		ebx
	MOV		eax, edx
	MOV		ebx, ecx
	JMP		L1

l_End:
	MOV		eax, ebx




	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
asmGCD ENDP



asmGCDR PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		eax, [ebp + 8]
	MOV		ebx, [ebp + 12]

L1:
	CMP		eax, 0
	JE		L2
	JMP		L3

L2:
	MOV		eax, [ebp + 12]
	JMP		l_End

L3:
	MOV		edx, 0
	MOV		eax, [ebp + 12]
	MOV		ebx, [ebp + 8]
	DIV		ebx				; remainder in edx
	PUSH	ebx				; arg2
	PUSH	edx				; arg1
	CALL	asmGCDR
	ADD		esp, (2 * 4)


l_End:


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
asmGCDR ENDP


END asmGCDR
