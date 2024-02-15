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
;--------------------------------; LINE 2
	SUB SP,2
	SUB SP,2
L22 :
;--------------------------------; LINE 3
MOV AX,1
	PUSH AX
MOV AX,5
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JGE L24
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JL L23
		JMP L24
	L23:
		PUSH 1
		JMP L25
	L24:
		PUSH 0
	L25:
	POP AX
	MOV [BP-2],AX
L21 :
;--------------------------------; LINE 4
MOV AX,1
	PUSH AX
MOV AX,5
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JGE L27
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JE L26
		JMP L27
	L26:
		PUSH 1
		JMP L28
	L27:
		PUSH 0
	L28:
	POP AX
	MOV [BP-4],AX
L20 :
;--------------------------------; LINE 5
	MOV AX,[BP-4]
	CALL println
L19 :
;--------------------------------; LINE 6
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
MOV AX,5
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
MOV AX,9
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
MOV AX,7
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	PUSH AX
	POP AX
	MOV [BP-4],AX
L18 :
;--------------------------------; LINE 7
	MOV AX,[BP-2]
	CALL println
L17 :
;--------------------------------; LINE 8
	MOV AX,[BP-4]
	CALL println
L16 :
;--------------------------------; LINE 9
MOV AX,1
	PUSH AX
MOV AX,5
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JL L29
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JL L29
		JMP L30
	L29:
		PUSH 1
		JMP L31
	L30:
		PUSH 0
	L31:
	POP AX
	MOV [BP-4],AX
L15 :
;--------------------------------; LINE 10
	MOV AX,[BP-4]
	CALL println
L14 :
;--------------------------------; LINE 11
MOV AX,1
	PUSH AX
MOV AX,5
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JG L32
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JL L32
		JMP L33
	L32:
		PUSH 1
		JMP L34
	L33:
		PUSH 0
	L34:
	POP AX
	MOV [BP-4],AX
L13 :
;--------------------------------; LINE 12
	MOV AX,[BP-4]
	CALL println
L12 :
;--------------------------------; LINE 13
MOV AX,1
	PUSH AX
MOV AX,5
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JG L35
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JG L35
		JMP L36
	L35:
		PUSH 1
		JMP L37
	L36:
		PUSH 0
	L37:
	POP AX
	MOV [BP-4],AX
L11 :
;--------------------------------; LINE 14
	MOV AX,[BP-4]
	CALL println
L10 :
;--------------------------------; LINE 15
MOV AX,1
	PUSH AX
MOV AX,5
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JE L39
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
MOV AX,1
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JNE L38
		JMP L39
	L38:
		PUSH 1
		JMP L40
	L39:
		PUSH 0
	L40:
	POP AX
	MOV [BP-4],AX
L9 :
;--------------------------------; LINE 16
	MOV AX,[BP-4]
	CALL println
L8 :
;--------------------------------; LINE 17
MOV AX,1
	PUSH AX
MOV AX,5
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JE L42
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
MOV AX,1
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JE L41
		JMP L42
	L41:
		PUSH 1
		JMP L43
	L42:
		PUSH 0
	L43:
	POP AX
	MOV [BP-4],AX
L7 :
;--------------------------------; LINE 18
	MOV AX,[BP-4]
	CALL println
L6 :
;--------------------------------; LINE 19
MOV AX,1
	PUSH AX
MOV AX,5
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JE L45
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
MOV AX,1
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JLE L44
		JMP L45
	L44:
		PUSH 1
		JMP L46
	L45:
		PUSH 0
	L46:
	POP AX
	MOV [BP-4],AX
L5 :
;--------------------------------; LINE 20
	MOV AX,[BP-4]
	CALL println
L4 :
;--------------------------------; LINE 21
MOV AX,1
	PUSH AX
MOV AX,5
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JE L48
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
MOV AX,1
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JGE L47
		JMP L48
	L47:
		PUSH 1
		JMP L49
	L48:
		PUSH 0
	L49:
	POP AX
	MOV [BP-4],AX
L3 :
;--------------------------------; LINE 22
	MOV AX,[BP-4]
	CALL println
L2 :
;--------------------------------; LINE 23
MOV AX,1
	PUSH AX
MOV AX,5
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JE L51
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
MOV AX,1
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JG L50
		JMP L51
	L50:
		PUSH 1
		JMP L52
	L51:
		PUSH 0
	L52:
	POP AX
	MOV [BP-4],AX
L1 :
;--------------------------------; LINE 24
	MOV AX,[BP-4]
	CALL println
L53 :
		ADD SP, 4
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
