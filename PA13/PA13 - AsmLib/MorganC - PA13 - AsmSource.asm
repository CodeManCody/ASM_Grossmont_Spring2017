; CSIS 165 - Assembly Language / Machine Architecture
; Student:      Cody Morgan
; Instructor:   Bochsler
; Assignment #: PA13
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


asmEncrypt PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	;         C++ CODE TO EMULATE
	; -------------------------------------
	; int k = 0;
	; for (int i = 0; i < ilen; i++)
	; {
	; 	int loopCount = 0;
	; 	while (ring[k % ringlen] != in[i])
	; 	{
	; 		loopCount++;
	; 		k++;
	; 	}
	;
	;	out[i] = loopCount;
	;	cout << out[i];
	; }


	MOV		eax, 0				; counter k for inner while loop
	MOV		ebx, 0				; counter i for outer for loop
	MOV		esi, [ebp + 8]		; *ring
	MOV		edi, [ebp + 12]		; *in

l_For:
	CMP		ebx, DWORD PTR [ebp + 20]		; i < ilen ??
	JGE		l_End							; if not, jump out of for loop and to the end
	MOV		dl, 0							; set loopCount = 0  //  loopCount will be the elements of encoded array
	MOV		cl, BYTE PTR[edi + ebx]			; in[i]
	OR      cl, 20h                         ; convert to lower case

l_While:
	PUSH	eax								; save counter k
	PUSH	edx								; save loopCount
	MOV		edx, 0							; reset loopCount = 0
	DIV		DWORD PTR[ebp + 24]				; k % ringlen, remainder in edx
	MOV		ch, BYTE PTR[esi + edx]			; ring[k % ringlen]
	POP		edx								; restore loopCount
	POP		eax								; restore k						
	CMP		cl, ch							; ring[k % ringlen] != in[i] ??					
	JE		l_ForInc						; if equal, jump to increment for loop
	INC		eax								; k++
	INC		dl								; loopCount++
	JMP		l_While							; while loop

l_ForInc:
	PUSH	edi
	MOV		edi, [ebp + 16]
	MOV		[edi + ebx], dl					; move loopCount into output/encrypted array								
	POP		edi

	MOV		edx, 0							; reset loopCount
	INC		ebx								; i++
	JMP		l_For							; for loop

l_End:


	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
asmEncrypt ENDP


asmDecrypt PROC PUBLIC
	PUSH	ebp		; save caller base pointer
	MOV	ebp, esp	; set our base pointer
	SUB	esp, (1 * 4)	; create local var
	PUSH	edi
	PUSH	esi
	; end prologue


	MOV		eax, 0				; counter k for inner while loop
	MOV		ebx, 0				; counter i for outer for loop
	MOV		esi, [ebp + 8]		; *ring
	MOV		edi, [ebp + 12]		; *in

l_For:
	CMP		ebx, DWORD PTR [ebp + 20]		; i < ilen ??
	JGE		l_End							; if not, jump out of for loop and to the end
	MOV		dl, 0							; set loopCount = 0  
	MOV		cl, BYTE PTR[edi + ebx]			; out[i]
	

l_While:
	PUSH	eax								; save counter k
	PUSH	edx								; save loopCount
	MOV		edx, 0							; reset loopCount = 0
	DIV		DWORD PTR[ebp + 24]				; k % ringlen, remainder in edx
	MOV		ch, BYTE PTR[esi + edx]			; ring[k % ringlen]
	POP		edx								; restore loopCount
	POP		eax								; restore k						
	CMP		dl, cl							; loopCount != out[i] ??					
	JE		l_ForInc						; if equal, jump to increment for loop
	INC		eax								; k++
	INC		dl								; loopCount++
	JMP		l_While							; while loop

l_ForInc:
	PUSH	edi
	MOV		edi, [ebp + 16]
	MOV		[edi + ebx], ch					; move ring[i] into output/encrypted array								
	POP		edi

	MOV		edx, 0							; reset loopCount
	INC		ebx								; i++
	JMP		l_For							; for loop

l_End:
	MOV		dl, 0
	MOV		edi, [ebp + 16]
	MOV		[edi + ebx], dl					; null terminate




	; start epilogue
	POP	esi
	POP	edi
	MOV	esp, ebp	; deallocate locals
	POP	ebp		; restore caller base pointer
	RET
asmDecrypt ENDP

END asmDecrypt