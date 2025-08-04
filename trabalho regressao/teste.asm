extern printf
extern atof

section .data
    lido : db "%f", 10, 0

section .bss
    buffer : resb 3

section .text
    global main

main:
    push rbp
    mov rbp, rsp
    and rsp, -16       ; alinhando 16 bytes (prof que falou, eu nao sei oq isso faz)

    ; abrindo o entrada.txt
    mov rax, 2
    mov rdi, [rsi + 8]
    xor rsi, rsi
    xor rdx, rdx
    syscall

    mov r12, rax

    ; lendo o trem
    mov rax, 0
    mov rdi, r12
    mov rsi, buffer
    mov rdx, 3
    syscall

    ; função atof pra transformar string em float
    mov rdi, buffer
    call atof

    ; printando oq foi lido para fins de testagem
    mov rax, 1
    mov rdi, lido
    ; é pra tar em xmm0
    call printf

    ; por enquanto é isso pois tenho outros trecos a fazer e ja levou algumas horas

fim:
    mov rsp, rbp
    pop rbp

    mov rax, 60
    xor rdi, rdi
    syscall