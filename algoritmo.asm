
;La siguiente parte de código son tags para hacer más legible el código;
	sys_exit 		equ 	1
	sys_read 		equ 	3
	sys_write 		equ 	4
	sys_open 		equ 	5	
	sys_close 		equ 	6
	sys_create 		equ 	8
	stdin 			equ		0
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

;-------------------------------------------------------------------------------------------------------

SECTION .text


global _start 
	
_start:

	nop

;;;preguntar por el nombre del primer archivo	
Preguntar_Nombre_1:
	mov ecx, msg1		;muevo al ecx el mensaje al usuario
	mov edx, lenmsg1	;muevo al edx el largo
	call MostrarTexto	;llamo al procedimiento de imprimir en pantalla

	;leo de usuario un texto
	mov ecx, input_1	;muevo al ecx el puntero del buffer de almacenamiento

	mov edx, lenInput_1		;muevo la catidad de caracteres maxima q puedo tener

	call LeerTexto		;llamo al procedimiento de recibir de teclado

	dec eax				;en el eax tengo el largo del mensaje, lo decremento
	mov byte[input_1+eax],0h	;cambio el ultimo caracter por un null
	

;;;;abrir el archivo 
.Abrir_archivo_1:			
	mov eax, sys_open		;muevo al eax la directiva de abrir archivo
	mov ebx, input_1  		;muevo al ebx el nombre de lo que quiero abrir

	mov ecx, 2				;muevo permisos que tendra el archivo
	int 80h					;interrupcion del sistema
	push eax				;salvo el FD
	test eax, eax 			;primero nos aseguramos que abrio bien
	js	error				;no es asi? imprime mensaje de error
	mov	ebx, eax			;paso al ebx el FD
	mov	ecx, archivo_1   	;paso el puntero del buffer con el archivo

	mov	edx, LenArchivo_1	;y su len correspondiente
	mov	eax, sys_read		;y llamo a read de dicho archivo
	int 80h					;interrupcion del sistema
	pop ebx					;saco el FD de la pila
	push eax				;salvo la cantidad de digitos
	mov eax, sys_close 		;muevo la directiva de cerrar el archivo
	int 80h	



;preguntar por el nombre del segundo archivo	
Preguntar_Nombre_2:
	mov ecx, msg2			;muevo al ecx el mensaje al usuario
	mov edx, lenmsg2	    ;muevo al edx el largo
	call MostrarTexto  		;llamo al procedimiento de imprimir en pantalla

	;leo de usuario un texto
	mov ecx, input_2		;muevo al ecx el puntero del buffer de almacenamiento

	mov edx, lenInput_2 	;muevo la catidad de caracteres maxima q puedo tener

	call LeerTexto 			;llamo al procedimiento de recibir de teclado
	dec eax 				;en el eax tengo el largo del mensaje, lo decremento
	mov byte[input_2+eax],0h	;cambio el ultimo caracter por un null



;abrir el archivo 
.Abrir_archivo_2:			
	mov eax, sys_open 		;muevo al eax la directiva de abrir archivo
	mov ebx, input_2	 	;muevo al ebx el nombre de lo que quiero abrir

	mov ecx, 2				;muevo permisos que tendra el archivo
	int 80h		      		;interrupcion del sistema
	push eax				;salvo el FD
	test eax, eax 			;primero nos aseguramos que abrio bien
	js	error				;no es asi? imprime mensaje de error
	mov	ebx, eax			;paso al ebx el FD
	mov	ecx, archivo_2	 	;paso el puntero del buffer con el archivo
	mov	edx, LenArchivo_2	;y su len correspondiente
	mov	eax, sys_read		;y llamo a read de dicho archivo
	int 80h					;interrupcion del sistema
	pop ebx					;saco el FD de la pila
	push eax				;salvo la cantidad de digitos
	mov eax, sys_close 		;muevo la directiva de cerrar el archivo
	int 80h		

MostrarTexto:
    mov     eax, sys_write
    mov     ebx, stdout
    int     80h 
    ret


LeerTexto:
    mov ebx, stdin
    mov eax, sys_read
    int 80H
    ret



;mostrar en pantalla si ocurrio un error al abrir el archivo
error:
	mov ecx, errorMsg
	mov edx, lenErrorMsg
	call MostrarTexto
	jmp Cerrar



;llena la primera fila de ceros en la matriz
fila_fill_zero:
	pop eax			;saco el largo del 2do archivo
	pop edx			;saco el largo del primer archivo
	push edx		;los vuelvo a salvar
	push eax
	mov ecx, 0		;limpio el ecx para usarlo como contador


cycle:
	mov byte[matriz+ecx], 0		;muevo a la matriz un cero
	inc ecx						;incremento el contador
	cmp ecx, edx				;pregunto si ya llene la primera fila
	jne cycle					;si no lo he llenada, siga llenando
	pop ebx		     			;saco el largo del 2do archivo
	pop eax						;saco el largo del primer archivo
	push eax					;los vuelvo a salvar
	push ebx
	xor edx, edx				
	mul ebx           			;multiplico los largos para sacar el area de la matriz

	mov edx, eax				;muevo al edx el area



;llena de ceros la primera columna de la matriz
col_fill_zero:
	mov byte[matriz+ecx], 0   	;muevo a la matriz un cero
	add ecx, eax				;sumo al contador para que quede inicie en la siguiente columna

	cmp ecx, edx				;pregunto si ya termino
	jne col_fill_zero			;si no lo es sigo llenando
	
	pop eax						;saco el largo del 2do archivo
	pop ecx						;saco el largo del primer archivo
	push ecx					;los vuelvo a salvar
	push eax
	inc ecx						;incremento el tamaño de la fila para quedar en la pos [1,1] de la matriz



;---------------------------------------------------------------------------------------------------



Cerrar:
	mov edx,1
	mov ecx, enter
	call MostrarTexto
	mov eax, sys_exit  			;muevo la variabla sys_close al eax
	int 80h		  				;llamo a la interrupcion de kernel

