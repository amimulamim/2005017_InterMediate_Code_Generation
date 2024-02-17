.MODEL SMALL
.STACK 1000H
.Data
	number DB "00000$"
.CODE
f PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 2
	MOV AX, 2
	PUSH AX
	MOV AX,[BP+4]
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP AX
	JMP L0
L1:
;--------------------------------; LINE 3
	MOV AX, 9
	PUSH AX
	POP AX
	MOV [BP+4],AX
	PUSH AX
	POP AX
L0:

L2:
	POP BP
	RET 2
	f ENDP


g PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 7
	SUB SP,2
L5:
;--------------------------------; LINE 8
	MOV AX,[BP+6]
	PUSH AX
	CALL f
	PUSH AX
	MOV AX,[BP+6]
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	MOV AX,[BP+4]
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L4:
;--------------------------------; LINE 9
	MOV AX,[BP-2]
	PUSH AX
	POP AX
	JMP L3
L3:

L6:
	ADD SP, 2
	POP BP
	RET 4
	g ENDP


ff PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 13
	SUB SP,2
L9:
;--------------------------------; LINE 14
	MOV AX, [BP+4]
	PUSH AX
	INC W.[BP+4]
	POP AX
L8:
;--------------------------------; LINE 15
	MOV AX, [BP+4]
	PUSH AX
	DEC W.[BP+4]
	POP AX
L7:

L10:
	ADD SP, 2
	POP BP
	RET 2
	ff ENDP


main PROC
	MOV AX, @DATA
	MOV DS, AX
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 19
	SUB SP,2
	SUB SP,2
L17:
;--------------------------------; LINE 20
	MOV AX, 1
	PUSH AX
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L16:
;--------------------------------; LINE 21
	MOV AX, 2
	PUSH AX
	POP AX
	MOV [BP-4],AX
	PUSH AX
	POP AX
L15:
;--------------------------------; LINE 22
	MOV AX,[BP-2]
	PUSH AX
	MOV AX,[BP-4]
	PUSH AX
	CALL g
	PUSH AX
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L14:
;--------------------------------; LINE 23
	MOV AX,[BP-2]
	CALL println
L13:
;--------------------------------; LINE 24
	MOV AX, 5
	PUSH AX
	CALL ff
	PUSH AX
	POP AX
L12:
;--------------------------------; LINE 25
	MOV AX, 0
	PUSH AX
	POP AX
	JMP L11
L11:

L18:
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
