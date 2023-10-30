.MODEL SMALL
.DATA
    vetor DB ?, ?, ?, ?, ?, ?, ?    ;vetor sera lido
.CODE
main proc
    MOV AX, @DATA
    MOV DS, AX

    XOR BX, BX          ;contador posicao do digito
    MOV CX, 7           ;contador numero de digitos
    MOV AH, 01
ler:
    INT 21h
    MOV vetor[BX], AL
    INC BX              ;posicao do digito
    LOOP ler

    XOR DI, DI          ;ultimo posicao vetor
    MOV SI, 6           ;primeira posicao vetor          
    MOV CX, 3           ;troca ate metade do vetor

troca:
    MOV BL, vetor[DI]   ;guarda primeiro
    MOV BH, vetor[SI]   ;guarda ultimo

    MOV vetor[DI], BH   ;joga no primeiro
    MOV vetor[SI], BL   ;joga no ultimo

    INC DI
    DEC SI

    LOOP troca

    XOR BX, BX
    MOV CX, 7
    MOV AH, 02
    MOV DL, 10          ;print enter
    INT 21h

print:
    MOV DL, vetor[BX]
    INT 21h
    INC BX
    LOOP print

    MOV AH, 4Ch
    INT 21h
main endp
END MAIN