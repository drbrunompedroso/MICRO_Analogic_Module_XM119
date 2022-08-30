
_config_io:

;AD_MOD.c,19 :: 		void config_io()
;AD_MOD.c,21 :: 		ADCON1=0x0E; // Configura o Pino (AN0) como canal analógico e o restante com digital
	MOVLW       14
	MOVWF       ADCON1+0 
;AD_MOD.c,22 :: 		TRISE=0x00; // Configura como Pinos de saída Digital
	CLRF        TRISE+0 
;AD_MOD.c,23 :: 		TRISD=0x00; // Configura como Pinos de saída Digital
	CLRF        TRISD+0 
;AD_MOD.c,24 :: 		PORTE.RE1=0; // Seleciona como '0' o pino RE1 (R/W do display de lCD)
	BCF         PORTE+0, 1 
;AD_MOD.c,25 :: 		}
L_end_config_io:
	RETURN      0
; end of _config_io

_main:

;AD_MOD.c,27 :: 		void main()
;AD_MOD.c,29 :: 		config_io(); // inicializa função de configuração dos pinos de IO
	CALL        _config_io+0, 0
;AD_MOD.c,30 :: 		ADC_Init(); // Inicia o canal analógico
	CALL        _ADC_Init+0, 0
;AD_MOD.c,31 :: 		Lcd_Init(); // Inicia o LCD
	CALL        _Lcd_Init+0, 0
;AD_MOD.c,32 :: 		Lcd_Cmd(_LCD_CLEAR); // Limpa o Display de LCD
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;AD_MOD.c,33 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // Desliga o cursor do LCD
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;AD_MOD.c,35 :: 		LCD_Out(1,1,"Valor da A/D PIC");  // Texto inicial no display de lcd
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_AD_MOD+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_AD_MOD+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;AD_MOD.c,37 :: 		while(1)
L_main0:
;AD_MOD.c,40 :: 		iAN0= ADC_Read(0); // realiza a leitura do canal analógico AN0
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _iAN0+0 
	MOVF        R1, 0 
	MOVWF       _iAN0+1 
;AD_MOD.c,41 :: 		IntToStr(iAN0,sText); // converte a variável do tipo inteiro para string para impressão no Display de LCD
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _sText+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_sText+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;AD_MOD.c,42 :: 		LCD_Out(2,1,"A/D:"); // Texto no display de lcd
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_AD_MOD+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_AD_MOD+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;AD_MOD.c,43 :: 		LCD_Out(2,5,sText+2); // Imprime o valor convertido da A/D em string no lCD e desloca 2 casas para esquerda na string
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _sText+2
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_sText+2)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;AD_MOD.c,45 :: 		}
	GOTO        L_main0
;AD_MOD.c,46 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
