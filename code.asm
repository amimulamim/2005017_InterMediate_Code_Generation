.MODEL SMALL
.STACK 1000H
.Data
	number DB "00000$"
	w DW 10 DUP (0000H)
.CODE
main PROC
	MOV AX, @DATA
	MOV DS, AX
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 4
	SUB SP,2
L26:
;--------------------------------; LINE 5
	SUB SP,20
L25:
;--------------------------------; LINE 6
	MOV AX, 2
	PUSH AX
	POP AX
	NEG AX
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	MOV AX, 0
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP CX
	LEA SI,w
	SHL CX,1
	ADD SI,CX
	POP AX
	MOV [SI], AX
	PUSH AX
	POP AX
L24:
;--------------------------------; LINE 7
	MOV AX, 0
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP CX
	LEA SI,w
	SHL CX,1
	ADD SI,CX
	MOV AX,[SI]
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	MOV AX, 0
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP CX
	SHL CX,1
	ADD CX,22
	MOV DI,BP
	SUB DI,CX
	POP AX
	MOV [DI], AX
	PUSH AX
	POP AX
L23:
;--------------------------------; LINE 8
	MOV AX, 0
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP CX
	SHL CX,1
	ADD CX,22
	MOV DI,BP
	SUB DI,CX
	MOV AX,[DI]
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L22:
;--------------------------------; LINE 9
	MOV AX,[BP-2]
	CALL println
L21:
;--------------------------------; LINE 10
	MOV AX, 0
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP CX
	LEA SI,w
	SHL CX,1
	ADD SI,CX
	MOV AX, [SI]
	PUSH AX
	PUSH AX
	INC W.[SI]
	;--------------------------------cond,need = 0 ,0
	MOV AX, 1
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP CX
	SHL CX,1
	ADD CX,22
	MOV DI,BP
	SUB DI,CX
	POP AX
	MOV [DI], AX
	PUSH AX
	POP AX
L20:
;--------------------------------; LINE 11
	MOV AX, 1
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP CX
	SHL CX,1
	ADD CX,22
	MOV DI,BP
	SUB DI,CX
	MOV AX,[DI]
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L19:
;--------------------------------; LINE 12
	MOV AX,[BP-2]
	CALL println
L18:
;--------------------------------; LINE 13
	MOV AX, 0
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP CX
	LEA SI,w
	SHL CX,1
	ADD SI,CX
	MOV AX,[SI]
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L17:
;--------------------------------; LINE 14
	MOV AX,[BP-2]
	CALL println
L16:
;--------------------------------; LINE 16
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L15:
;--------------------------------; LINE 17
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L14:
;--------------------------------; LINE 18
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 1
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L13:
;--------------------------------; LINE 19
	MOV AX,[BP-2]
	CALL println
L12:
;--------------------------------; LINE 20
	SUB SP,2
L11:
;--------------------------------; LINE 21
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 10
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JL L27
	PUSH 0
	JMP L28
L27:
	PUSH 1
L28:
	POP AX
	MOV [BP-24],AX
	PUSH AX
	POP AX
L10:
;--------------------------------; LINE 22
	MOV AX,[BP-24]
	CALL println
L9:
;--------------------------------; LINE 23
	SUB SP,2
	SUB SP,2
L8:
;--------------------------------; LINE 24
	MOV AX, 1
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-26],AX
	PUSH AX
	POP AX
L7:
;--------------------------------; LINE 25
	MOV AX, 5
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-28],AX
	PUSH AX
	POP AX
L6:
;--------------------------------; LINE 26
	;setting needed true for rel_expression	: simple_expression 
	MOV AX,[BP-26]
	PUSH AX
	;--------------------------------cond,need = 1 ,1
	;-------------------------------- simp of rel called--------------------------------

	;conditionality of simple exp
	POP AX
	CMP AX, 0
	JE L5
	;-------------------------------- simp of rel done--------------------------------

	;setting needed true for rel_expression	: simple_expression 
	MOV AX,[BP-28]
	PUSH AX
	;--------------------------------cond,need = 1 ,1
	;-------------------------------- simp of rel called--------------------------------

	;conditionality of simple exp
	POP AX
	CMP AX, 0
	JE L5
	;-------------------------------- simp of rel done--------------------------------

;--------------------------------; LINE 27
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 5
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L29:
;--------------------------------; LINE 28
	MOV AX,[BP-2]
	CALL println
L5:
;--------------------------------; LINE 30
	MOV AX, 0
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-28],AX
	PUSH AX
	POP AX
L4:
;--------------------------------; LINE 31
	;setting needed true for rel_expression	: simple_expression 
	MOV AX,[BP-26]
	PUSH AX
	;--------------------------------cond,need = 1 ,1
	;-------------------------------- simp of rel called--------------------------------

	;conditionality of simple exp
	POP AX
	CMP AX, 0
	JE L3
	;-------------------------------- simp of rel done--------------------------------

	;setting needed true for rel_expression	: simple_expression 
	MOV AX,[BP-28]
	PUSH AX
	;--------------------------------cond,need = 1 ,1
	;-------------------------------- simp of rel called--------------------------------

	;conditionality of simple exp
	POP AX
	CMP AX, 0
	JE L3
	;-------------------------------- simp of rel done--------------------------------

;--------------------------------; LINE 32
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 10
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	MOV AX, DX
	PUSH AX
	MOV AX, 20
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L30:
;--------------------------------; LINE 33
	MOV AX,[BP-2]
	CALL println
L3:
;--------------------------------; LINE 36
	;setting needed true for rel_expression	: simple_expression 
	;setting needed false for rel_expression : simple_expression RELOP simple_expression
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JLE L33
	;setting needed true for rel_expression	: simple_expression 
	MOV AX,[BP-24]
	PUSH AX
	;--------------------------------cond,need = 1 ,1
	;-------------------------------- simp of rel called--------------------------------

	;conditionality of simple exp
	POP AX
	CMP AX, 0
	JNE L32
	;-------------------------------- simp of rel done--------------------------------

L33:

	;--------------------------------cond,need = 1 ,0
	;setting needed true for rel_expression	: simple_expression 
	;setting needed false for rel_expression : simple_expression RELOP simple_expression
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JGE L31
	;setting needed false for rel_expression : simple_expression RELOP simple_expression
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 10
	PUSH AX
	POP AX
	NEG AX
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JLE L31
	;--------------------------------cond,need = 1 ,0
L32:

	MOV AX, 100
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
	JMP L2
L31:

	MOV AX, 200
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L2:
;--------------------------------; LINE 40
	MOV AX,[BP-2]
	CALL println
L1:
;--------------------------------; LINE 42
	MOV AX, 0
	PUSH AX
	;--------------------------------cond,need = 0 ,0
	POP AX
	JMP L0
L0:

L34:
	ADD SP, 28
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
