section .data
    vetor:     db 9,8,7,6,5,4,3,2,1
    tamanho:   equ $ - vetor

section .text
    global _start

_start:
    mov rsi, 0

leitura:
    cmp rsi, tamanho
    jge fim

    mov rdi, 0
    mov rcx, tamanho
    dec rcx
    sub rcx, rsi

sort:
    cmp rdi, rcx
    jge proximo

    mov al, [vetor + rdi]
    mov bl, [vetor + rdi + 1]
    cmp al, bl
    jle nao_troca

    mov [vetor + rdi], bl
    mov [vetor + rdi + 1], al

nao_troca:
    inc rdi
    jmp sort

proximo:
    inc rsi
    jmp leitura

fim:
    mov rax, 60
    mov rdi, 0
    syscall