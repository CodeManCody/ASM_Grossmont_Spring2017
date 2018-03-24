; CSIS 165 - Assembly Language / Machine Architecture
; Student:      Cody Morgan
; Instructor:   Bochsler
; Assignment #: ICE12
; Due Date:     4/21/17
;
; Description:
; Implement functions that combine pure Assembler Library and C/C++

.386P           ; use 80386 instruction set
.MODEL flat,C     ; use flat memory model

printf PROTO C, :VARARG

.DATA           ; declare initialzed data here



.STACK          ; use default 1k stack space

.CODE           ; contains our code


findFirstChar PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	
	MOV		edi, [ebp + 8]				; set pointer to char array in edi
	
	PUSH	[ebp + 8]					; push string to get length
	CALL	stringLength				; get stringLength
	ADD		esp, 4

	MOV		ecx, eax					; store length in ecx to set counter for REP command
	MOV		al, BYTE PTR[ebp + 12]		; store 'c' in al for scan
	CLD									; direction = forward
	REPNE SCASB							; repeat while not equal
	JNZ		not_found					; jump if no 'c' is found	
	DEC		edi							; found: back up EDI
	SUB		edi, [ebp + 8]				; get index of 'c' char
	MOV		eax, edi					; return index of 'c'
	JMP		l_End
	
not_found:
	MOV		eax, -1						; if no 'c' is found

l_End:


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
findFirstChar ENDP


stringLength PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		edi, [ebp + 8]		; set pointer to char array in edi
	MOV		al, 0				; look for 0
	CLD							; direction = forward

L1:
	SCASB						; scan for 0	
	JNE		L1					; loop until 0 is found

	SUB		edi, [ebp + 8]		; get stringLength
	MOV		eax, edi			; return the length


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
stringLength ENDP

END findFirstChar