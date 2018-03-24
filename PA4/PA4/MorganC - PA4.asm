; Win32 Console I/O Template
; uses Win32 system calls from kernel32.dll

; CSIS 165 - Assembly Language / Machine Architecture
; Student:	Cody Morgan
; Instructor:	Bochsler
; Assignment #: PA4
; Due Date:	3/2/17


; Problem solutions:
	; 1) funProb1(uint16_t funProb1(uint16_t foo,
	;	uint16_t bar, uint_16_t baz, uint16_t qux) {
	;		return = (~(bar - 1) + foo) + (baz + 2*qux);
	;	}
	;
	; 2) uint16_t funProb2(uint16_t foo, uint16_t bar) {
	;		return = ((foo | bar) & ~(foo & bar)) | ~((~bar & foo) | (~foo & bar));
	;	}
	;
	; 3) uint16_t funProb3(uint16_t foo, uint16_t bar) {
	;		return = (3 * foo - bar) - (foo - bar + 32);
	;	}
	;
	; 4) al = 0x16


.386P		; use 80386 instruction set
.MODEL flat	; use flat memory model

; declare external functions that we are using
extern _ExitProcess@4:near
extern _GetStdHandle@4:near
extern _ReadConsoleA@20:near
extern _WriteConsoleA@20:near

.DATA	; declare initialzed data here
obuf	db "Enter a single digit 0-9:", 10
obuf2	db "Enter another single digit 0-9:", 10
obuf3	db "Result is:", 10
newline	db 10

.DATA?		; declare uninitialzed data here
whandle		dword ?		; write handle
rhandle		dword ?		; read handle
bytesWritten	dword ?
bytesRead		dword ?
ibuf		dword ?
num1		dword ?

STD_INPUT_HANDLE	EQU	-10
STD_OUTPUT_HANDLE	EQU	-11

; MACRO to write a newline to the console
;  uses global 'newline' byte array
; cwhandle - valid write handle
; cbytesWritten - dword storage for actual bytes written
writeNewLine MACRO cwhandle, cbytesWritten
	; WriteConsole(whandle, obuf, obufLen, &bytesWritten, 0);
	push	0
	push	OFFSET cbytesWritten	; bytes written
	push	SIZEOF newline		; write out a newline char
	push	OFFSET newline		; output buffer of newline
	push	cwhandle
	call	_WriteConsoleA@20
ENDM

.STACK 		; use default 1k stack space


.CODE		; contains our code
;'_main' is the entry point, as defined in MSVS
; Properties->Linker->Advanced->Entrypoint
_main PROC PUBLIC
	; whandle = GetStdHandle(STD_OUTPUT_HANDLE);
	push	STD_OUTPUT_HANDLE
	call	_GetStdHandle@4
	mov	whandle, eax

	; WriteConsole(whandle, obuf, obufLen, &bytesWritten, 0);		; prompt user for first ASCII digit
	push	0
	push	OFFSET bytesWritten	
	push	SIZEOF obuf		
	push	OFFSET obuf		
	push	whandle
	call	_WriteConsoleA@20

	; rhandle = GetStdHandle(STD_INPUT_HANDLE);
	push	STD_INPUT_HANDLE
	call	_GetStdHandle@4
	mov	rhandle, eax

	; ReadConsole(rhandle, ibuf, sizeof(ibuf), &bytesRead, 0);		; read in first ASCII digit
	push	0
	push	OFFSET bytesRead	
	push	SIZEOF ibuf		
	push	OFFSET ibuf		
	push	rhandle
	call	_ReadConsoleA@20

	
	MOV		eax, ibuf		
	SUB		eax, 48				; convert ASCII digit to int
	MOV		num1, eax			; store int in num1
	

	writeNewLine whandle, bytesWritten		; call writeNewLine MACRO

	; WriteConsole(whandle, obuf, obufLen, &bytesWritten, 0);		; prompt user for second ASCII digit
	push	0
	push	OFFSET bytesWritten	
	push	SIZEOF obuf2		
	push	OFFSET obuf2		
	push	whandle
	call	_WriteConsoleA@20

	; ReadConsole(rhandle, ibuf, sizeof(ibuf), &bytesRead, 0);		; read in second ASCII digit
	push	0
	push	OFFSET bytesRead	
	push	SIZEOF ibuf		
	push	OFFSET ibuf		
	push	rhandle
	call	_ReadConsoleA@20
	
	
	MOV		ebx, ibuf		
	SUB		ebx, 48				; convert second ASCII digit to int
	ADD		num1, ebx			; sum of first and second int
	MOV		eax, num1
	AND		eax, 7				; logical AND the sum with 0x7 (aka decimal 7)
	ADD		eax, 48				; convert int result back to ASCII character
	MOV		ibuf, eax


	writeNewLine whandle, bytesWritten		; call writeNewLine MACRO

	; WriteConsole(whandle, obuf, obufLen, &bytesWritten, 0);		; output the "result" string
	push	0
	push	OFFSET bytesWritten	
	push	SIZEOF obuf3		
	push	OFFSET obuf3		
	push	whandle
	call	_WriteConsoleA@20

	; WriteConsole(whandle, obuf, obufLen, &bytesWritten, 0);		; output of final ASCII character result
	push	0
	push	OFFSET bytesWritten	
	push	SIZEOF ibuf		
	push	OFFSET ibuf		
	push	whandle
	call	_WriteConsoleA@20

	writeNewLine whandle, bytesWritten		; call writeNewLine MACRO
	writeNewLine whandle, bytesWritten		; call writeNewLine MACRO
	

	; ExitProcess(0);
	; normal end with error code 0 == no error
	push	0
	call	_ExitProcess@4

_main ENDP	;end the "_main" procedure
END _main 	;end the entire program around the "main" procedure