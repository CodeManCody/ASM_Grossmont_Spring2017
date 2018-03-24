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

.DATA?
scratch1	BYTE 120 DUP(?)				; used to store stripped down input string, aka, only lower case and digits
scratch2	BYTE 120 DUP(?)				; used to store reversed and stripped down input string


.STACK          ; use default 1k stack space

.CODE           ; contains our code


isStringAPalindrome PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		esi, [ebp + 8]			; move input string into esi
	MOV		edi, 0					; set index to 0 for adding chars to scratch1 string

l_Start:
	MOV		bl, BYTE PTR[esi]		; move pointer to first char of input string to register
	CMP		bl, 0
	JE		l_Final					; done if at end of string
	CMP		bl, "a"					; check if lower case letter
	JL		l_Upper					; if not, check for upper case letter
	CMP		bl, "z"
	JG		l_Upper
	MOV		scratch1[edi], bl		; if lower case, add to scratch1
	ADD		edi, 1
	ADD		esi, 1
	JMP		l_Start					; loop

l_Upper:
	CMP		bl, "A"					; check if upper case
	JL		l_Digit					; if not, check for digits
	CMP		bl, "Z"
	JG		l_Digit
	XOR		bl, 20h					; convert upper case to lower case
	MOV		scratch1[edi], bl		; move into scratch1 string
	ADD		edi, 1
	ADD		esi, 1
	JMP		l_Start					; loop

l_Digit:
	CMP		bl, "0"					; check if a digit
	JL		l_Next					; if not, continue checking chars in string
	CMP		bl, "9"
	JG		l_Next
	MOV		scratch1[edi], bl		; add digits to scratch1
	ADD		edi, 1

l_Next:
	ADD		esi, 1					; continue checking next chars in string
	JMP		l_Start					; loop

l_Final:
	MOV		scratch1[edi], 0		; add null to end
	CALL	stringReverse
	CALL	isStringEqual
	

	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
isStringAPalindrome ENDP


stringReverse PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		esi, 0				; set index to 0 for scratch2

l_Start:
	CMP		edi, 0					; at end of scratch1?	
	JE		l_End					; if so, exit loop
	MOV		bl, scratch1[edi-1]		; we are at end of scratch1, so minus 1 for proper indexing
	MOV		scratch2[esi], bl		; move last char of scratch1 into first char of scratch2
	SUB		edi, 1
	ADD		esi, 1				
	JMP		l_Start					; loop
	
l_End:
	MOV		scratch2[esi], 0		; add null to scratch2


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
stringReverse ENDP


isStringEqual PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		esi, 0				; set index to 0 for both strings
	
l_Start:
	MOV		al, scratch1[esi]
	MOV		bl, scratch2[esi]
	CMP		al, bl				; check for equality
	JNE		l_False				; if not, then false

	CMP		al, 0				; at end of first string?
	JZ		l_True
	
	CMP		bl, 0				; at end of second string?
	JZ		l_True

	ADD		esi, 1
	JMP		l_Start				; loop

l_False:
	MOV		eax, 0
	JMP		l_Final				; exit loop

l_True:
	MOV		eax, 1				; set return to true if equal

l_Final:

	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
isStringEqual ENDP


END isStringAPalindrome
