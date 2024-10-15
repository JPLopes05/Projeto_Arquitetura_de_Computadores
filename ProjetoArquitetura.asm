RS      equ     P1.3
EN      equ     P1.2

ORG 0000H

start:
    ACALL lcd_init
    ACALL displayLCD

main_loop:
    ACALL displaySegments
    JMP main_loop

displaySegments:
    SETB P3.4
    SETB P3.3
    MOV P1, #10100100B
    CALL delay

    CLR P3.3
    SETB P3.4
    MOV P1, #11000000B
    CALL delay

    RET

displayLCD:
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
    MOV A, #'C'
    ACALL sendCharacter
    MOV A, #'a'
    ACALL sendCharacter
    MOV A, #'f'
    ACALL sendCharacter
    MOV A, #'e'
    ACALL sendCharacter

    RET

lcd_init:
    CLR RS
    CLR P1.7
    CLR P1.6
    SETB P1.5
    CLR P1.4
    SETB EN
    CLR EN
    CALL short_delay
    SETB EN
    CLR EN
    SETB P1.7
    SETB EN
    CLR EN
    CALL short_delay
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
    CALL short_delay
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
    CALL short_delay
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
    CALL short_delay
    RET

segundaLinha:
    CLR RS
    MOV A, #0C0h
    ACALL sendCommand
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
    CALL short_delay
    RET

delay:
    MOV R0, #200
delay_loop:
    DJNZ R0, delay_loop
    RET

short_delay:
    MOV R0, #50
short_delay_loop:
    DJNZ R0, short_delay_loop
    RET
