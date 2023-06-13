section .data
msg1 db "Enter String - ",0xA,0xD
len1 equ $-msg1
msg2 db "length of string is - ",0xA,0xD
len2 equ $-msg2

section .bss
str: resb 200
result: resb 200

section .text
global _start
_start:

;display input msg
mov rax,1
mov rdi,1
mov rsi,msg1
mov rdx,len1
syscall

;taking string input
mov rax,0
mov rdi,0
mov rsi,str
mov rdx,20
syscall

;store result length in rbx
dec rax
mov rbx,rax
mov rdi,result
mov cx,16

loop1:
rol rbx,04
mov al,bl
and al,0fh
cmp al,09h

Jg loop2
add al,30h
JMP l1
	
loop2:add al,37h
l1:mov [rdi],al
inc rdi
dec cx
JNZ loop1


;display msg2
mov rax,1
mov rdi,1
mov rsi,msg2
mov rdx,len2
syscall

;display result
mov rax,1
mov rdi,1
mov rsi,result
mov rdx,16
syscall

mov rax,60
mov rdi,0
syscall



