.MODEL SMALL
.DATA
    array DB 1, 2, 3, 4, 5, 6
.CODE
main proc
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 02h
    MOV CX, 6           ;contador

    LEA BX, array       ;endereco base do vetor

print:
    MOV DL, [BX]        ;conteudo do endereco
    INC BX              ;proximo endereco vetor

    OR DL, 30h          ;ASCII
    INT 21h
    LOOP print

    MOV AH, 4Ch
    INT 21h

main endp
END MAIN