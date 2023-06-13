section .data
array dq 0xffff111122223333 ,0x1111222233334444 , 0x1111111122222222 , 0x3333333344441111 , 0x1010101010101010
msg1     db   "Positive numbers :"
len1     equ  $-msg1
msg2     db   " Negative number :"
len2     equ  $-msg2

counter db 05h
pos_count db 00h
neg_count db 00h

section .text

global _start
_start:

mov rsi,array

loop1:
mov rax,qword[rsi]
bt rax,63
jnc loop2
inc byte[neg_count]
jmp update

loop2:
inc byte[pos_count]

update:
inc   rsi
dec   byte[counter]
jnz   loop1

add byte[pos_count],30h
add byte[neg_count],30h

mov  rax , 01
mov  rdi , 01
mov  rsi , msg1
mov  rdx , len1
syscall 

mov  rax , 01
mov  rdi , 01
mov  rsi , pos_count
mov  rdx , 01
syscall 

mov  rax , 01
mov  rdi , 01
mov  rsi , msg2
mov  rdx , len2
syscall 

mov  rax , 01
mov  rdi , 01
mov  rsi , neg_count
mov  rdx , 01
syscall 

mov  rax , 60
mov  rdx , 00  
syscall

