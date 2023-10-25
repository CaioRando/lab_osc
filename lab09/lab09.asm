;input nas bases - binario, decimal e hexadecimal
;output nas bases - binario, decimal e hexadecimal
.MODEL SMALL

new_line macro
    PUSH AX
    MOV AH, 02h
    MOV DL, 10
    INT 21h

    MOV DL, 13
    INT 21h
    POP AX
endm

.STACK 100h
.DATA
    input DW ?

    tamanho DB 0

    hexadecimal DB '0','1','2','3','4','5','6','7', '8','9'
                DB 'A','B','C','D','E','F'

    menu_input  DB '1. Entrada em Binario', 10, 13
                DB '2. Entrada em Decimal', 10, 13
                DB '3. Entrada em Hexadecimal', 10, 13, '$'

    menu_output DB 10, 13, '1. Saida em Binario', 10, 13
                DB '2. Saida em Decimal', 10, 13
                DB '3. Saida em Hexadecimal', 10, 13, '$'

    print_pede_input DB 'Digite o numero: $'
.CODE
main proc
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 08h
    CALL print_menu_input
    INT 21h
    AND AL, 0Fh
    new_line
    CALL pede_input

    CMP AL, 1
    JA input_nao_bin
        CALL input_bin
        JMP ask_output
input_nao_bin:
    CMP AL, 2
    JA input_nao_dec
        CALL input_dec
        JMP ask_output
input_nao_dec:
        CALL input_hex

ask_output:
    CALL print_menu_output
    INT 21h
    AND AL, 0Fh
    CMP AL, 1
    JA output_nao_bin
        CALL output_bin
        JMP sair
output_nao_bin:
    CMP AL, 2
    JA output_nao_dec
        CALL output_dec
        JMP sair
output_nao_dec:
        CALL output_hex

sair:
    MOV AH, 4Ch
    INT 21h
endp

print_menu_input proc NEAR ;printa o menu de entrada        ;PRONTO
    PUSH AX

    MOV AH, 09h
    MOV DX, OFFSET menu_input
    INT 21h

    POP AX
    RET
endp

input_bin proc NEAR ;input em binario                       ;PRONTO
    PUSH AX

    XOR BX, BX
    MOV CX, 16
    MOV AH, 01h
le_bin:    
    INT 21h
    CMP AL, 13
    JE sai_input_bin

    AND AL, 0Fh
    ROR AX, 1
    RCL BX, 1
    ROL AX, 1
    LOOP le_bin
    new_line

sai_input_bin:
    MOV input, BX

    POP AX
    RET
endp

input_dec proc NEAR ;input em decimal                       ;PRONTO
    PUSH AX

    MOV BX, 10
    XOR AX, AX
    XOR CX, CX

le_dec:
    PUSH AX
    MOV AH, 01h
    INT 21h
    CMP AL, 13
    JE sai_input_dec

    AND AL, 0Fh
    MOV CL, AL
    POP AX
    MUL BX
    ADD AX, CX
    JMP le_dec
sai_input_dec:
    POP AX
    MOV input, AX

    POP AX
    RET
endp

input_hex proc NEAR ;input em hexadecimal                   ;PRONTO
    PUSH AX

    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    MOV AH, 01h

le_hex:
    INT 21h
    CMP AL, 13
    JE sai_input_hex
    CMP AL, 40h
    JB caracter_numero_in

    SUB AL, 7
caracter_numero_in:
    AND AL, 0Fh
    SHL BX, 4
    ADD BL, AL
    INC CL
    JMP le_hex

sai_input_hex:
    MOV input, BX
    MOV tamanho, CL

    POP AX
    RET
endp

print_menu_output proc NEAR ;printa o menu de saida         ;PRONTO
    PUSH AX

    MOV AH, 09h
    MOV DX, OFFSET menu_output
    INT 21h

    POP AX
    RET
endp

output_bin proc NEAR ;output em binario                     ;PRONTO
    PUSH AX

    MOV AX, input
    MOV BX, 2
    XOR CX, CX
empilha_output_bin:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE empilha_output_bin

    MOV AH, 02h
print_bin:
    POP DX
    OR DX, 30h
    INT 21h
    LOOP print_bin

    POP AX
    RET
endp

output_dec proc NEAR ;output em decimal                     ;PRONTO
    PUSH AX

    XOR CX, CX
    MOV AX, input
    MOV BX, 10
transforma_dec:
    XOR DX, DX
    DIV BX
    OR DX, 30h
    PUSH DX
    INC CX
    CMP AX, 0
    JNE transforma_dec

    MOV AH, 02h
print_dec:
    POP DX
    INT 21h
    LOOP print_dec

    POP AX
    RET
endp

output_hex proc NEAR ;output em hexadecimal                 ;PRONTO
    PUSH AX

    XOR CX, CX
    MOV SI, 16
    MOV AX, input
    MOV BX, OFFSET hexadecimal

div_hex:
    XOR DX, DX
    DIV SI
    PUSH DX
    INC CX
    CMP AX, 0
    JNE div_hex

    XOR AX, AX
print_hex:
    POP AX
    XLAT
    MOV DL, AL
    MOV AH, 02h
    INT 21h
    LOOP print_hex

    POP AX
    RET
endp

pede_input proc NEAR
    PUSH AX
    
    MOV DX, OFFSET print_pede_input
    MOV AH, 09h
    INT 21h

    POP AX
    RET
endp

END MAIN