section .data
newline db 10,10
newline_len equ $-newline

space db " "

msg1 db 10,"Before Transfer::"
len1 equ $-msg1

msg2 db 10,"After Transfer::"
len2 equ $-msg2

msg3 db 10," Source Block :"
len3 equ $-msg3

msg4 db 10," Destination Block :"
len4 equ $-msg4

array1 db 5h,3h,4h,7h,9h
array2 times 5 db 0

;------------------------------------------------------------------------------
section .bss
ans resb 2 ;ans is of 2 byte because we have 2 byte nos

;-----------------------------------------------------------------------------

%macro Print 2
       MOV RAX,1
       MOV RDI,1
       MOV RSI,%1
       MOV RDX,%2
       syscall
%endmacro

%macro Read 2
       MOV RAX,0
       MOV RDI,0
       MOV RSI,%1
       MOV RDX,%2
       syscall
%endmacro


%macro Exit 0
      Print newline,newline_len
      MOV RAX,60
      MOV RDI,0
      syscall
%endmacro
;---------------------------------------------------------------      

section .text
global _start

_start:

Print msg1,len1                   ;Block values before transfer

Print msg3,len3
mov rsi,array1                   ;As rsi is used to point source as well as destination block
call disp_block                  ;assign source and destination block separately before call

Print msg4,len4
mov rsi,array2
call disp_block

call Copy                             ;call for actual block transfer

Print msg2,len2                        ;Block values after transfer

Print msg3,len3
mov rsi,array1
call disp_block

Print msg4,len4
mov rsi,array2
call disp_block

Exit
;-----------------------------------------------------------------
Copy:
mov rsi,array1
mov rdi,array2
mov rcx,5

back: movsb

dec rcx
jnz back
RET
;-----------------------------------------------------------------
disp_block:
mov rbp,5 ;counter as 5 values

next_num:
mov al,[rsi] ;moves 1 value to rsi
push rsi ;push rsi on stack as it get modified in Disp

call Hex_Asc
Print space,1

pop rsi ;again pop rsi that pushed on stack
inc rsi

dec rbp
jnz next_num
RET
;---------------------------------------------------------------
Hex_Asc:
MOV RSI,ans+1
MOV RCX,2           ;counter
MOV RBX,16          ;Hex no

next_digit:
XOR RDX,RDX
DIV RBX

CMP DL,9
JBE add30
ADD DL,07H

add30 :
ADD DL,30H
MOV [RSI],DL

DEC RSI
DEC RCX
JNZ next_digit

Print ans,2
ret

