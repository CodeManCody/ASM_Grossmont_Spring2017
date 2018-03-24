; Win32 Console I/O Template
; uses Win32 system calls from kernel32.dll

; CSIS 165 – Assembly Language / Machine Architecture 
; Student:	Cody Morgan
; Instructor:	Bochsler
; Assignment #: PA#3
; Due Date:	2/23/17

.386P		; use 80386 instruction set
.MODEL flat	; use flat memory model

; declare external functions that we are using
extern _ExitProcess@4:near
extern _GetStdHandle@4:near
extern _ReadConsoleA@20:near
extern _WriteConsoleA@20:near

.DATA		; declare initialzed data here
obuf		db "Toto, I've a feeling we're not in ""Kansas"" anymore.", 10
prompt		db "Enter a name: "
obuf2		db ", I've a feeling we're not in ""Kansas"" anymore.", 10
endl		db " ", 10

january = 1
february = 2
march = 3
april = 4
may = 5
june = 6
july = 7
august = 8
september = 9
october = 10
november = 11
december = 12

monthsArr BYTE january, february, march, april
		  BYTE may, june, july, august
		  BYTE september, october, november, december

.DATA?		; declare uninitialzed data here
ohandle	dword ?
ihandle	dword ?
bout	dword ?
bin		dword ?
ibuf	db 80 DUP (?)
ibufsize = ($ - ibuf)

b BYTE ?
s SBYTE ?
w WORD ?
sw SWORD ?
d DWORD ?
sd SDWORD ?
f FWORD ?
q QWORD ?
t TBYTE ?
r4 REAL4 ?
r8 REAL8 ?
r10 REAL10 ?

STD_INPUT_HANDLE	EQU	-10
STD_OUTPUT_HANDLE	EQU	-11

.STACK 		; use default 1k stack space


.CODE		; contains our code
;'main' is the entry point, as defined in MSVS 
; Properties->Linker->Advanced->Entrypoint 
main PROC PUBLIC
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

	; WriteConsole(ohandle, obuf, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF endl		; obuf length in bytes
	push	OFFSET endl		; output buffer
	push	ohandle
	call	_WriteConsoleA@20

	; WriteConsole(ohandle, prompt, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	push	SIZEOF prompt		; obuf length in bytes
	push	OFFSET prompt		; output buffer
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

	; WriteConsole(ohandle, obuf, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout		; bytes written
	MOV		eax, bin		; get bytes read in
	SUB		eax, 2			; subtract off the CR/NL
	push	eax				; write out only the bytes read in less CR/NL
	push	OFFSET ibuf		; output buffer
	push	ohandle
	call	_WriteConsoleA@20

	; WriteConsole(ohandle, obuf, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bout			; bytes written
	push	SIZEOF obuf2		; obuf length in bytes
	push	OFFSET obuf2		; output buffer
	push	ohandle
	call	_WriteConsoleA@20


	; ExitProcess(0);
	; normal end with error code 0 == no error
	push	0
	call	_ExitProcess@4

main ENDP	;end the "main" procedure
END main 	;end the entire program around the "main" procedure