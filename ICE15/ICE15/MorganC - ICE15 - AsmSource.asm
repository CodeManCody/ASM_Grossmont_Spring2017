; CSIS 165 - Assembly Language / Machine Architecture
; Student:      ICE15-solution
; Instructor:   Bochsler
; Assignment #: ICE#15
; Due Date:     12 May 2017
;
; Description:
; Implement functions that combine pure Assembler Library and C/C++

.386P           ; use 80386 instruction set
.MODEL flat     ; use flat memory model

; declare external functions that we are using
extern _ExitProcess@4:near
extern _GetStdHandle@4:near
extern _ReadConsoleA@20:near
extern _WriteConsoleA@20:near

STD_INPUT_HANDLE	EQU	-10
STD_OUTPUT_HANDLE	EQU	-11

doPrologue MACRO nvars	
	PUSH	ebp				; save caller base pointer
	MOV		ebp, esp		; set our base pointer
	SUB		esp, (4 * nvars); create local var
	PUSH	edi
	PUSH	esi				; end prologue
ENDM

doEpilogue MACRO
	POP		esi			; start epilogue
	POP		edi
	MOV		esp, ebp	; deallocate locals
	POP		ebp			; restore caller base pointer
ENDM

; MACRO to write a string to the console
; cwhandle - write handle
; outString - byte string to be displayed
; outLen - length of output string to be displayed
; bytesOut - return number of bytes written
writeConsoleString MACRO cwhandle, outString, outLen, bytesOut
	; WriteConsole(whandle, obuf, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bytesOut		; bytes written
	push	outLen				; bytes to write
	push	OFFSET outString	; output buffer
	push	cwhandle
	call	_WriteConsoleA@20
ENDM

writeAConsoleString MACRO cwhandle, outString, outLen, bytesOut
	; WriteConsole(whandle, obuf, obufLen, &byteswritten, 0);
	push	0
	push	OFFSET bytesOut		; bytes written
	push	outLen				; bytes to write
	push	outString			; output buffer
	push	cwhandle
	call	_WriteConsoleA@20
ENDM

; MACRO to write a newline to the console
; cwhandle - write handle
; bytesOut - return number of bytes written
writeConsoleNL MACRO cwhandle, bytesOut
	writeConsoleString cwhandle, WCnewline, SIZEOF WCnewline, bytesOut
ENDM

; MACRO to write a space to the console
; cwhandle - write handle
; bytesOut - return number of bytes written
writeConsoleSP MACRO cwhandle, bytesOut
	writeConsoleString cwhandle, WCspace, SIZEOF WCspace, bytesOut
ENDM

; MACRO to read a string from the console
; crhandle - read handle
; inString - byte string to be read
; inLen - length of output string to be read
; bytesIn - return number of bytes read
readConsoleString MACRO crhandle, inString, inLen, bytesIn
	push	0
	push	OFFSET bytesIn		; bytes read
	push	inLen				; ibuf length in bytes
	push	OFFSET inString		; input buffer
	push	crhandle			; read  handle
	call	_ReadConsoleA@20
ENDM

Auto STRUCT
	Make		DB 'Maker   '
	Model		DB 'Car Name'
	Style		DB 'SUV     '
	ALIGN		DWORD
	Mileage		DWORD	0
Auto ENDS

.DATA?          ; declare initialzed data here
whandle		dword ?		; write handle
rhandle		dword ?		; read handle
bout		dword ?
bin			dword ?
ibuf1		db 20 DUP (?)

.DATA
PROMPT0		EQU	<"CSIS-165 ICE#15 Morgan", 10>
PROMPT1		EQU	<"Please enter an owner Robin/Taylor: ">
ASEDAN		EQU	<"Sedan">
ACOUPE		EQU	<"Coupe">

obuf0		DB	PROMPT0
obuf1		DB	PROMPT1
WCnewline	DB	10
WCspace		DB	' '

FamCars	Auto < 'Honda', 'CR-V', , 32 >,			
			< 'Ford', 'Escape', , 34 >				
	
.STACK          ; use default 1k stack space

.CODE           ; contains our code

; 
; return the length of the string passed in
; 
stringLength PROC PUBLIC
	doPrologue	0

	MOV		esi, [ebp + 8]	; get arg0
	XOR		eax, eax		; clear counter
L1:	MOV		bl, BYTE PTR [esi + eax]
	INC		eax				; increment the count
	CMP		bl, 0h			; end of string
	JNZ		L1

	DEC		eax			; fix counter overshot
	doEpilogue
	RET
stringLength ENDP

; 
; reverse a string in place
; 
stringReverse PROC PUBLIC
	doPrologue	0

	MOV		esi, [ebp + 8]
	XOR		ecx, ecx
	XOR		eax, eax
	; push chars until done, keeping count
L1:	MOV		al, BYTE PTR[esi + ecx]
	CMP		al, 0
	JZ		L2
	INC		ecx
	PUSH	eax
	JNE		L1
	; pop them back starting from the front
L2:	CMP		ecx, 0
	JZ		L3
	POP		eax
	MOV		BYTE PTR[esi], al
	INC		esi
	LOOP	L2

L3:	MOV		BYTE PTR[esi], 0	; null terminate
	doEpilogue
	RET
stringReverse ENDP

;
; convert an integer to an ascii string
;
itoa PROC
	doPrologue	0
	MOV		ebx, 10
	MOV		eax, [ebp + 12]
	MOV		edi, [ebp + 8]
	PUSH	edi					; for stringReverse
L1:	XOR		edx, edx
	DIV		ebx
	ADD		edx, '0'
	MOV		BYTE PTR[edi], dl
	INC		edi
	CMP		eax, 0
	JNZ		L1

	MOV		BYTE PTR[edi], 0	; null terminate
	CALL	stringReverse
	ADD		esp, (1 + 4)
	doEpilogue
	RET
itoa ENDP

;
; Function to display a Auto structure
;	Displays the Make, Model and Mileage of the structure referenced
;
;   @param [in]	Auto structure pointer.
;
;	void displayCarInfo(Auto *ap);
;
displayCarInfo PROC
	doPrologue 0
	

	MOV		esi, [ebp + 8]					; move *Auto STRUCT into esi
	
	writeAConsoleString whandle, esi, SIZEOF Auto.Make, bout		; output Make
	ADD		esi, OFFSET Auto.Model									; increment esi to Model
	writeAConsoleString whandle, esi, SIZEOF Auto.Model, bout		; output Model

	MOV		esi, [ebp + 8]							; reset esi
	ADD		esi, OFFSET Auto.Mileage				; move esi to Mileage index

	PUSH	[esi]									; PUSH mileage value to convert from int to string
	PUSH	OFFSET ibuf1							; PUSH buffer to write to
	CALL	itoa									; convert int to string
	ADD		esp, (2 * 4)							; reset stack pointer
	writeConsoleString whandle, ibuf1, SIZEOF ibuf1, bout			; output mileage

	
	doEpilogue
	RET
displayCarInfo ENDP

;'main' is the entry point, as defined in MSVS
; Properties->Linker->Advanced->Entrypoint
_main PROC 
	; generate handles for I/O
	; whandle = GetStdHandle(STD_OUTPUT_HANDLE);
	push	STD_OUTPUT_HANDLE
	call	_GetStdHandle@4
	mov	whandle, eax

	; rhandle = GetStdHandle(STD_INPUT_HANDLE);
	push	STD_INPUT_HANDLE
	call	_GetStdHandle@4
	mov	rhandle, eax

	; write the header
	writeConsoleString whandle, obuf0, SIZEOF obuf0, bout

	; loop until user quits, collecting info for queries
	; process the query by searching the selected array and displaying the
	; query results
L0:	writeConsoleNL whandle, bout
	; write the Domestic/Import prompt
	writeConsoleString whandle, obuf1, SIZEOF obuf1, bout
	; read char in
	readConsoleString rhandle, ibuf1, SIZEOF ibuf1, bin

	; did the user request to quit?  Or save the users dbase choice
	MOV		al, ibuf1[0]		; get the first char
	OR		al, 020h			; force lower case
	CMP		al, 'r'				; Robin?
	JNE		L1					; no
	MOV		ebx, OFFSET FamCars	; load pointer to the first record
	JMP		L2

L1:	CMP		al, 't'				; save the import array data
	JNE		L3					; anything else is quit
	MOV		ebx, OFFSET FamCars	; load pointer to the first record
	ADD		ebx, SIZEOF Auto	; and index to the second

L2:	PUSH	ebx					; pointer to struct to be displayed
	CALL displayCarInfo
	ADD		esp, (1 * 4)

	JMP		L0					; and loop

L3:	push	0
	call	_ExitProcess@4	; normal termination with error code 0 == no error
_main ENDP
END _main