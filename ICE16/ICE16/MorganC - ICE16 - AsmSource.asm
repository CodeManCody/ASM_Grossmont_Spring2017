; CSIS 165 - Assembly Language / Machine Architecture
; Student:      ICE16-solution
; Instructor:   Bochsler
; Assignment #: ICE#16
; Due Date:     19 May 2017
;

; declare external functions that we are using from system libraries
EXTERN	ExitProcess: PROC
EXTERN	MessageBoxA: PROC
EXTERN	GetStdHandle: PROC
EXTERN	ReadConsoleA: PROC
EXTERN	WriteConsoleA: PROC

STD_INPUT_HANDLE	EQU	-10
STD_OUTPUT_HANDLE	EQU	-11

.DATA			; declar initialized data here
wcaption	db	'64-bit hello!', 0
wmessage	db	'Hello Cody!', 0
ibuf		db 20 DUP (0)
PROMPT1		EQU	<"Enter an Integer: ">
obuf1		DB	PROMPT1
PROMPT2		EQU	<"Prompt read was: ">
obuf2		DB	PROMPT2


.DATA?          ; declare uninitialzed data here
whandle		dword ?		; write handle
rhandle		dword ?		; read handle
bout		qword ?
bin			qword ?
_result		QWORD ?
ibuf2		db 20 DUP (?)

.CODE

 addToRef PROC PUBLIC

 MOVSXD		rcx, ecx
 MOVSXD		rdx, edx

 ADD	rcx, rdx
 SUB	r8, rcx
 MOV	rax, r8
 MOV	[r9], rax
 

 RET
addToRef ENDP



;'main' is the entry point, as defined in MSVS
; Properties->Linker->Advanced->Entrypoint
mainCRTStartup PROC 
	SUB	rsp,28h			; shadow space, aligns stack to 16bit boundary

 ; Part 1 - create this project with this file.

 ; Part 2 - implement and call a procedure that is an ASM translation of the
 ; C code for addToRef().
 ; Capture the results in a comment after the procedure call.
 

 ; addToRef(0x0a3274902, 0x012345678, 0x017FBDC2F283, &result)
 
 MOV	rcx, 0a3274902h
 MOV	rdx, 012345678h
 MOV	r8, 017FBDC2F283h
 MOV	r9, OFFSET _result
 CALL	addToRef

 ; result in RAX is: 0000018008675309


; Part 3
; Using WriteConsoleA() and ReadConsoleA(), implement a prompt for an integer
; and then read the value and echo the value read back to the console.  See Screen
; Capture for details.

		; get a write handle
		MOV	rcx, STD_OUTPUT_HANDLE
		CALL	GetStdHandle
		MOV	whandle, eax			; write handle
		; get a read handle
		MOV	rcx, STD_INPUT_HANDLE
		CALL	GetStdHandle
		MOV	rhandle, eax			; read handle


		MOV		r9, OFFSET bout		; bytes written
		MOV		r8, SIZEOF obuf1				; bytes to write
		MOV		rdx, OFFSET obuf1	; output buffer
		MOV		ecx, whandle
		call	WriteConsoleA

		MOV		r9,	OFFSET bin		; bytes read
		MOV		r8,	SIZEOF ibuf2				; ibuf length in bytes
		MOV		rdx, OFFSET ibuf2		; input buffer
		MOV		ecx, rhandle			; read  handle
		call	ReadConsoleA

		MOV		r9, OFFSET bout		; bytes written
		MOV		r8, SIZEOF obuf2				; bytes to write
		MOV		rdx, OFFSET obuf2	; output buffer
		MOV		ecx, whandle
		call	WriteConsoleA

		MOV		r9, OFFSET bout		; bytes written
		MOV		r8, bin				; bytes to write
		MOV		rdx, OFFSET ibuf2	; output buffer
		MOV		ecx, whandle
		call	WriteConsoleA


; Part 4
; MODIFY the following to output a message that includes your name.
; Note that LEA {reg}, {buf} is equivalent to MOV {reg}, OFFSET {buf}
;
; WINUSERAPI int WINAPI MessageBoxA(
;  RCX =>  _In_opt_ HWND hWnd,
;  RDX =>  _In_opt_ LPCSTR lpText,
;  R8  =>  _In_opt_ LPCSTR lpCaption,
;  R9  =>  _In_ UINT uType);
		MOV	rcx, 0			; hWnd = HWND_DESKTOP
		LEA	rdx, wmessage	; LPCSTR lpText
		LEA	r8, wcaption	; LPCSTR lpCaption
		MOV	r9d, 0			; uType = MB_OK
		CALL	MessageBoxA		; call MessageBox API function
		MOV	ecx, eax		; uExitCode = MessageBox(...)

		; and we are done
		CALL	ExitProcess

mainCRTStartup ENDP
END 	