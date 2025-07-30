; a08at03
; Dado um vetor de 10 posições de inteiros (4 bytes cada), ordene seus elementos em ordem crescente

section .data
    vetor:     dd 9,8,7,6,5,4,3,2,1,0
    tamanho:   equ 10

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

    mov eax, [vetor + rdi*4]
    mov ebx, [vetor + rdi*4 + 4]
    cmp eax, ebx
    jle nao_troca

    mov [vetor + rdi*4], ebx
    mov [vetor + rdi*4 + 4], eax

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