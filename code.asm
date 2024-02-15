.MODEL SMALL
.STACK 1000H
.Data
number DB "00000$"
	r DW 10 DUP (0000H)
	a DW 1 DUP (0000H)
	b DW 1 DUP (0000H)
.CODE
	f PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 7
	SUB SP,2
	SUB SP,2
	SUB SP,2
l6 :
;--------------------------------; LINE 8
	MOV AX,[BP+6]
	PUSH AX
MOV AX,3
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
MOV AX,10
	PUSH AX
	POP BX
	POP AX
	ADD AX,BX
	PUSH AX
	POP AX
	MOV [BP+6],AX
l5 :
;--------------------------------; LINE 9
	MOV AX,[BP+6]
	CALL println
l4 :
;--------------------------------; LINE 11
	MOV AX,[BP+4]
	PUSH AX
	CALL cc
l3 :
;--------------------------------; LINE 12
MOV AX,2
	PUSH AX
	POP AX
	MOV [BP-2],AX
l2 :
;--------------------------------; LINE 13
MOV AX,3
	PUSH AX
	POP AX
	MOV [BP-4],AX
Label7 : 
		ADD SP, 6
		POP BP
		RET 4
	f ENDP


	cc PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 17
	SUB SP,2
	SUB SP,2
l13 :
;--------------------------------; LINE 18
	MOV AX,[BP+4]
	PUSH AX
MOV AX,2
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP AX
	MOV [BP+4],AX
l12 :
;--------------------------------; LINE 19
	MOV AX,[BP+4]
	CALL println
l11 :
;--------------------------------; LINE 20
	MOV AX,[BP+4]
	PUSH AX
	CALL d
l10 :
;--------------------------------; LINE 21
MOV AX,11
	PUSH AX
	POP AX
	MOV [BP-4],AX
l9 :
;--------------------------------; LINE 22
	MOV AX,[BP-4]
	CALL println
Label14 : 
		ADD SP, 4
		POP BP
		RET 2
	cc ENDP


	d PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 25
	SUB SP,2
	SUB SP,2
l21 :
;--------------------------------; LINE 26
	MOV AX,[BP+4]
	PUSH AX
MOV AX,2
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP AX
	MOV [BP+4],AX
l20 :
;--------------------------------; LINE 27
	MOV AX,[BP+4]
	CALL println
l19 :
;--------------------------------; LINE 28
	MOV AX,[BP+4]
	PUSH AX
	CALL e
l18 :
;--------------------------------; LINE 29
	MOV AX,[BP+4]
	CALL println
l17 :
;--------------------------------; LINE 30
MOV AX,55
	PUSH AX
	POP AX
	MOV [BP-4],AX
l16 :
;--------------------------------; LINE 31
	MOV AX,[BP-4]
	CALL println
Label22 : 
		ADD SP, 4
		POP BP
		RET 2
	d ENDP


	testing PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 36
	MOV AX,[BP+6]
	CALL println
l24 :
;--------------------------------; LINE 37
	MOV AX,[BP+4]
	CALL println
Label25 : 
		POP BP
		RET 4
	testing ENDP


	e PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 42
	MOV AX,[BP+4]
	PUSH AX
MOV AX,2
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP AX
	MOV [BP+4],AX
l28 :
;--------------------------------; LINE 43
	MOV AX,[BP+4]
	CALL println
l27 :
;--------------------------------; LINE 44
	MOV AX,[BP+4]
	PUSH AX
MOV AX,3
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
MOV AX,10
	PUSH AX
	CALL testing
Label29 : 
		POP BP
		RET 2
	e ENDP


	k PROC
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 50
	SUB SP,2
l43 :
;--------------------------------; LINE 52
MOV AX,17
	PUSH AX
	POP AX
	MOV [BP-2],AX
l42 :
;--------------------------------; LINE 53
	SUB SP,20
l41 :
;--------------------------------; LINE 54
	MOV AX,[BP-2]
	CALL println
l40 :
;--------------------------------; LINE 55
MOV AX,19
	PUSH AX
	MOV AX,[BP-2]
	PUSH AX
MOV AX,10
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	MOV AX,DX
	PUSH AX
MOV AX,5
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,22
	MOV DI,BP
	SUB DI,CX
	POP AX
	MOV [DI],AX
l39 :
;--------------------------------; LINE 56
	MOV AX,[BP-2]
	PUSH AX
MOV AX,10
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	MOV AX,DX
	PUSH AX
MOV AX,5
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	POP CX
	SHL CX,1
	ADD CX,22
	MOV DI,BP
	SUB DI,CX
	MOV AX,[DI]
	PUSH AX
	POP AX
	MOV b,AX
l38 :
;--------------------------------; LINE 57
	MOV AX,b
	CALL println
l37 :
;--------------------------------; LINE 58
MOV AX,20
	PUSH AX
MOV AX,2
	PUSH AX
MOV AX,3
	PUSH AX
	POP BX
	POP AX
	IMUL BX
	PUSH AX
	POP CX
	LEA SI,r
	SHL CX,1
	ADD SI,CX
	POP AX
	MOV [SI],AX
l36 :
;--------------------------------; LINE 59
MOV AX,9
	PUSH AX
MOV AX,6
	PUSH AX
MOV AX,2
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	PUSH AX
	POP BX
	POP AX
	SUB AX,BX
	PUSH AX
	POP CX
	LEA SI,r
	SHL CX,1
	ADD SI,CX
	MOV AX,[SI]
	PUSH AX
	POP AX
	MOV b,AX
l35 :
;--------------------------------; LINE 60
	MOV AX,b
	CALL println
l34 :
;--------------------------------; LINE 62
MOV AX,26
	PUSH AX
	POP AX
	MOV a,AX
l33 :
;--------------------------------; LINE 63
MOV AX,13
	PUSH AX
	MOV AX,a
	PUSH AX
	CALL f
l32 :
;--------------------------------; LINE 64
	MOV AX,a
	CALL println
l31 :
;--------------------------------; LINE 65
	MOV AX,a
	PUSH AX
MOV AX,10
	PUSH AX
	POP BX
	POP AX
	CWD
	IDIV BX
	MOV AX,DX
	PUSH AX
	POP AX
	MOV b,AX
Label44 : 
		ADD SP, 22
		POP BP
		RET
	k ENDP


	main PROC
	MOV AX, @DATA
	MOV DS, AX
	PUSH BP
	MOV BP, SP
;--------------------------------; LINE 70
	CALL k
l46 :
;--------------------------------; LINE 71
	MOV AX,b
	CALL println
Label47 : 
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
