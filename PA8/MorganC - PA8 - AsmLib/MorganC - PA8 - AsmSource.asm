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
digits		db	"digits, ", 0
lower		db	"lower case, ", 0
upper		db	"upper case, ", 0
other		db	"other chars", 10, 0

.STACK          ; use default 1k stack space

.CODE           ; contains our code

; 
;
scanStringForChars PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	MOV		esi, [ebp + 8]
	MOV		al, 0

	l_intStart:
	MOV		bl, BYTE PTR[esi]
	CMP		bl, "0"
	JL		l_intNo
	CMP		bl, "9"
	JG		l_intNo
	JMP		l_intYes

	l_intNo:
	INC		esi
	MOV		bl, BYTE PTR[esi]
	CMP		bl, 0
	JE		l_intEnd
	JMP		l_intStart

	l_intYes:
	INC		al
	INC		esi
	MOV		bl, BYTE PTR[esi]
	CMP		bl, 0
	JE		l_intEnd
	JMP		l_intStart

	l_intEnd:	

	PUSH	eax				
	PUSH	OFFSET fmt		; push the string format
	CALL	printf			; print number of digits
	ADD		esp, 4			; clear the stack
	PUSH	OFFSET digits
	CALL	printf			; print "digits"
	ADD		esp, 4			; clear the stack




	MOV		esi, [ebp + 8]
	MOV		al, 0

	l_lowStart:
	MOV		bl, BYTE PTR[esi]
	CMP		bl, "a"
	JL		l_lowNo
	CMP		bl, "z"
	JG		l_lowNo
	JMP		l_lowYes

	l_lowNo:
	INC		esi
	MOV		bl, BYTE PTR[esi]
	CMP		bl, 0
	JE		l_lowEnd
	JMP		l_lowStart

	l_lowYes:
	INC		al
	INC		esi
	MOV		bl, BYTE PTR[esi]
	CMP		bl, 0
	JE		l_lowEnd
	JMP		l_lowStart

	l_lowEnd:	

	PUSH	eax				
	PUSH	OFFSET fmt		; push the string format
	CALL	printf			; print number of digits
	ADD		esp, 4			; clear the stack
	PUSH	OFFSET lower
	CALL	printf			; print "digits"
	ADD		esp, 4			; clear the stack





	MOV		esi, [ebp + 8]
	MOV		al, 0

	l_uppStart:
	MOV		bl, BYTE PTR[esi]
	CMP		bl, "A"
	JL		l_uppNo
	CMP		bl, "Z"
	JG		l_uppNo
	JMP		l_uppYes

	l_uppNo:
	INC		esi
	MOV		bl, BYTE PTR[esi]
	CMP		bl, 0
	JE		l_uppEnd
	JMP		l_uppStart

	l_uppYes:
	INC		al
	INC		esi
	MOV		bl, BYTE PTR[esi]
	CMP		bl, 0
	JE		l_uppEnd
	JMP		l_uppStart

	l_uppEnd:	

	PUSH	eax				
	PUSH	OFFSET fmt		; push the string format
	CALL	printf			; print number of digits
	ADD		esp, 4			; clear the stack
	PUSH	OFFSET upper
	CALL	printf			; print "digits"
	ADD		esp, 4			; clear the stack






	MOV		esi, [ebp + 8]
	MOV		al, 0

	l_otherStart:
	MOV		bl, BYTE PTR[esi]
	CMP		bl, 0
	JE		l_otherNo
	CMP		bl, "/"
	JLE		l_otherYes
	CMP		bl, ":"
	JL		l_otherNo
	CMP		bl, "@"
	JLE		l_otherYes
	CMP		bl, "Z"
	JLE		l_otherNo
	CMP		bl, "`"
	JLE		l_otherYes
	CMP		bl, "z"
	JG		l_otherYes

	l_otherNo:
	INC		esi
	MOV		bl, BYTE PTR[esi]
	CMP		bl, 0
	JE		l_otherEnd
	JMP		l_otherStart

	l_otherYes:
	INC		al
	INC		esi
	MOV		bl, BYTE PTR[esi]
	CMP		bl, 0
	JE		l_otherEnd
	JMP		l_otherStart

	l_otherEnd:
	PUSH	eax				
	PUSH	OFFSET fmt		; push the string format
	CALL	printf			; print number of digits
	ADD		esp, 4			; clear the stack
	PUSH	OFFSET other
	CALL	printf			; print "digits"
	ADD		esp, 4			; clear the stack


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
scanStringForChars ENDP




stringLength PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		esi, [ebp + 8]
	MOV		eax, 0

	l_start:
	MOV		bl, BYTE PTR[esi]
	CMP		bl, 0
	JZ		l_end
	INC		eax
	INC		esi
	JMP		l_start

	l_end:


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
stringLength ENDP





stringReverse PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	PUSH	[ebp + 8]
	CALL	stringLength
	ADD		esp, 4


	MOV		esi, [ebp + 8]
	MOV		edi, [ebp + 12]

	

l_start:
	CMP		eax, 0				; at end of first string?
	JZ		l_end
	MOV		bl, BYTE PTR[esi+eax-1]
	MOV		BYTE PTR[edi], bl	; copy into second string
	INC		edi					; move to next char in reversed string
	DEC		eax
	JMP		l_start
	
	
l_end:
	MOV		BYTE PTR[edi], 0	

	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
stringReverse ENDP

END stringReverse