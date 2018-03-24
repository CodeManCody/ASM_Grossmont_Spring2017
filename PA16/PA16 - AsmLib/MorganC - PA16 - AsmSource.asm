; CSIS 165 - Assembly Language / Machine Architecture
; Student:      Cody Morgan
; Instructor:   Bochsler
; Assignment #: PA16
; Due Date:     5/25/17
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


intToBin PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	MOV		eax, [ebp + 8]			; int32_t input to convert
	MOV		edi, [ebp + 12]			; destination char* array after conversion
	MOV		ecx, 32					; loop counter for 32 bits

l_Start:
	SHL		eax, 1					; get MSB into CF
	JC		l_char1					; if CF == 1
	MOV		BYTE PTR[edi], '0'		; otherwise put '0' into dest array
	JMP		l_Inc					; jump to INC dest array

l_char1:
	MOV		BYTE PTR[edi], '1'		; move '1' into dest array

l_Inc:
	INC		edi						; INC dest array pointer
	LOOP	l_Start					; loop

	MOV		BYTE PTR[edi], 0		; null terminate dest array

	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
intToBin ENDP



isSubString PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	MOV		esi, [ebp + 8]			; const char* s
	MOV		edi, [ebp + 12]			; const char* ss
	MOV		eax, 0					; assume false

l_Start:
	MOV		bl, BYTE PTR[esi]		; move char from s array into bl
	MOV		cl, BYTE PTR[edi]		; move char from ss array into cl
	CMP		bl, 0					; at end of s array??
	JE		l_Check					; if so, jump to check for last char in ss
	CMP		cl, 0					; at end of ss array??			
	JE		l_Check					; if so, jump to check for last char in ss
	CMP		bl, cl					; compare char in s to char in ss
	JE		l_True					; if equal, jump to set true
	MOV		eax, 0					; otherwise, set false
	INC		esi						; INC char* s
	JMP		l_Start					; loop

l_True:
	MOV		eax, 1					; set true
	INC		esi						; INC char* s
	INC		edi						; INC char* ss
	JMP		l_Start					; loop

l_Check:
	MOV		cl, BYTE PTR[edi]		; move last char in ss into cl
	CMP		cl, 0					; is there a char present??
	JG		l_FalseEnd				; if so, set to false
	JMP		l_End					; if not, we are done

l_FalseEnd:
	MOV		eax, 0					; set to false

l_End:								; done

	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
isSubString ENDP

END isSubString