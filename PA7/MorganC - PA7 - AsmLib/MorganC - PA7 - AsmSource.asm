; CSIS 165 - Assembly Language / Machine Architecture
; Student:      Cody Morgan
; Instructor:   Bochsler
; Assignment #: PA7
; Due Date:     23 March 2017
;
; Description:
; Implement functions that combine pure Assembler Library and C/C++

.386P           ; use 80386 instruction set
.MODEL flat,C     ; use flat memory model

printf PROTO C, :VARARG

.DATA           ; declare initialzed data here
fmt			db	"%d", 10, 0
lessThan	db "less than", 0
equalTo		db "equal to", 0
greaterThan	db "greater than", 0

.STACK          ; use default 1k stack space

.CODE           ; contains our code

; 
;
_LargestOfTwo PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	MOV		eax, [ebp + 8]		; get arg0
	CMP		eax, [ebp + 12]		; compare values
	JGE		L1					; if eax >= arg1, jump to L1
	MOV		eax, [ebp + 12]		; else move arg1 to eax
	
	L1: 
	

	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
_LargestOfTwo ENDP


_LargestOfFour PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local0 variable
	PUSH	edi
	PUSH	esi
	; end prologue

	PUSH	[ebp + 8]		; get arg0
	PUSH	[ebp + 12]		; get arg1
	CALL	_LargestOfTwo
	ADD		esp, (2 * 4)	; fix stack on return
	PUSH	eax

	PUSH	[ebp + 16]		; get arg2
	PUSH	[ebp + 20]		; get arg3
	CALL	_LargestOfTwo
	ADD	esp, (2 * 4)	; fix stack

	; find the largest of two remaining args
	PUSH	eax
	CALL	_LargestOfTwo
	ADD	esp, (2 * 4)	; fix stack
	

	PUSH	eax				; push for return
	PUSH	eax				; push to print
	PUSH	OFFSET fmt		; push the string format
	CALL	printf
	ADD		esp, (2 * 4)	; clear the stack

	; start epilogue
	POP eax					; pop and restore for return
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
_LargestOfFour ENDP


_isSumLess PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	MOV eax, [ebp + 8]		; move arg0 to eax
	ADD eax, [ebp + 12]		; add arg0 with arg1
	CMP eax, [ebp + 16]		; compare (arg0 + arg1) with arg2
	JG L1					; jump to L1 if sum > arg2
	JL L2					; jump to L2 if sum < arg2
	JE L3					; jump to L3 if sum == arg2

	L1:
	PUSH	OFFSET greaterThan
	CALL	printf			; print "greater than" to include in sentence of output
	ADD		esp, 4			; fix stack
	MOV		eax, 1			; move return value to eax
	JMP		L4				; done

	L2:
	PUSH	OFFSET lessThan
	CALL	printf			; print "less than" to include in sentence of output
	ADD		esp, 4			; fix stack
	MOV		eax, -1			; move return value to eax
	JMP		L4				; done

	L3:
	PUSH	OFFSET equalTo
	CALL	printf			; print "equal to" to include in sentence of output
	ADD		esp, 4			; fix stack
	MOV		eax, 0			; move return value to eax

	L4:						; done


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
_isSumLess ENDP


_complexCompare PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local0 variable
	PUSH	edi
	PUSH	esi
	; end prologue

	MOV		eax, [ebp + 8]			; move arg0 to eax
	CMP		eax, [ebp + 12]			; compare arg0 to arg1
	JG		L1						; if arg0 > arg1 jump to L1
	JMP		L2						; else jump to L2

	L1:
	MOV		eax, [ebp + 12]			; move arg1 to eax
	CMP		eax, [ebp + 16]			; compare arg1 to arg2
	JG		true					; if arg1 > arg2 jump to true
	JMP		L2						; else jump to L2

	L2:
	MOV		eax, [ebp + 20]			; move arg3 to eax
	CMP		eax, [ebp + 8]			; compare arg3 to arg0
	JG		true					; if arg3 > arg0 jump to true
	JMP		false					; else jump to false

	true:
	MOV		eax, [ebp + 12]			; move arg1 to eax
	ADD		eax, [ebp + 16]			; add arg2 to arg1
	JMP		final					; jump to final

	false:
	MOV		eax, [ebp + 8]			; move arg0 to eax
	ADD		eax, [ebp + 20]			; add arg3 to arg0

	final:							; done
	

	PUSH	eax				; push the return value
	PUSH	OFFSET fmt		; push the string format
	CALL	printf
	ADD		esp, (2 * 4)	; clear the stack

	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
_complexCompare ENDP

END _complexCompare