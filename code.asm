.MODEL SMALL
.STACK 1000H
.Data
number DB "00000$"
	a DW 1 DUP (0000H)
	b DW 1 DUP (0000H)
.CODE
	f PROC
	PUSH BP
	MOV BP, SP
	SUB SP,2
	SUB SP,2
	SUB SP,2
	MOV AX,[BP+6]
	PUSH AX
MOV AX,3
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
MOV AX,10
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	POP AX
	MOV [BP+6],AX
	MOV AX,[BP+6]
	CALL println
	MOV AX,[BP+4]
	PUSH AX
	CALL cc
MOV AX,2
	PUSH AX
	POP AX
	MOV [BP-2],AX
MOV AX,3
	PUSH AX
	POP AX
	MOV [BP-4],AX
Label1 : 
		ADD SP, 6
		POP BP
		RET 4
	f ENDP


	cc PROC
	PUSH BP
	MOV BP, SP
	SUB SP,2
	SUB SP,2
	MOV AX,[BP+4]
	PUSH AX
MOV AX,2
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP AX
	MOV [BP+4],AX
	MOV AX,[BP+4]
	CALL println
	MOV AX,[BP+4]
	PUSH AX
	CALL d
MOV AX,11
	PUSH AX
	POP AX
	MOV [BP-4],AX
	MOV AX,[BP-4]
	CALL println
Label2 : 
		ADD SP, 4
		POP BP
		RET 2
	cc ENDP


	d PROC
	PUSH BP
	MOV BP, SP
	SUB SP,2
	SUB SP,2
	MOV AX,[BP+4]
	PUSH AX
MOV AX,2
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP AX
	MOV [BP+4],AX
	MOV AX,[BP+4]
	CALL println
	MOV AX,[BP+4]
	PUSH AX
	CALL e
	MOV AX,[BP+4]
	CALL println
MOV AX,55
	PUSH AX
	POP AX
	MOV [BP-4],AX
	MOV AX,[BP-4]
	CALL println
Label3 : 
		ADD SP, 4
		POP BP
		RET 2
	d ENDP


	testing PROC
	PUSH BP
	MOV BP, SP
Label4 : 
		POP BP
		RET 4
	testing ENDP


	e PROC
	PUSH BP
	MOV BP, SP
	MOV AX,[BP+4]
	PUSH AX
MOV AX,2
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP AX
	MOV [BP+4],AX
	MOV AX,[BP+4]
	CALL println
	MOV AX,[BP+4]
	PUSH AX
MOV AX,3
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
MOV AX,10
	PUSH AX
	CALL testing
Label5 : 
		POP BP
		RET 2
	e ENDP


	k PROC
	PUSH BP
	MOV BP, SP
	SUB SP,2
MOV AX,17
	PUSH AX
	POP AX
	MOV [BP-2],AX
	MOV AX,[BP-2]
	CALL println
MOV AX,26
	PUSH AX
	POP AX
	MOV a,AX
MOV AX,13
	PUSH AX
	MOV AX,a
	PUSH AX
	CALL f
	MOV AX,a
	CALL println
	MOV AX,a
	PUSH AX
MOV AX,10
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	MOV AX,DX
	PUSH AX
	POP AX
	MOV b,AX
Label6 : 
		ADD SP, 2
		POP BP
		RET
	k ENDP


	main PROC
	MOV AX, @DATA
	MOV DS, AX
	PUSH BP
	MOV BP, SP
	CALL k
	MOV AX,b
	CALL println
Label7 : 
		POP BP
		MOV AX, 4CH
		INT 21H
	main ENDP



new_line proc
    push ax
    push dx
    mov ah,2
    mov dl,0Dh
    int 21h
    mov ah,2
    mov dl,0Ah
    int 21h
    pop dx
    pop ax
    ret
new_line endp

println proc  ;print what is in ax
    push ax
    push bx
    push cx
    push dx
    push si
    lea si,number
    mov bx,10
    add si,4
    cmp ax,0
    jnge negate
    print:
    xor dx,dx
    div bx
    mov [si],dl
    add [si],'0'
    dec si
    cmp ax,0
    jne print
    inc si
    lea dx,si
    mov ah,9
    int 21h
    call new_line
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
    negate:
    push ax
    mov ah,2
    mov dl,'-'
    int 21h
    pop ax
    neg ax
    jmp print
    println endp
END main
