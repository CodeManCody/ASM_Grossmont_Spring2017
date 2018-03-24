; CSIS 165 - Assembly Language / Machine Architecture
; Student:      Cody Morgan
; Instructor:   Bochsler
; Assignment #: ICE13
; Due Date:    Week 13
;
; Description:
; This program implements the solution to ICE12

.386P								; use 80386 instruction set
.MODEL flat,C						; use flat memory model

printf PROTO C, :VARARG

.DATA								; declare initialzed data here

.STACK								; use default 1k stack space

.CODE								; contains our code

asmDoMath PROC
	PUSH	ebp
	MOV		ebp, esp
	PUSH	edi
	PUSH	esi					; end prologue

	
	MOV		esi, [ebp + 8]		; const int8_t *a
	MOV		ebx, [ebp + 12]		; const int16_t *b
	MOV		edi, [ebp + 16]		; int32_t *c
	MOV		ecx, [ebp + 20]		; max
	MOV		edx, 0				; i = 0

top:
	CMP		edx, ecx		; i < max ??
	JAE		l_End			; if not, exit
	; loop body

	PUSH		esi			; save const int8_t *a
	PUSH		ebx			; save const int16_t *b
	PUSH		edx			; save i

	MOV		al, BYTE PTR [esi]		; const int8_t *a
	MOV		bx, WORD PTR [ebx]		; const int16_t *b
	CBW
	IMUL	bx					; a[i] * b[i]
	SUB		ax, [ebp + 24]		; subtract offset
	CWDE
	MOV		[edi], ax			; move into 16 bit array
	AND		eax, 0FFFFh
	AND		edx, 0FFFFh
	SHL		edx, 16
	OR		eax, edx
	
	MOV		[edi], eax			; move into 32 bit array

	POP		edx			; resore i
	POP		ebx			; restore b
	POP		esi			; restore a
	ADD		esi, 1
	ADD		ebx, 2
	ADD		edi, 4
	INC		edx				
	JMP		top				; loop

l_End:

	POP		esi					; start epilogue
	POP		edi
	POP		ebp
	RET
asmDoMath ENDP

END