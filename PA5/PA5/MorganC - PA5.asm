; Win32 Console I/O Template
; uses Win32 system calls from kernel32.dll

; CSIS 165 - Assembly Language / Machine Architecture
; Student:	Cody Morgan
; Instructor:	Bochsler
; Assignment #: PA5
; Due Date:	3/9/17


.386P		; use 80386 instruction set
.MODEL flat	; use flat memory model

; declare external functions that we are using
extern _ExitProcess@4:near

.DATA	; declare initialzed data here
firstDWord		dword	10
secondDWord		dword	10
thirdDWord		dword	10

.STACK 		; use default 1k stack space


.CODE		; contains our code

_addTwoArgs PROC
	PUSH	ebp				; save caller base pointer
	MOV		ebp, esp		; set our base pointer
	PUSH	edi
	PUSH	esi
	; end preamble

	
	MOV		eax, [ebp + 12]		; move arg0 into eax
	ADD		eax, [ebp + 8]		; add arg0 with arg1


	; start postamble
	POP		esi
	POP		edi
	POP		ebp			; restore caller base pointer
	RET
_addTwoArgs ENDP	; end the procedure


_addFourArgsByTwo PROC
	PUSH	ebp				; save caller base pointer
	MOV		ebp, esp		; set our base pointer
	SUB		esp, (1 * 4)	; allocate 1 x uint32_t local variables
	PUSH	edi
	PUSH	esi
	; end preamble

	
	PUSH	[ebp + 8]
	PUSH	[ebp + 12]
	CALL	_addTwoArgs
	MOV		[ebp - 4], eax
	PUSH	[ebp + 16]
	PUSH	[ebp + 20]
	CALL	_addTwoArgs
	ADD		eax, [ebp - 4]


	; start postamble
	POP		esi
	POP		edi
	MOV		esp, ebp	; deallocate local
	POP		ebp			; restore caller base pointer
	RET
_addFourArgsByTwo ENDP	; end the procedure


_swapTwoArgs PROC
	PUSH	ebp				; save caller base pointer
	MOV		ebp, esp		; set our base pointer
	PUSH	edi
	PUSH	esi
	; end preamble

	
	MOV		eax, [ebp + 12]		; move/load contents of firstDWord into eax
	MOV		edi, [ebp + 8]		; move/load contents of secondDWord into edi
	MOV		[ebp + 8], eax		; move/swap firstDWord into secondDWord
	MOV		[ebp + 12], edi		; move/swap secondDWord into firstDWord
	

	; start postamble
	POP		esi
	POP		edi
	POP		ebp			; restore caller base pointer
	RET
_swapTwoArgs ENDP	; end the procedure


;'_main' is the entry point, as defined in MSVS
; Properties->Linker->Advanced->Entrypoint

_main PROC

	MOV		ebx, 0baddcafeh
	MOV		ecx, -1

	; save regs that callee is using
	PUSH	0deadbeefh		; add sentinal

	; preload regs to validate reg saving is working
	MOV	ebx, firstDWord
	MOV	ecx, secondDWord
	MOV	edx, thirdDWord


	; part1a - call addTwoArgs to add the two arguments

	; push arguments, right to left
	PUSH	3333h			; arg1
	PUSH	4444h			; arg0
	CALL	_addTwoArgs		; _addTwoArgs(4444h, 3333h)
	ADD		esp, 8
	POP		eax		; remove sentinal


	; part1b - call addFourArgsByTwo to add the four arguments,
	; two at a time

	; push arguments, right to left
	PUSH	1111h		; arg3
	PUSH	2222h		; arg2
	PUSH	3333h		; arg1
	PUSH	4444h		; arg0
	CALL	_addFourArgsByTwo	; _addFourArgsByTwo(4444h, 3333h, 2222h, 1111h)
	ADD		esp, 16
	POP		eax		; remove sentinal


	; part 2 - swap the contents of two locations in memory
	
	PUSH	OFFSET firstDWord
	PUSH	OFFSET secondDWord
	CALL	_swapTwoArgs		; _swapTwoArgs(OFFSET secondDWord, OFFSET firstDWord)
	ADD		esp, 8
	POP		eax		; remove sentinal


	; load regs to confirm that the contents were swapped
	; subtraction results should be zero
	SUB	ebx, secondDWord	; note the swap here
	SUB	ecx, firstDWord
	SUB	edx, thirdDWord

	; ExitProcess(0)
	; normal termination with error code 0 == no error
	push	0
	call	_ExitProcess@4

_main ENDP	; end the main procedure
END _main	; end the entire program around the main procedure