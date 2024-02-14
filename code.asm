.MODEL SMALL
.STACK 1000H
.Data
number DB "00000$"
.CODE
	main PROC
		MOV AX, @DATA
		MOV DS, AX
		PUSH BP
		MOV BP, SP
	SUB SP,2
	SUB SP,2
	SUB SP,6
MOV AX,1
	PUSH AX
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
MOV AX,3
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	MOV AX,DX
	PUSH AX
	POP AX
	MOV [BP-2],AX
MOV AX,1
	PUSH AX
MOV AX,5
	PUSH AX
	POP AX
	MOV [BP-4],AX
MOV AX,2
	PUSH AX
MOV AX,0
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,10
	MOV DI,BP
	SUB DI,CX
	POP AX
	MOV [DI],AX
	MOV AX,[BP-2]
	PUSH AX
	MOV AX,[BP-4]
	PUSH AX
MOV AX,0
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,10
	MOV DI,BP
	SUB DI,CX
	MOV AX, [DI]
	PUSH AX
	INC W.[DI]
MOV AX,0
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,10
	MOV DI,BP
	SUB DI,CX
	MOV AX,[DI]
	PUSH AX
MOV AX,1
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,10
	MOV DI,BP
	SUB DI,CX
	POP AX
	MOV [DI],AX
	MOV AX,[BP-2]
	CALL println
	MOV AX,[BP-4]
	CALL println
Label1 : 
		ADD SP, 10
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
