
_config_io:

;FSR.c,29 :: 		void config_io()
;FSR.c,31 :: 		ADCON1=0x0E; // Configura o Pino (RA0) como canal analógico e o restante com digital
	MOVLW       14
	MOVWF       ADCON1+0 
;FSR.c,32 :: 		TRISE=0x00; // Configura como Pinos de saída Digital
	CLRF        TRISE+0 
;FSR.c,33 :: 		TRISD=0x00; // Configura como Pinos de saída Digital
	CLRF        TRISD+0 
;FSR.c,34 :: 		TRISB=0X01; // RB0 como entrada digital
	MOVLW       1
	MOVWF       TRISB+0 
;FSR.c,35 :: 		TRISC=0X00; // PORTC como saída digital
	CLRF        TRISC+0 
;FSR.c,36 :: 		PORTE.RE1=0; // Seleciona como '0' o pino RE1 (R/W do display de lCD)
	BCF         PORTE+0, 1 
;FSR.c,37 :: 		PORTD=0x00; // Seleciona como '0' os pinos D0, D1, D2 E D3 para limpar o PORTD (pinos do display de LCD)
	CLRF        PORTD+0 
;FSR.c,38 :: 		}
L_end_config_io:
	RETURN      0
; end of _config_io

_main:

;FSR.c,40 :: 		void main()
;FSR.c,42 :: 		ADC_Init(); // Inicia o canal analógico
	CALL        _ADC_Init+0, 0
;FSR.c,43 :: 		config_io(); // inicializa função de configuração dos pinos de IO
	CALL        _config_io+0, 0
;FSR.c,44 :: 		Lcd_Init(); // Inicia o LCD
	CALL        _Lcd_Init+0, 0
;FSR.c,45 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o Display de LCD
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;FSR.c,46 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // Desliga o cursor do LCD
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;FSR.c,48 :: 		while(1)
L_main0:
;FSR.c,50 :: 		rAN0= ADC_Read(0);
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
;FSR.c,51 :: 		rForce= rAN0/8.52;    // Equação do sensor 0 - 1023 / 0L - 120kg
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
	MOVWF       _rForce+0 
	MOVF        R1, 0 
	MOVWF       _rForce+1 
	MOVF        R2, 0 
	MOVWF       _rForce+2 
	MOVF        R3, 0 
	MOVWF       _rForce+3 
;FSR.c,52 :: 		FloatToStr(rForce,sForce);
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _sForce+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_sForce+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;FSR.c,54 :: 		if(B1 == 0)
	BTFSC       PORTB+0, 0 
	GOTO        L_main2
;FSR.c,56 :: 		LCD_Out(1,3,"SENSOR FORCE");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       3
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_FSR+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_FSR+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;FSR.c,57 :: 		LCD_Out(2,1,"FORCE: ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_FSR+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_FSR+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;FSR.c,58 :: 		LCD_Out(2,8,sForce);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _sForce+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_sForce+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;FSR.c,59 :: 		LCD_Out(2,12," kg     ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_FSR+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_FSR+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;FSR.c,60 :: 		delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
	NOP
	NOP
;FSR.c,61 :: 		}
	GOTO        L_main4
L_main2:
;FSR.c,62 :: 		else if (B1 == 1)
	BTFSS       PORTB+0, 0 
	GOTO        L_main5
;FSR.c,64 :: 		LCD_Out(1,4,"LED STATUS");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_FSR+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_FSR+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;FSR.c,65 :: 		LCD_Out(2,1,"D1:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_FSR+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_FSR+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;FSR.c,66 :: 		Lcd_Chr(2,4,sD1);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        _sD1+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;FSR.c,67 :: 		LCD_Out(2,5," D2:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_FSR+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_FSR+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;FSR.c,68 :: 		Lcd_Chr(2,9,sD2);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       9
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        _sD2+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;FSR.c,69 :: 		LCD_Out(2,10," D3:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       10
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_FSR+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_FSR+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;FSR.c,70 :: 		Lcd_Chr(2,14,sD3);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       14
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        _sD3+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;FSR.c,71 :: 		}
L_main5:
L_main4:
;FSR.c,73 :: 		if(rForce < 20)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       131
	MOVWF       R7 
	MOVF        _rForce+0, 0 
	MOVWF       R0 
	MOVF        _rForce+1, 0 
	MOVWF       R1 
	MOVF        _rForce+2, 0 
	MOVWF       R2 
	MOVF        _rForce+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main6
;FSR.c,75 :: 		sD1 = '1';
	MOVLW       49
	MOVWF       _sD1+0 
;FSR.c,76 :: 		sD2 = '0';
	MOVLW       48
	MOVWF       _sD2+0 
;FSR.c,77 :: 		sD3 = '0';
	MOVLW       48
	MOVWF       _sD3+0 
;FSR.c,78 :: 		PORTC = 0XFE;
	MOVLW       254
	MOVWF       PORTC+0 
;FSR.c,80 :: 		}
	GOTO        L_main7
L_main6:
;FSR.c,81 :: 		else if (rForce >= 20 && rForce < 60)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       131
	MOVWF       R7 
	MOVF        _rForce+0, 0 
	MOVWF       R0 
	MOVF        _rForce+1, 0 
	MOVWF       R1 
	MOVF        _rForce+2, 0 
	MOVWF       R2 
	MOVF        _rForce+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       112
	MOVWF       R6 
	MOVLW       132
	MOVWF       R7 
	MOVF        _rForce+0, 0 
	MOVWF       R0 
	MOVF        _rForce+1, 0 
	MOVWF       R1 
	MOVF        _rForce+2, 0 
	MOVWF       R2 
	MOVF        _rForce+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
L__main18:
;FSR.c,83 :: 		sD1 = '0';
	MOVLW       48
	MOVWF       _sD1+0 
;FSR.c,84 :: 		sD2 = '1';
	MOVLW       49
	MOVWF       _sD2+0 
;FSR.c,85 :: 		sD3 = '0';
	MOVLW       48
	MOVWF       _sD3+0 
;FSR.c,86 :: 		PORTC = 0XFD;
	MOVLW       253
	MOVWF       PORTC+0 
;FSR.c,88 :: 		}
	GOTO        L_main11
L_main10:
;FSR.c,89 :: 		else if (rForce >= 60 && rForce < 90)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       112
	MOVWF       R6 
	MOVLW       132
	MOVWF       R7 
	MOVF        _rForce+0, 0 
	MOVWF       R0 
	MOVF        _rForce+1, 0 
	MOVWF       R1 
	MOVF        _rForce+2, 0 
	MOVWF       R2 
	MOVF        _rForce+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main14
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       52
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	MOVF        _rForce+0, 0 
	MOVWF       R0 
	MOVF        _rForce+1, 0 
	MOVWF       R1 
	MOVF        _rForce+2, 0 
	MOVWF       R2 
	MOVF        _rForce+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main14
L__main17:
;FSR.c,91 :: 		sD1 = '1';
	MOVLW       49
	MOVWF       _sD1+0 
;FSR.c,92 :: 		sD2 = '1';
	MOVLW       49
	MOVWF       _sD2+0 
;FSR.c,93 :: 		sD3 = '0';
	MOVLW       48
	MOVWF       _sD3+0 
;FSR.c,94 :: 		PORTC = 0XFC;
	MOVLW       252
	MOVWF       PORTC+0 
;FSR.c,96 :: 		}
	GOTO        L_main15
L_main14:
;FSR.c,97 :: 		else if (rForce >= 90)
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       52
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	MOVF        _rForce+0, 0 
	MOVWF       R0 
	MOVF        _rForce+1, 0 
	MOVWF       R1 
	MOVF        _rForce+2, 0 
	MOVWF       R2 
	MOVF        _rForce+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main16
;FSR.c,99 :: 		sD1 = '0';
	MOVLW       48
	MOVWF       _sD1+0 
;FSR.c,100 :: 		sD2 = '0';
	MOVLW       48
	MOVWF       _sD2+0 
;FSR.c,101 :: 		sD3 = '1';
	MOVLW       49
	MOVWF       _sD3+0 
;FSR.c,102 :: 		PORTC = 0XFB;
	MOVLW       251
	MOVWF       PORTC+0 
;FSR.c,104 :: 		}
L_main16:
L_main15:
L_main11:
L_main7:
;FSR.c,106 :: 		}
	GOTO        L_main0
;FSR.c,107 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
