;nasm start.asm -f elf32 -o start.o && ld start.o -m elf_i386 -o start && ./start

section .data

    msg1                db  10, "Bem-vindo. Digite seu nome: ", 0
    msg1_length         equ $-msg1

    msg2                db  "Hola, ", 0
    msg2_length         equ $-msg2

    msg3                db  ", bem-vindo ao programa de CALC IA-32", 10, 10, 0
    msg3_length         equ $-msg3

    msg4                db  "Vai trabalhar com 16 ou 32 bits (digite 0 para 16 e 1 para 32): ", 0
    msg4_length         equ $-msg4

    msg16               db 10, "Modo de precisao 16 bits.", 10, 0
    msg32               db 10, "Modo de precisao 32 bits.", 10, 0

    mode_msg_length     equ 28

    menu                db  10
                        db  "ESCOLHA UMA OPÇÃO:",   10 
                        db  "- 1: SOMA",            10
                        db  "- 2: SUBTRACAO",       10
                        db  "- 3: MULTIPLICACAO",   10
                        db  "- 4: DIVISAO",         10
                        db  "- 5: EXPONENCIACAO",   10
                        db  "- 6: MOD",             10
                        db  "- 7: SAIR",            10, 10
    menu_length         equ $-menu

    msg_op1             db 10, "Entre com o primeiro operando: ", 0
    msg_op1_lenght      equ $-msg_op1

    msg_op2             db 10, "Entre com o segundo operando: ", 0
    msg_op2             equ $-msg_op2

    msg_exit            db 10, "Fim voluntario do programa...", 10
    msg_exit_lenght     equ $-msg-exit


section .bss

    name        resb    32      ; Reserva 32 bytes para o nome do usuario
    precision   resb    1       ; Reserva 1 byte para a precisao
    option      resb    1       ; Reserva 1 byte para a opcao do menu

section .text
    global _start

_start:

    ; Mostra a mensagem de boas vindas.
    push msg1_length
    push msg1
    call print

    ; Adquire uma string e salva em < name >
    push name
    call getStringVariable

    ; Mostra o comeco da segunda mensagem
    push msg2_length
    push msg2
    call print

    ; Calcula tamanho e mostra nome
    push name
    call getStringLength

    push eax
    push name
    call print

    ; Mostra fim da mensagem 
    push msg3_length
    push msg3
    call print

    ; Mostra mensagem de precisao
    push msg4_length
    push msg4
    call print

    ; Adquire precisao
    push precision
    call getStringVariable

    ; Mostra precisao escolhida
    cmp byte[ precision ], '0'
    je modo16                   ; 16 bits se igual a zero
    jne modo32                  ; 32 bits se for diferente de zero

modo16:
    push mode_msg_length
    push msg16
    call print

    ; Mostra o menu
    push menu_length
    push menu
    call print

    ; Adquire a opcao
    push option
    call getStringVariable

    ; Seleciona a opcao
    cmp byte[ option ], '1'
    je soma16
    cmp byte[ option ], '2'
    je sub16
    cmp byte[ option ], '3'
    je mul16
    cmp byte[ option ], '4'
    je div16
    cmp byte[ option ], '5'
    je exp16
    cmp byte[ option ], '6'
    je modo16
    cmp byte[ option ], '7'
    je exit


modo32:
    push mode_msg_length
    push msg32
    call print    

    ; Mostra o menu
    push menu_length
    push menu
    call print

    ; Adquire a operacao desejada
    push option
    call getStringVariable

    ; Seleciona a opcao
    cmp byte[ option ], '1'
    je soma32
    cmp byte[ option ], '2'
    je sub32
    cmp byte[ option ], '3'
    je mul32
    cmp byte[ option ], '4'
    je div32
    cmp byte[ option ], '5'
    je exp32
    cmp byte[ option ], '6'
    je modo32
    cmp byte[ option ], '7'
    je exit


;----------------------------
; Funcoes
;----------------------------

; Operacoes
soma32:

    ret


; Utilidade
print:

    push ebp                    ; Criando a Frame da pilha
    mov ebp, esp

    mov ecx, [ebp + 8]          ; Ponteiro para a mensagem
    xor esi, esi                ; Zerando o contador

    print_loop:
        cmp esi, [ebp + 12]  ; Checa se está no tamanho da mensagem
        jae print_done

        mov eax, 4                  ; Chamada ao sistema com sys_write
        mov ebx, 1                  ; Define o arquivo como o monitor (stdout)     
        mov edx, 1                  ; Numero maximo de bytes para ler
        int 0x80

        ; Incrementar o endereço da string
        inc esi                     ; Incrementa contador
        inc ecx
        jmp print_loop              ; Loop

    print_done:

        mov esp, ebp                ; Finalizando a pilha
        pop ebp
        ret

; Adquire uma string pelo input e a coloca em uma variavel
getStringVariable:

    push ebp                    ; Criando o Frame de pilha
    mov ebp, esp

    mov eax, 3                  ; Chamada ao sistema com sys_read
    mov ebx, 0                  ; Define o arquivo como o teclado (stdin)
    mov ecx, [esp + 8]          ; Buffer para armazenar o nome
    mov edx, 32                 ; Numero maximo de bytes para ler
    int 0x80                    ; Chamada ao Kernel

    mov esp, ebp                ; Finalizando a pilha
    pop ebp
    ret

; Calcula o tamanho de uma string. Retorna em EAX
getStringLength:
    push ebp
    mov ebp, esp

    xor ecx, ecx          ; Zerar o contador
    mov esi, [ebp + 8]    ; Ponteiro para a string

    getStringLengthLoop:
        cmp byte [esi], 0     ; Comparar o byte atual com zero
        je getStringLengthEnd ; Sai se encontrar o byte nulo
        cmp byte [esi], 10    ; Comparar o byte atual com 10 (quebra de linha)
        je getStringLengthEnd ; Sai se encontrar a quebra de linha
        inc ecx               ; Incrementar o contador
        inc esi               ; Avançar para o próximo caractere
        jmp getStringLengthLoop
    getStringLengthEnd:

    mov eax, ecx          ; Mover o tamanho para o registrador eax
    mov esp, ebp
    pop ebp
    ret

; getInt32:

; getInt16:

exit:

    ; Mensagem de saida voluntaeia do programa
    push msg_exit_lenght
    push msg_exit
    call print

    ; exit system call
    mov eax, 1                  ; sys_exit system call
    xor ebx, ebx                ; exit status (0)
    int 0x80                    ; call the kernel

