%include "io.mac"

.DATA
	msg: db "Bienvenido al generador de ADN, ingrese la cantidad que desea: ",0
	msg_2: db "Digite el nombre del archivo a generar y no olvide la extensión (.adn): ",0
	msg_3: db "Su archivo con extensión .adn ha sido creado porfavor si desea crear otro archivo corra nuevamente el programa",0
	;;;;;preg: db "Desea crear otra secuencia de ADN?(S/n): ",0;;;;; No sirve se cae
	fd: dd 0

.UDATA
	tamTEXT:   	rest 32
	secuencia: 	rest 32
	numRandom: 	rest 32
	cadena:    	rest 32
	filename: 	resb 32
	res 		resb 1

.CODE
    .STARTUP
    
main:

	call lecturaDatos
	nwln
	call creaArchivo
	;;;;;;;;;;;;;;;call pregunta
	call salir


lecturaDatos:
	PutStr msg
	GetInt [tamTEXT]
	mov CX,	[tamTEXT]
	PutStr msg_2
	GetStr filename
	xor edi,	edi
	call Generador
	PutStr cadena
	nwln
	PutStr msg_3
	ret	

Generador:

	call random
	mov AL, [secuencia]
	mov byte[cadena + edi], AL
	inc edi
	loop Generador
	ret

random:
	
	xor EAX, EAX		;limpio el eax					
	RDTSC			;para el random	
	and EAX, 0FFH		
	mov EBX, 4		; muevo al ebx un 4 
	xor EDX, EDX		; limpio el edx 
	div EBX			; divido (modulo) entre 4
	mov EAX, EAX 		; paso el resultado random(0, 1, 2, 3) al eax

	
	cmp eax, 0		;aca en caso de que el random sea 0 es adenina, 1 es citocina, 2 es timina y 3 es guanina 
	je adenina			
	cmp EAX, 1
	je citosina
	cmp EAX, 2
	je timina
	jmp guanina
	ret

adenina:
	mov byte[secuencia],"A"
	ret

citosina:
	mov byte[secuencia],"C"
	ret

timina:
	mov byte[secuencia],"T"
	ret

guanina:
	mov byte[secuencia],"G"
	ret


creaArchivo:

	mov EAX, 8 			; Crea el Archivo
        mov EBX, filename 		; Asigna el nombre del Archivo
        mov ECX, 644O 
        int 80h 			;interrupcion al sistema
        mov [fd], eax 	
	mov EAX, 4 			; Escribe en el Archivo
        mov EBX, [fd],
        mov ECX, cadena			
        mov EDX, [tamTEXT]
        int 80h				;interrupcion al sistema
	mov EAX, 6 			; close
        mov EBX, [fd]
        int 80h				;interrupcion al sistema
	ret

;;;;;;;;esta parte preguntaba si el usuario queria volver a correr e lprograma sin cerrarlo pero se cae;;;;;;;;;;;;;;;;	
pregunta:

	PutStr preg
	GetStr res
	cmp byte[res], "S"
	je main
	jne salir
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

salir:
     .EXIT
