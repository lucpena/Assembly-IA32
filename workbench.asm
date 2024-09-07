section .data

    num1    dd      100
    num2    dd      100

    buffer  db      '0000000000', 0

    msg     db      'The result is: ', 0x10
    msg_len equ     $-msg

    nwln     db      0x10, 0xA

section .bss

    result  resd    1

section .text
    global _start

_start:

    push dword[num1]
    push dword[num2]
    call add
    mov [result], eax

    ; mov ecx, 10
    ; mov edi, buffer + 9

    ; push dword[num1]
    ; push dword[num2]
    ; push ebx
    ; push ecx
    ; push edi

    ; call itoa

    ; mov eax, 4
    ; mov ebx, 1
    ; mov ecx, msg
    ; mov edx, msg_len
    ; int 0x80

    ; mov eax, buffer + 9
    ; sub eax, edi
    ; mov edx, eax
    ; mov eax, 4
    ; mov ebx, 1
    ; lea ecx, [edi + 1] 
    ; int 0x80

    ; mov eax, 4
    ; mov ebx, 1
    ; mov ecx, nwln
    ; mov edx, 2
    ; int 0x80
    
    mov eax, 1
    sub ebx, ebx
    int 0x80

%define Y dword[EBP + 12]
%define X dword[EBP + 8]
; Return Address => [EBP + 4] (CALL)
; EBP => [EBP]  ↓ LOCAL STACK ↓
%define RESULT dword[EBP - 4]

add:
    enter 4, 0

        mov eax, X
        add eax, Y
        
        ; Useless, just to do some tom foolery
        mov RESULT, eax
        mov eax, RESULT        

    leave
    ret    

itoa:
    push ebp
    mov ebp, esp

    sub edx, edx
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz itoa

    ret