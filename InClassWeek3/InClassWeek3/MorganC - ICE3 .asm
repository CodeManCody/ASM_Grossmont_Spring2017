; Win32 Console I/O Template
; uses Win32 system calls from kernel32.dll

; CSIS 165 – Assembly Language / Machine Architecture 
; Student:	Cody Morgan
; Instructor:	Bochsler
; Assignment #: In Class Exercise Week #3
; Due Date:	2/17/17	
;
; Description:
; This program ....

; following are options if you want {}.list file
;TITLE enterYourTitleHere
;PAGE 60,132 	; #lines, width

.386P		; use 80386 instruction set
.MODEL flat	; use flat memory model

; declare external functions that we are using
extern _ExitProcess@4:near
extern _GetStdHandle@4:near
extern _ReadConsoleA@20:near
extern _WriteConsoleA@20:near

.DATA		; declare initialzed data here
obuf		db "Hello, world!", 10
obuf2		db "Enter first string", 10
obuf3		db "Enter second string", 10
obuf4		db "Enter third string", 10
endl		db " ", 10


.DATA?		; declare uninitialzed data here
ohandle	dword ?
ihandle	dword ?
bout	dword ?
bin		dword ?
ibuf	db 80 DUP (?)
ibufsize = ($ - ibuf)
ibuf2	db 80 DUP (?)
ibuf2size = ($ - ibuf2)
ibuf3	db 80 DUP (?)
ibuf3size = ($ - ibuf3)
ibuf4	db 80 DUP (?)
ibuf4size = ($ - ibuf4)

STD_INPUT_HANDLE	EQU	-10
STD_OUTPUT_HANDLE	EQU	-11

.STACK 		; use default 1k stack space

.CODE		; contains our code
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

	; ReadConsole(ihandle, ibuf, sizeof(ibuf), &bytesread, 0);
	push	0
	push	OFFSET bin		; bytes read
	push	SIZEOF ibuf		; ibuf length in bytes
	push	OFFSET ibuf		; input buffer
	push	ihandle
	call	_ReadConsoleA@20






	; WriteConsole(ohandle, obuf2, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF obuf2		; obuf length in bytes
	push	OFFSET obuf2		; output buffer
	push	ohandle
	call	_WriteConsoleA@20

	; ReadConsole(ihandle, ibuf2, sizeof(ibuf2), &bytesread, 0);
	push	0
	push	OFFSET bin		; bytes read
	push	SIZEOF ibuf2		; ibuf length in bytes
	push	OFFSET ibuf2		; input buffer
	push	ihandle
	call	_ReadConsoleA@20

	MOV		al, ibuf2
	AND		al, 0DFh
	MOV		ibuf2, al

	; WriteConsole(ohandle, ibuf2, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF ibuf2		; obuf length in bytes
	push	OFFSET ibuf2		; output buffer
	push	ohandle
	call	_WriteConsoleA@20

	; WriteConsole(ohandle, endl, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF endl		; obuf length in bytes
	push	OFFSET endl		; output buffer
	push	ohandle
	call	_WriteConsoleA@20





	; WriteConsole(ohandle, obuf3, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF obuf3		; obuf length in bytes
	push	OFFSET obuf3		; output buffer
	push	ohandle
	call	_WriteConsoleA@20

	; ReadConsole(ihandle, ibuf3, sizeof(ibuf3), &bytesread, 0);
	push	0
	push	OFFSET bin		; bytes read
	push	SIZEOF ibuf3		; ibuf length in bytes
	push	OFFSET ibuf3		; input buffer
	push	ihandle
	call	_ReadConsoleA@20

	MOV		al, ibuf3
	OR		al, 20h
	MOV		ibuf3, al

	; WriteConsole(ohandle, ibuf3, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF ibuf3		; obuf length in bytes
	push	OFFSET ibuf3		; output buffer
	push	ohandle
	call	_WriteConsoleA@20

	; WriteConsole(ohandle, endl, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF endl		; obuf length in bytes
	push	OFFSET endl		; output buffer
	push	ohandle
	call	_WriteConsoleA@20








	; WriteConsole(ohandle, obuf4, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF obuf4		; obuf length in bytes
	push	OFFSET obuf4		; output buffer
	push	ohandle
	call	_WriteConsoleA@20

	; ReadConsole(ihandle, ibuf4, sizeof(ibuf4), &bytesread, 0);
	push	0
	push	OFFSET bin		; bytes read
	push	SIZEOF ibuf4		; ibuf length in bytes
	push	OFFSET ibuf4		; input buffer
	push	ihandle
	call	_ReadConsoleA@20

	MOV		al, ibuf4
	XOR		al, 020h
	MOV		ibuf4, al

	; WriteConsole(ohandle, ibuf4, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF ibuf4		; obuf length in bytes
	push	OFFSET ibuf4		; output buffer
	push	ohandle
	call	_WriteConsoleA@20

	; WriteConsole(ohandle, endl, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF endl		; obuf length in bytes
	push	OFFSET endl		; output buffer
	push	ohandle
	call	_WriteConsoleA@20



	; ExitProcess(0);
	; normal end with error code 0 == no error
	push	0
	call	_ExitProcess@4

_main ENDP	;end the "main" procedure
END _main 	;end the entire program around the "main" procedure