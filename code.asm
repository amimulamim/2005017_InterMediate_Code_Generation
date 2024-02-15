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
L8 :
;--------------------------------; LINE 3
MOV AX,1
	PUSH AX
MOV AX,5
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JL L9
		PUSH 0
		JMP L10
	L9:
		PUSH 1
	L10:
	POP AX
	MOV [BP-2],AX
L7 :
;--------------------------------; LINE 4
	MOV AX,[BP-2]
	CALL println
L6 :
;--------------------------------; LINE 5
	MOV AX,[BP-2]
	PUSH AX
MOV AX,0
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JE L11
		PUSH 0
		JMP L12
	L11:
		PUSH 1
	L12:
	POP AX
	MOV [BP-4],AX
L5 :
;--------------------------------; LINE 6
	MOV AX,[BP-4]
	CALL println
L4 :
;--------------------------------; LINE 7
	MOV AX,[BP-2]
	PUSH AX
MOV AX,1
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JE L13
		PUSH 0
		JMP L14
	L13:
		PUSH 1
	L14:
	POP AX
	MOV [BP-4],AX
L3 :
;--------------------------------; LINE 8
	MOV AX,[BP-4]
	CALL println
L2 :
;--------------------------------; LINE 9
	MOV AX,[BP-2]
	PUSH AX
MOV AX,2
	PUSH AX
	POP DX
	POP AX
	CMP AX,DX
		JE L15
		PUSH 0
		JMP L16
	L15:
		PUSH 1
	L16:
	POP AX
	MOV [BP-4],AX
L1 :
;--------------------------------; LINE 10
	MOV AX,[BP-4]
	CALL println
L17 :
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
