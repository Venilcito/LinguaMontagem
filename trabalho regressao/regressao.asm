; nasm -f elf64 regressao.asm
; gcc -m64 -no-pie regressao.o -o regressao.x

extern printf
extern fopen
extern fscanf
extern fprintf
extern fclose

section .data
    arq_saida : db "resultado.txt", 0
    leitura_xy : db "%f %f", 0
    modo_r : db "r", 0
    modo_a : db "a+", 0
    string_scanf : db "Execução %d",10,"============",10,"Coeficiente a: %f",10,"Coeficiente b: %f",10,"============", 10, 0
    string_result : db "Execução %02d",10,"============",10,"Coeficiente a: %.2lf",10,"Coeficiente b: %.2lf",10,"============", 10, 0

section .bss
    exec : resd 1
    
    x : resd 1
    y : resd 1
    
    somaX : resd 1
    somaY : resd 1
    somaXY: resd 1
    somaX2: resd 1

    coefA : resd 1
    coefB : resd 1
    n     : resd 1

    desc1 : resd 1
    desc2 : resd 1
    desc3 : resd 1

section .text
    global main

main:
    push rbp
    mov rbp, rsp
    and rsp, -16       ; alinhando 16 bytes (prof que falou, eu nao sei oq isso faz)

    ; zerar td p n dar problema
    mov dword [somaX], 0
    mov dword [somaY], 0
    mov dword [somaXY], 0
    mov dword [somaX2], 0
    mov dword [n], 0

    ; abrindo aqruivo com fopen
    mov rdi, [rsi+8]
    mov rsi, modo_r
    xor rax, rax
    call fopen

    mov r12, rax

regresso: ; nosso while(true)
    ; lendo o trem tem q usar o fscanf(r12, lido, x, y)
    mov rdi, r12
    lea rsi, [leitura_xy]
    lea rdx, [x]
    lea rcx, [y]
    xor rax, rax
    call fscanf
    ; ver se é EOF
    cmp eax, -1
    je resultado ; break
    
    movss xmm0, dword [x]
    movss xmm1, dword [y]

    ; somaX += x
    movss xmm2, dword [somaX]
    addss xmm2, xmm0
    movss dword [somaX], xmm2

    ; somaY += y
    movss xmm2, dword [somaY]
    addss xmm2, xmm1
    movss dword [somaY], xmm2

    ; somaXY += x * y
    movss xmm2, xmm0
    mulss xmm2, xmm1 ; xmm2 = x*y
    movss xmm3, dword [somaXY]
    addss xmm3, xmm2
    movss dword [somaXY], xmm3

    ; somaX2 += x * x
    movss xmm2, xmm0
    mulss xmm2, xmm0
    movss xmm3, dword [somaX2]
    addss xmm3, xmm2
    movss dword [somaX2], xmm3

    ; n++
    mov eax, dword [n]
    add eax, 1
    mov dword [n], eax

    jmp regresso

resultado:
    ; converter o n pra float p n dar ruim
    mov eax, dword [n]
    cvtsi2ss xmm7, eax

    movss xmm0, dword [somaXY]
    movss xmm1, dword [somaX]
    movss xmm2, dword [somaY]
    movss xmm3, dword [somaX2]

    ; resultado 1 = n * somaXY - somaX * somaY
    movss xmm4, xmm7 ; xmm4 = n
    mulss xmm4, xmm0 ; xmm4 = n * somaXY

    movss xmm5, xmm1 ; xmm5 = somaX
    mulss xmm5, xmm2 ; xmm5 = somaX * somaY
    
    subss xmm4, xmm5 ; resultado = xmm4 - xmm5

    ; resultado 2 = n * somaX2 - somaX * somaX
    movss xmm6, xmm7 ; xmm6 = n
    mulss xmm6, xmm3 ; xmm6 = n * somaX2

    movss xmm5, xmm1 ; xmm5 = somaX
    mulss xmm5, xmm1 ; xmm5 = somaX * somaX

    subss xmm6, xmm5 ; resultado = xmm6 - xmm5

    ; ccoefA = xmm4 / xmm6
    divss xmm4, xmm6
    movss dword [coefA], xmm4

    ; coefB = (somaT - coefA * somaX) / n
    movss xmm5, dword [coefA] ; xmm5 = coefA
    movss xmm6, xmm1 ; xmm 6 = somaX
    mulss xmm5, xmm6 ; xmm5 = coefA * somaX

    movss xmm6, dword [somaY] ; xmm6 = somaY
    subss xmm6, xmm5 ; somaY - coefA*somaX(xmm5)

    ; coefB = xmm6 / xmm7
    divss xmm6, xmm7
    movss dword [coefB], xmm6

saida:
    ; abrir arquivo de saída
    lea rdi, [arq_saida]
    lea rsi, [modo_a]
    xor rax, rax
    call fopen
    mov r13, rax

    mov dword [exec], 0

exec_loop:
    ; exec++
    mov eax, dword [exec]
    add eax, 1
    mov dword [exec], eax

    ; ler o arquivo de saída pra contar quantas execuções teve
    mov rdi, r13
    lea rsi, [string_scanf]
    lea rdx, [desc1] ; variáveis de descarte só pra ler
    lea rcx, [desc2]
    lea r8, [desc3]
    
    xor rax, rax
    call fscanf
    ; verificar o EOF
    cmp eax, -1
    jne exec_loop

final_mente:
    ;printf no arquivo de saida
    mov rdi, r13
    lea rsi, [string_result]
    mov edx, dword [exec]
    mov rax, 1

    movss xmm0, dword [coefA]
    cvtss2sd xmm0, xmm0
    
    movss xmm1, dword [coefB]
    cvtss2sd xmm1, xmm1

    call fprintf

fim:
    ; fechar os arquivos td, se n né... más práticas aí
    mov rdi, r12
    call fclose
    mov rdi, r13
    call fclose

    mov rsp, rbp
    pop rbp

    mov eax, 0
    ret