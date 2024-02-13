.MODEL SMALL
.STACK 1000H
.Data
number DB "00000$"
	g1 DW 1 DUP (0000H)
	g2 DW 1 DUP (0000H)
	a DW 1 DUP (0000H)
	b DW 9 DUP (0000H)
.CODE
	f PROC
		PUSH BP
		MOV BP, SP
Label1 : 
		POP BP
		RET 2
	f ENDP
	main PROC
		MOV AX, @DATA
		MOV DS, AX
		PUSH BP
		MOV BP, SP
	SUB SP,2
	SUB SP,10
MOV AX,7
	PUSH AX
MOV AX,3
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	MOV AX,DX
	PUSH AX
MOV AX,5
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
MOV AX,2
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	MOV AX,[BP-2]
	PUSH AX
	CALL println
	PUSH AX
MOV AX,5
	PUSH AX
MOV AX,3
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	CALL f
	PUSH AX
Label2 : 
		ADD SP, 12
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
