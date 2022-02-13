; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

        .CONST
MsgExit DB      0Ah, 0Dh, "Press Enter to exit", 0Ah, 0Dh, 0
sizearr SDWORD  30
rows    SDWORD  5
columnsl SDWORD  5
Chl      DB      0Ah, 0Dh, 0
Tab      DB      09h, 0 
inpEl DB 'Input element: ',0
inp_end DB      ": ", 0
res_m  DB      0Ah, 0Dh,"Result matrix:", 0Ah, 0Dh, 0
orig_m  DB      0Ah, 0Dh,"Original matrix:", 0Ah, 0Dh, 0
inpN DB 'Enter number of row: ',0 
        
        .DATA
inbuf DB    15 DUP (' '),0
buf   DB    10 DUP (?)
        .DATA?
array   SDWORD  ?
N SDWORD ?         
        
        .CODE
Start:
        mov ECX, sizearr
        mov EBX, 0
        cycle1:
            push ECX
            invoke StdOut, addr inpEl
            invoke StdIn, addr buf, LengthOf buf   ;ввожу массив
            invoke StripLF, addr buf
            invoke atol, addr buf
            mov array[EBX*4], EAX
            inc EBX	
            pop ECX        
        loop cycle1	
        
        Invoke StdOut, ADDR inpN
        Invoke StdIn, ADDR buf,LengthOf buf
        Invoke StripLF, ADDR buf
        Invoke atol, ADDR buf
        mov EBX,EAX    ;номер строки ввожу, которую расставить надо
        mov EAX,24d
        imul EBX
        sub EAX,28d
        mov EDI,EAX 
        push EDI
        invoke StdOut, addr orig_m
 	    mov ECX, rows
	    mov EDI, 0
	    cycle2:	
	        push ECX	
	        mov EBX, 0
	        cycle3: cmp EBX,6
		        je exit
		        invoke dwtoa, array[EBX*4 + EDI], addr buf 
		        invoke StdOut, addr buf
		        invoke StdOut, addr Tab
		        inc EBX
		    jmp cycle3
	    exit:
	        invoke StdOut, addr Chl
	        pop ECX
            add EDI, 24
	    loop cycle2	
        pop EDI
        
      
        mov EAX,1
        cyclesort1:
            cmp EAX,columnsl
            jg continue
            mov ECX,columnsl
            cyclesort2:
                mov EBX,array[EDI+ECX*4+4]
                cmp array[EDI+ECX*4],EBX
                jl nextstep
                mov EDX,array[EDI+ECX*4]
                mov array[EDI+ECX*4],EBX
                mov array[EDI+ECX*4+4],EDX
                nextstep:
            loop cyclesort2
            inc EAX
        jmp cyclesort1 
      
continue:   
	    invoke StdOut, addr res_m
 	    mov ECX, rows
	    mov EDI, 0
	    cycle4:	
	        push ECX	
	        mov EBX, 0
	        cycle5: cmp EBX,6
		        je exit2
		        invoke dwtoa, array[EBX*4 + EDI], addr buf 
		        invoke StdOut, addr buf
		        invoke StdOut, addr Tab
		        inc EBX
		    jmp cycle5
	        exit2:
	            invoke StdOut, addr Chl
	            pop ECX
                add EDI, 24
	    loop cycle4	

         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR buf,LengthOf buf		
         Invoke ExitProcess,0
         End    Start
