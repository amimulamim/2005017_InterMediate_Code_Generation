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
L6:
;--------------------------------; LINE 3
	MOV AX, 0
	PUSH AX
	POP AX
	MOV [BP-4],AX
L5:
;--------------------------------; LINE 4
	MOV AX,[BP-4]
	PUSH AX
	POP AX
	CMP AX, 0
	JNE L8
	MOV AX, 1
	PUSH AX
	MOV AX, 5
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JLE L7
	JMP L8
L7:
	PUSH 1
	JMP L9
L8:
	PUSH 0
L9:
	POP AX
	MOV [BP-2],AX
L4:
;--------------------------------; LINE 5
	MOV AX,[BP-2]
	CALL println
L3:
;--------------------------------; LINE 6
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JLE L2
;--------------------------------; LINE 7
	MOV AX, 10
	PUSH AX
	POP AX
	MOV [BP-2],AX
L2:
;--------------------------------; LINE 10
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JGE L1
;--------------------------------; LINE 11
	MOV AX, 10
	PUSH AX
	POP AX
	NEG AX
	PUSH AX
	POP AX
	MOV [BP-2],AX
L1:
;--------------------------------; LINE 14
	MOV AX,[BP-2]
	CALL println
L10:
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
