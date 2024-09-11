section .data

    buffer      db      '0000000000', 0
    buffer_size equ     10

    msg1        db      'Enter the first number: ', 0x10
    msg1_len    equ     $-msg1

    msg2        db      'Enter the second number: ', 0x10
    msg2_len    equ     $-msg2

    msg3        db      'The sum is: ', 0x10
    msg3_len    equ     $-msg3

    nwln        db      0x10, 0xA

section .bss

    num1        resb    buffer_size
    num2        resb    buffer_size

    result      resd    1

section .text
    global _start

_start:

    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, msg1_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, buffer_size
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, msg2_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, buffer_size
    int 0x80
_break:
    push num1
    call atoi
    mov [num1], eax

    push num2
    call atoi
    mov [num2], eax

    push dword[num1]
    push dword[num2]
    call add
    mov [result], eax

    mov edi, buffer + 9
    mov eax, [result]
    call itoa

    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, msg3_len
    int 0x80

    mov eax, buffer + 10
    sub eax, edi
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    lea ecx, [edi + 1] 
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, nwln
    mov edx, 2
    int 0x80
    
    mov eax, 1
    sub ebx, ebx
    int 0x80

add:
    %define Y dword[EBP + 12]
    %define X dword[EBP + 8]
    ; Return Address => [EBP + 4] (CALL)
    ; EBP => [EBP]  ↓ LOCAL STACK ↓
    %define RESULT dword[EBP - 4]

    enter 4, 0

        mov eax, X
        add eax, Y
        
        ; Useless, just to do some tom foolery
        mov RESULT, eax
        mov eax, RESULT        

    leave
    ret    

itoa:
    enter 0,0
    
    itoa_loop:

        sub edx, edx
        mov ecx, 10
        div ecx
        add dl, '0'
        mov [edi], dl
        dec edi
        test eax, eax
        jnz itoa_loop

    leave
    ret 8

atoi:
    %define VALUE [EBP + 8]
    ; Return Address => [EBP + 4] (CALL)
    ; EBP => [EBP]  ↓ LOCAL STACK ↓
    enter 0,0

    sub eax, eax
    sub ebx, ebx 
    
    mov esi, VALUE
       
    atoi_loop:

        mov bl, byte[esi]
        cmp bl, 0xA ; new line
        je atoi_loop_end
        cmp ebx, 0 ; null char frum ASCII, not number '0'
        je atoi_loop_end
        sub bl, '0' ; here's number '0'
        imul eax, eax, 10
        add eax, ebx
        inc esi
        jmp atoi_loop

    atoi_loop_end:

    leave
    ret 4