section .data
    hello_msg db "Hello, World!", 10, 0

section .text
    global _start

_start:
    ; write system call
    mov eax, 4                  ; sys_write system call
    mov ebx, 1                  ; file descriptor (stdout)
    mov ecx, hello_msg          ; pointer to the message
    mov edx, 14                 ; message length
    int 0x80                    ; call the kernel

    ; exit system call
    mov eax, 1                  ; sys_exit system call
    xor ebx, ebx                ; exit status (0)
    int 0x80                    ; call the kernel
