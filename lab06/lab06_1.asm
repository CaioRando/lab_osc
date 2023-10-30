.MODEL SMALL
.DATA
.CODE
main proc
    MOV CX, 4   ;contador
inicio:
    MOV AH, 08h ;le caracter
    INT 21h
    MOV DL, AL

    CMP DL, '0'
    JNE imprime ;se nao for 0 imprime
    MOV DL, 'X' ;se for 0 muda pra X
imprime:
    MOV AH, 02h ;imprime
    INT 21h
    LOOP inicio

    MOV AH, 4Ch
    INT 21h
       
main endp
END MAIN