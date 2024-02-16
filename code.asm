.MODEL SMALL
.STACK 1000H
.Data
	number DB "00000$"
.CODE
f PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 2
	MOV AX,[BP+4]
	PUSH AX
	MOV AX, 1
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JG L1
	MOV AX, 1
	PUSH AX
	POP AX
	JMP L0
L1:
;--------------------------------; LINE 3
	MOV AX,[BP+4]
	PUSH AX
	MOV AX,[BP+4]
	PUSH AX
	MOV AX, 1
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	CALL f
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP AX
	JMP L0
L0:

L2:
	POP BP
	RET 2
	f ENDP


g PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 8
	MOV AX, 1
	PUSH AX
	POP AX
	JMP L3
L3:

L4:
	POP BP
	RET
	g ENDP


main PROC
	MOV AX, @DATA
	MOV DS, AX
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 11
	SUB SP,2
	SUB SP,2
L11:
;--------------------------------; LINE 12
	MOV AX, 4
	PUSH AX
	CALL f
	PUSH AX
	POP AX
	MOV [BP-2],AX
L10:
;--------------------------------; LINE 13
	MOV AX,[BP-2]
	CALL println
L9:
;--------------------------------; LINE 14
	CALL g
	PUSH AX
	POP AX
	MOV [BP-2],AX
L8:
;--------------------------------; LINE 15
	MOV AX,[BP-2]
	PUSH AX
	POP AX
	MOV [BP-4],AX
L7:
;--------------------------------; LINE 16
	MOV AX,[BP-2]
	CALL println
L6:
;--------------------------------; LINE 17
	MOV AX,[BP-4]
	CALL println
L5:

L12:
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
