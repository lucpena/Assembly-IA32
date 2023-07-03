;nasm start.asm -f elf32 -o start.o && ld start.o -m elf_i386 -o start && ./start

section .data
    hello_msg       db 10, "Bem-vindo. Digite seu nome: ", 0
    welcome_msg_s   db "Hola, ", 0
    welcome_msg_e   db ", bem-vindo ao programa de CALC IA-32", 10, 10, 0
    precision_msg   db "Vai trabalhar com 16 ou 32 bits (digite 0 para 16 e 1 para 32): ", 0

section .bss
    name        resb    32      ; Reserva 32 bytes para o nome do usuario
    precision   resb    1       ; Reserva 1  byte para a precisao

    ; TO DO: MANDAR PARA A PILHA
    num1        resb    4       ; Reserva 4 bytes para o primeiro numero
    num2        resb    4       ; Reserva 4 bytes para o segundo numero

section .text
    global _start

_start:

    ; Mostrando a mensagem inicial na tela
    mov eax, 4                  ; Chamada ao sistema com sys_write 
    mov ebx, 1                  ; Define o arquivo como o monitor (stdout)
    mov ecx, hello_msg          ; Ponteiro para a mensagem
    mov edx, 30                 ; Tamanho da mensagem
    int 0x80                    ; Chamada ao Kernel


    ; Lendo o nome do usuario
    mov eax, 3                  ; Chamada ao sistema com sys_read
    mov ebx, 0                  ; Define o arquivo como o teclado (stdin)
    mov ecx, name               ; Buffer para armazenar o nome
    mov edx, 32                 ; Numero maximo de bytes para ler
    int 0x80                    ; Chamada ao Kernel


    ; Mostrando a mensagem na tela
    mov eax, 4                  ; Chamada ao sistema com sys_write
    mov ebx, 1                  ; Define o arquivo como o monitor (stdout)
    mov ecx, welcome_msg_s      ; Ponteiro para o comeco da mensagem
    mov edx, 7                  ; Tamanho da mensagem
    int 0x80                    ; Chamada ao Kernel

    xor ebx, ebx                ; Resets ebx
    mov edi, name               ; Ponteiro para o nome
    mov ecx, 0                  ; Inicializa contador

    get_name_size:
        cmp byte[edi], 10       ; Checa pelo null no final do texto
        je gns_continue         ; Sai se acabar o nome
        inc ecx                 ; Incrementa contador
        inc edi                 ; Vai para o próximo caractere
        jmp get_name_size       ; Loop
    gns_continue:

    mov eax, 4                  ; Chamada ao sistema com sys_write
    mov ebx, 1                  ; Define o arquivo como o monitor (stdout)
    mov edx, ecx                ; Tamanho maximo do nome
    mov ecx, name               ; Ponteiro para o nome do usuario
    int 0x80                    ; Chamada ao Kernel

    mov eax, 4                  ; Chamada ao sistema com sys_write
    mov ebx, 1                  ; Define o arquivo como o monitor (stdout)
    mov ecx, welcome_msg_e      ; Ponteiro para o final da mensagem
    mov edx, 40                 ; Tamanho da mensagem
    int 0x80                    ; Chamada ao Kernel
    ; Fim da mensagem de boas vindas
    
    ; Mostrando a mensagem para a precisao
    mov eax, 4                  ; Chamada ao sistema com sys_write
    mov ebx, 1                  ; Define o arquivo como o monitor
    mov ecx, precision_msg      ; Define o ponteiro para a mensagem
    mov edx, 65                 ; Tamanho da mensagem a ser exibida
    int 0x80

    ; Lendo a precisao
    mov eax, 3                  ; Chamada ao sistema com sys_read
    mov ebx, 0                  ; Define o arquivo como o teclado
    mov ecx, precision          ; Buffer para a precisao
    mov edx, 1                  ; Numero maximo de bytes para ler
    int 0x80                    ; Chamada ao Kernel

    je exit                     ; Sai do programa

exit:
    ; exit system call
    mov eax, 1                  ; sys_exit system call
    xor ebx, ebx                ; exit status (0)
    int 0x80                    ; call the kernel

