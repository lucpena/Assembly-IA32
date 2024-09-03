#!/bin/bash

# Verifica se o usuário forneceu um nome de arquivo
if [ -z "$1" ]; then
    echo "Uso: $0 <nome_do_arquivo_asm>"
    exit 1
fi

# Nome do arquivo de origem (sem extensão)
SOURCE="$1"

# Verifica se o arquivo .asm existe
if [ ! -f "${SOURCE}.asm" ]; then
    echo -e "\nErro: Arquivo ${SOURCE}.asm não encontrado!\n"
    exit 1
fi

# Nome do arquivo objeto intermediário
OBJECT="${SOURCE}.o"

# Nome do executável final
EXECUTABLE="${SOURCE}"

# Compilar o código Assembly com NASM
nasm "${SOURCE}.asm" -f elf32 -o "$OBJECT"
if [ $? -ne 0 ]; then
    echo -e "\nErro na compilação do NASM\n"
    exit 1
fi

# Linkar o arquivo objeto com LD
ld "$OBJECT" -m elf_i386 -o "$EXECUTABLE"
if [ $? -ne 0 ]; then
    echo -e "\nErro no link edit\n"
    exit 1
fi

# Executar o programa
./"$EXECUTABLE"