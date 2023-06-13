section .data
msg1 db "ENTER 5 number",0xA
len1 equ $-msg1

msg2 db "The Accepted Numbers are :",0xA
len2 equ $-msg2
 
count db 5h   ;counter defined for loop

section .bss
array resb 100   ;declaring reserved variable

section .text
global _start
_start:


mov rax,01   ;64 bit write system call
mov rdi,01
mov rsi,msg1
mov rdx,len1
syscall

mov r8,array

L1:             
mov rax,00
mov rdi,00
mov rsi,array
mov rsi,r8
mov rdx,17
syscall

add r8,17
dec byte[count]
jnz L1


mov rax,01   ;64 bit write system call
mov rdi,01
mov rsi,msg2
mov rdx,len2
syscall


mov byte[count],05
mov r8,array


L2:
mov rax,01
mov rdi,01   ;(printing the input taken from the user)
mov rsi,array     ;printing in loop
mov rsi,r8
mov rdx,17
syscall

add r8,17
dec byte[count]
jnz L2


mov rax,60    ;64bit system call to exit
mov rdi,00
syscall

