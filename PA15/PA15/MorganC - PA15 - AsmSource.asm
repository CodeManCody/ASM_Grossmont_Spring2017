; CSIS 165 - Assembly Language / Machine Architecture
; Student:      Cody Morgan
; Instructor:   Bochsler
; Assignment #: PA15
; Due Date:     18 May 2017
;
; Description:
; This program implements the solution to PA15

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
	Make		DB 'Maker    '
	Model		DB 'Car Name '
	Style		DB 'SUV     '
	Doors		DB 4
	ALIGN		WORD
	Range		WORD ?
	ALIGN		DWORD
	BasePrice	DWORD ?
Auto ENDS

.DATA?          ; declare initialzed data here
whandle		dword ?		; write handle
rhandle		dword ?		; read handle
bout		dword ?
bin			dword ?

ibuf1		db 20 DUP (?)
ibuf2		db 20 DUP (?)
ibuf3		db 20 DUP (?)
ibuf4		db 20 DUP (?)
ibuf5		db 20 DUP (?)

.DATA
PROMPT0		EQU	<"CSIS-165 PA#15 Morgan", 10>
PROMPT1		EQU	<"Please enter a field Range/Price: ">
PROMPT2		EQU	<"Please enter a comparison Greater/Equal/Less: ">
PROMPT3		EQU	<"Please enter a Limit: ", 0>
PROMPT4		EQU <"Please enter a choice Domestic/Import/Quit: ">
_ERROR		EQU	<"Invalid input, check and retry!">
ASEDAN		EQU	<"Sedan">
ACOUPE		EQU	<"Coupe">

obuf0		DB	PROMPT0
obuf1		DB	PROMPT1
obuf2		DB	PROMPT2
obuf3		DB	PROMPT3
obuf4		DB	PROMPT4
obufERROR		DB	_ERROR
WCnewline	DB	10
WCspace		DB	' '
	

ImportAutos Auto < 'Toyota', 'Camry', ASEDAN, , 370, 25000 >, 
				< "Toyota", 'RAV4', , , 320, 28000 >,
				< 'Toyota', '96', ACOUPE, 2, 330, 27000 >,
				< 'Honda', 'Accord', ASEDAN, , 380, 29000 >,
				< 'Honda', 'CR-V', , , 320, 28000 >,				
				< 'Honda', 'CR-Z', ACOUPE, 2, 340, 21000 >,				
				< 'Kia', 'Optima', ASEDAN, , 390, 27500 >,
				< 'Kia', 'Sportage', , , 290, 23000 >,
				< 'Kia', 'Forte', ACOUPE, 2, 310, 19900 >

DomesticAutos Auto < 'Chevy', 'Impala', ASEDAN, , 340, 27500 >, 
				< "Chevy", 'Equinox', , , 320, 28000 >,
				< 'Chevy', 'Spark', ACOUPE, 2, 330, 13000 >,
				< 'Ford', 'Focus', ASEDAN, , 380, 17000 >,
				< 'Ford', 'Escape', , , 330, 23750 >,				
				< 'Ford', 'Mustang', ACOUPE, 2, 290, 25185 >,				
				< 'Chrysler', '200', ASEDAN, , 340, 22610 >,
				< 'Chrysler', '300', ASEDAN, , 330, 32340 >

.STACK          ; use default 1k stack space

.CODE           ; contains our code

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
; convert an ascii string to integer
;
atoi PROC
	doPrologue	0

	XOR		eax, eax
	XOR		ebx, ebx
	MOV		esi, [ebp + 8]
L1:	MOV		bl, [esi]
	INC		esi
	CMP		bl, 0
	JZ		L2

	SUB		bl, '0'
	IMUL	eax, 10
	ADD		eax, ebx
	JMP		L1
L2:	doEpilogue
	RET
atoi ENDP

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
; convert a console input string into a null terminated string
;
nullTerminate PROC
	doPrologue	0
	MOV		esi, [ebp + 8]
L1:	CMP		BYTE PTR[esi], 0dh
	JE		L2
	INC		esi
	JMP		L1

L2:	MOV		BYTE PTR[esi], 0
	doEpilogue
	RET
nullTerminate ENDP


printContents	PROC						; print vehicle's contents accordingly
	doPrologue 0


	MOV		esi, [ebp + 8]					; move *Auto array into esi

	writeAConsoleString whandle, esi, SIZEOF Auto.Make, bout		; print Make
	ADD		esi, SIZEOF Auto.Model									; INC *Auto to Model
	writeAConsoleString whandle, esi, SIZEOF Auto.Model, bout		; print Model

	CMP		BYTE PTR [ebp + 12], 'R'				; Range selection??
	JNE		l_Price									; if not, jump to Price selection

	MOV		esi, [ebp + 8]					; reload *Auto
	ADD		esi, OFFSET Auto.Range			; INC to Range
	MOVZX	eax, WORD PTR[esi]				; move Range value
	PUSH	eax			
	PUSH	OFFSET	ibuf4
	CALL	itoa							; convert to string
	CALL	stringLength					; need the length to print
	ADD		esp, (2 * 4)
	writeConsoleString whandle, ibuf4, eax, bout	; print the Range

	JMP		l_End

l_Price:
	MOV		esi, [ebp + 8]					; reload *Auto	
	ADD		esi, OFFSET Auto.BasePrice		; INC to Price
	MOV		eax, DWORD PTR [esi]			; move Price value
	PUSH	eax
	PUSH	OFFSET	ibuf5
	CALL	itoa							; convert to string
	CALL	stringLength					; need the length to print
	ADD		esp, (2 * 4)
	writeConsoleString whandle, ibuf5, eax, bout	; print the Price

l_End:
	writeConsoleNL whandle, bout


	doEpilogue
	RET
printContents	ENDP


;
; print all records matching the specified criteria
;
; void printMatchingRecords(Auto ap[]; int32_t apLen; int32_t compVal;
;   char comp; char field)
;
; If comp equals 'E' then perform a 'equals' comparison.
; If comp equals 'G' then perform a 'greater than' comparison.
; If comp equals 'L' then perform a 'less than' comparison.
;
; If field equals 'R' then perform a comparison against the structure Range field.  
; If field equals 'P' then perform a comparison against the structure BasePrice field.
;
; Use the value compVal for each of the comparisons.
;
; Traverse the array of Auto structs pointed to by ap, performing the comparison determined
; by the comp argument between the compVal and the specified field.  If the comparison is
; true, print out the field as follows:
;
; {record number} {Model} {Make} {Range|BasePrice}
;
; print an error message and exit if one of the E/G/L or R/P values is out of bounds.
;
;  @param [in] ap - array of Auto struct
;  @param [in] apLen - length of array pointed to by ap
;  @param [in] compVal - value to perform comparisons against
;  @param [in] comp	- G/E/L selection, type of comparison to perform
;  @param [in] field - R/P selection, indicates which field to compare
;
printMatchingRecords PROC
	doPrologue 0


	; I COULD NOT FIGURE OUT HOW TO PROPERLY PRINT THE RECORD NUMBERS FOR EACH VEHICLE
	; THE REST SHOULD BE PRETTY SPOT ON
	
	
	MOV		esi, [ebp + 8]					; move *Auto STRUCT into esi
	MOV		ecx, [ebp + 12]					; length of array pointed to by ap

	CMP		BYTE PTR [ebp + 24], 'R'		; compare selection with R
	JE		l_CompR							; if equal, continue to Range field
	CMP		BYTE PTR [ebp + 24], 'P'		; compare selection with P
	JE		l_CompP							; if equal, continue to Price field
	JMP		ERROR							; input validation - print error message

l_CompR:
	CMP		BYTE PTR [ebp + 20], 'G'		; compare selection with G
	JE		l_RangeG						; if equal, continue to Range field
	CMP		BYTE PTR [ebp + 20], 'E'		; compare selection with E
	JE		l_RangeG						; if equal, continue to Range field
	CMP		BYTE PTR [ebp + 20], 'L'		; compare selection with L
	JE		l_RangeG						; if equal, continue to Range field
	JMP		ERROR							; input validation - print error message

l_CompP:
	CMP		BYTE PTR [ebp + 20], 'G'		; compare selection with G
	JE		l_PriceG						; if equal, continue to Price field
	CMP		BYTE PTR [ebp + 20], 'E'		; compare selection with E
	JE		l_PriceG						; if equal, continue to Price field
	CMP		BYTE PTR [ebp + 20], 'L'		; compare selection with L
	JE		l_PriceG						; if equal, continue to Price field

l_RangeG:									; Range Greater field - vehicles with range greater than input
	PUSH	ecx								; save array length
	CMP		ecx, 0							; at end of array??
	JE		l_End							; if so, we are done
	CMP		BYTE PTR [ebp + 20], 'G'		; compare selection with G
	JNE		l_RangeL						; if not equal, go to Less field
	MOV		bx, (Auto PTR [esi]).Range		; move Range value into bx
	CMP		bx, WORD PTR [ebp + 16]			; compare to input
	JLE		l_RGInc							; not greater so jump to INC
	PUSH	[ebp + 24]						; push field selection 
	PUSH	esi								; push OFFSET of array
	CALL	printContents					; print out matching vehicle
	ADD		esp, (2 * 4)					; reset stack
l_RGInc:
	POP		ecx								; restore array length
	DEC		ecx								; decrement array length
	ADD		esi, SIZEOF Auto				; move to next element/vehicle in array
	JMP		l_RangeG						; loop

l_RangeL:									; Range Less Than field - vehicles with range less than input
	PUSH	ecx								; save array length
	CMP		ecx, 0							; at end of array??
	JE		l_End							; if so, we are done
	CMP		BYTE PTR [ebp + 20], 'L'		; compare selection with L
	JNE		l_RangeE						; if not equal, go to Equal field
	MOV		bx, (Auto PTR [esi]).Range		; move Range value into bx
	CMP		bx, WORD PTR [ebp + 16]			; compare to input
	JGE		l_RLInc							; not less so jump to INC
	PUSH	[ebp + 24]						; push field selection 
	PUSH	esi								; push OFFSET of array
	CALL	printContents					; print out matching vehicle
	ADD		esp, (2 * 4)					; reset stack
l_RLInc:
	POP		ecx								; restore array length
	DEC		ecx								; decrement array length
	ADD		esi, SIZEOF Auto				; move to next element/vehicle in array
	JMP		l_RangeL						; loop
	
l_RangeE:									; Range Equal field - vehicles with range equal to input
	PUSH	ecx
	CMP		ecx, 0
	JE		l_End
	MOV		bx, (Auto PTR [esi]).Range	
	CMP		bx, WORD PTR [ebp + 16]
	JNE		l_REInc							; if not equal, jump to INC
	PUSH	[ebp + 24]
	PUSH	esi
	CALL	printContents
	ADD		esp, (2 * 4)
l_REInc:
	POP		ecx
	DEC		ecx
	ADD		esi, SIZEOF Auto
	JMP		l_RangeE						; loop

l_PriceG:									; Price Greater Than field - vehicles with price greater than input
	PUSH	ecx
	CMP		ecx, 0
	JE		l_End
	CMP		BYTE PTR [ebp + 20], 'G'
	JNE		l_PriceL						; if not greater, jump to Less than field
	MOV		ebx, (Auto PTR [esi]).BasePrice	
	CMP		ebx, DWORD PTR [ebp + 16]
	JLE		l_PGInc
	PUSH	[ebp + 24]
	PUSH	esi
	CALL	printContents					; print matching vehicle
	ADD		esp, (2 * 4)
l_PGInc:
	POP		ecx
	DEC		ecx
	ADD		esi, SIZEOF Auto
	JMP		l_PriceG						; loop

l_PriceL:									; Price Less Than field - vehicles with price less than input
	PUSH	ecx
	CMP		ecx, 0
	JE		l_End
	CMP		BYTE PTR [ebp + 20], 'L'
	JNE		l_PriceE						; if not less, jump to Equal field
	MOV		ebx, (Auto PTR [esi]).BasePrice	
	CMP		ebx, DWORD PTR [ebp + 16]
	JGE		l_PLInc
	PUSH	[ebp + 24]
	PUSH	esi
	CALL	printContents					; print matching vehicle
	ADD		esp, (2 * 4)
l_PLInc:
	POP		ecx
	DEC		ecx
	ADD		esi, SIZEOF Auto
	JMP		l_PriceL						; loop

l_PriceE:									; Price Equal to field - vehicles with price equal to input
	PUSH	ecx
	CMP		ecx, 0
	JE		l_End							; if at end, jump
	MOV		ebx, (Auto PTR [esi]).BasePrice	
	CMP		ebx, DWORD PTR [ebp + 16]
	JNE		l_PEInc							; if not equal, jump to INC
	PUSH	[ebp + 24]
	PUSH	esi
	CALL	printContents					; print matching vehicle
	ADD		esp, (2 * 4)
l_PEInc:
	POP		ecx
	DEC		ecx
	ADD		esi, SIZEOF Auto
	JMP		l_PriceE						; loop

ERROR:										; Input Validation
	writeConsoleString whandle, obufERROR, SIZEOF obufERROR, bout			; print error message
	writeConsoleNL whandle, bout

l_End:										; we are done


	doEpilogue
	RET
printMatchingRecords ENDP


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
	writeConsoleString whandle, obuf4, SIZEOF obuf4, bout
	; read char in
	readConsoleString rhandle, ibuf1, SIZEOF ibuf1, bin

	; did the user request to quit?  Or save the users dbase choice
	MOV		al, ibuf1[0]		; get the first char
	OR		al, 020h			; force lower case

	CMP		al, 'd'				; save the domestic array data
	JNE		L1
	PUSH	LENGTHOF DomesticAutos
	PUSH	OFFSET DomesticAutos	
	JMP		L2

L1:	CMP		al, 'i'				; save the import array data
	JNE		L3					; anything else is quit
	PUSH	LENGTHOF ImportAutos
	PUSH	OFFSET ImportAutos

	; write the Range/Price prompt
L2:	writeConsoleString whandle, obuf1, SIZEOF obuf1, bout
	; read char in
	readConsoleString rhandle, ibuf1, SIZEOF ibuf1, bin

	; write the Comparison prompt
	writeConsoleString whandle, obuf2, SIZEOF obuf2, bout
	; read char in
	readConsoleString rhandle, ibuf2, SIZEOF ibuf2, bin

	; write the Comparison value prompt
	writeConsoleString whandle, obuf3, SIZEOF obuf3, bout
	; read digits in
	readConsoleString rhandle, ibuf3, SIZEOF ibuf3, bin

	; convert the ascii input string to integer
	PUSH	OFFSET ibuf3	; get the number read
	CALL	nullTerminate	; input has CR/LF on the end
	CALL	atoi			; convert to integer
	ADD		esp, (1 * 4)

	; now make the call to printMatchingRecords() with the collected params
	POP		edx				; array of autos from above
	POP		ecx				; size of array from above

	MOVZX	ebx, ibuf1		; get R/P/Q
	PUSH	ebx
	MOVZX	ebx, ibuf2		; get G/E/L
	PUSH	ebx
	PUSH	eax				; atoi of user input
	PUSH	ecx				; pass in the array size
	PUSH	edx				; pass in the array of Autos
	CALL	printMatchingRecords
	ADD		esp, (5 * 4)
	JMP		L0				; and loop

L3:
	; ExitProcess(0)
	; normal termination with error code 0 == no error
	push	0
	call	_ExitProcess@4
_main ENDP	; end the main procedure
END _main	; end the entire program around the main procedure