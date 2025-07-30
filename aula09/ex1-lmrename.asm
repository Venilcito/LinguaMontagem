section .bss
    nomeVelho: resb 256
    nomeNovo:  resb 256

section .text
    global _start

_start:
    pop rax
    pop rbx

    pop rdi
    xor r9d, r9d

oldname:
    mov al, [rdi+r9]
    mov [nomeVelho+r9], al
    cmp al, 0
    je continua

    inc r9
    jmp oldname

continua:
    pop rsi
    xor r9d, r9d

newname:
    mov al, [rsi+r9]
    mov [nomeNovo+r9], al
    cmp al, 0
    je continua2

    inc r9
    jmp newname

continua2:
    mov rax, 82
    lea rdi, [nomeVelho]
    lea rsi, [nomeNovo]
    syscall

fim:
    mov rax, 60
    mov rdi, 0
    syscall