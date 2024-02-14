.MODEL SMALL
.STACK 1000H
.Data
number DB "00000$"
	a DW 1 DUP (0000H)
.CODE
	f PROC
		PUSH BP
		MOV BP, SP
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
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	POP AX
	MOV [BP+4],AX
	MOV AX,[BP+4]
	CALL println
MOV AX,17
	PUSH AX
	POP AX
	MOV a,AX
	CALL cc
Label1 : 
		POP BP
		RET 2
	f ENDP
	cc PROC
		PUSH BP
		MOV BP, SP
	MOV AX,a
	PUSH AX
MOV AX,2
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP AX
	MOV a,AX
Label2 : 
		POP BP
		RET
	cc ENDP
	main PROC
		MOV AX, @DATA
		MOV DS, AX
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
	CALL f
	MOV AX,a
	CALL println
Label3 : 
		ADD SP, 2
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
