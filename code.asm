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
;--------------------------------; LINE 3
	SUB SP,2
L6:
;--------------------------------; LINE 4
	SUB SP,2
L5:
;--------------------------------; LINE 5
	MOV AX, 2
	PUSH AX
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L4:
;--------------------------------; LINE 6
	MOV AX, 3
	PUSH AX
	POP AX
	MOV [BP-4],AX
	PUSH AX
	POP AX
L3:
;--------------------------------; LINE 7
L7:
	MOV AX,[BP-2]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JLE L2
;--------------------------------; LINE 8
	SUB SP,2
L11:
;--------------------------------; LINE 9
	MOV AX,[BP-2]
	PUSH AX
	POP AX
	MOV [BP-4],AX
	PUSH AX
	POP AX
L10:
;--------------------------------; LINE 10
L12:
	MOV AX,[BP-4]
	PUSH AX
	MOV AX, 0
	PUSH AX
	POP DX
	POP AX
	CMP AX, DX
	JLE L9
;--------------------------------; LINE 11
	SUB SP,2
L15:
;--------------------------------; LINE 12
	MOV AX,[BP-4]
	PUSH AX
	POP AX
	MOV [BP-2],AX
	PUSH AX
	POP AX
L14:
;--------------------------------; LINE 13
	MOV AX, [BP-4]
	PUSH AX
	DEC W.[BP-4]
	POP AX
L13:
;--------------------------------; LINE 14
	MOV AX,[BP-2]
	CALL println
	JMP L12
L9:
;--------------------------------; LINE 16
	MOV AX, [BP-2]
	PUSH AX
	DEC W.[BP-2]
	POP AX
L8:
;--------------------------------; LINE 17
	MOV AX,[BP-4]
	CALL println
	JMP L7
L2:
;--------------------------------; LINE 19
	MOV AX,[BP-2]
	CALL println
L1:
;--------------------------------; LINE 20
	MOV AX,[BP-4]
	CALL println
L0:

L16:
	ADD SP, 8
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
