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
L30:
;--------------------------------; LINE 5
	SUB SP,20
L29:
;--------------------------------; LINE 6
	MOV AX, 2
	NEG AX
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP CX
	LEA SI,w
	SHL CX,1
	ADD SI,CX
	POP AX
	MOV [SI], AX
L28:
;--------------------------------; LINE 7
	MOV AX, 0
	PUSH AX
	POP CX
	LEA SI,w
	SHL CX,1
	ADD SI,CX
	MOV AX,[SI]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,22
	MOV DI,BP
	SUB DI,CX
	POP AX
	MOV [DI], AX
L27:
;--------------------------------; LINE 8
	MOV AX, 0
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,22
	MOV DI,BP
	SUB DI,CX
	MOV AX,[DI]
	MOV [BP-2],AX
L26:
;--------------------------------; LINE 9
	MOV AX,[BP-2]
	CALL println
L25:
;--------------------------------; LINE 10
	MOV AX, 0
	PUSH AX
	POP CX
	LEA SI,w
	SHL CX,1
	ADD SI,CX
	MOV AX, [SI]
	PUSH AX
	PUSH AX
	INC W.[SI]
	MOV AX, 1
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,22
	MOV DI,BP
	SUB DI,CX
	POP AX
	MOV [DI], AX
L24:
;--------------------------------; LINE 11
	MOV AX, 1
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,22
	MOV DI,BP
	SUB DI,CX
	MOV AX,[DI]
	MOV [BP-2],AX
L23:
;--------------------------------; LINE 12
	MOV AX,[BP-2]
	CALL println
L22:
;--------------------------------; LINE 13
	MOV AX, 0
	PUSH AX
	POP CX
	LEA SI,w
	SHL CX,1
	ADD SI,CX
	MOV AX,[SI]
	MOV [BP-2],AX
L21:
;--------------------------------; LINE 14
	MOV AX,[BP-2]
	CALL println
L20:
;--------------------------------; LINE 16
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	MOV [BP-2],AX
L19:
;--------------------------------; LINE 17
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	MOV [BP-2],AX
L18:
;--------------------------------; LINE 18
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 1
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	MOV [BP-2],AX
L17:
;--------------------------------; LINE 19
	MOV AX,[BP-2]
	CALL println
L16:
;--------------------------------; LINE 20
	SUB SP,2
L15:
;--------------------------------; LINE 21
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 10
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JL L31
	PUSH 0
	JMP L32
L31:
	PUSH 1
L32:
	POP AX
	MOV [BP-24],AX
L14:
;--------------------------------; LINE 22
	MOV AX,[BP-24]
	CALL println
L13:
;--------------------------------; LINE 23
	SUB SP,2
	SUB SP,2
L12:
;--------------------------------; LINE 24
	MOV AX, 1
	MOV [BP-26],AX
L11:
;--------------------------------; LINE 25
	MOV AX, 5
	MOV [BP-28],AX
L10:
;--------------------------------; LINE 26
	MOV AX,[BP-26]
	CMP AX, 0
	JE L9
	MOV AX,[BP-28]
	CMP AX, 0
	JE L9
;--------------------------------; LINE 27
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 5
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	MOV [BP-2],AX
L33:
;--------------------------------; LINE 28
	MOV AX,[BP-2]
	CALL println
L9:
;--------------------------------; LINE 30
	MOV AX, 0
	MOV [BP-28],AX
L8:
;--------------------------------; LINE 31
	MOV AX,[BP-26]
	CMP AX, 0
	JE L7
	MOV AX,[BP-28]
	CMP AX, 0
	JNE L7
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
	MOV [BP-2],AX
L34:
;--------------------------------; LINE 33
	MOV AX,[BP-2]
	CALL println
L7:
;--------------------------------; LINE 35
	MOV AX,[BP-26]
	CMP AX, 0
	JE L6
	MOV AX,[BP-28]
	CMP AX, 0
	JNE L6
;--------------------------------; LINE 36
	MOV AX, 10
	MOV [BP-24],AX
L35:
;--------------------------------; LINE 37
	MOV AX,[BP-24]
	CALL println
L6:
;--------------------------------; LINE 40
	MOV AX,[BP-26]
	CMP AX, 0
	JE L36
	MOV AX,[BP-28]
	CMP AX, 0
	JNE L5
L36:
;--------------------------------; LINE 41
	MOV AX, 11
	MOV [BP-24],AX
L37:
;--------------------------------; LINE 42
	MOV AX,[BP-24]
	CALL println
L5:
;--------------------------------; LINE 44
	MOV AX,[BP-26]
	CMP AX, 0
	JNE L38
	MOV AX,[BP-28]
	CMP AX, 0
	JNE L4
L38:
;--------------------------------; LINE 45
	MOV AX, 12
	MOV [BP-24],AX
L39:
;--------------------------------; LINE 46
	MOV AX,[BP-24]
	CALL println
L4:
;--------------------------------; LINE 49
	MOV AX,[BP-26]
	CMP AX, 0
	JE L40
	MOV AX,[BP-28]
	CMP AX, 0
	JE L3
L40:
;--------------------------------; LINE 50
	MOV AX, 11
	MOV [BP-24],AX
L41:
;--------------------------------; LINE 51
	MOV AX,[BP-24]
	CALL println
L3:
;--------------------------------; LINE 54
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JLE L44
	MOV AX,[BP-24]
	CMP AX, 0
	JNE L43
L44:
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JGE L42
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 10
	NEG AX
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JLE L42
L43:
	MOV AX, 100
	MOV [BP-2],AX
	JMP L2
L42:
	MOV AX, 200
	MOV [BP-2],AX
L2:
;--------------------------------; LINE 58
	MOV AX,[BP-2]
	CALL println
L1:
;--------------------------------; LINE 60
	MOV AX, 0
L0:
L45:
	MOV SP,BP
	POP BP
	MOV AX, 4CH
	INT 21H
	main ENDP
;-------------------------------
;         print library
;-------------------------------
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
;--------------------------------
	END main
