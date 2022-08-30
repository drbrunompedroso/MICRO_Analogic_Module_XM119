
_config_io:

;level_control.c,33 :: 		void config_io()
;level_control.c,35 :: 		ADCON1=0x0E;    // Configura o Pino (AN0) como canal analógico e o restante com digital
	MOVLW       14
	MOVWF       ADCON1+0 
;level_control.c,36 :: 		TRISE=0x00;     // Configura como Pinos de saída Digital
	CLRF        TRISE+0 
;level_control.c,37 :: 		TRISD=0x00;     // Configura como Pinos de saída Digital
	CLRF        TRISD+0 
;level_control.c,38 :: 		TRISB=0X01;     // RB0 como entrada digital
	MOVLW       1
	MOVWF       TRISB+0 
;level_control.c,39 :: 		TRISC=0X00;     // PORTC como saída digital
	CLRF        TRISC+0 
;level_control.c,40 :: 		PORTE.RE1=0;    // Seleciona como '0' o pino RE1 (R/W do display de lCD)
	BCF         PORTE+0, 1 
;level_control.c,41 :: 		PORTD=0x00;     // Seleciona como '0' os pinos D0, D1, D2 E D3 para limpar o PORTD (pinos do display de LCD)
	CLRF        PORTD+0 
;level_control.c,42 :: 		}
L_end_config_io:
	RETURN      0
; end of _config_io

_main:

;level_control.c,45 :: 		void main()
;level_control.c,47 :: 		ADC_Init();                 // Inicia o canal analógico
	CALL        _ADC_Init+0, 0
;level_control.c,48 :: 		config_io();                // inicializa função de configuração dos pinos de IO
	CALL        _config_io+0, 0
;level_control.c,49 :: 		Lcd_Init();                 // Inicia o LCD
	CALL        _Lcd_Init+0, 0
;level_control.c,50 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);   // Desliga o cursor do LCD
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;level_control.c,52 :: 		while(1)
L_main0:
;level_control.c,54 :: 		rAN0= ADC_Read(0);              // Efetua a leitua de AN0
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	CALL        _word2double+0, 0
	MOVF        R0, 0 
	MOVWF       _rAN0+0 
	MOVF        R1, 0 
	MOVWF       _rAN0+1 
	MOVF        R2, 0 
	MOVWF       _rAN0+2 
	MOVF        R3, 0 
	MOVWF       _rAN0+3 
;level_control.c,55 :: 		rNivel= rAN0 / 8.52;            // Equação do sensor 0 - 1023 / 0L - 120L
	MOVLW       236
	MOVWF       R4 
	MOVLW       81
	MOVWF       R5 
	MOVLW       8
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _rNivel+0 
	MOVF        R1, 0 
	MOVWF       _rNivel+1 
	MOVF        R2, 0 
	MOVWF       _rNivel+2 
	MOVF        R3, 0 
	MOVWF       _rNivel+3 
;level_control.c,56 :: 		sprintf(sNivel,"%.1f",rNivel);  // Função para conversão de Float para String com formatação
	MOVLW       _sNivel+0
	MOVWF       FARG_sprintf_wh+0 
	MOVLW       hi_addr(_sNivel+0)
	MOVWF       FARG_sprintf_wh+1 
	MOVLW       ?lstr_1_level_control+0
	MOVWF       FARG_sprintf_f+0 
	MOVLW       hi_addr(?lstr_1_level_control+0)
	MOVWF       FARG_sprintf_f+1 
	MOVLW       higher_addr(?lstr_1_level_control+0)
	MOVWF       FARG_sprintf_f+2 
	MOVF        R0, 0 
	MOVWF       FARG_sprintf_wh+5 
	MOVF        R1, 0 
	MOVWF       FARG_sprintf_wh+6 
	MOVF        R2, 0 
	MOVWF       FARG_sprintf_wh+7 
	MOVF        R3, 0 
	MOVWF       FARG_sprintf_wh+8 
	CALL        _sprintf+0, 0
;level_control.c,59 :: 		if(S1 == 1)
	BTFSS       PORTB+0, 0 
	GOTO        L_main2
;level_control.c,62 :: 		LCD_Out(1,1,"LEVEL CONTROL");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_level_control+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_level_control+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;level_control.c,63 :: 		LCD_Out(2,1,"LEVEL:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_level_control+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_level_control+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;level_control.c,64 :: 		LCD_Out(2,7,sNivel);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       7
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _sNivel+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_sNivel+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;level_control.c,65 :: 		LCD_Chr(2,12,'L');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       76
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;level_control.c,66 :: 		delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
	NOP
;level_control.c,67 :: 		}
	GOTO        L_main4
L_main2:
;level_control.c,68 :: 		else if (S1 == 0)
	BTFSC       PORTB+0, 0 
	GOTO        L_main5
;level_control.c,70 :: 		LCD_Out(1,1,"    ETEC - PV     ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_level_control+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_level_control+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;level_control.c,71 :: 		LCD_Out(2,1," AUTOMACAO IND.");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_level_control+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_level_control+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;level_control.c,72 :: 		}
L_main5:
L_main4:
;level_control.c,74 :: 		if(rNivel <= (0.25 * 120))
	MOVF        _rNivel+0, 0 
	MOVWF       R4 
	MOVF        _rNivel+1, 0 
	MOVWF       R5 
	MOVF        _rNivel+2, 0 
	MOVWF       R6 
	MOVF        _rNivel+3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       112
	MOVWF       R2 
	MOVLW       131
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main6
;level_control.c,76 :: 		V1 = 1;
	BSF         PORTC+0, 0 
;level_control.c,77 :: 		V2 = 0;
	BCF         PORTC+0, 1 
;level_control.c,78 :: 		B1 = 1;
	BSF         PORTC+0, 2 
;level_control.c,79 :: 		}
	GOTO        L_main7
L_main6:
;level_control.c,80 :: 		else if (rNivel > (0.25 * 120) && rNivel <= (0.50 * 120))
	MOVF        _rNivel+0, 0 
	MOVWF       R4 
	MOVF        _rNivel+1, 0 
	MOVWF       R5 
	MOVF        _rNivel+2, 0 
	MOVWF       R6 
	MOVF        _rNivel+3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       112
	MOVWF       R2 
	MOVLW       131
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
	MOVF        _rNivel+0, 0 
	MOVWF       R4 
	MOVF        _rNivel+1, 0 
	MOVWF       R5 
	MOVF        _rNivel+2, 0 
	MOVWF       R6 
	MOVF        _rNivel+3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       112
	MOVWF       R2 
	MOVLW       132
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
L__main18:
;level_control.c,82 :: 		V1 = 1;
	BSF         PORTC+0, 0 
;level_control.c,83 :: 		V2 = 0;
	BCF         PORTC+0, 1 
;level_control.c,84 :: 		B1 = 1;
	BSF         PORTC+0, 2 
;level_control.c,85 :: 		}
	GOTO        L_main11
L_main10:
;level_control.c,86 :: 		else if (rNivel > (0.50 * 120) && rNivel <= (0.75 * 120))
	MOVF        _rNivel+0, 0 
	MOVWF       R4 
	MOVF        _rNivel+1, 0 
	MOVWF       R5 
	MOVF        _rNivel+2, 0 
	MOVWF       R6 
	MOVF        _rNivel+3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       112
	MOVWF       R2 
	MOVLW       132
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main14
	MOVF        _rNivel+0, 0 
	MOVWF       R4 
	MOVF        _rNivel+1, 0 
	MOVWF       R5 
	MOVF        _rNivel+2, 0 
	MOVWF       R6 
	MOVF        _rNivel+3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       52
	MOVWF       R2 
	MOVLW       133
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main14
L__main17:
;level_control.c,88 :: 		V1 = 1;
	BSF         PORTC+0, 0 
;level_control.c,89 :: 		V2 = 1;
	BSF         PORTC+0, 1 
;level_control.c,90 :: 		B1 = 1;
	BSF         PORTC+0, 2 
;level_control.c,91 :: 		}
	GOTO        L_main15
L_main14:
;level_control.c,92 :: 		else if (rNivel > (0.75 * 120))
	MOVF        _rNivel+0, 0 
	MOVWF       R4 
	MOVF        _rNivel+1, 0 
	MOVWF       R5 
	MOVF        _rNivel+2, 0 
	MOVWF       R6 
	MOVF        _rNivel+3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       52
	MOVWF       R2 
	MOVLW       133
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main16
;level_control.c,94 :: 		V1 = 0;
	BCF         PORTC+0, 0 
;level_control.c,95 :: 		V2 = 1;
	BSF         PORTC+0, 1 
;level_control.c,96 :: 		B1 = 0;
	BCF         PORTC+0, 2 
;level_control.c,97 :: 		}
L_main16:
L_main15:
L_main11:
L_main7:
;level_control.c,98 :: 		}
	GOTO        L_main0
;level_control.c,99 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
