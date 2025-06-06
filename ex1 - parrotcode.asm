; Aula 07 - Controle de Fluxo de Execucao
; Atividade: Parrot Code whitout "unwanted feature"
;   dica: onde estão os caracteres que não foram lidos ainda?

%define maxChars 10

section .data
   strOla : db "Digite algo: "
   strOlaL: equ $ - strOla

   strBye : db "Você digitou: "
   strByeL: equ $ - strBye

   strLF  : db 10 ; quebra de linha
   strLFL : equ 1

section .bss
   strLida  : resb maxChars
   strLidaL : resd 1

section .text
	global _start

_start:
   ; ssize_t write(int fd , const void *buf, size_t count);
   ; rax     write(int rdi, const void *rsi, size_t rdx  );
   mov rax, 1  ; WRITE
   mov rdi, 1
   lea rsi, [strOla]
   mov edx, strOlaL
   syscall

leitura:
   mov dword [strLidaL], maxChars

   ; ssize_t read(int fd , const void *buf, size_t count);
   ; rax     read(int rdi, const void *rsi, size_t rdx  );
   mov rax, 0  ; READ
   mov rdi, 1
   lea rsi, [strLida]
   mov edx, [strLidaL]
   syscall

   mov [strLidaL], eax

resposta:
   mov rax, 1  ; WRITE
   mov rdi, 1
   lea rsi, [strBye]
   mov edx, strByeL
   syscall

   mov rax, 1  ; WRITE
   mov rdi, 1
   lea rsi, [strLida]
   mov edx, [strLidaL]
   syscall

   ; nao pular linha se tamanho < maxChars
   cmp eax, maxChars
   jl fim

   mov al, [strLida + 9]
   cmp al, 10
   je fim

   ; NAO CONSEGUI FAZER O TRECO DE LIMPAR O BUFFER

quebradeLinha:
   mov rax, 1  ; WRITE
   mov rdi, 1
   lea rsi, [strLF]
   mov edx, strLFL
   syscall

fim:
   ; void _exit(int status);
   ; void _exit(int rdi   );
   mov rax, 60
   mov rdi, 0
   syscall
