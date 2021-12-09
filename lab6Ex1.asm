.486
.model flat, stdcall
option casemap :none
include windows.inc
include kernel32.inc
include masm32.inc
include user32.inc
includelib kernel32.lib
includelib masm32.lib
includelib user32.lib

.data
	template db "sqrt(|cos(%s) + sin(%s)|) = %s", 0
	inputMessage db "input floating point number > ", 0

.data?
	inputHandle dd ?
	outputHandle dd ?
	numberOfChars dd ?
	inputBuffer db ?
	numberX db 1000 dup (?)
	numberY db 1000 dup (?)
	answer db 100 dup (?)
	x dq ?
	y dq ?

.code

entryPoint:
	push STD_INPUT_HANDLE
	call GetStdHandle
	mov inputHandle, EAX
	push STD_OUTPUT_HANDLE
	call GetStdHandle
	mov outputHandle, EAX

	push offset inputMessage
	call lstrlen
	push NULL
	push offset numberOfChars
	push EAX
	push offset inputMessage
	push outputHandle
	call WriteConsole

	push NULL
	push offset numberOfChars
	push 1000
	push offset numberX
	push inputHandle
	call ReadConsole
	mov EDX, offset numberX
	mov EAX, numberOfChars
	mov byte ptr [ EDX + EAX - 2 ], 0
	
	; Input to float
	push offset x
	push offset numberX
	call StrToFloat

	; ?????????? ????????? ? ??????? ????????????
	finit
	fld x
	fcos
	fld x
	fsin
	fadd ST (0), ST (1)
	fabs
	fsqrt
	fstp y

	; ?????????????? ?????-?????????? ? ??????
	push offset numberY
	push dword ptr y + 4
	push dword ptr y
	call FloatToStr

	; ???????????? ??????-?????????? ??? ??????
	push offset numberY
	push offset numberX
	push offset numberX
	push offset template
	push offset answer
	call wsprintf
	add ESP, 20

	; ????? ??????-??????????
	push offset answer
	call lstrlen
	push NULL
	push offset numberOfChars
	push EAX
	push offset answer
	push outputHandle
	call WriteConsole

	; ???????? ???????? ????
	push NULL
	push offset numberOfChars
	push 1
	push offset inputBuffer
	push inputHandle
	call ReadConsole

	; ????? ?? ?????????
	push 0
	call ExitProcess
END entryPoint