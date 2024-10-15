 RS      equ     P1.3
 EN      equ     P1.2

org 0000h
	LJMP START

org 0030h
START:
	acall lcd_init
	ACALL posicionaCursor 

	; Exibe "Selecione o tipo"
	MOV A, #'S'
	ACALL sendCharacter
	CALL delay

	MOV A, #'e'
	ACALL sendCharacter
	CALL delay

	MOV A, #'l'
	ACALL sendCharacter
	CALL delay

	MOV A, #'e'
	ACALL sendCharacter
	CALL delay

	MOV A, #'c'
	ACALL sendCharacter
	CALL delay

	MOV A, #'i'
	ACALL sendCharacter
	CALL delay

	MOV A, #'o'
	ACALL sendCharacter
	CALL delay

	MOV A, #'n'
	ACALL sendCharacter
	CALL delay

	MOV A, #'e'
	ACALL sendCharacter
	CALL delay

	MOV A, #' '
	ACALL sendCharacter
	CALL delay

	MOV A, #'o'
	ACALL sendCharacter
	CALL delay

	MOV A, #' '
	ACALL sendCharacter
	CALL delay

	MOV A, #'t'
	ACALL sendCharacter
	CALL delay

	MOV A, #'i'
	ACALL sendCharacter
	CALL delay

	MOV A, #'p'
	ACALL sendCharacter
	CALL delay

	MOV A, #'o'
	ACALL sendCharacter
	CALL delay

	; Muda para a segunda linha do display
	ACALL segundaLinha

	; Exibe "de Café"
	MOV A, #'d'
	ACALL sendCharacter
	CALL delay

	MOV A, #'e'
	ACALL sendCharacter
	CALL delay

	MOV A, #' '
	ACALL sendCharacter
	CALL delay

	MOV A, #'C'
	ACALL sendCharacter
	CALL delay

	MOV A, #'a'
	ACALL sendCharacter
	CALL delay

	MOV A, #'f'
	ACALL sendCharacter
	CALL delay

	MOV A, #'e'
	ACALL sendCharacter
	CALL delay

	JMP $

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
	RET

posicionaCursor:
	CLR RS
	SETB P1.7
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

segundaLinha:
	; Muda o cursor para o início da segunda linha
	CLR RS
	MOV A, #0C0h  ; Endereço da segunda linha no LCD
	ACALL sendCommand
	CALL delay
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
	DJNZ R0, $
	RET
