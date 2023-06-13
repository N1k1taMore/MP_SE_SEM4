section .data
array db  12h , 90h , 06h , 15h , 32h

section .bss
result resb 2

section .text

global _start
_start:

mov   rsi , array
mov   al  , 0h   ; current largest number
mov   rcx , 05h  ; counter

loop1:
mov   bl  , [rsi]
cmp   bl  , al
jb    update
mov   al  , bl

update:
inc   rsi
dec   rcx
jnz   loop1

mov   rcx  , 02h      ;reinitialize counter
mov   rsi  , result    ;point rsi to array

hextoascii:
rol   al  ,  04
mov   dl  ,  al
and   dl  ,  0x0F
cmp   dl  ,  09h
jbe   copydigit
add   dl  ,  07h
copydigit:
add   dl  ,  30h
mov   [rsi] , dl
inc   rsi
dec   rcx
jnz   hextoascii

mov  rax , 01
mov  rdi , 01
mov  rsi , result
mov  rdx , 02 
syscall 

mov  rax , 60
mov  rdx , 00  
syscall
