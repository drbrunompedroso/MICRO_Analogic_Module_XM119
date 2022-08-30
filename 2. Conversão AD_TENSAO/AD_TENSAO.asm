
_config_io:

;AD_TENSAO.c,20 :: 		void config_io()
;AD_TENSAO.c,22 :: 		ADCON1=0x0E; // Configura o Pino (RA0) como canal analógico e o restante com digital
	MOVLW       14
	MOVWF       ADCON1+0 
;AD_TENSAO.c,23 :: 		TRISE=0x00; // Configura como Pinos de saída Digital
	CLRF        TRISE+0 
;AD_TENSAO.c,24 :: 		TRISD=0x00; // Configura como Pinos de saída Digital
	CLRF        TRISD+0 
;AD_TENSAO.c,25 :: 		TRISC=0X00; // Configura como Pinos de saída Digital
	CLRF        TRISC+0 
;AD_TENSAO.c,26 :: 		PORTE.RE1=0; // Seleciona como '0' o pino RE1 (R/W do display de lCD)
	BCF         PORTE+0, 1 
;AD_TENSAO.c,27 :: 		PORTD=0x00; // Seleciona como '0' os pinos D0, D1, D2 E D3 para limpar o PORTD (pinos do display de LCD)
	CLRF        PORTD+0 
;AD_TENSAO.c,28 :: 		PORTC=0xFF; // Limpa o PORTC
	MOVLW       255
	MOVWF       PORTC+0 
;AD_TENSAO.c,29 :: 		}
L_end_config_io:
	RETURN      0
; end of _config_io

_main:

;AD_TENSAO.c,31 :: 		void main()
;AD_TENSAO.c,33 :: 		ADC_Init(); // Inicia o canal analógico
	CALL        _ADC_Init+0, 0
;AD_TENSAO.c,34 :: 		config_io(); // inicializa função de configuração dos pinos de IO
	CALL        _config_io+0, 0
;AD_TENSAO.c,35 :: 		Lcd_Init(); // Inicia o LCD
	CALL        _Lcd_Init+0, 0
;AD_TENSAO.c,36 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o Display de LCD
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;AD_TENSAO.c,37 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // Desliga o cursor do LCD
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;AD_TENSAO.c,39 :: 		LCD_Out(1,1,"AD - TENSAO");  // Texto inicial no display de lcd
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_AD_TENSAO+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_AD_TENSAO+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;AD_TENSAO.c,41 :: 		while(1)
L_main0:
;AD_TENSAO.c,43 :: 		iAN0= ADC_Read(0);
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	CALL        _word2double+0, 0
	MOVF        R0, 0 
	MOVWF       _iAN0+0 
	MOVF        R1, 0 
	MOVWF       _iAN0+1 
	MOVF        R2, 0 
	MOVWF       _iAN0+2 
	MOVF        R3, 0 
	MOVWF       _iAN0+3 
;AD_TENSAO.c,44 :: 		iTensao= iAN0 * 4.88e-3;
	MOVLW       104
	MOVWF       R4 
	MOVLW       232
	MOVWF       R5 
	MOVLW       31
	MOVWF       R6 
	MOVLW       119
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _iTensao+0 
	MOVF        R1, 0 
	MOVWF       _iTensao+1 
	MOVF        R2, 0 
	MOVWF       _iTensao+2 
	MOVF        R3, 0 
	MOVWF       _iTensao+3 
;AD_TENSAO.c,45 :: 		FloatToStr(iTensao,sTensao);
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _sTensao+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_sTensao+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;AD_TENSAO.c,46 :: 		LCD_Out(2,1,"TENSAO:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_AD_TENSAO+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_AD_TENSAO+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;AD_TENSAO.c,47 :: 		LCD_Out(2,10,sTensao);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       10
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _sTensao+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_sTensao+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;AD_TENSAO.c,48 :: 		LCD_Out(2,14,"V       ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_AD_TENSAO+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_AD_TENSAO+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;AD_TENSAO.c,49 :: 		delay_ms(500);
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
;AD_TENSAO.c,51 :: 		if(iTensao < 1.25)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       127
	MOVWF       R7 
	MOVF        _iTensao+0, 0 
	MOVWF       R0 
	MOVF        _iTensao+1, 0 
	MOVWF       R1 
	MOVF        _iTensao+2, 0 
	MOVWF       R2 
	MOVF        _iTensao+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main3
;AD_TENSAO.c,53 :: 		PORTC=0XFF;
	MOVLW       255
	MOVWF       PORTC+0 
;AD_TENSAO.c,54 :: 		}
	GOTO        L_main4
L_main3:
;AD_TENSAO.c,55 :: 		else if(iTensao >= 1.25 && iTensao < 2.5)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       127
	MOVWF       R7 
	MOVF        _iTensao+0, 0 
	MOVWF       R0 
	MOVF        _iTensao+1, 0 
	MOVWF       R1 
	MOVF        _iTensao+2, 0 
	MOVWF       R2 
	MOVF        _iTensao+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	MOVF        _iTensao+0, 0 
	MOVWF       R0 
	MOVF        _iTensao+1, 0 
	MOVWF       R1 
	MOVF        _iTensao+2, 0 
	MOVWF       R2 
	MOVF        _iTensao+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
L__main15:
;AD_TENSAO.c,57 :: 		PORTC=0XFE;
	MOVLW       254
	MOVWF       PORTC+0 
;AD_TENSAO.c,58 :: 		}
	GOTO        L_main8
L_main7:
;AD_TENSAO.c,59 :: 		else if(iTensao >= 2.5 && iTensao < 4.65)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	MOVF        _iTensao+0, 0 
	MOVWF       R0 
	MOVF        _iTensao+1, 0 
	MOVWF       R1 
	MOVF        _iTensao+2, 0 
	MOVWF       R2 
	MOVF        _iTensao+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main11
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       20
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	MOVF        _iTensao+0, 0 
	MOVWF       R0 
	MOVF        _iTensao+1, 0 
	MOVWF       R1 
	MOVF        _iTensao+2, 0 
	MOVWF       R2 
	MOVF        _iTensao+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main11
L__main14:
;AD_TENSAO.c,61 :: 		PORTC=0XFC;
	MOVLW       252
	MOVWF       PORTC+0 
;AD_TENSAO.c,62 :: 		}
	GOTO        L_main12
L_main11:
;AD_TENSAO.c,63 :: 		else if(iTensao >= 4.65)
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       20
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	MOVF        _iTensao+0, 0 
	MOVWF       R0 
	MOVF        _iTensao+1, 0 
	MOVWF       R1 
	MOVF        _iTensao+2, 0 
	MOVWF       R2 
	MOVF        _iTensao+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main13
;AD_TENSAO.c,65 :: 		PORTC=0XF8;
	MOVLW       248
	MOVWF       PORTC+0 
;AD_TENSAO.c,66 :: 		}
L_main13:
L_main12:
L_main8:
L_main4:
;AD_TENSAO.c,68 :: 		}
	GOTO        L_main0
;AD_TENSAO.c,69 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
