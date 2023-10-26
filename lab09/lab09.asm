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

    hexadecimal DB '0','1','2','3','4','5','6','7', '8','9'
                DB 'A','B','C','D','E','F'

    menu_input  DB '1. Entrada em Binario', 10, 13
                DB '2. Entrada em Decimal', 10, 13
                DB '3. Entrada em Hexadecimal', 10, 13, '$'

    menu_output DB 10, 13, '1. Saida em Binario', 10, 13
                DB '2. Saida em Decimal', 10, 13
                DB '3. Saida em Hexadecimal', 10, 13, '$'

    print_pede_input DB 'Digite um numero: $'
.CODE
main proc
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 08h
    CALL print_menu_input   ;printa as opcoes de entrada
    INT 21h
    AND AL, 0Fh
    new_line
    CALL pede_input

    CMP AL, 1
    JA input_nao_bin
        CALL input_bin      ;1. entrada em binario
        JMP ask_output
input_nao_bin:
    CMP AL, 2
    JA input_nao_dec
        CALL input_dec      ;2. entrada em decimal
        JMP ask_output
input_nao_dec:
        CALL input_hex      ;3. entrada em hexadecimal

ask_output:
    CALL print_menu_output  ;printa as opcoes de saida
    INT 21h
    AND AL, 0Fh
    CMP AL, 1
    JA output_nao_bin
        CALL output_bin     ;1. saida em binario    
        JMP sair
output_nao_bin:
    CMP AL, 2
    JA output_nao_dec
        CALL output_dec     ;2. saida em decimal
        JMP sair
output_nao_dec:
        CALL output_hex     ;3. saida em hexadecimal

sair:
    MOV AH, 4Ch
    INT 21h
endp

print_menu_input proc NEAR  ;printa o menu de entrada
    PUSH AX

    MOV AH, 09h
    MOV DX, OFFSET menu_input
    INT 21h

    POP AX
    RET
endp

input_bin proc NEAR         ;input em binario
    PUSH AX

    XOR BX, BX
    MOV AH, 01h
le_bin:    
    INT 21h         ;pega caracter
    CMP AL, 13
    JE sai_input_bin    ;sai se apertar <enter>

    AND AL, 0Fh     ;transforma caracter em numero
    ROR AL, 1       ;salva o digito 1 ou 0 no carry
    RCL BX, 1       ;coloca o digito salvo em BX
    JMP le_bin
    new_line

sai_input_bin:
    MOV input, BX   ;salva o numero

    POP AX
    RET
endp

input_dec proc NEAR         ;input em decimal
    PUSH AX

    MOV BX, 10      ;multiplicacao
    XOR AX, AX      ;limpa ax para salvar 0 na pilha na primeira vez
    XOR CX, CX

le_dec:
    PUSH AX         ;salva na pilha a soma (ou 0)
    MOV AH, 01h
    INT 21h         ;le caracter
    CMP AL, 13
    JE sai_input_dec    ;sai se apertar <enter>

    AND AL, 0Fh     ;transfoma caracter em numero
    MOV CL, AL      ;guarda o numero temporariamente
    POP AX          ;pega o ultimo numero salvo na pilha
    MUL BX          ;multiplica ele por 10
    ADD AX, CX      ;soma (numero da pilha x 10) + (numero digitado)
    JMP le_dec
sai_input_dec:
    POP AX
    MOV input, AX   ;salva numero

    POP AX
    RET
endp

input_hex proc NEAR         ;input em hexadecimal
    PUSH AX

    XOR BX, BX
    MOV AH, 01h

le_hex:
    INT 21h
    CMP AL, 13
    JE sai_input_hex    ;sai se for <enter>
    CMP AL, 40h
    JB caracter_numero_in   ;jmp se o caracter for numero

    SUB AL, 7           ;-7 para os caracteres que sao letras para facilitar conversao em numero
caracter_numero_in:
    AND AL, 0Fh         ;trasforma o caracter em numero
    SHL BX, 4           ;x16
    ADD BL, AL          ;soma com o numero digitado          
    JMP le_hex

sai_input_hex:
    MOV input, BX       ;salva numero

    POP AX
    RET
endp

print_menu_output proc NEAR ;printa o menu de saida
    PUSH AX

    MOV AH, 09h
    MOV DX, OFFSET menu_output
    INT 21h

    POP AX
    RET
endp

output_bin proc NEAR        ;output em binario
    PUSH AX

    MOV AX, input       ;pega o input (independente da base)
    MOV BX, 2
    XOR CX, CX
empilha_output_bin:
    XOR DX, DX      ;limpa o resto da div
    DIV BX          ;divide numero por 2
    OR DX, 30h      ;transforma em caracter
    PUSH DX         ;salva resto na pilha
    INC CX          ;contador de vezes que tera que desempilhar
    CMP AX, 0       ;ve se o quociente chegou em 0
    JNE empilha_output_bin

    MOV AH, 02h
print_bin:
    POP DX          ;pega o numero da pilha
    INT 21h         ;print
    LOOP print_bin

    POP AX
    RET
endp

output_dec proc NEAR        ;output em decimal
    PUSH AX

    XOR CX, CX
    MOV AX, input       ;pega o input (independente da base)
    MOV BX, 10
transforma_dec:
    XOR DX, DX      ;limpa o resto da div
    DIV BX          ;divide numero por 10
    OR DX, 30h      ;transforma em caracter
    PUSH DX         ;salva resto na pilha
    INC CX          ;contador para desempilhar
    CMP AX, 0       ;ve se quociente chegou em 0
    JNE transforma_dec

    MOV AH, 02h
print_dec:
    POP DX          ;pega numero da pilha
    INT 21h         ;print
    LOOP print_dec

    POP AX
    RET
endp

output_hex proc NEAR        ;output em hexadecimal
    PUSH AX

    XOR CX, CX
    MOV SI, 16
    MOV AX, input       ;pega o input (independente da base)
    MOV BX, OFFSET hexadecimal  ;para trasnformar numero em caracter XLAT

div_hex:
    XOR DX, DX      ;limpa resto da div
    DIV SI          ;divide numero por 16
    PUSH DX         ;empilha
    INC CX          ;contador para desempilhar
    CMP AX, 0       ;ve se quociente chegou em 0
    JNE div_hex

print_hex:
    POP AX          ;pega numero da pilha
    XLAT            ;transforma numero em caracter
    MOV DL, AL
    MOV AH, 02h
    INT 21h         ;printa
    LOOP print_hex

    POP AX
    RET
endp

pede_input proc NEAR        ;pede para usuario digitar o numero
    PUSH AX
    
    MOV DX, OFFSET print_pede_input
    MOV AH, 09h
    INT 21h

    POP AX
    RET
endp

END MAIN