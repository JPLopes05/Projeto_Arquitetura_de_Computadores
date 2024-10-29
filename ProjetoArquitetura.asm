RS      equ     P1.3
EN      equ     P1.2

ORG 0000H
    LJMP START

ORG 0030H
START:
    ACALL lcd_init

    ACALL displayInicioMsg
    ACALL delay_10ms
    ACALL clearLCD
    ACALL displayTemperaturaInicial

espera_tecla:
    ACALL leituraTeclado
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

    CALL delay
              
    SETB EN
    CLR EN

    SETB P1.7

    SETB EN
    CLR EN
    CALL delay

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
    CALL delay

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
    CALL delay
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

    CALL delay
    CALL delay
    RET

    ACALL leituraTeclado
    JMP main_loop

displayInicioMsg:
    MOV A, #'S'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'l'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'c'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'p'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'b'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'b'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'1'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'4'
    ACALL sendCharacter
    RET

displayTemperaturaInicial:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'T'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'m'
    ACALL sendCharacter
    MOV A, #'p'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'g'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'l'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'2'
    ACALL sendCharacter
    MOV A, #'0'
    ACALL sendCharacter
    MOV A, #'C'
    ACALL sendCharacter
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
    CALL colScan
    JB F0, processaTecla

    SETB P0.0
    CLR P0.1
    CALL colScan
    JB F0, processaTecla

    SETB P0.1
    CLR P0.2
    CALL colScan
    JB F0, processaTecla

    SETB P0.2
    CLR P0.3
    CALL colScan
    JB F0, processaTecla
    RET

processaTecla:
    CJNE R0, #0BH, tecla1
    ACALL displayCafeQuente
    ACALL temperaturaCafeQuente
    ACALL esquentandoCafeQuente
    ACALL delay_10ms
    ACALL bebidaPronta
    LJMP main_loop

tecla1:
    CJNE R0, #0AH, tecla2
    ACALL displayCafeGelado
    ACALL temperaturaCafeGelado
    ACALL esfriandoCafeGelado
    ACALL delay_10ms
    ACALL bebidaPronta
    LJMP main_loop

tecla2:
    CJNE R0, #09H, tecla3
    ACALL displayChaQuente
    ACALL temperaturaChaQuente
    ACALL esquentandoChaQuente
    ACALL delay_10ms
    ACALL bebidaPronta
    LJMP main_loop

tecla3:
    CJNE R0, #08H, endProcess
    ACALL displayChaGelado
    ACALL temperaturaChaGelado
    ACALL esfriandoChaGelado
    ACALL delay_10ms
    ACALL bebidaPronta
    LJMP main_loop

endProcess:
    RET

displayCafeQuente:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'C'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'f'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'Q'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'['
    ACALL sendCharacter
    MOV A, #'1'
    ACALL sendCharacter
    MOV A, #']'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'f'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'l'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'c'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    RET

displayCafeGelado:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'C'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'f'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'G'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'l'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'['
    ACALL sendCharacter
    MOV A, #'2'
    ACALL sendCharacter
    MOV A, #']'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'f'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'l'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'c'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    RET

displayChaQuente:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'C'
    ACALL sendCharacter
    MOV A, #'h'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'Q'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'['
    ACALL sendCharacter
    MOV A, #'3'
    ACALL sendCharacter
    MOV A, #']'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'f'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'l'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'c'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    RET

displayChaGelado:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'C'
    ACALL sendCharacter
    MOV A, #'h'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'G'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'l'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'['
    ACALL sendCharacter
    MOV A, #'4'
    ACALL sendCharacter
    MOV A, #']'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'f'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'l'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'c'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    RET

temperaturaCafeQuente:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'T'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'m'
    ACALL sendCharacter
    MOV A, #'p'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'N'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'c'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'4'
    ACALL sendCharacter
    MOV A, #'5'
    ACALL sendCharacter
    MOV A, #'C'
    ACALL sendCharacter
    RET

temperaturaCafeGelado:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'T'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'m'
    ACALL sendCharacter
    MOV A, #'p'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'N'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'c'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'5'
    ACALL sendCharacter
    MOV A, #'C'
    ACALL sendCharacter
    RET

temperaturaChaQuente:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'T'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'m'
    ACALL sendCharacter
    MOV A, #'p'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'a'

    ACALL segundaLinha

    ACALL sendCharacter
    MOV A, #'N'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'c'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'4'
    ACALL sendCharacter
    MOV A, #'0'
    ACALL sendCharacter
    MOV A, #'C'
    ACALL sendCharacter
    RET

temperaturaChaGelado:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'T'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'m'
    ACALL sendCharacter
    MOV A, #'p'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'N'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'c'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'1'
    ACALL sendCharacter
    MOV A, #'0'
    ACALL sendCharacter
    MOV A, #'C'
    ACALL sendCharacter
    RET

esquentandoCafeQuente:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'E'
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'q'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'g'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'4'
    ACALL sendCharacter
    MOV A, #'5'
    ACALL sendCharacter
    MOV A, #'C'
    ACALL sendCharacter
    RET

esfriandoCafeGelado:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'E'
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'f'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'g'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'5'
    ACALL sendCharacter
    MOV A, #'C'
    ACALL sendCharacter
    RET

esquentandoChaQuente:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'E'
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'q'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'g'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'4'
    ACALL sendCharacter
    MOV A, #'0'
    ACALL sendCharacter
    MOV A, #'C'
    ACALL sendCharacter
    RET

esfriandoChaGelado:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'E'
    ACALL sendCharacter
    MOV A, #'s'
    ACALL sendCharacter
    MOV A, #'f'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter

    ACALL segundaLinha

    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'g'
    ACALL sendCharacter
    MOV A, #'u'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'1'
    ACALL sendCharacter
    MOV A, #'0'
    ACALL sendCharacter
    MOV A, #'C'
    ACALL sendCharacter
    RET

bebidaPronta:
    ACALL clearLCD
    ACALL long_delay
    MOV A, #'B'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter
    MOV A, #'b'
    ACALL sendCharacter
    MOV A, #'i'
    ACALL sendCharacter
    MOV A, #'d'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #' '
    ACALL sendCharacter
    MOV A, #'p'
    ACALL sendCharacter
    MOV A, #'r'
    ACALL sendCharacter
    MOV A, #'o'
    ACALL sendCharacter
    MOV A, #'n'
    ACALL sendCharacter
    MOV A, #'t'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    
espera_fim:
    NOP
    SJMP espera_fim
    RET

clearLCD:
    MOV A, #01H
    ACALL sendCommand
    RET

segundaLinha:
    CLR RS
    MOV A, #0C0H
    ACALL sendCommand
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
    CALL delay
    RET

delay:
    MOV R0, #50
short_delay_loop:
    DJNZ R0, short_delay_loop
    RET
