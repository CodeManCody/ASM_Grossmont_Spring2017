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


asmMatrixCopy PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	MOV		esi, [ebp + 16]			; *source matrix
	MOV		edi, [ebp + 20]			; *destination matrix
	MOV		bh, [ebp + 8]			; rowsize
	MOV		cl, 1					; row counter
	MOV		edx, 0					; j

L1:
	PUSH	edx						; save j
	CMP		cl, bh					; row counter < rowsize ??
	JG		L2						; if greater, jump to next row
	ADD		edx, [ebp + 20]			; get destination address
	MOV		bl, BYTE PTR[esi]		; move source matrix value in bl
	MOV		BYTE PTR[edx], bl		; copy value into destination matrix
	ADD		cl, 1					; row counter++
	INC		esi						; *source++
	POP		edx						; restore j
	INC		edx						; j++
	JMP		L1						; loop row

L2:
	MOV		cl, 1					; reset row counter
	MOV		edx, 0					; reset j

L3:
	PUSH	edx						; save j
	CMP		cl, bh					; row counter < rowsize ??
	JG		L4						; if greater, jump to next row
	ADD		dl, bh					; j + rowsize
	ADD		edx, [ebp + 20]			; get destination address
	MOV		bl, BYTE PTR[esi]		; move source matrix value in bl
	MOV		BYTE PTR[edx], bl		; copy value into destination matrix
	ADD		cl, 1					; row counter++
	INC		esi						; *source++
	POP		edx						; restore j
	INC		edx						; j++
	JMP		L3						; loop row

L4:
	MOV		cl, 1					; reset row counter
	MOV		edx, 0					; reset j
	MOV		ch, bh					; move rowsize into ch
	SHL		ch, 1					; ch = (rowsize * 2)

L5:
	PUSH	edx						; save j
	CMP		cl, bh					; row counter < rowsize ??
	JG		L6						; if greater, jump to next row
	ADD		dl, ch					; j + (rowsize * 2)
	ADD		edx, [ebp + 20]			; get destination address
	MOV		bl, BYTE PTR[esi]		; move source matrix value in bl
	MOV		BYTE PTR[edx], bl		; copy value into destination matrix
	ADD		cl, 1					; row counter++
	INC		esi						; *source++
	POP		edx						; restore j
	INC		edx						; j++
	JMP		L5						; loop row

L6:
	MOV		cl, 1					; reset row counter
	MOV		edx, 0					; reset j
	MOV		al, bh					; move rowsize into al
	MOV		ah, 3
	MUL		ah

L7:
	PUSH	edx						; save j
	CMP		cl, bh					; row counter < rowsize ??
	JG		L8						; if greater, jump to next row
	ADD		dx, ax					; j + (rowsize * 3)
	ADD		edx, [ebp + 20]			; get destination address
	MOV		bl, BYTE PTR[esi]		; move source matrix value in bl
	MOV		BYTE PTR[edx], bl		; copy value into destination matrix
	ADD		cl, 1					; row counter++
	INC		esi						; *source++
	POP		edx						; restore j
	INC		edx						; j++
	JMP		L7						; loop row

L8:


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
asmMatrixCopy ENDP


asmMatrixEqual PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	MOV		esi, [ebp + 16]			; *source matrix
	MOV		edi, [ebp + 20]			; *destination matrix
	MOV		bh, [ebp + 8]			; rowsize
	MOV		cl, 1					; row counter
	MOV		edx, 0					; j
	MOV		eax, 0					; assume true

L1:
	PUSH	edx						; save j
	CMP		cl, bh					; row counter < rowsize ??
	JG		L2						; if greater, jump to next row
	MOV		bl, BYTE PTR[esi]		; move source matrix value in bl
	MOV		dl, BYTE PTR[edi]		; move destination value in dl
	CMP		bl, dl					; source == dest. ??
	JNE		l_False					; if not, jump to set false
	INC		cl						; row counter++
	INC		esi						; *source++
	INC		edi						; *dest++
	POP		edx						; restore j
	INC		edx						; j++
	JMP		L1						; loop row

L2:
	MOV		cl, 1					; reset row counter
	MOV		edx, 0					; reset j

L3:
	PUSH	edx						; save j
	CMP		cl, bh					; row counter < rowsize ??
	JG		L4						; if greater, jump to next row
	MOV		bl, BYTE PTR[esi]		; move source matrix value in bl
	MOV		dl, BYTE PTR[edi]		; move destination value in dl
	CMP		bl, dl					; source == dest. ??
	JNE		l_False					; if not, jump to set false
	INC		cl						; row counter++
	INC		esi						; *source++
	INC		edi						; *dest++
	POP		edx						; restore j
	INC		edx						; j++
	JMP		L3						; loop row

L4:
	MOV		cl, 1					; reset row counter
	MOV		edx, 0					; reset j

L5:
	PUSH	edx						; save j
	CMP		cl, bh					; row counter < rowsize ??
	JG		L6						; if greater, jump to next row
	MOV		bl, BYTE PTR[esi]		; move source matrix value in bl
	MOV		dl, BYTE PTR[edi]		; move destination value in dl
	CMP		bl, dl					; source == dest. ??
	JNE		l_False					; if not, jump to set false
	INC		cl						; row counter++
	INC		esi						; *source++
	INC		edi						; *dest++
	POP		edx						; restore j
	INC		edx						; j++
	JMP		L5						; loop row

L6:
	MOV		cl, 1					; reset row counter
	MOV		edx, 0					; reset j

L7:
	PUSH	edx						; save j
	CMP		cl, bh					; row counter < rowsize ??
	JG		L8						; if greater, jump to next row
	MOV		bl, BYTE PTR[esi]		; move source matrix value in bl
	MOV		dl, BYTE PTR[edi]		; move destination value in dl
	CMP		bl, dl					; source == dest. ??
	JNE		l_False					; if not, jump to set false
	INC		cl						; row counter++
	INC		esi						; *source++
	INC		edi						; *dest++
	POP		edx						; restore j
	INC		edx						; j++
	JMP		L7						; loop row

L8:
	JMP		l_End					; all are equal, jump to end

l_False:
	MOV		eax, 1					; unequal chars found, set to false

l_End:


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
asmMatrixEqual ENDP


asmMatrixTranspose PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	MOV		esi, [ebp + 16]		; *source
	MOV		edi, [ebp + 20]		; *dest
	MOV		bh, 0				; comparison incrementer
	MOV		ecx, 1				; index incrementer
	
	MOV		bl, BYTE PTR[esi]			; exchange first char
	MOV		BYTE PTR[edi], bl

L1:
	CMP		bh, 2						; at end of first diagonal set??
	JG		L1_Reset					; if so, jump to reset
	MOV		bl, BYTE PTR[esi + ecx]		; load source char
	MOV		eax, 4
	MUL		ecx							; get proper index, product in eax
	MOV		BYTE PTR[edi + eax], bl		; move into dest
	INC		ecx							; next char
	INC		bh							; for comparison
	JMP		L1							; loop

L1_Reset:
	MOV		bh, 0						; reset comparison counter
	MOV		ecx, 4						; reset index incrementer
	MOV		edx, 1						; for index of dest with MUL

L1_Rev:									; to now exchange first set in reverse
	PUSH	edx							; save for MUL
	CMP		bh, 2						; at end of first row??
	JG		L2_Load						; if so, prep for next row
	MOV		eax, 4						; for proper MUL
	MUL		edx							; for dest index
	MOV		bl, BYTE PTR[esi + eax]	
	POP		edx							; restore edx
	MOV		BYTE PTR[edi + edx], bl		; move into dest
	INC		edx
	INC		bh
	JMP		L1_Rev						; loop

L2_Load:
	INC		ecx							; to continue index of string
	MOV		bl, BYTE PTR[esi + ecx]		; exchange next diagonal char in next row
	MOV		BYTE PTR[edi + ecx], bl
	MOV		bh, 0						; set up indexing for next set
	INC		ecx
	MOV		eax, 1
	MOV		edx, 3

L2:
	CMP		bh, 1						; at end of 2nd diagonal set??
	JG		L2_Reset
	MOV		bl, BYTE PTR[esi + ecx]
	MUL		edx
	ADD		ecx, eax
	MOV		BYTE PTR[edi + ecx], bl		; exchange
	MOV		ecx, 7						; keep proper indexing
	MOV		edx, 3
	MOV		eax, 2
	INC		bh
	JMP		L2							; loop

L2_Reset:
	MOV		ecx, 9					; reset for reverse exchange
	MOV		bh, 0
	MOV		edx, 1

L2_Rev:								; reverse logic for 2nd set
	PUSH	edx							; save 
	PUSH	ecx							; save
	CMP		bh, 1
	JG		L3
	MOV		bl, BYTE PTR[esi + ecx]
	MOV		eax, 3
	MUL		edx
	SUB		ecx, eax
	MOV		BYTE PTR[edi + ecx], bl
	POP		ecx							; restore
	POP		edx							; restore
	ADD		ecx, 4
	INC		edx
	INC		bh
	JMP		L2_Rev						; loop

L3:
	MOV		bl, BYTE PTR[esi + 10]			; I tried to get my registers set to do this in a loop but still had issues
	MOV		BYTE PTR[edi + 10], bl			; with zeroing out my registers so I just hardcoded the indexes here 
	MOV		bl, BYTE PTR[esi + 11]			; since it was the last small set of 4 anyway, 2 of which were direct copy
	MOV		BYTE PTR[edi + 14], bl
	MOV		bl, BYTE PTR[esi + 14]
	MOV		BYTE PTR[edi + 11], bl
	MOV		bl, BYTE PTR[esi + 15]
	MOV		BYTE PTR[edi + 15], bl


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
asmMatrixTranspose ENDP


asmMatrixMin PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		edi, [ebp + 16]			; *source matrix
	MOV		edx, 1					; element incrementer
	MOV		bl, 16					; (rcount * ccount)
	MOV		bh, 1					; comparison incrementer
	MOV		al, BYTE PTR[edi]		; move first source matrix value in al 

L1:
	CMP		bh, bl						; at end of matrix??
	JGE		l_End						; if so, jump to l_End
	MOV		cl, BYTE PTR[edi + edx]		; move next element into cl for comparison
	CMP		al, cl						; al < cl ??
	JG		l_Next						; if al > cl, jump
	INC		edx
	INC		bh
	JMP		L1

l_Next:
	MOV		al, BYTE PTR[edi + edx]		; move lesser element into al for comparison
	INC		edx
	INC		bh
	JMP		L1

l_End:						; min element saved in al for return value


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
asmMatrixMin ENDP


asmMatrixMax PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		edi, [ebp + 16]			; *source matrix
	MOV		edx, 1					; element incrementer
	MOV		bl, 16					; (rcount * ccount)
	MOV		bh, 1					; comparison incrementer
	MOV		al, BYTE PTR[edi]		; move first source matrix value in al 

L1:
	CMP		bh, bl						; at end of matrix??
	JGE		l_End						; if so, jump to l_End
	MOV		cl, BYTE PTR[edi + edx]		; move next element into cl for comparison
	CMP		al, cl						; al > cl ??
	JL		l_Next						; if al < cl, jump
	INC		edx
	INC		bh
	JMP		L1

l_Next:
	MOV		al, BYTE PTR[edi + edx]		; move greater element into al for comparison
	INC		edx
	INC		bh
	JMP		L1

l_End:						; max element saved in al for return value


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
asmMatrixMax ENDP


asmMatrixAdd PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue

	MOV		edi, [ebp + 16]			; *source matrix
	MOV		bh, [ebp + 8]			; rowsize
	MOV		cl, 1					; row counter
	MOV		edx, 0					; j

L1:
	PUSH	edx						; save j
	CMP		cl, bh					; row counter < rowsize ??
	JG		L2						; if greater, jump to next row
	MOV		bl, BYTE PTR[edi]		; move source matrix value in bl
	MOV		dl, [ebp + 20]			; move offset into dl
	ADD		bl, dl					; add offset to element
	MOV		BYTE PTR[edi], bl		; copy value into source matrix
	ADD		cl, 1					; row counter++
	INC		edi						; *source++
	POP		edx						; restore j
	INC		edx						; j++
	JMP		L1						; loop row

L2:
	MOV		cl, 1					; reset row counter
	MOV		edx, 0					; reset j

L3:
	PUSH	edx						; save j
	CMP		cl, bh					; row counter < rowsize ??
	JG		L4						; if greater, jump to next row
	MOV		bl, BYTE PTR[edi]		; move source matrix value in bl
	MOV		dl, [ebp + 20]			; move offset into dl
	ADD		bl, dl					; add offset to element
	MOV		BYTE PTR[edi], bl		; copy value into source matrix
	ADD		cl, 1					; row counter++
	INC		edi						; *source++
	POP		edx						; restore j
	INC		edx						; j++
	JMP		L3						; loop row

L4:
	MOV		cl, 1					; reset row counter
	MOV		edx, 0					; reset j

L5:
	PUSH	edx						; save j
	CMP		cl, bh					; row counter < rowsize ??
	JG		L6						; if greater, jump to next row
	MOV		bl, BYTE PTR[edi]		; move source matrix value in bl
	MOV		dl, [ebp + 20]			; move offset into dl
	ADD		bl, dl					; add offset to element
	MOV		BYTE PTR[edi], bl		; copy value into source matrix
	ADD		cl, 1					; row counter++
	INC		edi						; *source++
	POP		edx						; restore j
	INC		edx						; j++
	JMP		L5						; loop row

L6:
	MOV		cl, 1					; reset row counter
	MOV		edx, 0					; reset j

L7:
	PUSH	edx						; save j
	CMP		cl, bh					; row counter < rowsize ??
	JG		L8						; if greater, jump to next row
	MOV		bl, BYTE PTR[edi]		; move source matrix value in bl
	MOV		dl, [ebp + 20]			; move offset into dl
	ADD		bl, dl					; add offset to element
	MOV		BYTE PTR[edi], bl		; copy value into source matrix
	ADD		cl, 1					; row counter++
	INC		edi						; *source++
	POP		edx						; restore j
	INC		edx						; j++
	JMP		L7						; loop row

L8:


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
asmMatrixAdd ENDP

END asmMatrixAdd