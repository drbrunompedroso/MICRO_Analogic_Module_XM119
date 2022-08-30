
_config_io:

;temp_control.c,24 :: 		void config_io()
;temp_control.c,26 :: 		ADCON1=0x0E; // Configura o Pino (AN0) como canal analógico e o restante com digital
	MOVLW       14
	MOVWF       ADCON1+0 
;temp_control.c,27 :: 		TRISE=0x00; // Configura como Pinos de saída Digital
	CLRF        TRISE+0 
;temp_control.c,28 :: 		TRISD=0x00; // Configura como Pinos de saída Digital
	CLRF        TRISD+0 
;temp_control.c,29 :: 		TRISC=0X00;
	CLRF        TRISC+0 
;temp_control.c,30 :: 		PORTC=0XFF;
	MOVLW       255
	MOVWF       PORTC+0 
;temp_control.c,31 :: 		PORTE.RE1=0; // Seleciona como '0' o pino RE1 (R/W do display de lCD)
	BCF         PORTE+0, 1 
;temp_control.c,32 :: 		PORTD=0xFF; // Seleciona como '0' os pinos D0, D1, D2 E D3 para limpar o PORTD (pinos do display de LCD)
	MOVLW       255
	MOVWF       PORTD+0 
;temp_control.c,33 :: 		}
L_end_config_io:
	RETURN      0
; end of _config_io

_main:

;temp_control.c,35 :: 		void main()
;temp_control.c,37 :: 		ADC_Init(); // Inicia o canal analógico
	CALL        _ADC_Init+0, 0
;temp_control.c,38 :: 		config_io(); // inicializa função de configuração dos pinos de IO
	CALL        _config_io+0, 0
;temp_control.c,39 :: 		Lcd_Init(); // Inicia o LCD
	CALL        _Lcd_Init+0, 0
;temp_control.c,40 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o Display de LCD
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;temp_control.c,41 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // Desliga o cursor do LCD
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;temp_control.c,43 :: 		LCD_Out(1,1,"TEMP CONTROL");  // Texto inicial no display de lcd
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_temp_control+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_temp_control+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;temp_control.c,45 :: 		while(1)
L_main0:
;temp_control.c,47 :: 		rRA0= ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	CALL        _word2double+0, 0
	MOVF        R0, 0 
	MOVWF       _rRA0+0 
	MOVF        R1, 0 
	MOVWF       _rRA0+1 
	MOVF        R2, 0 
	MOVWF       _rRA0+2 
	MOVF        R3, 0 
	MOVWF       _rRA0+3 
;temp_control.c,48 :: 		rTemp= rRA0/4.09;    // Equação do sensor 0 - 1023 / 0ºC - 250°C
	MOVLW       72
	MOVWF       R4 
	MOVLW       225
	MOVWF       R5 
	MOVLW       2
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _rTemp+0 
	MOVF        R1, 0 
	MOVWF       _rTemp+1 
	MOVF        R2, 0 
	MOVWF       _rTemp+2 
	MOVF        R3, 0 
	MOVWF       _rTemp+3 
;temp_control.c,49 :: 		FloatToStr(rTemp,sTemp);
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _sTemp+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_sTemp+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;temp_control.c,50 :: 		LCD_Out(2,1,"TEMP:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_temp_control+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_temp_control+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;temp_control.c,51 :: 		LCD_Out(2,6,sTemp);  // Mostra a variável no display
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _sTemp+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_sTemp+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;temp_control.c,52 :: 		LCD_Out(2,11,"C     ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       11
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_temp_control+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_temp_control+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;temp_control.c,53 :: 		delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main2:
	DECFSZ      R13, 1, 1
	BRA         L_main2
	DECFSZ      R12, 1, 1
	BRA         L_main2
	DECFSZ      R11, 1, 1
	BRA         L_main2
	NOP
	NOP
;temp_control.c,55 :: 		if(rTemp < 62.5)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       132
	MOVWF       R7 
	MOVF        _rTemp+0, 0 
	MOVWF       R0 
	MOVF        _rTemp+1, 0 
	MOVWF       R1 
	MOVF        _rTemp+2, 0 
	MOVWF       R2 
	MOVF        _rTemp+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main3
;temp_control.c,57 :: 		D1 = 0;
	BCF         PORTC+0, 0 
;temp_control.c,58 :: 		D2 = 1;
	BSF         PORTC+0, 1 
;temp_control.c,59 :: 		D3 = 1;
	BSF         PORTC+0, 2 
;temp_control.c,60 :: 		delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	DECFSZ      R11, 1, 1
	BRA         L_main4
	NOP
	NOP
;temp_control.c,61 :: 		D1 = 1;
	BSF         PORTC+0, 0 
;temp_control.c,62 :: 		D2 = 1;
	BSF         PORTC+0, 1 
;temp_control.c,63 :: 		D3 = 1;
	BSF         PORTC+0, 2 
;temp_control.c,64 :: 		delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	DECFSZ      R11, 1, 1
	BRA         L_main5
	NOP
	NOP
;temp_control.c,65 :: 		}
	GOTO        L_main6
L_main3:
;temp_control.c,66 :: 		else if (rTemp >= 62.5 && rTemp < 125)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       132
	MOVWF       R7 
	MOVF        _rTemp+0, 0 
	MOVWF       R0 
	MOVF        _rTemp+1, 0 
	MOVWF       R1 
	MOVF        _rTemp+2, 0 
	MOVWF       R2 
	MOVF        _rTemp+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main9
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	MOVF        _rTemp+0, 0 
	MOVWF       R0 
	MOVF        _rTemp+1, 0 
	MOVWF       R1 
	MOVF        _rTemp+2, 0 
	MOVWF       R2 
	MOVF        _rTemp+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main9
L__main23:
;temp_control.c,68 :: 		D1 = 1;
	BSF         PORTC+0, 0 
;temp_control.c,69 :: 		D2 = 0;
	BCF         PORTC+0, 1 
;temp_control.c,70 :: 		D3 = 1;
	BSF         PORTC+0, 2 
;temp_control.c,71 :: 		delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main10:
	DECFSZ      R13, 1, 1
	BRA         L_main10
	DECFSZ      R12, 1, 1
	BRA         L_main10
	DECFSZ      R11, 1, 1
	BRA         L_main10
	NOP
	NOP
;temp_control.c,72 :: 		D1 = 1;
	BSF         PORTC+0, 0 
;temp_control.c,73 :: 		D2 = 1;
	BSF         PORTC+0, 1 
;temp_control.c,74 :: 		D3 = 1;
	BSF         PORTC+0, 2 
;temp_control.c,75 :: 		delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main11:
	DECFSZ      R13, 1, 1
	BRA         L_main11
	DECFSZ      R12, 1, 1
	BRA         L_main11
	DECFSZ      R11, 1, 1
	BRA         L_main11
	NOP
	NOP
;temp_control.c,76 :: 		}
	GOTO        L_main12
L_main9:
;temp_control.c,77 :: 		else if (rTemp >= 125 && rTemp < 187.5)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	MOVF        _rTemp+0, 0 
	MOVWF       R0 
	MOVF        _rTemp+1, 0 
	MOVWF       R1 
	MOVF        _rTemp+2, 0 
	MOVWF       R2 
	MOVF        _rTemp+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main15
	MOVLW       0
	MOVWF       R4 
	MOVLW       128
	MOVWF       R5 
	MOVLW       59
	MOVWF       R6 
	MOVLW       134
	MOVWF       R7 
	MOVF        _rTemp+0, 0 
	MOVWF       R0 
	MOVF        _rTemp+1, 0 
	MOVWF       R1 
	MOVF        _rTemp+2, 0 
	MOVWF       R2 
	MOVF        _rTemp+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main15
L__main22:
;temp_control.c,79 :: 		D1 = 1;
	BSF         PORTC+0, 0 
;temp_control.c,80 :: 		D2 = 1;
	BSF         PORTC+0, 1 
;temp_control.c,81 :: 		D3 = 0;
	BCF         PORTC+0, 2 
;temp_control.c,82 :: 		delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main16:
	DECFSZ      R13, 1, 1
	BRA         L_main16
	DECFSZ      R12, 1, 1
	BRA         L_main16
	DECFSZ      R11, 1, 1
	BRA         L_main16
	NOP
	NOP
;temp_control.c,83 :: 		D1 = 1;
	BSF         PORTC+0, 0 
;temp_control.c,84 :: 		D2 = 1;
	BSF         PORTC+0, 1 
;temp_control.c,85 :: 		D3 = 1;
	BSF         PORTC+0, 2 
;temp_control.c,86 :: 		delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main17:
	DECFSZ      R13, 1, 1
	BRA         L_main17
	DECFSZ      R12, 1, 1
	BRA         L_main17
	DECFSZ      R11, 1, 1
	BRA         L_main17
	NOP
	NOP
;temp_control.c,87 :: 		}
	GOTO        L_main18
L_main15:
;temp_control.c,88 :: 		else if (rTemp >= 187.5)
	MOVLW       0
	MOVWF       R4 
	MOVLW       128
	MOVWF       R5 
	MOVLW       59
	MOVWF       R6 
	MOVLW       134
	MOVWF       R7 
	MOVF        _rTemp+0, 0 
	MOVWF       R0 
	MOVF        _rTemp+1, 0 
	MOVWF       R1 
	MOVF        _rTemp+2, 0 
	MOVWF       R2 
	MOVF        _rTemp+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main19
;temp_control.c,90 :: 		D1 = 0;
	BCF         PORTC+0, 0 
;temp_control.c,91 :: 		D2 = 0;
	BCF         PORTC+0, 1 
;temp_control.c,92 :: 		D3 = 0;
	BCF         PORTC+0, 2 
;temp_control.c,93 :: 		delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main20:
	DECFSZ      R13, 1, 1
	BRA         L_main20
	DECFSZ      R12, 1, 1
	BRA         L_main20
	DECFSZ      R11, 1, 1
	BRA         L_main20
	NOP
	NOP
;temp_control.c,94 :: 		D1 = 1;
	BSF         PORTC+0, 0 
;temp_control.c,95 :: 		D2 = 1;
	BSF         PORTC+0, 1 
;temp_control.c,96 :: 		D3 = 1;
	BSF         PORTC+0, 2 
;temp_control.c,97 :: 		delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main21:
	DECFSZ      R13, 1, 1
	BRA         L_main21
	DECFSZ      R12, 1, 1
	BRA         L_main21
	DECFSZ      R11, 1, 1
	BRA         L_main21
	NOP
	NOP
;temp_control.c,98 :: 		}
L_main19:
L_main18:
L_main12:
L_main6:
;temp_control.c,99 :: 		}
	GOTO        L_main0
;temp_control.c,100 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
