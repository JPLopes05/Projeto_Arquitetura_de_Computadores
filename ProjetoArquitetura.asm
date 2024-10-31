RS      equ     P1.3
EN      equ     P1.2

ORG 0000H
    LJMP START

ORG 0030H
START:
    LCALL lcd_init

    LCALL displayInicioMsg
    LCALL delay_10ms
    LCALL clearLCD
    LCALL displayTemperaturaInicial

espera_tecla:
    LCALL leituraTeclado
    JNB F0, espera_tecla
    CLR F0
    JMP main_loop

main_loop:

lcd_init:
    CLR RS

    CLR P1.7
    CLR P1.6
    SETB P1.5
    CLR P1.4

    SETB EN
    CLR EN

    LCALL delay
              
    SETB EN
    CLR EN

    SETB P1.7

    SETB EN
    CLR EN
    LCALL delay

    CLR P1.7
    CLR P1.6
    CLR P1.5
    CLR P1.4

    SETB EN
    CLR EN

    SETB P1.6
    SETB P1.5

    SETB EN
    CLR EN
    LCALL delay

    CLR P1.7
    CLR P1.6
    CLR P1.5
    CLR P1.4

    SETB EN
    CLR EN

    SETB P1.7
    SETB P1.6
    SETB P1.5
    SETB P1.4

    SETB EN
    CLR EN
    LCALL delay
    RET

sendCharacter:
    SETB RS
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
    LCALL delay
    RET

    LCALL leituraTeclado
    JMP main_loop

displayInicioMsg:
    MOV A, #'S'
    LCALL sendCharacter
    MOV A, #'e'
    LCALL sendCharacter
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

    LCALL segundaLinha

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
    RET

displayTemperaturaInicial:
    LCALL clearLCD
    LCALL long_delay
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

    LCALL segundaLinha

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
    RET

colScan:
    JNB P0.4, gotKey
    INC R0
    JNB P0.5, gotKey
    INC R0
    JNB P0.6, gotKey
    INC R0
    RET

gotKey:
    SETB F0
    RET

leituraTeclado:
    MOV R0, #0

    MOV P0, #0FFh
    CLR P0.0
    LCALL colScan
    JB F0, processaTecla

    SETB P0.0
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
    RET

processaTecla:
    CJNE R0, #0BH, tecla1
    LCALL motorHorario
    LCALL displayCafeQuente
    LCALL temperaturaCafeQuente
    LCALL esquentandoCafeQuente
    LCALL delay_10ms
    LCALL desligaMotor
    LCALL bebidaPronta
    LJMP main_loop

tecla1:
    CJNE R0, #0AH, tecla2
    LCALL motorAntiHorario
    LCALL displayCafeGelado
    LCALL temperaturaCafeGelado
    LCALL esfriandoCafeGelado
    LCALL delay_10ms
    LCALL desligaMotor
    LCALL bebidaPronta
    LJMP main_loop

tecla2:
    CJNE R0, #09H, tecla3
    LCALL motorHorario
    LCALL displayChaQuente
    LCALL temperaturaChaQuente
    LCALL esquentandoChaQuente
    LCALL delay_10ms
    LCALL desligaMotor
    LCALL bebidaPronta
    LJMP main_loop

tecla3:
    CJNE R0, #08H, endProcess
    LCALL motorAntiHorario
    LCALL displayChaGelado
    LCALL temperaturaChaGelado
    LCALL esfriandoChaGelado
    LCALL delay_10ms
    LCALL desligaMotor
    LCALL bebidaPronta
    LJMP main_loop

endProcess:
    RET

displayCafeQuente:
    LCALL motorHorario
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'C'
    LCALL desligaMotor
    LCALL sendCharacter
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
    LCALL segundaLinha
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
    LCALL motorAntiHorario
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'C'
    LCALL desligaMotor
    LCALL sendCharacter
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
    LCALL segundaLinha
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
    LCALL motorHorario
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'C'
    LCALL desligaMotor
    LCALL sendCharacter
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
    LCALL segundaLinha
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
    LCALL motorAntiHorario
    LCALL clearLCD
    LCALL long_delay
    MOV A, #'C'
    LCALL desligaMotor
    LCALL sendCharacter
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
    LCALL segundaLinha
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
