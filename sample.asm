section .data
    buffer db "00000", 0   ; Buffer para armazenar o número convertido como string
    result dd 1234         ; Número a ser convertido

section .text
    global _start

_start:
    mov eax, [result]      ; Carrega o número a ser convertido
    mov edi, buffer + 4    ; Aponta para o final da string (de trás para frente)

convert_loop:
        xor edx, edx           ; Limpa EDX para a operação de divisão
        mov ecx, 10            ; Divisão por 10 (base decimal)
        div ecx                ; Divide EAX por 10. Resultado em EAX, resto em EDX
        
        add dl, '0'            ; Converte o resto (o dígito) para ASCII
        mov [edi], dl          ; Armazena o dígito no buffer
        dec edi                ; Move para o próximo caractere (esquerda)

        test eax, eax          ; Verifica se EAX é 0 (fim da conversão)
    jnz convert_loop       ; Se não for, continua a conversão

    ; Calcula o tamanho da string a ser exibida
    mov eax, buffer + 5    ; Ponteiro para o final da string
    sub eax, edi           ; Tamanho da string (quantidade de dígitos)

    ; Exibe o número convertido
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    lea ecx, [edi + 1]     ; Ponteiro para o início da string convertida
    sub edx, edx           ; Limpa o registrador EDX
    mov edx, eax           ; Copia o tamanho da string em EDX
    int 0x80               ; Chamada ao kernel para exibir a string

    ; Saída do programa
    mov eax, 1             ; sys_exit
    xor ebx, ebx           ; Código de saída 0
    int 0x80
