.MODEL SMALL
.DATA
.CODE
main proc
    MOV CX, 4   ;contador
inicio:
    MOV AH, 08h ;le caracter
    INT 21h

    MOV DL, AL

    CMP DL, 'A'
    JE troca_A
    CMP DL, 'a'
    JNE imprime
troca_A:
    MOV DL, '*' ;se for a ou A troca
imprime:
    MOV AH, 02h ;imprime
    INT 21h
    LOOP inicio

    MOV AH,4Ch
    INT 21h
main endp
END MAIN