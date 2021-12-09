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
	template db "(%s + %s) * (%s - %s) / 4 = %s", 0
	inputMessageX db "input x > ", 0 
	inputMessageY db "input y > ", 0 
	z dd 4

.data?
	inputHandle dd ?
	outputHandle dd ?
	numberOfChars dd ?
	inputBuffer db ?
	numberX db 1000 dup (?)
	numberY db 1000 dup (?)
	resSTR db 1000 dup (?)
	answer db 100 dup (?)
	x dq ?
	y dq ? 
	res dq ?

.code

entryPoint:
	push STD_INPUT_HANDLE
	call GetStdHandle
	mov inputHandle, EAX
	push STD_OUTPUT_HANDLE
	call GetStdHandle
	mov outputHandle, EAX

	push offset inputMessageX
	call lstrlen
	push NULL
	push offset numberOfChars
	push EAX
	push offset inputMessageX
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
	
	
	push offset inputMessageY
	call lstrlen
	push NULL
	push offset numberOfChars
	push EAX
	push offset inputMessageY
	push outputHandle
	call WriteConsole

	push NULL
	push offset numberOfChars
	push 1000
	push offset numberY
	push inputHandle
	call ReadConsole
	mov EDX, offset numberY
	mov EAX, numberOfChars
	mov byte ptr [ EDX + EAX - 2 ], 0
	
	; Input to float
	push offset y
	push offset numberY
	call StrToFloat

	; ?????????? ????????? ? ??????? ????????????
	finit
       	fld x
       	fadd y
	fld x
       	fsub y
       	fmul ST (0), ST (1) 
	fidiv z
	fstp res

	; ?????????????? ?????-?????????? ? ??????
	push offset resSTR
	push dword ptr res + 4
	push dword ptr res
	call FloatToStr

	; ???????????? ??????-?????????? ??? ??????
	push offset resSTR
	push offset numberY
	push offset numberX
	push offset numberY
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