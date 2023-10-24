.MODEL SMALL
.STACK 100H
.DATA
    matriz4x4   DB ?, ?, ?, ?
                DB ?, ?, ?, ?
                DB ?, ?, ?, ?
                DB ?, ?, ?, ?

    soma    DB ?
.CODE
main proc
    MOV AX, @DATA
    MOV DS, AX

    CALL ler_matriz
    CALL new_line
    
    CALL print_matriz
    CALL new_line

    CALL somar
    CALL print_soma
    MOV AH, 4Ch
    INT 21h
main endp

somar proc
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    XOR AX, AX
    XOR BX, BX  ;coluna
    MOV DH, 4   ;contador linha

soma_muda_linha:
    XOR SI, SI  ;linha
    MOV CX, 4   ;contador coluna
    soma_coluna:
        MOV AH, matriz4x4[SI+BX]
        AND AH, 0Fh
        ADD AL, AH
        INC SI
        LOOP soma_coluna
    ADD BX, 4
    DEC DH
    JNZ soma_muda_linha

    MOV soma, AL

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
somar endp

print_soma proc
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    XOR AX,AX
    XOR CX, CX
    MOV BX, 10
    MOV AL, soma

dividir:
    XOR DX,DX
    DIV BX  ;quociente/10
    PUSH DX ;empilha resto
    INC CX
    CMP AX, 0
    JNE dividir
    
    MOV AH, 02h
printar:
    POP DX
    OR DL, 30h  ;ascii
    INT 21h
    LOOP printar

    POP DX
    POP CX
    POP BX
    POP AX
    RET
print_soma endp

ler_matriz proc
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    XOR BX, BX  ;coluna

    MOV DH, 4   ;contador linha
    MOV AH, 01h

le_muda_linha:
    XOR SI, SI  ;linha
    MOV CX, 4   ;contador coluna

    le_coluna:
        INT 21h
        MOV matriz4x4[SI+BX], AL
        INC SI
        CALL spaco
        LOOP le_coluna

    CALL new_line
    ADD BX, 4
    DEC DH
    JNZ le_muda_linha

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
ler_matriz endp

print_matriz proc
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    XOR BX, BX  ;colunas
    MOV AH, 02h
    MOV DH, 4   ;contador linha

print_muda_linha:

    XOR SI, SI  ;zera linha
    MOV CX, 4   ;contador coluna

    print_coluna:
        MOV DL, matriz4x4[SI+BX]
        INT 21h
        INC SI
        CALL spaco
        LOOP print_coluna

    CALL new_line
    ADD BX, 4   ;prox linha
    DEC DH      ;dec contador linha
    JNZ print_muda_linha    ;not zero -> prox linha

    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
print_matriz endp

spaco proc
    PUSH AX
    PUSH DX
    
    MOV AH, 02
    MOV DL, 20h
    INT 21h

    POP DX
    POP AX
    RET
spaco endp

new_line proc
    PUSH AX
    PUSH DX

    MOV AH, 02
    MOV DL, 10
    INT 21h

    MOV DL, 13
    INT 21h
    
    POP DX
    POP AX
    RET
new_line endp
END MAIN