.MODEL SMALL
.DATA
.CODE
main proc
    MOV AH, 01h
inicio:
    INT 21h
    CMP AL, 13
    JNE inicio
    
    MOV AH, 4Ch
    INT 21h
main endp
END MAIN