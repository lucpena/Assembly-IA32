; nasm sample.asm -f elf32 -o sample.o && ld sample.o -m elf_i386 -o sample && ./sample

section .data
    hello_msg   db "Hello, world!", 0

section .text
    global _start

_start:

    ; Push the string address onto the stack
    push hello_msg                   ; Push the address of the string onto the stack

    ; Calculate the length of the string
    mov ecx, 0                   ; Initialize a counter to 0
    mov esi, hello_msg               ; Move the address of the string to esi register
    count_loop:
        cmp byte [esi], 0        ; Compare the byte at esi with 0 (end of string)
        je end_count             ; Jump to end_count if the byte is 0 (end of string)
        inc esi                  ; Increment esi to point to the next character
        inc ecx                  ; Increment the counter
        jmp count_loop           ; Jump back to count_loop to continue counting
    end_count:

    ; Write the string to stdout
    mov eax, 4                   ; sys_write system call
    mov ebx, 1                   ; file descriptor (stdout)
    mov edx, ecx                 ; Move the string length (counter) to edx
    pop ecx                      ; Pop the address of the string from the stack to ecx
    int 0x80                     ; Call the kernel to write the string to stdout

    call exit

exit:
    ; exit system call
    mov eax, 1                  ; sys_exit system call
    xor ebx, ebx                ; exit status (0)
    int 0x80                    ; call the kernel
