; funcao ler - manda pra vetor
; funcao inverte
; funcao print
.MODEL SMALL
.STACK 100h
.DATA
    LF EQU 10
    vetor DB ?,?,?,?,?,?,?
.CODE
main proc
    MOV AX, @DATA
    MOV DS, AX

    MOV SI, OFFSET vetor

    CALL ler_vetor
    CALL inverte_vetor
    CALL print_vetor



    MOV AH, 4Ch
    INT 21h
main endp

ler_vetor proc near
; offset em SI
    PUSH AX
    PUSH BX
    PUSH CX

    XOR BX, BX
    MOV CX, 7

    MOV AH, 01h
ler:
    INT 21h
    MOV [SI + BX], AL
    INC BX
    LOOP ler

    POP CX
    POP BX
    POP AX

    RET
ler_vetor endp

inverte_vetor proc near
; offset em SI
    PUSH DI
    PUSH AX
    PUSH BX
    PUSH CX

    MOV CX, 3   ; contador
    MOV DI, SI  ; primeira posicao vetor
    MOV BX, 6   ; ultima pos vetor

troca:
    MOV AL, [SI + BX]   ; AX <- ultima pos
    XCHG AL, [DI]       ; primeira pos <-> AX
    XCHG AL, [SI + BX]  ; ultima pos <- AX
    INC DI
    DEC BX
    LOOP troca

    POP CX
    POP BX
    POP AX
    POP DI
    RET
inverte_vetor endp

print_vetor proc near
; offset em SI
    PUSH AX
    PUSH CX
    PUSH DX
    PUSH DI

    MOV AH, 02
    MOV DL, OFFSET LF
    INT 21h

    MOV DI, SI  ; contador posicao do vetor
    MOV CX, 7   ; contador quantas vezes vai printar
    MOV AH, 02h
print:
    MOV DL, [DI]
    INT 21h
    INC DI
    LOOP print

    POP DI
    POP DX
    POP CX
    POP AX
    RET
print_vetor endp
END MAIN