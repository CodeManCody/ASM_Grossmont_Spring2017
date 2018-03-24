; CSIS 165 - Assembly Language / Machine Architecture
; Student:      Cody Morgan
; Instructor:   Bochsler
; Assignment #: ICE14
; Due Date:     5/4/17
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


asmUpdateFrequency PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	
	MOV		esi, [ebp + 20]		; move address of testString[i] into esi
	
L1:
	MOV		ebx, 0		; clear ebx
	MOV		bl, BYTE PTR[esi]
	CMP		bl, 0			; at end of string?
	JE		l_End			; if so, we are done
	CMP		bl, 'a'
	JL		L2
	CMP		bl, 'z'
	JG		L2
	SUB		bl, 'a'			; to get j
	SHL		ebx, 1
	ADD		ebx, [ebp + 16]
	INC		WORD PTR[ebx]
	JMP		l_Next

L2:
	CMP		bl, 'A'
	JL		l_Next
	CMP		bl, 'Z'
	JG		l_Next
	SUB		bl, 'A'			; to get j
	ADD		bl, [ebp + 12]
	SHL		ebx, 1
	ADD		ebx, [ebp + 16]
	INC		WORD PTR[ebx]

l_Next:
	INC		esi
	JMP		L1

l_End:


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
asmUpdateFrequency ENDP

END asmUpdateFrequency