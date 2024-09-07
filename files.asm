section .data

    msg         db 'Este programa ira copiar o conteudo de input e salvar em output...', 0x10, 0xA
    msg_len     equ $-msg

    msg2        db  'Conteudo de Input salvo em Output.', 0x10, 0xA
    msg2_len    equ $-msg2

    input_file  db  'input.txt', 0
    output_file db  'output.txt', 0

    buffer_size equ 128


section .bss

    buffer      resb  128
    input_fd    resd    1
    output_fd   resd    1
    bytes_read  resd    1

section .text
    global _start

_start:

    ; print mensagem
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    ; ler arquivo
    mov eax, 5
    mov ebx, input_file
    mov ecx, 0
    int 0x80
    mov [input_fd], eax

    ; criar arquivo de saida
    mov eax, 8
    mov ebx, output_file
    mov ecx, 0666o
    int 0x80 
    mov [output_fd], eax
    
    ; lendo arquivo de entrada
    read_write_loop:
    
        mov eax, 3
        mov ebx, [input_fd]
        mov ecx, buffer
        mov edx, buffer_size
        int 0x80
        mov [bytes_read], eax

        cmp dword[bytes_read], 0
        je end_read_write
        
        mov eax, 4
        mov ebx, [output_fd]
        mov ecx, buffer
        mov edx, [bytes_read]
        int 0x80
        
        jmp read_write_loop
    
    end_read_write:

    ; fecha os arquivo
    mov eax, 6
    mov ebx, [input_fd]
    int 0x80

    mov eax, 6
    mov ebx, [output_fd]
    int 0x80

    ; mensagem final
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, msg2_len
    int 0x80

    ; fecha programa
    mov eax, 1
    xor ebx, ebx
    int 0x80
