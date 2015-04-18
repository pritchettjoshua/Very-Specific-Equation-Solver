%include "Along32.inc"
section .data ;data section
  messageprompt1    : db "Please Enter integer A",0ah, 0
  messageprompt2    : db "Please Enter integer B",0ah, 0
  result     : db "(A*B)-(A+B)/(A-B) = ", 0
  InputError : db "Input value Invalid, integer expected",0ah, 0
  DenominatorError : db "Division by zero error",0ah, 0

;               	Start Main Method

section .code          ;code section
  global _start 
  _start:                               ; main method
          call     readA                ; read A from stdin
          push     eax                  ; push A onto stack register
          call     readB                ; read B from stdin
          push     eax                  ; push B onto stack register
          pop      ebx                  ; pop B off stack register to ebx
          pop      eax                  ; pop A off stack register to eax
          call     MulAB                ; multiply A and B input eax, ebx
                                        ; return ecx from MulAB
          push     ecx                  ; push saved result of MulAB onto stack register
          call     AddAB                ; add A and B input eax, ebx 
                                        ; return ecx from AddAB
          push     ecx                  ; push saved result of AddAB onto stack register
          call     SubAB                ; subtract A and B input eax, ebx
                                        ; return ecx from SubAB
          push     ecx                  ; push saved result of SubAB onto stack register
          pop      ebx                  ; pop A-B off stack register to ebx
          pop      eax                  ; pop A+B off stack register to eax
          call     DivAB                ; divide (A+B) by (A-B) input eax, ebx
                                        ; return ecx from DivAB
          push     ecx                  ; push saved result of DivAB onto stack register
          pop      ebx                  ; pop (A+B)/(A-B) off stack register to ebx
          pop      eax                  ; pop (A*B) off stack register to eax
          call     SubAB                ; subtract (A*B)-(A+B)/(A-B) input eax, ebx
                                        ; return ecx from SubAB
          call     ShowResult           ; write result
          jmp      exit                 ; exit program

;			End Main Method

;                     	Start Math Methods

MulAB:                                  ; arguments eax, ebx result in ecx
         push     eax                   ; stores A
         cdq
         imul     eax, ebx               ; multiply A, B result in eax
         mov      ecx, eax               ; move result in ecx
         pop      eax                    ; restores A
         ret                             ; returns to main

AddAB:                                   ; arguments eax, ebx result in ecx
         push     eax                    ; stores A
         add      eax, ebx               ; adds A, B returns result in eax
         mov      ecx, eax               ; move result in ecx
         pop      eax                    ; restores A
         ret                             ; returns to start

SubAB:                                  ; arguments eax, ebx result in ecx
         push     eax                   ; stores A
         sub      eax, ebx              ; subtracts A,B result in eax
         mov      ecx, eax              ; moves result in ecx
         pop      eax                   ; restores a
         ret                            ; returns to start

DivAB:                                   ; arguments eax, ebx result in ecx
         mov       ecx,ebx               ; move ebx into ecx
         jecxz     DivZeroError          ; jumps if ecx is zero
         mov       edx, 0                ; clears edx
         cdq
         idiv      ebx                   ; divides eax by ebx results in eax
         mov       ecx, eax              ; move result in ecx
         ret                             ; returns to start

;                      	End Math Methods

;                   	Start Util Methods

readA:                                  	; prompts user input for A
         mov       edx, messageprompt1          ; moves promptA into edx
         call      WriteString          	; writes prompt
         call      ReadInt              	; reads A into eax 
                                        	; integer
         jo        InvalidInput         	; jumps to InvalidInput if not 
                                        	; integer
         ret                            	; return to start

readB:                                  	; prompts user input for B
        mov        edx, messageprompt2         	; moves promptB into edx
        call       WriteString          	; writes prompt
        call       ReadInt              	; reads A into eax
						; integer
        jo         InvalidInput         	; jumps to InvalidInput if not 
                                        	; integer
        ret                             	; return to start

InvalidInput:                            ; error for invalid input
        mov        edx, InputError       ; move InputError into edx
        call       WriteString           ; writes error
        jmp        exit                  ; exits program

DivZeroError:                            ; error for divide by zero error
        mov        edx, DenominatorError ; move ValueError into edx
        call       WriteString           ; writes error
        jmp        exit                  ; exits program

ShowResult:                              ; shows result
        mov        edx, result           ; moves result in edx
        call       WriteString           ; write result
        mov        eax, ecx              ; mov result into eax
        call       WriteInt              ; writes result
        call       Crlf                  ; write newline

exit:                                    ; exit function
       mov     eax, 1                    ; mov 1 eax
       int     0x80                      ; ask to exit

;                      End Util Methods