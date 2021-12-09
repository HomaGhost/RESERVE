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
       AKN dd 1 
       AKN_str db 1000 dup (0)
       enter_k db "Enter K: "
       enter_n db "Enter N: "  
       AKN_is db "AKN: "

.data?               
      k dd ?
      n dd ?
      numberOfChars dd ?
      outputHandle dd ?  
      inputHandle dd ? 
.code   
getAKN:
 	push EBP
        mov EBP, ESP 
        mov EBX, [ EBP + 16 ]
        cycle:
       		cmp EBX, 0
                je endFunction  
                dec EBX
                            
                mov EAX, AKN
               	mul dword ptr [ EBP + 12 ] 
               	mov AKN, EAX 
    	       	
       	        dec dword ptr [ EBP + 12 ]
       	        mov dword ptr [ EBP + 16 ], EBX
       	      	mov ECX, dword ptr [ EBP + 12 ]    ; n  
        	  
                push EBX
                push ECX
                push AKN
                call getAKN
        jmp cycle
        endFunction:
        pop EBP
ret 12



main:
      	push STD_INPUT_HANDLE     ; ???????? ????????? ? ???????
	call GetStdHandle         ; ????? ????????? ???????
	mov inputHandle, EAX      ; ?????????? ?????????? ???????  
		
	push STD_OUTPUT_HANDLE
	call GetStdHandle
	mov outputHandle, EAX  
	
	push NULL                 
	push 9            
	push offset enter_k  
	push outputHandle         
	call WriteConsole
	
	push NULL
	push offset numberOfChars
	push 1000
	push offset k
	push inputHandle
	call ReadConsole                   
                                                                  
	mov EDX, offset k             
	mov EAX, numberOfChars             
	mov byte ptr [ EDX + EAX - 2 ], 0 
	
	push offset k
	call atodw 
       	mov k, EAX
       	
       	push NULL                 
	push 9            
	push offset enter_n 
	push outputHandle         
	call WriteConsole   
       	
       	push NULL
	push offset numberOfChars
	push 1000
	push offset n
	push inputHandle
	call ReadConsole                   
                                                                  
	mov EDX, offset n             
	mov EAX, numberOfChars             
	mov byte ptr [ EDX + EAX - 2 ], 0 
	
	push offset n
	call atodw 
       	mov n, EAX      	
        
        
        push k
        push n
        push AKN
        call getAKN 
        
        push NULL                 
	push 5            
	push offset AKN_is
	push outputHandle         
	call WriteConsole
       	
       	push offset AKN_str
       	push AKN         
       	call dwtoa
       	         
        push offset AKN_str                            
       	call lstrlen                                         
       	push NULL
       	push offset numberOfChars
       	push EAX                                             
       	push offset AKN_str
       	push outputHandle
       	call WriteConsole 

 	push NULL
	push offset numberOfChars
	push 1
	push offset n
	push inputHandle
	call ReadConsole  
 
	push 0
	call ExitProcess  
	
	push offset AKN_str
       	       	push dword ptr [ EBP + 12 ]        
       	 	call dwtoa
       	        
               	push offset AKN_str                            
       	  	call lstrlen                                         
       	       	push NULL
       	       	push offset numberOfChars
       	       	push EAX                                             
       	       	push offset AKN_str
       	       	push outputHandle
       	       	call WriteConsole  
end main