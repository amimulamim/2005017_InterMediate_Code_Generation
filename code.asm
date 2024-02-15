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
;--------------------------------; LINE 4
	SUB SP,2
	SUB SP,2
L1 :
		ADD SP, 4
		POP BP
		RET 4
	f ENDP


	g PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 10
	MOV AX,[BP+4]
	PUSH AX
MOV AX,229
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	POP AX
	MOV g1,AX
L3 :
;--------------------------------; LINE 11
	MOV AX,g1
	PUSH AX
	POP AX
	NEG AX
	PUSH AX
	POP AX
	MOV g2,AX
L4 :
		POP BP
		RET 2
	g ENDP


	main PROC
	MOV AX, @DATA
	MOV DS, AX
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 15
	SUB SP,2
	SUB SP,10
	SUB SP,2
L34 :
;--------------------------------; LINE 16
MOV AX,7
	PUSH AX
MOV AX,4
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	MOV AX,DX
	PUSH AX
MOV AX,7
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
MOV AX,2
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP AX
	MOV [BP-2],AX
L33 :
;--------------------------------; LINE 17
	MOV AX,[BP-2]
	CALL println
L32 :
;--------------------------------; LINE 18
MOV AX,1
	PUSH AX
MOV AX,3
	PUSH AX
MOV AX,5
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
MOV AX,8
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
MOV AX,9
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	MOV AX,DX
	PUSH AX
MOV AX,2
	PUSH AX
	POP CX
	LEA SI,b
	SHL CX,1
	ADD SI,CX
	POP AX
	MOV [SI],AX
L31 :
;--------------------------------; LINE 19
MOV AX,2
	PUSH AX
	POP CX
	LEA SI,b
	SHL CX,1
	ADD SI,CX
	MOV AX,[SI]
	PUSH AX
	POP AX
	MOV [BP-14],AX
L30 :
;--------------------------------; LINE 20
	MOV AX,[BP-14]
	CALL println
L29 :
;--------------------------------; LINE 21
MOV AX,2
	PUSH AX
	POP CX
	LEA SI,b
	SHL CX,1
	ADD SI,CX
	MOV AX,[SI]
	PUSH AX
MOV AX,5
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	MOV AX,[BP-2]
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
MOV AX,3
	PUSH AX
	POP CX
	LEA SI,b
	SHL CX,1
	ADD SI,CX
	POP AX
	MOV [SI],AX
L28 :
;--------------------------------; LINE 22
MOV AX,3
	PUSH AX
	POP CX
	LEA SI,b
	SHL CX,1
	ADD SI,CX
	MOV AX,[SI]
	PUSH AX
MOV AX,3
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,12
	MOV DI,BP
	SUB DI,CX
	POP AX
	MOV [DI],AX
L27 :
;--------------------------------; LINE 23
MOV AX,3
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,12
	MOV DI,BP
	SUB DI,CX
	MOV AX,[DI]
	PUSH AX
	POP AX
	MOV [BP-14],AX
L26 :
;--------------------------------; LINE 24
	MOV AX,[BP-14]
	CALL println
L25 :
;--------------------------------; LINE 25
MOV AX,3
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,12
	MOV DI,BP
	SUB DI,CX
	MOV AX, [DI]
	PUSH AX
	INC W.[DI]
L24 :
;--------------------------------; LINE 26
MOV AX,3
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,12
	MOV DI,BP
	SUB DI,CX
	MOV AX,[DI]
	PUSH AX
	POP AX
	MOV [BP-14],AX
L23 :
;--------------------------------; LINE 27
	MOV AX,[BP-14]
	CALL println
L22 :
;--------------------------------; LINE 28
MOV AX,3
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,12
	MOV DI,BP
	SUB DI,CX
	MOV AX, [DI]
	PUSH AX
	DEC W.[DI]
L21 :
;--------------------------------; LINE 29
MOV AX,3
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,12
	MOV DI,BP
	SUB DI,CX
	MOV AX, [DI]
	PUSH AX
	DEC W.[DI]
L20 :
;--------------------------------; LINE 30
MOV AX,3
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,12
	MOV DI,BP
	SUB DI,CX
	MOV AX,[DI]
	PUSH AX
	POP AX
	MOV [BP-14],AX
L19 :
;--------------------------------; LINE 31
	MOV AX,[BP-14]
	CALL println
L18 :
;--------------------------------; LINE 32
MOV AX,5
	PUSH AX
MOV AX,3
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,12
	MOV DI,BP
	SUB DI,CX
	POP AX
	MOV [DI],AX
L17 :
;--------------------------------; LINE 33
MOV AX,3
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,12
	MOV DI,BP
	SUB DI,CX
	MOV AX,[DI]
	PUSH AX
	POP AX
	MOV [BP-14],AX
L16 :
;--------------------------------; LINE 34
	MOV AX,[BP-14]
	CALL println
L15 :
;--------------------------------; LINE 36
	MOV AX,[BP-2]
	CALL println
L14 :
;--------------------------------; LINE 37
	MOV AX, [BP-2]
	PUSH AX
	INC W.[BP-2]
L13 :
;--------------------------------; LINE 38
	MOV AX,[BP-2]
	CALL println
L12 :
;--------------------------------; LINE 39
	MOV AX, [BP-2]
	PUSH AX
	DEC W.[BP-2]
L11 :
;--------------------------------; LINE 40
	MOV AX, [BP-2]
	PUSH AX
	DEC W.[BP-2]
L10 :
;--------------------------------; LINE 41
	MOV AX, [BP-2]
	PUSH AX
	DEC W.[BP-2]
L9 :
;--------------------------------; LINE 42
	MOV AX,[BP-2]
	CALL println
L8 :
;--------------------------------; LINE 44
MOV AX,212
	PUSH AX
	CALL g
L7 :
;--------------------------------; LINE 45
	MOV AX,g1
	CALL println
L6 :
;--------------------------------; LINE 46
	MOV AX,g2
	CALL println
L35 :
		ADD SP, 14
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
