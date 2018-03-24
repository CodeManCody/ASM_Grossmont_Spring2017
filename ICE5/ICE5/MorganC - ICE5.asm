; CSIS 165 - Assembly Language / Machine Architecture
; Student:      Cody Morgan
; Instructor:   Bochsler
; Assignment #: ICE5
; Due Date:     2 March 2017
;
; Description:
; This program ....

.386P           ; use 80386 instruction set
.MODEL flat     ; use flat memory model

; declare external functions that we are using
extern _ExitProcess@4:near

.DATA           ; declare initialzed data here

.STACK          ; use default 1k stack space

.CODE           ; contains our code

COMMENT #
	0x0046F974  00000000  ....		ESI
	0x0046F978  00000000  ....		EDI
	0x0046F97C  00009999  ™™..		Local1	
	0x0046F980  00009999  ™™..		Local0
	0x0046F984  0046f9a8  ¨ùF.		EBP
	0x0046F988  00b610a8  ¨.¶.		Return address from call
	0x0046F98C  00004444  DD..		arg3
	0x0046F990  00003333  33..		arg2
	0x0046F994  00001111  ....		arg1
	0x0046F998  00001111  ....		arg0
	0x0046F99C  deadbeef  ï..Þ		sentinal
	#





_addFourArgs PROC
	PUSH	ebp				; save caller base pointer
	MOV		ebp, esp		; set our base pointer
	SUB		esp, (2 * 4)	; allocate 2 x uint32_t local variables
	PUSH	edi
	PUSH	esi
	; end preamble

	
	MOV		eax, [ebp + 20]		
	ADD		eax, [ebp + 16]
	ADD		eax, [ebp + 12]
	ADD		eax, [ebp + 8]
	MOV		[ebp - 4], eax
	MOV		[ebp - 8], eax

	; start postamble
	POP		esi
	POP		edi
	MOV		esp, ebp	; deallocate locals
	POP		ebp			; restore caller base pointer
	RET
_addFourArgs ENDP	; end the procedure

;'main' is the entry point, as defined in MSVS
; Properties->Linker->Advanced->Entrypoint
_main PROC 

	MOV		ebx, 0baddcafeh
	MOV		ecx, -1

	;
	; save regs that callee is using
	PUSH	0deadbeefh		; add sentinal

	; push arguments, right to left
	PUSH	1111h			; arg3
	PUSH	1111h			; arg2
	PUSH	3333h			; arg1
	PUSH	4444h			; arg0
	CALL	_addFourArgs	; addFourArgs(4444h, 3333h, 1111h, 1111h)
	ADD		esp, 16
	
	POP		eax		; remove sentinal
	
	; ExitProcess(0)
	; normal termination with error code 0 == no error
	push	0
	call	_ExitProcess@4

_main ENDP	; end the main procedure
END _main	; end the entire program around the main procedure