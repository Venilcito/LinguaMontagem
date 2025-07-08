; Vinicius Castamann e Eduardo Korte nunca mais foram os mesmos após este código
; Assembly deve ser eliminado de todos os sistemas
; Gambiarras por conta da casa aproveite

section .data
	maxChars equ 1
	nome_saida db "ordenado.txt", 0
	pedir_input db "Digite o nome do arquivo: ", 0
	text_trocas db " Trocas", 10
	text_compar db " Comparacoes", 10

section .bss
	nome_arquivo resb 11
	
	texto: resb 3
	fileHandle: resd 1
	contador: resq 1
	vetor: resb 31
	vetor_index: resq 1
	tamanho: resq 1
	
	buffer: resb 3

	num_compares: resq 1
	num_trocas: resq 1

section .text
	global _start

_start:
	;contador = 0
	mov qword [contador], -1
	;index do vetor = 0
	mov qword [vetor_index], 0
	; tamanho = 0
	mov qword [tamanho], 0
	;comparações = 0
	mov qword [num_compares], 0
	;trocas = 0
	mov qword [num_trocas], 0

	; pedir o nome do arquivo
	mov rax, 1
	mov rdi, 1
	lea rsi, pedir_input
	mov rdx, 26
	syscall

	perfumaria:
		mov rax, 0
		mov rdi, 0
		mov rsi, nome_arquivo
		mov rdx, 11
		syscall
	

; Passo 1 - abrir  arquivo
	mov rax, 2
	lea rdi, [nome_arquivo]
	mov esi, 0
	mov edx, 0
	syscall

	mov [fileHandle], eax

; Passo 2 - ler o arquivo (dã)
	ler_prox_char:
		; contador++
		mov rax, [contador]
		inc rax
		mov [contador], rax

		; endereço de leitura = texto + contador
		lea rsi, [texto + rax]

		; leitura do próximo caractere
		mov rax, 0
		mov edi, [fileHandle]
		mov rdx, maxChars
		syscall
		mov r12, rax ; quantidade de bytes lidos

		; EOF
		cmp r12, 0
		je fim_da_leitura

		; verifica se o char == \n
		mov rbx, [contador]
		mov al, byte [texto + rbx]
		cmp al, 10
		jne ler_prox_char

; Passo 2.2 - Converter o número lido do arquivo
	converter_p_num:
		mov rdx, [contador]
		
		mov al, byte [texto]
		sub al, '0'

		cmp rdx, 1
		je final_conversao
	
	converter_dezena:
		; multiplica por 10 p transformar em dezena
		mov r9, 10
		mul r9

		; pega a unidade do texto
		movzx r10, byte [texto + 1]
		sub r10, '0'
		add al, r10b

; Passo 2.3 - Salvar número no vetor
	final_conversao:
		; guardar valores de r8
		mov rdi, [vetor_index]

		mov [vetor + rdi], al
		inc rdi
		mov [vetor_index], rdi

		; incrementa o tamanho
		mov rax, [tamanho]
		inc rax
		mov [tamanho], rax

	; Resetar tudo e ler proximo valor até achar o EOF	
	mov qword [contador], -1
	xor rax, rax
	mov byte [texto] , 0
	mov byte [texto + 1], 0
	mov byte [texto + 2], 0
	jmp ler_prox_char

	fim_da_leitura:
	; fechar o arquivo aqui
	mov rax, 3
	mov rdi, [fileHandle]
	syscall

; Passo 3 - Mostrar vetor DESordenado
	mov rdx, 0
	mov [contador], rdx

	rodar_vetor_desordenado:
	mov rdx, [contador]
	cmp rdx, [tamanho]
	je acabar_vetor_desordenado

	movzx rbx, byte [contador]
	movzx rax, byte [vetor + rbx] ; pegou o num
	
	; dividir po 10
	xor rdx, rdx
	mov rcx, 10
	div rcx

	add al, '0'
	add dl, '0'

	mov [texto], al
	mov [texto + 1], dl
	mov byte [texto +2], " "

	; escrever no terminal
	mov rax, 1
	mov rdi, 1
	mov rsi, texto
	mov rdx, 3
	syscall

	mov rax, [contador]
	inc rax
	mov [contador], rax
	
	jmp rodar_vetor_desordenado
	
	acabar_vetor_desordenado:
		mov byte [texto], 10

		mov rax, 1
		mov rdi, 1
		mov rsi, texto
		mov rdx, 1
		syscall

; Passo 4 - Fazer a ordenagem
	mov rsi, 0
	xor r15, r15
	xor r14, r14

	leitura:
		cmp rsi, [tamanho]
		jge fim_da_ordenagem

		mov rdi, 0
		mov rcx, [tamanho]
		dec rcx
		sub rcx, rsi

	sort:
		cmp rdi, rcx
		jge proximo
		
		; cmp++
		inc r15

		mov al, [vetor + rdi]
		mov bl, [vetor + rdi + 1]

		cmp al, bl

		jle nao_troca
				
		mov [vetor + rdi], bl
		mov [vetor + rdi + 1], al

		inc r14

	nao_troca:
		inc rdi
		jmp sort

	proximo:
		inc rsi
		jmp leitura

	fim_da_ordenagem:
	;terminou, só p debugar no gdb
		
		; MOSTRAR AS COMPARAÇÕES
		mov [num_compares], r15
		mov rax, qword [num_compares]
		
		xor rdx, rdx
		mov rcx, 10
		div rcx

		add dl, '0'
		mov byte [texto + 2], dl

		xor rdx, rdx
		mov rcx, 10
		div rcx

		add al, '0'
		mov byte [texto], al
		add dl, '0'
		mov byte [texto + 1], dl

		mov rax, 1
		mov rdi, 1
		mov rsi, texto
		mov rdx, 3
		syscall

		mov byte [texto], 10
		mov rax, 1
		mov rdi, 1
		mov rsi, text_compar
		mov rdx, 13
		syscall

		; MOSTRAR AS TROCAS
		mov [num_trocas], r14
		mov rax, qword [num_trocas]
		
		xor rdx, rdx
		mov rcx, 10
		div rcx

		add dl, '0'
		mov byte [texto + 2], dl

		xor rdx, rdx
		mov rcx, 10
		div rcx

		add al, '0'
		mov byte [texto], al
		add dl, '0'
		mov byte [texto + 1], dl

		mov rax, 1
		mov rdi, 1
		mov rsi, texto
		mov rdx, 3
		syscall

		mov byte [texto], 10
		mov rax, 1
		mov rdi, 1
		mov rsi, text_trocas
		mov rdx, 8
		syscall

; Passo 5 - Mostrar vetor ordenado
	mov rdx, 0
	mov [contador], rdx

	rodar_vetor_ordenado:
	mov rdx, [contador]
	cmp rdx, [tamanho]
	je acabar_vetor_ordenado

	movzx rbx, byte [contador]
	movzx rax, byte [vetor + rbx] ; pegou o num
	
	; dividir po 10
	xor rdx, rdx
	mov rcx, 10
	div rcx

	add al, '0'
	add dl, '0'

	mov [texto], al
	mov [texto + 1], dl
	mov byte [texto +2], " "

	; escrever no terminal
	mov rax, 1
	mov rdi, 1
	mov rsi, texto
	mov rdx, 3
	syscall

	mov rax, [contador]
	inc rax
	mov [contador], rax
	
	jmp rodar_vetor_ordenado
	
	acabar_vetor_ordenado:
		mov byte [texto], 10

		mov rax, 1
		mov rdi, 1
		mov rsi, texto
		mov rdx, 1
		syscall

; Passo 6 - Salvar vetor um aqruivo .txt
	mov rax, 2
	mov rdi, nome_saida
	mov esi, 577
	mov edx, 0644
	syscall
	mov r12, rax

	; limpar o buffer do texto
	mov byte [texto] , 0
	mov byte [texto + 1], 0
	mov byte [texto + 2], 0

	; escrever os bglh no arquivo
	mov rdx, 0
	mov [contador], rdx

	rodar_vetor:
	mov rdx, [contador]
	cmp rdx, [tamanho]
	je acabar

	movzx rbx, byte [contador]
	movzx rax, byte [vetor + rbx] ; pegou o num
	
	; dividir po 10
	xor rdx, rdx
	mov rcx, 10
	div rcx

	add al, '0'
	add dl, '0'

	mov [texto], al
	mov [texto + 1], dl
	mov byte [texto +2], 10

	; escrever al no arquivo
	escrever_no_arquivo:
		mov rax, 1
		mov rdi, r12
		mov rsi, texto
		mov rdx, 3
		syscall

	mov rax, [contador]
	inc rax
	mov [contador], rax
	
	jmp rodar_vetor

	acabar:
	; fechar o arquivo aqui
	mov rax, 3
	mov rdi, r12
	syscall

_fim:
	mov rax, 60
	mov rdi, 0
	syscall
