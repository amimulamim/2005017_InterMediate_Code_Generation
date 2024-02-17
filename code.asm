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
	SUB SP,2
L11:
;--------------------------------; LINE 3
	MOV AX, 1
	PUSH AX
	POP AX
	NEG AX
	PUSH AX
	POP AX
	MOV [BP-6],AX
L10:
;--------------------------------; LINE 4
	MOV AX, 1
	PUSH AX
	POP AX
	MOV [BP-2],AX
L9:
;--------------------------------; LINE 5
	MOV AX, 5
	PUSH AX
	POP AX
	MOV [BP-4],AX
L8:
;--------------------------------; LINE 6
	MOV AX,[BP-2]
	PUSH AX
	POP AX
	CMP AX, 0
	JE L7
	MOV AX,[BP-4]
	PUSH AX
	POP AX
	CMP AX, 0
	JE L7
;--------------------------------; LINE 7
	MOV AX,[BP-6]
	PUSH AX
	MOV AX, 5
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP AX
	MOV [BP-6],AX
L12:
;--------------------------------; LINE 8
	MOV AX,[BP-6]
	CALL println
L7:
;--------------------------------; LINE 10
	MOV AX, 0
	PUSH AX
	POP AX
	MOV [BP-4],AX
L6:
;--------------------------------; LINE 11
	MOV AX,[BP-2]
	PUSH AX
	POP AX
	CMP AX, 0
	JE L5
	MOV AX,[BP-4]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JG L5
;--------------------------------; LINE 12
	MOV AX,[BP-6]
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
	POP AX
	MOV [BP-6],AX
L13:
;--------------------------------; LINE 13
	MOV AX,[BP-6]
	CALL println
L5:
;--------------------------------; LINE 15
	MOV AX,[BP-2]
	PUSH AX
	POP AX
	CMP AX, 0
	JE L15
	MOV AX,[BP-4]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JG L15
	JMP L14
L14:
	PUSH 1
	JMP L16
L15:
	PUSH 0
L16:
	POP AX
	MOV [BP-6],AX
L4:
;--------------------------------; LINE 16
	MOV AX,[BP-6]
	CALL println
L3:
;--------------------------------; LINE 17
	MOV AX,[BP-6]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JLE L19
	MOV AX,[BP-6]
	PUSH AX
	MOV AX, 10
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JL L18
L19:

	MOV AX,[BP-6]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JGE L17
	MOV AX,[BP-6]
	PUSH AX
	MOV AX, 10
	PUSH AX
	POP AX
	NEG AX
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JLE L17
L18:

	MOV AX, 100
	PUSH AX
	POP AX
	MOV [BP-6],AX
	JMP L2
L17:

	MOV AX, 200
	PUSH AX
	POP AX
	MOV [BP-6],AX
L2:
;--------------------------------; LINE 21
	MOV AX,[BP-6]
	CALL println
L1:
;--------------------------------; LINE 22
	MOV AX,[BP-2]
	PUSH AX
	POP AX
	CMP AX, 0
	JE L20
	MOV AX,[BP-4]
	PUSH AX
	POP AX
	CMP AX, 0
	JNE L0
L20:

;--------------------------------; LINE 23
	MOV AX, 212
	PUSH AX
	POP AX
	MOV [BP-6],AX
L21:
;--------------------------------; LINE 24
	MOV AX,[BP-6]
	CALL println
L0:

L22:
	ADD SP, 6
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
