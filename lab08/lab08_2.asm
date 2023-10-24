.MODEL SMALL
.STACK 100h
.DATA
    matriz4x4   DB 1, 2, 3, 4
                DB 4, 3, 2, 1
                DB 5, 6, 7, 8
                DB 8, 7, 6, 5
    LF  EQU  10
.CODE
main proc
    MOV AX, @DATA
    MOV DS, AX

    CALL print_matriz

    MOV AH, 4Ch
    INT 21h
main endp

print_matriz proc near
    PUSH SI
    PUSH CX
    PUSH BX
    PUSH AX
    PUSH DX

    XOR BX, BX  ; pos linha

    MOV AH, 02h
    MOV DH, 4   ; contador muda linha

muda_a_linha:
    XOR SI, SI  ; pos coluna
    MOV CX, 4   ; contador de colunas

print_linha:
    MOV DL, matriz4x4[BX+SI]    
    OR DL, 30h  ; caracter
    INT 21h

    MOV DL, ' ' ; espaco
    INT 21h

    INC SI
    loop print_linha

    MOV DL, LF  ; enter
    INT 21h

    ADD BX, 4   ; proxima linha
    DEC DH      ; contador linhas -1
    JNZ muda_a_linha

    POP DX
    POP AX
    POP BX
    POP CX
    POP SI
    RET
print_matriz endp
END MAIN