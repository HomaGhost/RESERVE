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

Body struct
	day dd ?
	month dd ?
	year dd ?
	mass dq ? 
Body ends

.data          
      	 template db "%.2d.%.2d.%.d - %3.10s kg", 10, 13, 0 
      	 about_mass_sort db "Mass sort: "
      	 about_date_sort db "Date sort: "    
      	 newStr dd 0ah
      	 arr_size dd 0  
      	 result db 1000 dup (0)
       	 array Body <07, 12, 2012, 77.56>, <10, 12, 2012, 78.0>, <11, 2, 2021, 55.36>, <8, 12, 2012, 77.56>, <15, 12, 2012, 77.56> 
       	 ;array Body <08, 10, 2029, 71.0>, <11, 10, 2019, 78.0>, <10, 11, 2021, 55.36>, <8, 11, 2020, 89.56>, <7, 12, 2022, 15.56> 
       	 massStr db 100 dup(0) 
       	 xSTR db 100 dup(0) 
       	 new_str dd 0ah 
       	 
.data?  
	sort_type dd ?
	inner_cycle_size dd ?       
      	numberOfChars dd ?
      	outputHandle dd ?  
      	inputHandle dd ? 
.code   

dateCmp:
       	mov EAX, [ ESP + 4 ] 		; first mass 
       	fild dword ptr [ EAX + 8 ] 		
       	mov EAX, [ ESP + 8 ] 		; second mass
       	ficomp dword ptr [ EAX + 8 ]         

       	fstsw AX
      	sahf
       	je equallowerYEAR
       	jb greatYEAR 
       	ja smallerYEAR
       	
       	smallerYEAR:
       	         mov EAX, 0
       	      	 jmp return1
       	greatYEAR: ; Структура слева больше, чем справа 
       	      	mov EAX, -1
       	      	jmp return1
       	equallowerYEAR: 
       		mov EAX, [ ESP + 4 ] 		; first mass 
       		fild dword ptr [ EAX + 4 ] 		
       		mov EAX, [ ESP + 8 ] 		; second mass
       		ficomp dword ptr [ EAX + 4 ]         

       		fstsw AX
       		sahf
       		je equallowerMONTH 
       		jb greatMONTH 
       		ja smallerMONTH 
       		smallerMONTH:
       		        mov EAX, 0
       	      		jmp return1 
       		greatMONTH:
       	      		mov EAX, -1
       	      		jmp return1 
       		equallowerMONTH:
       			mov EAX, [ ESP + 4 ] 		; first mass 
       	       		fild dword ptr [ EAX ] 		
       			mov EAX, [ ESP + 8 ] 		; second mass
       			ficomp dword ptr [ EAX ]         

       			fstsw AX
       			sahf
       			jae equallowerDAY
       			jb greatDAY 
       			equallowerDAY:
       				mov EAX, 0
       	      			jmp return1
       	      	        greatDAY:		
       				mov EAX, -1
       	      	       		jmp return1
       	return1: 
ret 8 

massCmp:
	mov EAX, [ ESP + 4 ] 		; first mass 
       	fld qword ptr [ EAX + 12 ] 		
       	mov EAX, [ ESP + 8 ] 		; second mass
       	fcomp qword ptr [ EAX + 12 ]         

       	fstsw AX
      	sahf
       	je equallFULL  
       	ja lowerFULL
       	jb greatFULL
       	
       	lowerFULL:
       	        mov EAX, 0
       	      	jmp return2
       	greatFULL:
       	      	mov EAX, -1
       	      	jmp return2   	      	
       	equallFULL:
       		mov EAX, [ ESP + 4 ] 		; first mass 
       		fld qword ptr [ EAX + 16 ] 		
       		mov EAX, [ ESP + 8 ] 		; second mass
       		fcomp qword ptr [ EAX + 16 ]         

       		fstsw AX
       		sahf
       		jae equallowerREAL
       		jb greatREAL
       		greatREAL:
       	      		mov EAX, -1
       	      		jmp return2
       		equallowerREAL:
       		       mov EAX, 0
       	               jmp return2
       	return2: 
ret 8 
       	      	

bubbleSort:
           ; размер массива
       	mov EDX, [ ESP + 4 ]   ; адрес функции, которая будет сравнивать элементы 
       	mov sort_type, EDX
        mov arr_size, 0
       	;=================================================================================== BUBBLE SORT (по возрастанию) ==================================================================================;
       	beginCycle: 
	        mov EBX, [ ESP + 8 ]
       		mov ESI, EBX
       		
       	       ;	push offset xSTR
       	      	;push [ EBX + 12 ]     
       	      	;call dwtoa
       	       	;push offset  xSTR                             
       	       	;call lstrlen                                         
       	       	;push NULL
       	       	;push offset numberOfChars
       	       	;push EAX                                             
       	       	;push offset  xSTR
       	       	;push outputHandle
       	        ;call WriteConsole 
       	        
       	        ;push NULL
       		;push offset numberOfChars
       		;push 1
       		;push offset newStr
		;push outputHandle
	       	;call WriteConsole
       		
	       	cmp arr_size, 4
	        je endCycle   		                    
	            
	        mov inner_cycle_size, 0
	        ;============================== inner cycle ==============================================;
	 	innercycle:
	 	mov EAX, 4
	 	sub EAX, arr_size	     	       	
	        cmp inner_cycle_size, EAX
		je skip   
		inc inner_cycle_size 
		mov ESI, EBX
		add EBX, 20
		
		;push ESI 
	       	;push EBX 
	       	;call sort_type
		
	        ;push offset xSTR
       	      	;push EAX      
       	      	;call dwtoa
       	       	;push offset  xSTR                             
       	       	;call lstrlen                                         
       	       	;push NULL
       	       	;push offset numberOfChars
       	       	;push EAX                                             
       	       	;push offset  xSTR
       	       	;push outputHandle
       	        ;call WriteConsole 
       	        
       	        ;push NULL
       		;push offset numberOfChars
       		;push 1
       		;push offset newStr
		;push outputHandle
	       ;	call WriteConsole
		
		push ESI 
	       	push EBX 
	       	call sort_type   
	       
                cmp EAX, 0
	       	je skipinner
      		
      		
      		
      		; ===================================== v swap() v ===================================================== ;
      		mov ECX, [ EBX + 16 ]
      	       	mov EAX, [ ESI + 16 ]
      		
	       	mov [ EBX + 16 ], EAX 
	       	mov  [ ESI + 16 ], ECX  
	       	
	       	mov ECX, [ EBX + 12 ]
      	       	mov EAX, [ ESI + 12 ]
      		
	       	mov [ EBX + 12 ], EAX 
	       	mov  [ ESI + 12 ], ECX  
      		
      	       	mov ECX, [ EBX + 8 ]
      	       	mov EAX, [ ESI + 8 ]
      		
	       	mov [ EBX + 8 ], EAX 
	       	mov  [ ESI + 8 ], ECX  
	       	
	       	mov ECX, [ EBX + 4 ]
      	       	mov EAX, [ ESI + 4 ]
      		
	       	mov [ EBX + 4 ], EAX 
	       	mov  [ ESI + 4 ], ECX 
	       	
	       	mov ECX, [ EBX ]
      	       	mov EAX, [ ESI ]
      		
	       	mov [ EBX ], EAX 
	       	mov  [ ESI ], ECX  
	        ; ===================================== ^ swap() ^ ===================================================== ;
	        	 
	       	skipinner:
		jmp innercycle
	       	
	       	skip:
	       	inc arr_size
	       	
	       ;	push 5
       	      ;	push offset  array
       	       ;	call coutArr
       		
       		      	       	
      	       ;	push NULL
       	;	push offset numberOfChars
       		;push 1
       		;push offset newStr
		;push outputHandle
		;call WriteConsole 
       		 
	       	jmp beginCycle
       	endCycle:
       	mov arr_size, 5
ret 8

coutArr:
; Стандартный пролог функции
        push EBP
        mov EBP, ESP
        cycle:
                cmp dword ptr [ EBP + 12 ], 0
                je endFunction 

                          
                mov EBX, [ EBP + 8 ] 
                
                push offset massStr
	       	push dword ptr [ EBX + 16 ]
       	       	push dword ptr [ EBX + 12 ]
	       	call FloatToStr
           	    
                push offset massStr 
                push dword ptr [ EBX + 8 ]
                push dword ptr [ EBX + 4 ] 
                push dword ptr [ EBX ]                                                 
                push offset template          
                push offset result                                  
                call wsprintf                                                            
                add ESP, 24                  

                push offset result
               	call lstrlen
        
       	       	push NULL
       	       	push offset numberOfChars
       	       	push EAX
       	       	push offset result
      	       	push outputHandle 
      	       	call WriteConsole       
                                              
                add dword ptr [ EBP + 8 ], 20                                               
                dec dword ptr [ EBP + 12 ]    
        jmp cycle
        endFunction:
        pop EBP
ret 8

main:
      	push STD_INPUT_HANDLE     ; ???????? ????????? ? ???????
	call GetStdHandle         ; ????? ????????? ???????
	mov inputHandle, EAX      ; ?????????? ?????????? ???????  
		
	push STD_OUTPUT_HANDLE
	call GetStdHandle
	mov outputHandle, EAX  
	 
	
       
	
	push NULL                 
       	push 11           
       	push offset about_date_sort  
       	push outputHandle         
       	call WriteConsole 
       	
       	push NULL
	push offset numberOfChars
	push 1
	push offset newStr
       	push outputHandle
       	call WriteConsole
	
       	push offset array
       	push dateCmp
       	call bubbleSort  
	
       	push 5
       	push offset  array
       	call coutArr
       	
       	  
       	
       	push NULL                 
       	push 11           
       	push offset about_mass_sort  
       	push outputHandle         
       	call WriteConsole
       	
       	push NULL
	push offset numberOfChars
	push 1
	push offset newStr
	push outputHandle
	call WriteConsole 
       	
       	push offset array
       	push massCmp
       	call bubbleSort  
	
       	push 5
       	push offset  array
        call coutArr

 	push NULL
	push offset numberOfChars
	push 1
	push offset newStr
	push inputHandle
	call ReadConsole  
 
	push 0
	call ExitProcess
end main