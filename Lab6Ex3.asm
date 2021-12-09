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
	template db "|   %10.5s   |   %10.5s   |", 0
	inputMessageX1 db "input x1 > ", 0 
	inputMessageX2 db "input x2 > ", 0
	inputMessageXD db "input delta x > ", 0  
	inputMessageA db "input a > ", 0  
	inputMessageB db "input b > ", 0  
	dva dd 2
	odin dd 1 
	newStr dd 0ah 
	arr_size dd 0  
	pointer dd 0
.data?
	inputHandle dd ?
	outputHandle dd ?
	numberOfChars dd ?
	inputBuffer db ?   
	
	numberX1 db 1000 dup (?)
	numberX2 db 1000 dup (?)
	numberXD db 1000 dup (?)
	numberA db 1000 dup (?)
	numberB db 1000 dup (?)
        
	X_STR db 1000 dup (?)
	answer db 1000 dup (?)
	x1 dq ?
	x2 dq ?
	xd dq ?
	a dq ?
	b dq ?
	y dq ?
	
	ln1 dq ? 
	ln2 dq ?
	
        res dq ?
        resSTR dq 1000 dup (?)
        arrX dq 1000 dup (?)
	arrY dq 1000 dup (?)
        
        E_STR db 1000 dup (?)
.code

FindY:        
	cycle: 
   finit  
   	mov EBX, arr_size 
   		
	fld x1
	fld x2
	fcomp
       	FSTSW AX 
	SAHF 
	jb endCycle
	  
	
	fldz
      	fcomp x1
      	FSTSW AX 
      	SAHF 
       	jb second
      	
	      			;------------------Вычисления при x <= 0 ---------------------; 
       	fld x1     ;ST(0) = x
       	fmul a     ;ST(0) = x * a
       	fsin       ;ST(0) = sin(x * a)
       	FLDPI      ;ST(0) = PI   |   ST(1) = sin(x * a)
       	fidiv dva  ;ST(0) = PI/2   |   ST(1) = sin(x * a)
       	FADDP ST (1), ST (0) ;ST(0) = PI/2 + sin(x * a)   |   ST(1) - pushed       	 	  
       	fldln2     ;ST(0) = ln2 = (1 / log2(e))   |   ST(1) = PI/2 + sin(x * a)
       	FXCH ST (1) ;ST(0) = PI/2 + sin(x * a)   |  ST(1) = ln2      
        fyl2x      ;ST(1) = ST(1) * log2(ST(0)) = (1 / log2(e)) * log2(PI/2 + sin(x * a)) = log2(PI/2 + sin(x * a)) / log2(e)) = ln(PI/2 + sin(x * a))  | ST(0) - pushed 
        fstp y	  ; ST(1) -> ST(0) -  pushed
     	jmp incr_X 
     				;------------------Вычисления при x > 0 ---------------------; 
     	second:
       	fld x1
       	fmul x1
       	fld b
       	fmulp ST (1), ST (0)   
       	FLDPI 
       	FADDP ST (1), ST (0)        	 	  
       	fldln2     
        FXCH ST (1) 
        fyl2x 
        fstp ln1 
        
        fild dva 
        fld x1  
        fiadd odin 
        fdivp ST (1), ST (0)
        fldln2 
       	FXCH ST (1)       
        fyl2x
        fstp ln2
        
        fld ln1
        fsub ln2   	 
        fstp y 
         
        
	 				;------------ Увеличиваем x ---------------------;
	incr_X:   
       	fld x1
       	fst  qword ptr [ arrX + EBX * 8 ]
       	fadd xd 
 	fstp x1 
 	fld y
 	fstp qword ptr [ arrY + EBX * 8 ] 

   	inc arr_size
   	
        jmp cycle
        endCycle: 

ret 

Cout:    
	cycle2:  
	mov ECX, pointer
	cmp ECX, arr_size
	je ending 
       	  
       
       ;	push offset E_STR
       ;	push pointer        
       ;	call dwtoa
       	
       ;	push NULL               
       ;	push offset numberOfChars 
       ;	push 11           
       ;;	push offset  E_STR
       ;push outputHandle         
      ;	call WriteConsole 	 
	
       ;	push NULL               
       ;	push offset numberOfChars 
       ;	push 1           
       ;;	push offset  newStr 
       ;	push outputHandle         
       ;	call WriteConsole   
	
       	push offset X_STR
      	push dword ptr [ arrX + ECX * 8 + 4 ]
       	push dword ptr [ arrX + ECX * 8 ] 
       	call FloatToStr 
	; 
	mov ECX, pointer
        push offset resSTR
      	push dword ptr [ arrY + ECX * 8 + 4 ]
       	push dword ptr [ arrY + ECX * 8 ]
      	call FloatToStr  
  				
       	push offset resSTR
      	push offset X_STR
       	push offset template 
      	push offset answer
      	call wsprintf 
       	add ESP, 16
	
      	push offset answer
       	call lstrlen 
	
      	push NULL                 
       	push offset numberOfChars
       	push EAX
      	push offset answer
       	push outputHandle         
       	call WriteConsole 
       	
        push NULL               
       	push offset numberOfChars 
       	push 1           
       	push offset  newStr 
       	push outputHandle         
       	call WriteConsole  
	
	inc pointer
	jmp cycle2 
	ending:
ret 


entryPoint:
	push STD_INPUT_HANDLE
	call GetStdHandle
	mov inputHandle, EAX
	push STD_OUTPUT_HANDLE
	call GetStdHandle
	mov outputHandle, EAX
        
	
	; -----------------------------------------  Ввод данных   ---------------------------------------------------------
	push offset inputMessageX1
	call lstrlen
	push NULL
	push offset numberOfChars
	push EAX
	push offset inputMessageX1
	push outputHandle
	call WriteConsole

	push NULL
	push offset numberOfChars
	push 1000
	push offset numberX1
	push inputHandle
	call ReadConsole
	mov EDX, offset numberX1
	mov EAX, numberOfChars
	mov byte ptr [ EDX + EAX - 2 ], 0
	
	; Input to float
	push offset x1
	push offset numberX1
	call StrToFloat
	
	
	push offset inputMessageX2
	call lstrlen
	push NULL
	push offset numberOfChars
	push EAX
	push offset inputMessageX2
	push outputHandle
	call WriteConsole

	push NULL
	push offset numberOfChars
	push 1000
	push offset numberX2
	push inputHandle
	call ReadConsole
	mov EDX, offset numberX2
	mov EAX, numberOfChars
	mov byte ptr [ EDX + EAX - 2 ], 0
	
	; Input to float
	push offset x2
	push offset numberX2
	call StrToFloat
	
	push offset inputMessageXD
	call lstrlen
	push NULL
	push offset numberOfChars
	push EAX
	push offset inputMessageXD
	push outputHandle
	call WriteConsole

	push NULL
	push offset numberOfChars
	push 1000
	push offset numberXD
	push inputHandle
	call ReadConsole
	mov EDX, offset numberXD
	mov EAX, numberOfChars
	mov byte ptr [ EDX + EAX - 2 ], 0
	
	push offset xd
	push offset numberXD
	call StrToFloat
	
	push offset inputMessageA
	call lstrlen
	push NULL
	push offset numberOfChars
	push EAX
	push offset inputMessageA
	push outputHandle
	call WriteConsole

	push NULL
	push offset numberOfChars
	push 1000
	push offset numberA
	push inputHandle
	call ReadConsole
	mov EDX, offset numberA
	mov EAX, numberOfChars
	mov byte ptr [ EDX + EAX - 2 ], 0
	
	push offset a
	push offset numberA
	call StrToFloat
	
	push offset inputMessageB
	call lstrlen
	push NULL
	push offset numberOfChars
	push EAX
	push offset inputMessageB
	push outputHandle
	call WriteConsole

	push NULL
	push offset numberOfChars
	push 1000
	push offset numberB
	push inputHandle
	call ReadConsole
	mov EDX, offset numberB
	mov EAX, numberOfChars
	mov byte ptr [ EDX + EAX - 2 ], 0
	
	push offset b
	push offset numberB
	call StrToFloat
        ; ----------------------------------------- Конец ввода данных ---------------------------------------------------------;
        
        call FindY
        call Cout  
     	
	push NULL
	push offset numberOfChars
	push 1
	push offset inputBuffer
	push inputHandle
	call ReadConsole

	push 0
	call ExitProcess
END entryPoint