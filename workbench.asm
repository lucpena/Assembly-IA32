section .data

    file_in         db      'input.txt', 0
    file_out        db      'output.txt', 0

    matrix1         db      3, 3, 3, 3, 3, 3, 3, 3, 3
    matrix3         db      3, 3, 3, 3, 3, 3, 3, 3, 3

    space           db      ' ', 0

section .bss

    in_fd           resd    1
    out_fd          resd    1

    matrix2         resb    9
    matrixResult    resb    9

section .text
    global _start

_start:

    mov eax, 5
    mov ebx, file_in
    mov ecx, 0
    int 0x80
    mov [in_fd], eax

    mov eax, 3
    mov ebx, [in_fd]
    mov ecx, matrix2
    mov edx, 9

    mov eax, 5
    mov ebx, file_out 
    mov ecx, 01101o
    mov edx, 0666o
    int 0x80
    mov [out_fd], eax

    mov ecx, 3
    sub ebx, ebx
    sub esi, esi
    sub eax, eax
    sub edx, edx

sum:
    mov al, [matrix1 + ebx + esi]
    mov dl, [matrix3 + ebx + esi]
    add al, dl
    add al, '0'
    mov [matrixResult + ebx + esi], al
    inc esi
    cmp esi, 3
    jb sum
    add ebx, 3
    mov esi, 0
    loop sum

    sub esi, esi    

    mov eax, 4
    mov ebx, [out_fd]
    lea ecx, [matrixResult]
    mov edx, 9
    int 0x80

    mov eax, 6
    mov ebx, [in_fd]
    int 0x80

    mov eax, 6
    mov ebx, [out_fd]
    int 0x80

    mov eax, 1
    sub ebx, ebx
    int 0x80