
;La siguiente parte de código son tags para hacer más legible el código;
	sys_exit 		equ 	1
	sys_read 		equ 	3
	sys_write 		equ 	4
	sys_open 		equ 	5	
	sys_close 		equ 	6
	sys_create 		equ 	8
	stdin 			equ	0
	stdout 			equ 	1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION .data

intro:	db	"Algoritmo de Stickman Waterman",0 

msg1:	db	"Introduzca el nombre del primer documento (incluyendo la extension):",10
lenmsg1:	equ $-msg1

msg2:	db	"Introduzca el nombre del segundo documento (incluyendo la extension):",10
lenmsg2:	equ $-msg2

errorMsg:	db	"Error al abrir el archivo",10,10
lenErrorMsg:	equ $-errorMsg

enter:	db	10

SECTION .bss


buffer	resb	100	
	
LenMatriz	equ	1000000
matriz	resb	LenMatriz

lenInput_1	equ	35
input_1	resb	lenInput_1

lenInput_2	equ	35
input_2	resb	lenInput_2

LenArchivo_1	equ	1000000
archivo_1	resb	LenArchivo_1
	
LenArchivo_2	equ	1000000
archivo_2	resb	LenArchivo_2


SECTION .text


global _start 
	
_start:

	nop

;;;preguntar por el nombre del primer archivo;;;	
Preguntar_Nombre_1:
	mov 	ECX, msg1		;muevo al ecx el mensaje al usuario
	mov 	EDX, lenmsg1		;muevo al edx el largo
	call MostrarTexto		;llamo al procedimiento 

	;leo de usuario un texto
	mov 	ECX, input_1		;muevo al ecx el puntero del buffer de almacenamiento

	mov 	EDX, lenInput_1		;muevo la catidad de caracteres maxima q puedo tener

	call LeerTexto			;llamo al procedimiento de recibir de teclado

	dec EAX				;en el eax tengo el largo del mensaje, lo decremento
	mov byte[input_1+EAX],0h	;cambio el ultimo caracter por un null
	

;;;;abrir el archivo;;;;; 
.Abrir_archivo_1:			
	mov 	EAX, sys_open			;muevo al eax la directiva de abrir archivo
	mov 	EBX, input_1  			;muevo al ebx el nombre de lo que quiero abrir

	mov 	ECX, 2				;muevo permisos que tendra el archivo
	int 80h					;interrupcion del sistema
	push EAX				;salvo el FD
	test EAX, EAX 				;primero nos aseguramos que abrio bien
	js	error				;no es asi? imprime mensaje de error
	mov	EBX, EAX			;paso al ebx el FD
	mov	ECX, archivo_1   		;paso el puntero del buffer con el archivo y su len correspondiente

	mov	EDX, LenArchivo_1	
	mov	EAX, sys_read			;y llamo a read de dicho archivo
	int 80h					;interrupcion del sistema
	pop EBX					;saco el FD de la pila
	push EAX				
	mov 	EAX, sys_close 			;muevo la directiva de cerrar el archivo
	int 80h					;interrupcion del sistema



;;;;preguntar por el nombre del segundo archivo;;;;	
Preguntar_Nombre_2:
	mov 	ECX, msg2		;muevo al ecx el mensaje al usuario
	mov 	EDX, lenmsg2	    	;muevo al edx el largo
	call MostrarTexto  		;llamo al procedimiento 

	;leo de usuario un texto
	mov 	ECX, input_2		;muevo al ecx el puntero del buffer de almacenamiento

	mov 	EDX, lenInput_2 	;muevo la catidad de caracteres maxima q puedo tener

	call LeerTexto 			;llamo al procedimiento 
	dec EAX 			;en el eax tengo el largo del mensaje, lo decremento
	mov byte[input_2+EAX],0h	;cambio el ultimo caracter por un null



;;;;abrir el archivo;;;; 
.Abrir_archivo_2:			
	mov 	EAX, sys_open 		;muevo al eax la directiva de abrir archivo
	mov 	EBX, input_2	 	;muevo al ebx el nombre de lo que quiero abrir

	mov 	ECX, 2			;muevo permisos que tendra el archivo
	int 80h		      		;interrupcion del sistema
	push EAX			;salvo el FD
	test EAX, EAX 			;primero nos aseguramos que abrio bien
	js	error				
	mov	EBX, EAX		;paso al ebx el FD
	mov	ECX, archivo_2	 	;paso el puntero del buffer con el archivo y su len correspondiente
	mov	EDX, LenArchivo_2	
	mov	EAX, sys_read		;llamo a read de dicho archivo
	int 80h				;interrupcion del sistema
	pop EBX				;saco el FD de la pila
	push EAX			;salvo la cantidad de digitos
	mov 	EAX, sys_close 		;muevo la directiva de cerrar el archivo
	int 80h				;interrupcion del sistema

MostrarTexto:
    mov     EAX, sys_write		;escribe 
    mov     EBX, stdout
    int     80h 
    ret


LeerTexto:
    mov 	EBX, stdin
    mov 	EAX, sys_read		;read
    int 80h				;interrupcion del sistema
    ret



;mostrar en pantalla si ocurrio un error al abrir el archivo
error:
	mov 	ECX, errorMsg
	mov 	EDX, lenErrorMsg
	call MostrarTexto
	jmp Cerrar



;llena la primera fila de ceros en la matriz
fila_fill_zero:
	pop EAX			;saco el largo del 2do archivo
	pop EDX			;saco el largo del primer archivo
	push EDX		;los vuelvo a salvar
	push EAX
	mov 	ECX, 0		;limpio el ecx para usarlo como contador


cycle:
	mov byte[matriz+ECX], 0			;muevo a la matriz un cero
	inc ECX					;incremento el contador
	cmp ECX, edx				;pregunto si ya llene la primera fila
	jne cycle				;por si no se ha llenado
	pop EVX		     			;saco el largo del 2do archivo
	pop EAX					;saco el largo del primer archivo
	push EAX				;los vuelvo a salvar
	push EBX
	xor EDX, EDX				;limpio el edx				
	mul EBX           			;multiplico para sacar el area de la matriz

	mov 	EDX, EAX			;muevo al edx el area



;llena de ceros la primera columna de la matriz
col_fill_zero:
	mov byte[matriz+ECX], 0   		;muevo a la matriz un cero
	add ECX, EAX				;sumo al contador para que quede iniciado en la siguiente columna

	cmp ECX, EDX				;pregunto si ya termino
	jne col_fill_zero			;por si no se ha llenado
	
	pop EAX					;saco el largo del 2do archivo
	pop ECX					;saco el largo del primer archivo
	push ECX				;los vuelvo a salvar
	push EAX
	inc ECX					;incremento el tamaño de la fila para quedar en la posicion [1,1] de la matriz


;;;para cerrar;;;;
Cerrar:
	mov 	EDX,1
	mov 	ECX, enter
	call MostrarTexto
	mov 	EAX, sys_exit  			;muevo la variable sys_close al eax
	int 80h		  			;llamo a la interrupcion de kernel

