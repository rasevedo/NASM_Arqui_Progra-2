
holamundo: holamundo.o
	ld -m elf_i386 -o holamundo holamundo.o io.o
holamundo.o: holamundo.asm
	nasm -f elf -g -F stabs holamundo.asm -l holamundo.lst
