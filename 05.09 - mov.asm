section .data
    pt1r8 : db 0x10
    pt1r16: dw 0x2020
    pt1r32: dd 0x30303030
    pt1r64: dq 0x4040404040404040

    pt2m8 : db 0x00
    pt2m16: dw 0x0000
    pt2m32: dd 0x00000000
    pt2m64: dq 0x0000000000000000

    pt4m8 : db 0x00
    pt4m16: dw 0x0000
    pt4m32: dd 0x00000000
    

section .text
    global _start

_start:

pt1:
    mov al , [pt1r8]
    mov bx , [pt1r16]
    mov ecx, [pt1r32]
    mov rdx, [pt1r64]

pt2:
    mov [pt2m8] , al
    mov [pt2m16], bx
    mov [pt2m32], ecx
    mov [pt2m64], rdx

pt3:
    mov al , 0x02
    mov bx , 0x0404
    mov ecx, 0x08080808
    mov rdx, 0x1616161616161616

pt4:
    mov byte  [pt4m8] , 0x12
    mov word  [pt4m16], 0x2424
    mov dword [pt4m32], 0x36363636

fim:
    mov rax, 60
    mov rdi, 0
    syscall
