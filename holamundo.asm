%include "io.mac"

   section .text

    global _start

        _start:
                    mov EAX, 8
                    mov EBX, filename
                    mov ECX, 0700
                    int 0x80
                    mov EBX, EAX
                    mov EAX, 4
                    mov ECX, texto
                    mov EDX, textlen
                    int 0x80
                    mov EAX, 6
                    int 0x80
                    mov eax, 1
                    int 0x80

    section .data

        filename db "./output.txt", 0
        texto db "prueba", 0
        textlen equ $ - texto
