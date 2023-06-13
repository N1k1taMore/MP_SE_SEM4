%macro print 2
mov  rax , 01  ; sys_write
mov  rdi , 01  ; stdout - file descriptor
mov  rsi , %1  ; address of string to print
mov  rdx , %2  ; no. of bytes to print
syscall
%endmacro


%macro read  2
mov  rax , 00  ; sys_read
mov  rdi , 00  ; stdin - file descriptor
mov  rsi , %1  ; address where bytes are to be stored
mov  rdx , %2  ; no. of bytes to read
syscall
%endmacro


HTA:
hextoascii:
rol   rax  ,  04
mov   rbx ,  rax
and   rbx  ,  0x0F
cmp   rbx  ,  09h
jbe   copydigit
add   rbx  ,  07h
copydigit:
add   rbx  ,  30h
mov   [rsi] , rbx
inc   rsi
dec   rcx
jnz   hextoascii
ret


section .data
msg1     db   "Enter 1st number" , 0xA
len1     equ  $-msg1
msg2     db   "Enter 2nd number" , 0xA
len2     equ  $-msg2
msg3     db   "Result is" , 0xA
len3     equ  $-msg3
msg4     db   0xA , "Options are 0-> Add, 1 -> Subtract, 2 -> Multiply, 3 -> Divide ,4->Exit" ,0xA
len4     equ  $-msg4

section .bss
result resq 16
n1 resq 16
n2 resq 16
option resb 02
resascii resb 02

section .text

global _start
_start:


print  msg1 , len1
read   n1 , 16

print  msg2 ,len2
read   n2 ,16

programloop:
print    msg4 , len4
read     option, 02
mov      bl    ,  byte[option]
sub      bl    ,  30h
cmp      bl    ,  00h
jz       ADD
cmp      bl    ,  01h
jz       SUB
cmp      bl    ,  02h
jz       MULTIPLY
cmp      bl    ,  03h
jz       DIVIDE
cmp      bl    ,  04h
jz       EXIT

ADD:
mov rax,qword[n1]
mov rbx,qword[n2]
adc rax,rbx

mov [result],rax
mov   rcx  , 16h      ;reinitialize counter
mov   rsi  , result    ;point rsi to array

call HTA
print msg3,len3
print result,16
jmp programloop

SUB:
mov rax,qword[n1]
mov rbx,qword[n2]
sub rax,rbx

mov   rcx  , 16h      ;reinitialize counter
mov   rsi  , result    ;point rsi to array

call HTA
print msg3,len3
print result,16
jmp programloop

MULTIPLY:
mov rax,qword[n1]
mov rbx,qword[n2]
imul  rbx
mov   [result] ,rax

mov   rcx  , 16h      ;reinitialize counter
mov   rsi  , result    ;point rsi to array

call HTA
print msg3,len3
print result,16
jmp programloop

DIVIDE:
mov rax,qword[n1]
mov rbx,qword[n2]
div rbx
mov   [result] ,rax

mov   rcx  , 16h      ;reinitialize counter
mov   rsi  , result    ;point rsi to array

call HTA
print msg3,len3
print result,16
jmp programloop

EXIT:
mov  rax , 60
mov  rdx , 00  
syscall
