.486
.model flat, stdcall
option casemap: none

include windows.inc
include user32.inc
include kernel32.inc   
include masm32.inc

includelib user32.lib
includelib kernel32.lib
includelib masm32.lib

.data   
	arr_size dd 10  
	result db 1000 dup (0)
	template db "%d ", 0
       	sum dd 0
      	sum_str db 1000 dup (0)
      	new_str dd 0ah  
      	divider dd 2  
      	num dd 7
.data?               
      arr dd 1000 dup (?)
      numberOfChars dd ?
      outputHandle dd ?  
      inputHandle dd ? 
.code   

arrayToStr:
        ; Стандартный пролог функции
        push EBP
        mov EBP, ESP
        ; начало цикла - пока есть необработанные элементы
        cycle:
                cmp dword ptr [ EBP + 16 ], 0
                je endFunction 
                ; Формирование текстового представления целого числа
                mov EAX, [ EBP + 12 ]         ; указатель на очередное число    
                
                push [ EAX ]                  ; целое число (элемент массива),
                                              ; преобразуемое в строку
                push offset template          ; шаблон строки, в который
                                              ; подставляются значения
                push [ EBP + 8 ]              ; адрес буфера для размещения
                                              ; итоговой строки
                call wsprintf                 ; в EAX записывается число символов,
                                              ; записанных в буфер
                add ESP, 12                   ; выровняем стек
                ; Подготовка к следующему числу
                add [ EBP + 8 ], EAX          ; рассчитаем адрес строки для
                                              ; следующего числа
                add dword ptr [ EBP + 12 ], 4 ; перемещаем указатель на следующий
                                              ; элемент массива
                dec dword ptr [ EBP + 16 ]    ; уменьшаем счетчик
        jmp cycle
        endFunction:
        ; Стандартный эпилог функции
        pop EBP
; Выйти и выровнять стек
ret 12
    

setArr:
 	push EBP
        mov EBP, ESP   
  
        mov EBX,  [ EBP + 12 ]
        mov EDX, [ EBP + 8 ]
        cycle2:
       		cmp dword ptr [ EBP + 16 ], 0
                je endFunction2
                mov [ EBX ], EDX
                add EBX, 4 
                add EDX, 7 
                dec dword ptr [ EBP + 16 ]
        jmp cycle2
        endFunction2: 
        pop EBP
ret 12

;setArr:
;        mov EBX, offset arr
;        mov ECX, arr_size  
;        mov EDX, 7
;        cycle2:
;       	cmp ECX, 0
;                je endFunction2
;                mov dword ptr [EBX], EDX
;                add EBX, 4 
;                add EDX, 7 
 ;               dec ECX
 ;       jmp cycle2
 ;       endFunction2: 
;ret 

sumArr:
        mov EBX, offset arr
        mov ECX, arr_size 
        cycle3:
        	cmp ECX, 0
                je endFunction3  
                mov EAX, sum
                add EAX, dword ptr [EBX] 
                mov sum, EAX
                add EBX, 4
                dec ECX
        jmp cycle3
        endFunction3:
ret 

changeArr:
        mov EBX, offset arr
        mov ECX, arr_size
        cycle4:
        	cmp ECX, 0
                je endFunction4
                xor EDX, EDX
                mov EAX, dword ptr [EBX] 
                idiv divider
                cmp EDX, 0
                jne oddNum
                mov dword ptr [EBX], EAX
                oddNum:
                add EBX, 4  
                dec ECX
        jmp cycle4
        endFunction4: 
ret

main:
      	push STD_INPUT_HANDLE     ; ???????? ????????? ? ???????
	call GetStdHandle         ; ????? ????????? ???????
	mov inputHandle, EAX      ; ?????????? ?????????? ???????  
		
	push STD_OUTPUT_HANDLE
	call GetStdHandle
	mov outputHandle, EAX
	
	push NULL
	push offset numberOfChars
	push 1000
	push offset arr_size
	push inputHandle
	call ReadConsole                   
                                                                  
	mov EDX, offset arr_size             
	mov EAX, numberOfChars             
	mov byte ptr [ EDX + EAX - 2 ], 0 
	
	push offset arr_size
	call atodw 
       	mov arr_size, EAX   
	
	push arr_size
        push offset arr 
        push num 
       	call setArr 
       	
        call sumArr
                
       	push arr_size
        push offset arr 
        push offset result
        call arrayToStr
              
        push offset result
 	call lstrlen 
	
 	push NULL                 
       	push offset numberOfChars
       	push EAX
       	push offset result
       	push outputHandle         
       	call WriteConsole
       	
       	push offset sum_str
       	push sum          
       	call dwtoa
       	         
        push offset sum_str                             
       	call lstrlen                                         
       	push NULL
       	push offset numberOfChars
       	push EAX                                             
       	push offset sum_str
       	push outputHandle
       	call WriteConsole
       	
       	push NULL                 
      	push offset numberOfChars 
       	push 1         
       	push offset  new_str
       	push outputHandle         
       	call WriteConsole   
       	
        mov sum, 0
       	call changeArr 
        call sumArr
        
        push arr_size
        push offset arr 
        push offset result
        call arrayToStr
              
        push offset result
 	call lstrlen 
	
 	push NULL                 
       	push offset numberOfChars
       	push EAX
       	push offset result
       	push outputHandle         
       	call WriteConsole
       	
       	push offset sum_str
       	push sum          
       	call dwtoa
       	         
        push offset sum_str                             
       	call lstrlen                                         
       	push NULL
       	push offset numberOfChars
       	push EAX                                             
       	push offset sum_str
       	push outputHandle
       	call WriteConsole 

 	push NULL
	push offset numberOfChars
	push 1
	push offset result
	push inputHandle
	call ReadConsole  
 
	push 0
	call ExitProcess
end main