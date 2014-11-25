
archivo: archivo.o
	ld -m elf_i386 -o archivo archivo.o io.o
archivo.o: archivo.asm
	nasm -f elf -g -F stabs archivo.asm -l archivo.lst
