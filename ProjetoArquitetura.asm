; Definições de pinos
RS      equ     P1.3        ; Define o pino RS (Register Select) do LCD no pino P1.3
EN      equ     P1.2        ; Define o pino EN (Enable) do LCD no pino P1.2

; Início do programa na posição de memória 0000H
ORG 0000H
    LJMP START              ; Realiza um salto para o rótulo START, iniciando o programa

; Posição de início para a rotina principal
ORG 0030H
START:
    LCALL lcd_init          ; Chama a sub-rotina de inicialização do LCD

    LCALL displayInicioMsg  ; Chama a sub-rotina para exibir a mensagem inicial de boas-vindas
    LCALL delay_10ms        ; Adiciona um pequeno atraso de 10ms
    LCALL clearLCD          ; Chama a sub-rotina para limpar o display LCD
    LCALL displayTemperaturaInicial ; Exibe a temperatura inicial no LCD

; Espera por uma tecla ser pressionada
espera_tecla:
    LCALL leituraTeclado    ; Chama a sub-rotina para ler o teclado
    JNB F0, espera_tecla    ; Se F0 estiver limpo (nenhuma tecla pressionada), volta para 'espera_tecla'
    CLR F0                  ; Limpa o flag F0 ao detectar uma tecla pressionada
    JMP main_loop           ; Vai para o loop principal do programa

; Rotina principal
main_loop:

; Sub-rotina lcd_init - Inicializa o LCD
lcd_init:
    CLR RS                  ; Define RS como 0 para enviar comandos ao LCD

    ; Sequência de inicialização do LCD
    CLR P1.7                ; Configura a porta P1.7 como 0
    CLR P1.6                ; Configura a porta P1.6 como 0
    SETB P1.5               ; Configura a porta P1.5 como 1
    CLR P1.4                ; Configura a porta P1.4 como 0

    SETB EN                 ; Ativa o pino Enable
    CLR EN                  ; Desativa o pino Enable, enviando o comando ao LCD

    LCALL delay             ; Adiciona um pequeno atraso para estabilização do comando
              
    SETB EN                 ; Ativa novamente o pino Enable
    CLR EN                  ; Desativa o pino Enable, enviando o próximo comando

    SETB P1.7               ; Define P1.7 como 1

    SETB EN                 ; Ativa o pino Enable
    CLR EN                  ; Desativa o pino Enable

    LCALL delay             ; Adiciona um pequeno atraso

    ; Define a configuração padrão para o LCD
    CLR P1.7
    CLR P1.6
    CLR P1.5
    CLR P1.4

    SETB EN                 ; Ativa o pino Enable
    CLR EN                  ; Desativa o pino Enable

    ; Configuração para 8 bits e 2 linhas
    SETB P1.6
    SETB P1.5

    SETB EN                 ; Ativa o pino Enable
    CLR EN                  ; Desativa o pino Enable

    LCALL delay             ; Adiciona um pequeno atraso

    ; Habilita o cursor e configura para escrita
    CLR P1.7
    CLR P1.6
    CLR P1.5
    CLR P1.4

    SETB EN                 ; Ativa o pino Enable
    CLR EN                  ; Desativa o pino Enable

    SETB P1.7
    SETB P1.6
    SETB P1.5
    SETB P1.4

    SETB EN                 ; Ativa o pino Enable
    CLR EN                  ; Desativa o pino Enable

    LCALL delay             ; Adiciona um pequeno atraso final para estabilizar o LCD
    RET                     ; Retorna da sub-rotina lcd_init

; Sub-rotina sendCharacter - Envia um caractere para o LCD
sendCharacter:
    SETB RS                 ; Define RS como 1 para indicar que é um dado (não comando)

    ; Transfere bits do acumulador (ACC) para o LCD
    MOV C, ACC.7            ; Move o bit 7 do ACC para o carry
    MOV P1.7, C             ; Move o carry para P1.7
    MOV C, ACC.6            ; Move o bit 6 do ACC para o carry
    MOV P1.6, C             ; Move o carry para P1.6
    MOV C, ACC.5            ; Move o bit 5 do ACC para o carry
    MOV P1.5, C             ; Move o carry para P1.5
    MOV C, ACC.4            ; Move o bit 4 do ACC para o carry
    MOV P1.4, C             ; Move o carry para P1.4

    SETB EN                 ; Ativa o pino Enable
    CLR EN                  ; Desativa o pino Enable, enviando a primeira metade do dado

    ; Envia a segunda metade do caractere
    MOV C, ACC.3
    MOV P1.7, C
    MOV C, ACC.2
    MOV P1.6, C
    MOV C, ACC.1
    MOV P1.5, C
    MOV C, ACC.0
    MOV P1.4, C

    SETB EN                 ; Ativa o pino Enable
    CLR EN                  ; Desativa o pino Enable, completando o envio do caractere

    LCALL delay             ; Atraso para estabilizar o caractere enviado
    LCALL delay             ; Atraso adicional
    RET                     ; Retorna da sub-rotina sendCharacter

    ; Continuação do loop de leitura do teclado
    LCALL leituraTeclado    ; Chama a leitura do teclado novamente
    JMP main_loop           ; Volta ao loop principal

; Sub-rotina displayInicioMsg - Exibe a mensagem inicial no LCD
displayInicioMsg:
    MOV A, #'S'             ; Carrega o caractere 'S' no acumulador
    LCALL sendCharacter     ; Envia o caractere para o LCD
    MOV A, #'e'             ; Carrega 'e' no acumulador
    LCALL sendCharacter     ; Envia 'e' para o LCD
    MOV A, #'l'
    LCALL sendCharacter
    MOV A, #'e'
    LCALL sendCharacter
    MOV A, #'c'
    LCALL sendCharacter
    MOV A, #'i'
    LCALL sendCharacter
    MOV A, #'o'
    LCALL sendCharacter
    MOV A, #'n'
    LCALL sendCharacter
    MOV A, #'e'
    LCALL sendCharacter
    MOV A, #' '
    LCALL sendCharacter
    MOV A, #'o'
    LCALL sendCharacter
    MOV A, #' '
    LCALL sendCharacter
    MOV A, #'t'
    LCALL sendCharacter
    MOV A, #'i'
    LCALL sendCharacter
    MOV A, #'p'
    LCALL sendCharacter
    MOV A, #'o'
    LCALL sendCharacter

    LCALL segundaLinha      ; Move o cursor para a segunda linha do LCD

    ; Exibe "de bebida 1 a 4" na segunda linha
    MOV A, #'d'
    LCALL sendCharacter
    MOV A, #'e'
    LCALL sendCharacter
    MOV A, #' '
    LCALL sendCharacter
    MOV A, #'b'
    LCALL sendCharacter
    MOV A, #'e'
    LCALL sendCharacter
    MOV A, #'b'
    LCALL sendCharacter
    MOV A, #'i'
    LCALL sendCharacter
    MOV A, #'d'
    LCALL sendCharacter
    MOV A, #'a'
    LCALL sendCharacter
    MOV A, #' '
    LCALL sendCharacter
    MOV A, #'1'
    LCALL sendCharacter
    MOV A, #' '
    LCALL sendCharacter
    MOV A, #'a'
    LCALL sendCharacter
    MOV A, #' '
    LCALL sendCharacter
    MOV A, #'4'
    LCALL sendCharacter
    RET                     ; Retorna da sub-rotina displayInicioMsg

; Sub-rotina displayTemperaturaInicial - Exibe a temperatura inicial no LCD
displayTemperaturaInicial:
    LCALL clearLCD          ; Limpa o LCD antes de exibir a temperatura
    LCALL long_delay        ; Atraso longo para estabilização

    ; Exibe "Temperatura da" na primeira linha
    MOV A, #'T'
    LCALL sendCharacter
    MOV A, #'e'
    LCALL sendCharacter
    MOV A, #'m'
    LCALL sendCharacter
    MOV A, #'p'
    LCALL sendCharacter
    MOV A, #'e'
    LCALL sendCharacter
    MOV A, #'r'
    LCALL sendCharacter
    MOV A, #'a'
    LCALL sendCharacter
    MOV A, #'t'
    LCALL sendCharacter
    MOV A, #'u'
    LCALL sendCharacter
    MOV A, #'r'
    LCALL sendCharacter
    MOV A, #'a'
    LCALL sendCharacter
    MOV A, #' '
    LCALL sendCharacter
    MOV A, #'d'
    LCALL sendCharacter
    MOV A, #'a'
    LCALL sendCharacter

    LCALL segundaLinha      ; Move o cursor para a segunda linha do LCD

    ; Exibe "agua atual 20C" na segunda linha
    MOV A, #'a'
    LCALL sendCharacter
    MOV A, #'g'
    LCALL sendCharacter
    MOV A, #'u'
    LCALL sendCharacter
    MOV A, #'a'
    LCALL sendCharacter
    MOV A, #' '
    LCALL sendCharacter
    MOV A, #'a'
    LCALL sendCharacter
    MOV A, #'t'
    LCALL sendCharacter
    MOV A, #'u'
    LCALL sendCharacter
    MOV A, #'a'
    LCALL sendCharacter
    MOV A, #'l'
    LCALL sendCharacter
    MOV A, #' '
    LCALL sendCharacter
    MOV A, #'2'
    LCALL sendCharacter
    MOV A, #'0'
    LCALL sendCharacter
    MOV A, #'C'
    LCALL sendCharacter
    RET                     ; Retorna da sub-rotina displayTemperaturaInicial

;Escaneia as colunas do teclado para verificar se uma tecla foi pressionada
colScan:
    JNB P0.4, gotKey        ; Verifica a tecla na coluna P0.4; se pressionada, vai para gotKey
    INC R0                  ; Incrementa R0 para identificar a próxima coluna
    JNB P0.5, gotKey        ; Verifica a tecla na coluna P0.5; se pressionada, vai para gotKey
    INC R0
    JNB P0.6, gotKey        ; Verifica a tecla na coluna P0.6; se pressionada, vai para gotKey
    INC R0
    RET                     ; Retorna se nenhuma tecla foi detectada

gotKey:
    SETB F0                 ; Define o flag F0 para sinalizar que uma tecla foi pressionada
    RET

;Varre as linhas do teclado para identificar a tecla pressionada
leituraTeclado:
    MOV R0, #0              ; Inicializa o contador de teclas em R0

    ; Ativa cada linha do teclado, chama colScan e verifica se F0 foi ativado
    MOV P0, #0FFh           ; Configura a porta P0 para leitura do teclado
    CLR P0.0
    LCALL colScan
    JB F0, processaTecla    ; Se uma tecla foi pressionada, processa a tecla

    SETB P0.0               ; Reseta a linha anterior e ativa a próxima
    CLR P0.1
    LCALL colScan
    JB F0, processaTecla

    SETB P0.1
    CLR P0.2
    LCALL colScan
    JB F0, processaTecla

    SETB P0.2
    CLR P0.3
    LCALL colScan
    JB F0, processaTecla
    RET                     ; Retorna se nenhuma tecla foi pressionada

;Verifica a tecla pressionada e executa a ação correspondente
processaTecla:
    CJNE R0, #0BH, tecla1   ; Se a tecla é 1 executa as ações de café quente
    LCALL motorHorario
    LCALL displayCafeQuente
    LCALL temperaturaCafeQuente
    LCALL esquentandoCafeQuente
    LCALL delay_10ms
    LCALL desligaMotor
    LCALL bebidaPronta
    LJMP main_loop          ; Retorna ao loop principal após preparar a bebida

tecla1:
    CJNE R0, #0AH, tecla2   ; Se a tecla é 2 executa as ações de café gelado
    LCALL motorAntiHorario
    LCALL displayCafeGelado
    LCALL temperaturaCafeGelado
    LCALL esfriandoCafeGelado
    LCALL delay_10ms
    LCALL desligaMotor
    LCALL bebidaPronta
    LJMP main_loop

tecla2:
    CJNE R0, #09H, tecla3   ; Se a tecla é 3 executa as ações de chá quente
    LCALL motorHorario
    LCALL displayChaQuente
    LCALL temperaturaChaQuente
    LCALL esquentandoChaQuente
    LCALL delay_10ms
    LCALL desligaMotor
    LCALL bebidaPronta
    LJMP main_loop

tecla3:
    CJNE R0, #08H, endProcess ; Se a tecla é 4 executa as ações de chá gelado
    LCALL motorAntiHorario
    LCALL displayChaGelado
    LCALL temperaturaChaGelado
    LCALL esfriandoChaGelado
    LCALL delay_10ms
    LCALL desligaMotor
    LCALL bebidaPronta
    LJMP main_loop

endProcess:
    RET                     ; Finaliza a execução da rotina de processaTecla

displayCafeQuente:
    LCALL motorHorario       ; Inicia o motor no sentido horário (bebidas quentes)
    LCALL clearLCD           ; Limpa o display LCD para a nova mensagem
    LCALL long_delay         ; Adiciona um atraso para estabilidade do display
    MOV A, #'C'              ; Carrega o caractere 'C' no acumulador para exibir no LCD
    LCALL desligaMotor       ; Desliga o motor momentaneamente para o próximo caractere
    LCALL sendCharacter      ; Envia o caractere 'C' para o display
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'f'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'Q'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'u'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'n'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'t'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'['
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'1'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #']'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario

    LCALL desligaMotor
    LCALL segundaLinha ; Move o cursor do LCD para a segunda linha
    LCALL motorHorario

    MOV A, #'f'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'l'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'c'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'n'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'d'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    LCALL desligaMotor
    RET

displayCafeGelado:
    LCALL motorAntiHorario   ; Inicia o motor no sentido anti-horário (bebidas frias)
    LCALL clearLCD           ; Limpa o display LCD para a nova mensagem
    LCALL long_delay         ; Adiciona um atraso para estabilidade do display
    MOV A, #'C'              ; Carrega o caractere 'C' no acumulador para exibir no LCD
    LCALL desligaMotor       ; Desliga o motor momentaneamente para o próximo caractere
    LCALL sendCharacter      ; Envia o caractere 'C' para o display
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'f'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'G'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'l'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'d'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'['
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'2'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #']'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario

    LCALL desligaMotor
    LCALL segundaLinha ; Move o cursor do LCD para a segunda linha
    LCALL motorAntiHorario

    MOV A, #'f'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'l'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'c'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'n'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'d'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    LCALL desligaMotor
    RET

displayChaQuente:
    LCALL motorHorario       ; Inicia o motor no sentido horário (bebidas quentes)
    LCALL clearLCD           ; Limpa o display LCD para a nova mensagem
    LCALL long_delay         ; Adiciona um atraso para estabilidade do display
    MOV A, #'C'              ; Carrega o caractere 'C' no acumulador para exibir no LCD
    LCALL desligaMotor       ; Desliga o motor momentaneamente para o próximo caractere
    LCALL sendCharacter      ; Envia o caractere 'C' para o display
    LCALL motorHorario
    MOV A, #'h'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'Q'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'u'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'n'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'t'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'['
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'3'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #']'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario

    LCALL desligaMotor
    LCALL segundaLinha ; Move o cursor do LCD para a segunda linha
    LCALL motorHorario

    MOV A, #'f'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'l'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'c'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'n'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'d'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    LCALL desligaMotor
    RET

displayChaGelado:
    LCALL motorAntiHorario   ; Inicia o motor no sentido anti-horário (bebidas frias)
    LCALL clearLCD           ; Limpa o display LCD para a nova mensagem
    LCALL long_delay         ; Adiciona um atraso para estabilidade do display
    MOV A, #'C'              ; Carrega o caractere 'C' no acumulador para exibir no LCD
    LCALL desligaMotor       ; Desliga o motor momentaneamente para o próximo caractere
    LCALL sendCharacter      ; Envia o caractere 'C' para o display
    LCALL motorAntiHorario
    MOV A, #'h'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'G'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'l'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'d'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'['
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'4'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #']'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario

    LCALL desligaMotor
    LCALL segundaLinha ; Move o cursor do LCD para a segunda linha
    LCALL motorAntiHorario

    MOV A, #'f'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'l'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'c'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'n'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'d'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    LCALL desligaMotor
    RET

temperaturaCafeQuente:
    LCALL motorHorario
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'T'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'m'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'p'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'t'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'u'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario

    LCALL desligaMotor
    LCALL segundaLinha
    LCALL motorHorario

    MOV A, #'N'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'c'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'4'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'5'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'C'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    LCALL desligaMotor
    RET

temperaturaCafeGelado:
    LCALL motorAntiHorario
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'T'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'m'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'p'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'t'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'u'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario

    LCALL desligaMotor
    LCALL segundaLinha
    LCALL motorAntiHorario

    MOV A, #'N'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'c'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'5'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'C'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    LCALL desligaMotor
    RET

temperaturaChaQuente:
    LCALL motorHorario
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'T'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'m'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'p'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'t'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'u'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario

    LCALL desligaMotor
    LCALL segundaLinha
    LCALL motorHorario

    MOV A, #'N'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'c'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'4'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'0'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'C'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    LCALL desligaMotor
    RET

temperaturaChaGelado:
    LCALL motorAntiHorario
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'T'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'m'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'p'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'t'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'u'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario

    LCALL desligaMotor
    LCALL segundaLinha
    LCALL motorAntiHorario

    MOV A, #'N'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'c'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'1'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'0'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'C'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    LCALL desligaMotor
    RET

esquentandoCafeQuente:
    LCALL motorHorario
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'E'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'q'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'u'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'n'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'t'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'n'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'d'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario

    LCALL desligaMotor
    LCALL segundaLinha
    LCALL motorHorario

    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'g'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'u'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'t'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'4'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'5'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'C'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    LCALL desligaMotor
    RET

esfriandoCafeGelado:
    LCALL motorAntiHorario
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'E'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'f'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'n'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'d'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario

    LCALL desligaMotor
    LCALL segundaLinha
    LCALL motorAntiHorario

    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'g'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'u'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'t'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'5'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'C'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    LCALL desligaMotor
    RET

esquentandoChaQuente:
    LCALL motorHorario
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'E'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'q'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'u'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'n'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'t'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'n'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'d'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario

    LCALL desligaMotor
    LCALL segundaLinha
    LCALL motorHorario

    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'g'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'u'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'t'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'4'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'0'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    MOV A, #'C'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorHorario
    LCALL desligaMotor
    RET

esfriandoChaGelado:
    LCALL motorAntiHorario
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'E'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'s'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'f'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'r'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'i'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'n'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'d'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'o'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario

    LCALL desligaMotor
    LCALL segundaLinha
    LCALL motorAntiHorario

    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'g'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'u'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'a'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'t'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'e'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #' '
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'1'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'0'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    MOV A, #'C'
    LCALL desligaMotor
    LCALL sendCharacter
    LCALL motorAntiHorario
    LCALL desligaMotor
    RET

bebidaPronta:
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'B'
    LCALL sendCharacter
    MOV A, #'e'
    LCALL sendCharacter
    MOV A, #'b'
    LCALL sendCharacter
    MOV A, #'i'
    LCALL sendCharacter
    MOV A, #'d'
    LCALL sendCharacter
    MOV A, #'a'
    LCALL sendCharacter
    MOV A, #' '
    LCALL sendCharacter
    MOV A, #'p'
    LCALL sendCharacter
    MOV A, #'r'
    LCALL sendCharacter
    MOV A, #'o'
    LCALL sendCharacter
    MOV A, #'n'
    LCALL sendCharacter
    MOV A, #'t'
    LCALL sendCharacter
    MOV A, #'a'
    LCALL sendCharacter
    
espera_fim:
    NOP
    SJMP espera_fim
    RET

clearLCD:
    MOV A, #01H
    LCALL sendCommand
    RET

segundaLinha:
    CLR RS
    MOV A, #0C0H
    LCALL sendCommand
    RET

delay_10ms:
    MOV R2, #2

delay_10ms_loop:
    MOV R1, #250

delay_inner_loop:
    DJNZ R1, delay_inner_loop
    DJNZ R2, delay_10ms_loop
    RET

long_delay:
    MOV R2, #5

long_delay_loop:
    MOV R1, #250

delay_inner_loop_long:
    DJNZ R1, delay_inner_loop_long
    DJNZ R2, long_delay_loop
    RET

sendCommand:
    CLR RS
    MOV C, ACC.7
    MOV P1.7, C
    MOV C, ACC.6
    MOV P1.6, C
    MOV C, ACC.5
    MOV P1.5, C
    MOV C, ACC.4
    MOV P1.4, C
    SETB EN
    CLR EN
    MOV C, ACC.3
    MOV P1.7, C
    MOV C, ACC.2
    MOV P1.6, C
    MOV C, ACC.1
    MOV P1.5, C
    MOV C, ACC.0
    MOV P1.4, C
    SETB EN
    CLR EN
    LCALL delay
    RET

motorHorario:
    SETB P3.0
    CLR P3.1
    RET

motorAntiHorario:
    CLR P3.0
    SETB P3.1
    RET

desligaMotor:
    CLR P3.0
    CLR P3.1
    RET

delay:
    MOV R0, #50

short_delay_loop:
    DJNZ R0, short_delay_loop
    RET
