; a08at02
; Dado um vetor de 10 posições de caracteres, inverta a ordem dos seus elementos

%define maxChars 10

section .data
    entra : db "Entre com o vetor: "
    entraL: equ $ - entra

    sai : db " eh inversao de "
    saiL: equ $ - sai

    bN : db 10
    bNL: equ 1

section .bss
    vetor : resb maxChars
    vetorL: resd 1

    inverso : resb maxChars
    inversoL: resd 1

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    lea rsi, [entra]
    mov edx, entraL
    syscall

    mov dword [vetorL], maxChars
    mov dword [inversoL], maxChars

    mov rax, 0
    mov rdi, 0
    lea rsi, [vetor]
    mov edx, [vetorL]
    syscall

    mov [vetorL], eax

    xor rcx, rcx
inversao:
    mov rbx, maxChars-1
    sub rbx, rcx

    mov al, [vetor + rbx]
    mov [inverso + rcx], al

    inc rcx
    cmp rcx, 9
    jle inversao

escrita:
    mov rax, 1
    mov rdi, 1
    lea rsi, [inverso]
    mov edx, [inversoL]
    syscall
    
    mov rax, 1
    mov rdi, 1
    lea rsi, [sai]
    mov edx, saiL
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [vetor]
    mov edx, [vetorL]
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [bN]
    mov edx, bNL
    syscall

fim:
    mov rax, 60
    mov rdi, 0
    syscall
