section .data
    maiuscula : db 'A'
    minuscula : db 'b'

section .bss
    lowercase : resb 1
    uppercase : resb 1

section .text
    global _start

_start:
    mov eax, [maiuscula]
    mov ebx, [minuscula]
    mov ecx, 32

operacao:
    add eax, ecx
    sub ebx, ecx
    mov [uppercase], ebx
    mov [lowercase], eax

fim:
    mov rax, 60
    mov rdi, 0
    syscall
