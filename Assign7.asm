%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

section .data
    Prot db "Protected Mode : ",10
    Plen equ $-Prot
   
    Real db "Real Mode : ",10
    Rlen equ $-Real
   
    msw db "MSW  : "
    mswlen equ $-msw
   
    gdtr db 10,"GDTR : "
    gdtrlen equ $-gdtr
   
    idt db 10,"IDTR : "
    idtlen equ $-idt
   
    tr db 10,"TR : "
    trlen equ $-tr
   
    ld db 10,"LDTR : "
    ldlen equ $-ld
   
section .bss
    gdt resb 4          ;to hold the value of the base address
    gdtli resb 2        ;to hold the value of the limit field
    msw1 resb 2         ;to hold msw value
    temp resb 1         ;to temporary store the value of al register
    result1 resq 1      
    result2 resw 1
    idt1 resb 4         ;to hold the value of the base address
    idtli resb 2        ;to hold the value of the limit field
    ldt resb 2          ;to hold ldtr value
    t_r resb 2          ;to hold the tr value

section .text
    global _start
_start:
    mov rsi,msw1
    smsw [rsi]
    mov ax,[rsi]
    bt ax,0                ;if carry = 1 then it is protected
    jc next
    print Real,Rlen  
    jmp z1
   
next:
    print Prot,Plen

z1:
    print msw,mswlen ;display the contents of msw
    mov ax,word[msw1]
    call display2
   
    print gdtr,gdtrlen
    mov rsi,gdt
    sgdt [rsi]
    mov rax, qword[rsi]
    call display1       ;display the contents of gdtr
   
    mov rsi,gdtli
    mov ax,word[rsi]
    call display2       ;display the table limit of gdtr
   
    print ld,ldlen
    mov rsi,ldt
    sldt [rsi]
    mov rax, [ldt]
    call display2       ;display the contents of ldtr
   
    print idt,idtlen
    mov rsi,idt1
    sidt [rsi]
    mov rax, [idt1]
    call display1       ;display the contents of idtr
   
    mov ax,[idtli]
    call display2     ;display the table limit of idtr
   
    print tr,trlen
    mov rsi,t_r
    str [rsi]
    mov rax, [t_r]
    call display2      ;display the contents of tr
   
    mov rax, 60
    mov rdi, 0
    syscall
   
display1:
    mov bp,16              ;to display 64 bit no (same process as we have done earlier)
up1:
    rol ax,4
    mov qword[result1],rax
    and al,0fh
    cmp al,09h
    jbe next1
    add al,07h
next1:
    add al,30h
    mov byte[temp],al
    print temp,1
    mov rax,qword[result1]
    dec bp
    jnz up1
    ret

display2:
    mov bp,4                ;to display 16 bit no (same process as we have done earlier)
up2:
    rol ax,4
    mov word[result2],ax
    and al,0fh
    cmp al,09h
    jbe next2
    add al,07h
next2:
    add al,30h
    mov byte[temp],al
    print temp,1
    mov ax,word[result2]
    dec bp
    jnz up2
    ret
