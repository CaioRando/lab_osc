.MODEL SMALL
.STACK 100h
.DATA
    LF EQU 10
    ask_dividendo DB 'Digite o dividendo: $'
    ask_divisor DB 'Digite o divisor: $'
    print_quociente DB 'Quociente: $'
    print_resto DB 'Resto: $'
.CODE
main proc
    MOV AX, @DATA
    MOV DS, AX

    MOV CH, 0   ;CH - quociente

    MOV AH,09h
    MOV DX, OFFSET ask_dividendo
    INT 21h

    MOV AH, 01h ;pega dividendo
    INT 21h

    SUB AL, 30h ;manda de ASCII para decimal
    MOV CL, AL  ;CL - resto

    MOV AH, 02h
    MOV DL, LF
    INT 21h

    MOV AH, 09h
    MOV DX, OFFSET ask_divisor
    INT 21h

    MOV AH, 01h ;pega divisor
    INT 21h

    SUB AL, 30h ;manda de ASCII para decimal
    MOV BH, AL  ;BH - divisor
    CMP BH, CL
    JA imprime  ;checa se divisor > dividendo
    CMP BH, 0
    JE imprime  ;checa se divisor = 0
dnv:
    SUB CL, BH  ;valor - divisor
    INC CH      ;resultado +1
    CMP CL, BH  ;ve se da pra subtrair dnv
    JAE dnv

imprime:
    ADD CH, 30h ;transforma para caracter ASCII
    ADD CL, 30h

    MOV AH, 02h
    MOV DL, LF
    INT 21h

    MOV AH, 09h
    MOV DX, OFFSET print_quociente
    INT 21h

    MOV AH, 02h ;print quociente
    MOV DL, CH
    INT 21h

    MOV DL, LF
    INT 21h

    MOV AH, 09h
    MOV DX, OFFSET print_resto
    INT 21h

    MOV AH, 02h ;print resto
    MOV DL, CL
    INT 21h

    MOV AH, 4Ch
    INT 21h
main endp
END MAIN