## Compiling

nasm start.asm -f elf32 -o start.o && ld start.o -m elf_i386 -o start && echo -e "\n" && ./start && echo -e "\n"
