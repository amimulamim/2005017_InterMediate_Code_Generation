.MODEL SMALL
.STACK 1000H
.Data
	number DB "00000$"
	arr DW 5 DUP (0000H)
	a DW 1 DUP (0000H)
.CODE
f PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 4
	MOV AX,[BP+8]
	CALL println
L7:
;--------------------------------; LINE 5
	MOV AX,[BP+6]
	CALL println
L6:
;--------------------------------; LINE 6
	MOV AX,[BP+4]
	CALL println
L5:
;--------------------------------; LINE 7
	MOV AX, 441
	PUSH AX
	MOV AX, 1
	PUSH AX
	POP CX
	LEA SI,arr
	SHL CX,1
	ADD SI,CX
	POP AX
	MOV [SI], AX
	PUSH AX
	POP AX
L4:
;--------------------------------; LINE 8
	MOV AX, 555
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP CX
	LEA SI,arr
	SHL CX,1
	ADD SI,CX
	POP AX
	MOV [SI], AX
	PUSH AX
	POP AX
L3:
;--------------------------------; LINE 9
	MOV AX, 1
	PUSH AX
	POP CX
	LEA SI,arr
	SHL CX,1
	ADD SI,CX
	MOV AX,[SI]
	PUSH AX
	POP AX
	MOV [BP+6],AX
	PUSH AX
	POP AX
L2:
;--------------------------------; LINE 10
	MOV AX,[BP+6]
	CALL println
L1:
;--------------------------------; LINE 11
	MOV AX, 0
	PUSH AX
	POP CX
	LEA SI,arr
	SHL CX,1
	ADD SI,CX
	MOV AX,[SI]
	PUSH AX
	POP AX
	JMP L0
L0:

L8:
	MOV SP,BP
	POP BP
	RET 6
	f ENDP


recursive PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 15
	MOV AX,[BP+4]
	PUSH AX
	MOV AX, 1
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JNE L11
	MOV AX, 1
	PUSH AX
	POP AX
	JMP L9
L11:
;--------------------------------; LINE 17
	MOV AX,[BP+4]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JNE L10
	MOV AX, 0
	PUSH AX
	POP AX
	JMP L9
L10:
;--------------------------------; LINE 19
	MOV AX,[BP+4]
	PUSH AX
	MOV AX, 1
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	CALL recursive
	PUSH AX
	MOV AX,[BP+4]
	PUSH AX
	MOV AX, 2
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	CALL recursive
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	POP AX
	JMP L9
L9:

L12:
	MOV SP,BP
	POP BP
	RET 2
	recursive ENDP


v PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 23
	MOV AX, 3
	PUSH AX
	POP AX
	MOV a,AX
	PUSH AX
	POP AX
L15:
;--------------------------------; LINE 24
	MOV AX,a
	PUSH AX
	POP AX
	CMP AX, 0
	JE L14
;--------------------------------; LINE 26
	SUB SP,2
L17:
;--------------------------------; LINE 27
	MOV AX, 1
	PUSH AX
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L16:
;--------------------------------; LINE 28
	MOV AX,[BP-2]
	CALL println
L14:
;--------------------------------; LINE 30
	MOV AX,a
	CALL println
L13:

L18:
	MOV SP,BP
	POP BP
	RET
	v ENDP


main PROC
	MOV AX, @DATA
	MOV DS, AX
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 34
	SUB SP,2
	SUB SP,2
	SUB SP,2
	SUB SP,2
	SUB SP,10
L68:
;--------------------------------; LINE 35
	MOV AX, 5
	PUSH AX
	POP AX
	MOV [BP-8],AX
	PUSH AX
	POP AX
L67:
;--------------------------------; LINE 36
	CALL v
	PUSH AX
	POP AX
L66:
;--------------------------------; LINE 37
	MOV AX,[BP-8]
	CALL println
L65:
;--------------------------------; LINE 38
	MOV AX, 0
	PUSH AX
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L69:
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 5
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JL L70
	JMP L64
	POP AX
L70:
;--------------------------------; LINE 40
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 1
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	MOV AX,[BP-2]
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,18
	MOV DI,BP
	SUB DI,CX
	POP AX
	MOV [DI], AX
	PUSH AX
	POP AX
	JMP L71
L71:
	MOV AX, [BP-2]
	PUSH AX
	INC W.[BP-2]
	POP AX
	JMP L69
L64:
;--------------------------------; LINE 42
	MOV AX, 4
	PUSH AX
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L63:
;--------------------------------; LINE 43
L72:
	MOV AX, [BP-2]
	PUSH AX
	DEC W.[BP-2]
	POP AX
	CMP AX, 0
	JE L62
;--------------------------------; LINE 45
	MOV AX,[BP-2]
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,18
	MOV DI,BP
	SUB DI,CX
	MOV AX,[DI]
	PUSH AX
	POP AX
	MOV [BP-4],AX
	PUSH AX
	POP AX
L73:
;--------------------------------; LINE 46
	MOV AX,[BP-4]
	CALL println
	JMP L72
L62:
;--------------------------------; LINE 48
	MOV AX, 2
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L61:
;--------------------------------; LINE 49
	MOV AX,[BP-6]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JLE L74
	MOV AX, [BP-6]
	PUSH AX
	INC W.[BP-6]
	POP AX
	JMP L60
L74:

	MOV AX, [BP-6]
	PUSH AX
	DEC W.[BP-6]
	POP AX
L60:
;--------------------------------; LINE 53
	MOV AX,[BP-6]
	CALL println
L59:
;--------------------------------; LINE 54
	MOV AX, 2
	PUSH AX
	POP AX
	NEG AX
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L58:
;--------------------------------; LINE 55
	MOV AX,[BP-6]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JGE L75
	MOV AX, [BP-6]
	PUSH AX
	INC W.[BP-6]
	POP AX
	JMP L57
L75:

	MOV AX, [BP-6]
	PUSH AX
	DEC W.[BP-6]
	POP AX
L57:
;--------------------------------; LINE 59
	MOV AX,[BP-6]
	CALL println
L56:
;--------------------------------; LINE 60
	MOV AX, 121
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L55:
;--------------------------------; LINE 61
	MOV AX,[BP-6]
	PUSH AX
	POP AX
	NEG AX
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L54:
;--------------------------------; LINE 62
	MOV AX, 5
	PUSH AX
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L53:
;--------------------------------; LINE 63
	MOV AX,[BP-2]
	PUSH AX
	MOV AX,[BP-6]
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L52:
;--------------------------------; LINE 64
	MOV AX,[BP-6]
	CALL println
L51:
;--------------------------------; LINE 65
	MOV AX, 4
	PUSH AX
	POP AX
	NEG AX
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L50:
;--------------------------------; LINE 66
	MOV AX,[BP-6]
	PUSH AX
	MOV AX, 4
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L49:
;--------------------------------; LINE 67
	MOV AX,[BP-6]
	CALL println
L48:
;--------------------------------; LINE 68
	MOV AX, 19
	PUSH AX
	POP AX
	MOV [BP-4],AX
	PUSH AX
	POP AX
L47:
;--------------------------------; LINE 69
	MOV AX, 4
	PUSH AX
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L46:
;--------------------------------; LINE 70
	MOV AX,[BP-4]
	PUSH AX
	MOV AX,[BP-2]
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L45:
;--------------------------------; LINE 71
	MOV AX,[BP-6]
	CALL println
L44:
;--------------------------------; LINE 72
	MOV AX,[BP-4]
	PUSH AX
	MOV AX,[BP-2]
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	MOV AX, DX
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L43:
;--------------------------------; LINE 73
	MOV AX,[BP-6]
	CALL println
L42:
;--------------------------------; LINE 74
	MOV AX, 111
	PUSH AX
	MOV AX, 222
	PUSH AX
	MOV AX, 333
	PUSH AX
	CALL f
	PUSH AX
	MOV AX, 444
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L41:
;--------------------------------; LINE 75
	MOV AX,[BP-6]
	CALL println
L40:
;--------------------------------; LINE 76
	MOV AX, 5
	PUSH AX
	CALL recursive
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L39:
;--------------------------------; LINE 77
	MOV AX,[BP-6]
	CALL println
L38:
;--------------------------------; LINE 78
	MOV AX, 2
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L37:
;--------------------------------; LINE 79
	MOV AX, 1
	PUSH AX
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L36:
;--------------------------------; LINE 80
	MOV AX,[BP-2]
	PUSH AX
	POP AX
	CMP AX, 0
	JNE L76
	MOV AX,[BP-6]
	PUSH AX
	POP AX
	CMP AX, 0
	JNE L76
	JMP L77
L76:
	PUSH 1
	JMP L78
L77:
	PUSH 0
L78:
	POP AX
	MOV [BP-4],AX
	PUSH AX
	POP AX
L35:
;--------------------------------; LINE 81
	MOV AX,[BP-4]
	CALL println
L34:
;--------------------------------; LINE 82
	MOV AX,[BP-2]
	PUSH AX
	POP AX
	CMP AX, 0
	JE L80
	MOV AX,[BP-6]
	PUSH AX
	POP AX
	CMP AX, 0
	JNE L79
	JMP L80
L79:
	PUSH 1
	JMP L81
L80:
	PUSH 0
L81:
	POP AX
	MOV [BP-4],AX
	PUSH AX
	POP AX
L33:
;--------------------------------; LINE 83
	MOV AX,[BP-4]
	CALL println
L32:
;--------------------------------; LINE 84
	MOV AX, 2
	PUSH AX
	POP AX
	MOV [BP-6],AX
	PUSH AX
	POP AX
L31:
;--------------------------------; LINE 85
	MOV AX, 0
	PUSH AX
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L30:
;--------------------------------; LINE 86
	MOV AX,[BP-2]
	PUSH AX
	POP AX
	CMP AX, 0
	JNE L82
	MOV AX,[BP-6]
	PUSH AX
	POP AX
	CMP AX, 0
	JNE L82
	JMP L83
L82:
	PUSH 1
	JMP L84
L83:
	PUSH 0
L84:
	POP AX
	MOV [BP-4],AX
	PUSH AX
	POP AX
L29:
;--------------------------------; LINE 87
	MOV AX,[BP-4]
	CALL println
L28:
;--------------------------------; LINE 88
	MOV AX,[BP-2]
	PUSH AX
	POP AX
	CMP AX, 0
	JE L86
	MOV AX,[BP-6]
	PUSH AX
	POP AX
	CMP AX, 0
	JNE L85
	JMP L86
L85:
	PUSH 1
	JMP L87
L86:
	PUSH 0
L87:
	POP AX
	MOV [BP-4],AX
	PUSH AX
	POP AX
L27:
;--------------------------------; LINE 89
	MOV AX,[BP-4]
	CALL println
L26:
;--------------------------------; LINE 90
	MOV AX,[BP-6]
	PUSH AX
	POP AX
	CMP AX, 0
	JNE L89
	PUSH 1
	JMP L88
L89:
	PUSH 0
L88:
	POP AX
	MOV [BP-4],AX
	PUSH AX
	POP AX
L25:
;--------------------------------; LINE 91
	MOV AX,[BP-4]
	CALL println
L24:
;--------------------------------; LINE 92
	MOV AX,[BP-4]
	PUSH AX
	POP AX
	CMP AX, 0
	JNE L91
	PUSH 1
	JMP L90
L91:
	PUSH 0
L90:
	POP AX
	MOV [BP-4],AX
	PUSH AX
	POP AX
L23:
;--------------------------------; LINE 93
	MOV AX,[BP-4]
	CALL println
L22:
;--------------------------------; LINE 94
	MOV AX, 12
	PUSH AX
	MOV AX, 2
	PUSH AX
	MOV AX, 89
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	PUSH AX
	MOV AX, 3
	PUSH AX
	MOV AX, 33
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	MOV AX, 64
	PUSH AX
	MOV AX, 2
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	MOV AX, DX
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	MOV AX, 3
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	MOV AX, 3
	PUSH AX
	MOV AX, 59
	PUSH AX
	MOV AX, 9
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	PUSH AX
	MOV AX, 2
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	MOV AX, 4
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	POP AX
	MOV [BP-4],AX
	PUSH AX
	POP AX
L21:
;--------------------------------; LINE 95
	MOV AX,[BP-4]
	CALL println
L20:
;--------------------------------; LINE 97
	MOV AX, 0
	PUSH AX
	POP AX
	JMP L19
L19:

L92:
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
