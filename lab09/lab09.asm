;input nas bases - binario, decimal e hexadecimal
;output nas bases - binario, decimal e hexadecimal
.MODEL SMALL

new_line macro
    MOV AH, 02h
    MOV DL, 10
    INT 21h

    MOV DL, 13
    INT 21h
endm

space macro
    MOV AH, 02h
    MOV DL, ' '
    INT 21h
endm

.STACK 100h
.DATA
    input DW ?
    tamanho DB 0
    hexadecimal DB 10, 11, 12, 13, 14, 15   ; A, B, C, D, E, F
.CODE
main proc
    MOV AX, @DATA
    MOV DS, AX

    CALL input_hex
    CALL output_dec

    MOV AH, 4Ch
    INT 21h
endp

print_menu_input proc NEAR ;printa o menu de entrada

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

input_hex proc NEAR ;input em hexadecimal
    PUSH AX
    
    RET
endp

print_menu_output proc NEAR ;printa o menu de saida

    RET
endp

output_bin proc NEAR ;output em binario

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

output_hex proc NEAR ;output em hexadecimal

    RET
endp

END MAIN