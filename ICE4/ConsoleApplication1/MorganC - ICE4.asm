; Win32 Console I/O Template
; uses Win32 system calls from kernel32.dll

; CSIS 165 – Assembly Language / Machine Architecture 
; Student:	Cody Morgan
; Instructor:	Bochsler
; Assignment #: ICE4
; Due Date:	2/24/17


.386P		; use 80386 instruction set
.MODEL flat	; use flat memory model

; declare external functions that we are using
extern _ExitProcess@4:near
extern _GetStdHandle@4:near
extern _ReadConsoleA@20:near
extern _WriteConsoleA@20:near

.DATA		; declare initialzed data here
obuf		db "Enter string1: "
obuf2		db "Enter string2: "

.DATA?		; declare uninitialzed data here
ohandle	dword ?
ihandle	dword ?
bout	dword ?
bin		dword ?
ibuf	db 80 DUP (?)
ibufsize = ($ - ibuf)

STD_INPUT_HANDLE	EQU	-10
STD_OUTPUT_HANDLE	EQU	-11

; MACRO to read input string
mac1 MACRO ihandle, bin, ibuf
	; ReadConsole(ihandle, ibuf, sizeof(ibuf), &bytesread, 0);
	push	0
	push	OFFSET bin		; bytes read
	push	SIZEOF ibuf		; ibuf length in bytes
	push	OFFSET ibuf		; input buffer
	push	ihandle
	call	_ReadConsoleA@20
ENDM


.STACK 		; use default 1k stack space

.CODE		; contains our code

; Function to display output
func1 PROC
	; WriteConsole(whandle, obuf, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout			; bytes written
	push	ebx					; write out only the bytes read in
	push	OFFSET ibuf			; output buffer
	push	eax
	call	_WriteConsoleA@20

	ret
func1 ENDP


;'main' is the entry point, as defined in MSVS 
; Properties->Linker->Advanced->Entrypoint 
_main PROC PUBLIC
	; ohandle = GetStdHandle(STD_OUTPUT_HANDLE);
	push	STD_OUTPUT_HANDLE
	call	_GetStdHandle@4
	mov	ohandle, eax

	; WriteConsole(ohandle, obuf, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF obuf		; obuf length in bytes
	push	OFFSET obuf		; output buffer
	push	ohandle
	call	_WriteConsoleA@20
	
	; ihandle = GetStdHandle(STD_INPUT_HANDLE);
	push	STD_INPUT_HANDLE
	call	_GetStdHandle@4
	mov	ihandle, eax

	; call MACRO to read input
	mac1 ihandle, bin, ibuf

	; increment first character of input string
	mov	al, ibuf
	inc al
	mov	ibuf, al

	mov eax, ohandle
	mov ebx, bin

	; call function to display output
	call func1

	; WriteConsole(ohandle, obuf2, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF obuf2		; obuf length in bytes
	push	OFFSET obuf2		; output buffer
	push	ohandle
	call	_WriteConsoleA@20

	; call MACRO to read input
	mac1 ihandle, bin, ibuf

	; decrement first character of input string
	mov	al, ibuf
	dec al
	mov	ibuf, al

	mov eax, ohandle
	mov ebx, bin

	; call function to display output
	call func1


	; ExitProcess(0);
	; normal end with error code 0 == no error
	push	0
	call	_ExitProcess@4

_main ENDP	;end the "main" procedure
END _main 	;end the entire program around the "main" procedure