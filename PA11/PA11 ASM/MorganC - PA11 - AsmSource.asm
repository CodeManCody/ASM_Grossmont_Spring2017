; CSIS 165 - Assembly Language / Machine Architecture
; Student:      Cody Morgan
; Instructor:   Bochsler
; Assignment #: PA#11
; Due Date:     4/20/17
;
; Description:
; Implement functions that combine pure Assembler Library and C/C++

.386P           ; use 80386 instruction set
.MODEL flat,C     ; use flat memory model

printf PROTO C, :VARARG

.DATA           ; declare initialzed data here
fmta			db	"[#%d, ", 0
fmtb		db	"%d] ", 0


.STACK          ; use default 1k stack space

.CODE           ; contains our code


sieveInit PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		esi, [ebp + 8]		; pass in primeVec pointer as arg1
	MOV		ebx, [ebp + 12]		; pass in LIMIT == 102 as arg2
	MOV		edi, 2				; set index of array (i = 2)

L1:
	CMP		edi, ebx			; is (i < LIMIT) ??
	JGE		l_End				; if not, exit loop

L2:
	MOV		BYTE PTR[esi + edi], 1		; set element to 1
	INC		edi							; INC index
	JMP		L1							; loop

l_End:


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
sieveInit ENDP


sieveRun PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		esi, [ebp + 8]		; pass in primeVec pointer as arg1
	MOV		ebx, [ebp + 12]		; pass in LIMIT == 102 as arg2
	MOV		edi, 2				; set index of array (i = 2)

L1:
	CMP		edi, ebx			; is (i < LIMIT) ??
	JGE		l_End				; if not, exit loop

L2:
	MOV		dl, BYTE PTR[esi + edi]			; move primeVec[i] into dl
	CMP		dl, 1							; is primeVec[i] == 1 ??
	JNE		L4								; if not, jump to increment
	MOV		eax, edi						; set j = i

L3:
	PUSH	eax								; save j on stack
	MUL		edi								; (j * i) /// product in eax
	CMP		eax, ebx						; is product < LIMIT ??
	JGE		L4								; if not, jump to increment
	MOV		BYTE PTR[esi + eax], 0			; set primeVec[j * i] == 0, which are the elements where a prime is printed
	POP		eax								; restore j
	INC		eax								; j++ inner loop
	JMP		L3								; loop the inner loop
	INC		edi								; i++
	JMP		L1								; loop outer loop

L4:
	INC		edi								; for false condition
	JMP		L1								; loop outer loop

l_End:


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
sieveRun ENDP


sievePrint PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		esi, [ebp + 8]		; pass in primeVec pointer as arg1
	MOV		ebx, [ebp + 12]		; pass in LIMIT == 102 as arg2
	MOV		edi, 2				; set index of array (i = 2)
	MOV		ecx, 0				; set primeCount

L1:
	CMP		edi, ebx			; is (i < LIMIT) ??
	JGE		l_End				; if not, exit loop

L2:
	MOV		al, BYTE PTR[esi + edi]			; move primeVec[i] into al
	CMP		al, 1							; is primeVec[i] == 1 ??
	JNE		L3								; if not, jump to increment
	INC		ecx								; primeCount++
	PUSH	ecx								; save primeCount on stack
	PUSH	ecx
	PUSH	OFFSET fmta
	CALL	printf							; print primeCount
	ADD		esp, (2 * 4)					; fix stack
	POP		ecx								; restore ecx
	PUSH	ecx
	PUSH	edi								; save prime number, i, on stack
	PUSH	OFFSET fmtb
	CALL	printf							; print prime number		
	ADD		esp, (2 * 4)					; fix stack
	POP		ecx								; restore ecx


L3:
	INC		edi								; for false condition
	JMP		L1								; loop

l_End:

	

	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
sievePrint ENDP


END sievePrint
