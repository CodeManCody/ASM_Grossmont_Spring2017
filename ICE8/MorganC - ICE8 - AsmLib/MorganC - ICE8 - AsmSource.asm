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
fmt			db	"%d", 10, 0


.STACK          ; use default 1k stack space

.CODE           ; contains our code

; 
;
isStringEqual PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	MOV		esi, [ebp + 8]
	MOV		edi, [ebp + 12]

l_start:
	MOV		al, BYTE PTR[esi]
	MOV		bl, BYTE PTR[edi]
	CMP		al, bl
	JNE		l_false

	CMP		al, 0
	JZ		l_exit
	
	CMP		bl, 0
	JZ		l_exit

	ADD		esi, 1
	ADD		edi, 1
	JMP		l_start

l_false:
	MOV		eax, 0
	JMP		l_final

l_exit:
	MOV		eax, 1

l_final:

	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
isStringEqual ENDP


END isStringEqual