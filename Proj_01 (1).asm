TITLE ALEXANDRE AUGUSTO TESCARO OLIVEIRA | HUGO TAHARA MENEGATTI 
.model SMALL
.data

    msg1 db 10, ' <<<  Operacoes disponiveis: + - / *  >>> ', 10, '$'
    msg2 db 10, 10,  ' -> Digite a operacao:   ', '$'
    msg3 db 10, 10, 'Resultado da operacao:   ', '$'
    msg4 db '_-_-_-_-_-_-_-_- CALCULADORA _-_-_-_-_-_-_-_-', 10, '$'
    msg5 db 10, '_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-', 10, '$'
    msg6 db 10, 'Resto da Operacao: ', '$'
    msg7 db 10, 'Nao coloque divisor 0, insira novamente: ',  '$'
    msgfinal db 10, 10,  ' -> Deseja realizar novas operacoes? (s/n):   ', '$'

    NUM1 DB ?                                       ; DEFININDO ESPACO PARA ARMAZENAR OS NUMEROS
    NUM2 DB ?

.code
    main proc
    MOV AX, @DATA                                   ; INICAR O @DATA
    MOV DS, AX

    RENICIAR:
    
    CALL cabecario                                  ; CHAMA O PROCEDIMENTO DO CABEÇARIO
    CALL leitura_mais_sinal                         ; CHAMA O PROCEDIMENTO PARA LEITURA DO PRIMEIRO NUMERO E SINAL DA OPERACAO
    
    CMP AL, '+'                                     ; SE O OPERANDO FOR + PULAR PARA SOMA
    JE SOMA

    CMP AL, '-'                                     ; SE O OPERANDO FOR - PULAR PARA SUBTRACAO
    JE SUBTRACAO
    
    CMP AL, '*'                                     ; SE O OPERANDO FOR * PULAR PARA MULTI
    JE MULTI
    
    CMP AL, '/'                                     ; SE O OPERANDO FOR / PULAR PARA DIVI
    JE DIVI

    SOMA: CALL FSOMA
    SUBTRACAO: CALL FSUBTRACAO
    MULTI: CALL FMULTI
    DIVI: CALL FDIVI
    PERGUNTA:                                       ; PROCESSO PARA PERGUNTAR SE O USUARIO DESEJA REALIZAR NOVAS OPERACOES 
        MOV AH, 09
        LEA DX, msgfinal                            ; EXIBI A MENSAGEM DA PERGUNTA
        INT 21H
        MOV AH, 01                                  ; LE O CARACTER S OU N
        INT 21H
        CMP AL, 's'                                 ; SE A RESPOSTA FOR 's', PULA PARA RENICIA E EXECUTA TUDO DE NOVO
        JE RENICIAR
    FIM: call final                                 ; FIM DO PROGRAMA

    main ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cabecario proc
    MOV AX, 3                       ; COMANDO PARA DAR CLEAR CONSOLE 
    INT 10H
    MOV AH, 06h                     ; SERIE DE COMANDOS PARA ALTERAR A APARECENCIA DO CONSOLE 
    XOR AL, AL     
    XOR CX, CX     
    MOV DX, 184FH   
    MOV BH, 1EH    
    INT 10H
    
    MOV AH, 09                      ; EXIBIR A MENSAGEM DAS OPERACOES DISPONIVEIS
    LEA DX, msg4  
    INT 21H

    MOV AH, 09                      ; EXIBIR A MENSAGEM DAS OPERACOES DISPONIVEIS
    LEA DX, msg1  
    INT 21H

    MOV AH, 09                      ; EXIBIR A MENSAGEM PARA DIGITAR A OPERACAO
    LEA DX, msg2  
    INT 21H
    RET
    cabecario ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    leitura_mais_sinal proc
    MOV AH, 01                      ; LER O PRIMEIRO NUMERO
    INT 21H
    SUB AL, 30H                     ; SUBTRAI 30H DO PRIMEIRO NUMERO LIDO PARA REALIZAR AS OPERACOES 
    MOV NUM1, AL                    ; MOVER O NUMERO LIDO PARA NUM1 DECLARADA NO @DATA
    MOV AH, 01                      ; LER O OPERANDO
    INT 21H    
    RET
    leitura_mais_sinal ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    FSOMA proc  
        MOV AH, 01                  ; LER O SEGUNDO NUMERO
        INT 21H
        SUB AL, 30H                 ; SUBTRAI 30H DO SEGUNDO NUMERO LIDO PARA REALIZAR AS OPERACOES 
        MOV NUM2, AL                ; MOVER O NUMERO LIDO PARA NUM2 DECLARADA NO @DATA
        MOV AH, 09                
        LEA DX, msg3                ; EXIBIR A MENSAGEM DE RESULTADO
        INT 21H
        MOV DL, NUM1                ; MOVE O PRIMEIRO NUMERO LIDO PARA DL
        ADD DL, NUM2                ; ADICIONA O VALOR DO SEGUNDO NUMERO LIDO AO PRIMEIRO NUMERO LIDO, RESULTANDO NA OPERACAO DE SOMA ENTRE ELES
        CMP DL, 0AH                 ; COMPARA O RESULTADO DA SOMA COM 10, SE FOR MAIOR OU IGUAL A 10, PULA PARA IMP, ONDE VAI CHAMAR O PROCEDIMENTO DE IMPRIMIR NUMEROS DE DOIS DIGITOS
        JGE IMP
        ADD DL, 30H                 ; SOMA 30H, PARA TRANSFORMAR DE VOLTA A TABELA ASCII E IMPRIMIR O RESULTADO
        MOV AH, 02                  ; COMO O NUMERO NÃO É DE DOIS DIGITOS, É SÓ IMPRIMIR ELE DIRETO 
        INT 21H                     
        JMP PERGUNTA                ; PULA PARA A PARTE DA PERGUNTA SOBRE REALIZAR NOVAS OPERAÇÕES 
        IMP:
            CALL imprime2           ; CHAMA O PROCEDIMENTO DE IMPRIMIR NUMEROS DE DOIS CARACTERES
    RET
    FSOMA ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    FSUBTRACAO proc
        MOV AH, 01                  ; LER O SEGUNDO NUMERO
        INT 21H
        SUB AL, 30H                 ; SUBTRAI 30H DO SEGUNDO NUMERO LIDO PARA REALIZAR AS OPERACOES 
        MOV NUM2, AL                ; MOVER O NUMERO LIDO PARA NUM2 DECLARADA NO @DATA
        MOV AH, 09                  
        LEA DX, msg3                ; EXIBIR A MENSAGEM DE RESULTADO
        INT 21H
        MOV DL, NUM1                ; MOVE O PRIMEIRO NUMERO LIDO PARA DL               
        CMP DL, NUM2                ; COMPARA O SEGUNDO NUMERO LIDO COM O PRIMEIRO
        JC NEGATIVO                 ; SE O SEGUNDO NUMERO LIDO FOR MAIOR DO QUE O PRIMEIRO, PULA PARA NEGATIVO, AONDE VAI REALIZAR A OPERAÇÃO E EXIBIR O RESULTADO NEGATIVO
        SUB DL, NUM2                ; SUBTRAI DO PRIMEIRO NUMERO LIDO O VALOR DO SEGUNDO
        ADD DL, 30H                 ; ADICIONAR 30H AO RESULTADO PARA IMPRIMIR DE ACORDO COM A TABELA ASCII
        MOV AH, 02                  ; IMPRIMIR O RESULTADO
        INT 21H
        JMP PERGUNTA                ; PULA PARA A PARTE DA PERGUNTA SOBRE REALIZAR NOVAS OPERAÇÕES
    RET
    FSUBTRACAO ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    NEGATIVO proc
        SUB NUM2, DL                ; SUBTRAI DE NUM2 O VALOR DO PRIMEIRO NUMERO
        MOV CL, NUM2                ; SALVA O RESULTADO EM CL
        MOV DL, '-'                 ; MOVE '-' PARA IMPRIMIR ANTES DO NUMERO
        MOV AH, 02                  ; IMPRIMI '-'
        INT 21H
        MOV DL, CL                  ; MOVE O RESULTADO PRA DL
        ADD DL, 30H                 ; SOMA 30H, PARA TRANSFORMAR DE VOLTA A TABELA ASCII E IMPRIMIR O RESULTADO
        MOV AH, 02                  ; IMPRIMI O RESULTADO
        INT 21H
        JMP PERGUNTA                ; PULA PARA A PARTE DA PERGUNTA SOBRE REALIZAR NOVAS OPERAÇÕES
    RET
    NEGATIVO ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    FMULTI proc
        MOV AH, 01                  ; LER O SEGUNDO NUMERO
        INT 21H        
        SUB AL, 30H                 ; SUBTRAI 30H DO SEGUNDO NUMERO LIDO PARA REALIZAR AS OPERACOES 
        MOV NUM2, AL                ; MOVER O NUMERO LIDO PARA NUM2 DECLARADA NO @DATA
        MOV AH, 09                 
        LEA DX, msg3                ; EXIBIR A MENSAGEM DE RESULTADO
        INT 21H

        XOR DX, DX                  ; ZERA DX 
        MOV CX, 4                   ; CONTADOR CX COM 4, SENDO O NUMERO DE LOOPS

        MOV BL,NUM1                 ; BL SERA ADICIONADO NO RESULTADO E ROTACIONA A ESQUERDA EM CASA LOOP
        MOV BH,NUM2                 ; BH SERA O NUMERO CONTADOR DE QUANTAS VEZES O BL SERA ACRESCENTADO  
                                    ; BH MANDARA UM VALOR AO CF, SE FOR 0 VAI PULAR
                                    ; CASO O CF FOR 1, SOMA NO DL(RESULTADO) O VALOR DE BL 

        VOLTA:
            SHR BH,1                ; MOVIMENTA BH P/ DIREITA (CF: CASO 1, ADICIONA BL AO RESULTADO E DESLOCA O BH, PARA ESQUERDA PARA A PROXIMA SOMA, CASO 0 APENAS DESLOCA NUM1 PARA ESQUERDA) 
            JNC PULA                
            ADD DL,BL

        PULA:
            SHL BL,1                ; MOVIMENTA BL P/ ESQUERDA A PROXIMA SOMA E PRECISO PULAR UMA CASA A ESQUERDA
            LOOP VOLTA

        CMP DL, 0AH                 ; COMPARA O RESULTADO COM 10, SE FOR MAIOR OU IGUAL A 10, PULA PARA IMPRIME, ONDE VAI CHAMAR O PROCEDIMENTO DE IMPRIMIR NUMEROS DE DOIS DIGITOS
        JGE IMPRIME
        
        ADD DL, 30H                 ; ADICIONAR 30H AO RESULTADO PARA IMPRIMIR DE ACORDO COM A TABELA ASCII 
        MOV AH, 02                  ; IMPRIME O RESULTADO
        INT 21h
        JMP PERGUNTA                ; PULA PARA A PARTE DA PERGUNTA SOBRE REALIZAR NOVAS OPERAÇÕES
        IMPRIME: 
            CALL imprime2           ; CHAMA O PROCEDIMENTO DE IMPRIMIR NUMEROS DE DOIS CARACTERES

    RET
    FMULTI ENDP
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    FDIVI proc
    PULA1:    
        MOV AH, 01                  ; LER O SEGUNDO NUMERO
        INT 21H
        AND AL, 0FH                 ; SUBTRAI 30H DO SEGUNDO NUMERO LIDO PARA REALIZAR AS OPERACOES
        CMP AL, 0
        JZ ERRO 
        MOV NUM2, AL                ; MOVER O NUMERO LIDO PARA NUM2 DECLARADA NO @DATA
        MOV AH, 09
        LEA DX, msg3                ; EXIBIR A MENSAGEM DE RESULTADO
        INT 21H

        XOR CL, CL                  ; ZERA O CONTADOR
        XOR DX, DX                  ; DL USADO PARA O RESTO E DH PARA O QUOCIENTE

        MOV CL, 8                   ; NUMERO DE DESLOCAMENTOS QUE SERAO FEITOS
        MOV BL, NUM2
        
        SALTA:
            MOV BH, NUM1            ; RESTAURA O DIVIDENDO NO LOOP
            SHR BH, CL              ; DESLOCA O DIVIDENDO
            RCL DL, 1               ; GUARDA O CF NO NUMERO DEPOIS DA ROTACAO (RESTO), PEGA OS BITS DO DIVIDENDO
            CMP BL, DL              ; VERIFICA SE O DIVISOR E MAIOR QUE O RESTO
            JG SALTA2
            SUB DL, BL              ; FAZ SUB PARA FICAR MENOR QUE BL
            INC DH                  ; INCREMENTA O RESTO
        
        SALTA2:
            CMP CL, 1
            JE SALTA3
            SHL DH, 1               ; DESLOCA O QUOCIENTE PARA DEIXAR O LSB EM 1 OU 0
        
        SALTA3:
            LOOP SALTA              ; LOOP ATE ZERAR CL

        
        MOV BL, DL                  ; GUARDA O RESTO EM BL
        MOV DL, DH
        ADD DL, 30H
        MOV AH, 02
        INT 21H                     ; IMPRIME O RESULTADO 

        MOV AH, 09
        LEA DX, msg6
        INT 21H
        MOV DL, BL                  ; CHAMA O RESTO NOVAMENTE
        ADD DL, 30H
        MOV AH, 02
        INT 21H                     ; IMPRIME O RESTO
        JMP PERGUNTA

        ERRO:
            MOV AH, 09
            LEA DX, msg7
            INT 21H
            JMP PULA1


    RET
    FDIVI ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    imprime2 proc
        MOV BL, DL                  ; MOVE O RESULTADO PARA O REGISTRADOR BL, PARA PODER REALIZAR AS OPERCOES           
        XOR AX,AX                   ; ZERA O AX 
        MOV AL,BL                   ; ADICIONA O RESULTADO A AL

        MOV BH,10                   ; ADICIONA 10 EM BH, PARA PODER DIVIDIR O RESULTADO POR 10
        DIV BH                      ; DIVIDE O RESULTADO (AL) POR 10, SENDO AL FICANDO COM O RESULTADO, E AH COM O RESTO DA OPERAÇÃO
        MOV BH,AH                   ; MOVE O RESTO DA OPERCAÇÃO PARA ARMAZENAR EM BH
        MOV BL,AL                   ; MOVE O RESULTADO DA OPERCAÇÃO PARA ARMAZENAR EM BL

        MOV DL,BL                   ; MOVE RESULTADO DA DIVISÃO PARA PODER IMPRIMIR PRIMEIRO
        ADD DL,30H                  ; ADICIONAR 30H AO RESULTADO PARA IMPRIMIR DE ACORDO COM A TABELA ASCII 
        MOV AH,02
        INT 21H                     ; IMPRIME O RESULTADO(PRIMEIRO DIGITO DO RESULTADO REAL)

        MOV DL,BH                   ; MOVE O RESTO DA OPERAÇÃO PARA PODER IMPRIMIR DEPOIS DO RESULTADO   
        ADD DL,30H                  ; ADICIONAR 30H AO RESULTADO PARA IMPRIMIR DE ACORDO COM A TABELA ASCII 
        INT 21H                     ; IMPRIME O RESULTADO(PRIMEIRO DIGITO DO RESULTADO REAL)
        JMP PERGUNTA

    RET
    imprime2 ENDP

    
    final proc
        MOV AH, 4Ch             ; FIM DO PROGRAMA
        int 21H
    RET
    final ENDP




end main
