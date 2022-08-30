#line 1 "C:/Users/Bruno Medina Pedroso/Documents/Projetos/Programação Aplicada 2/Módulo Analógico_EXSTO_XM119/1. Leitura_AD/AD_MOD.c"
sbit lcd_rs at RE0_bit;
sbit lcd_en at RE2_bit;
sbit lcd_d7 at RD7_bit;
sbit lcd_d6 at RD6_bit;
sbit lcd_d5 at RD5_bit;
sbit lcd_d4 at RD4_bit;

sbit lcd_rs_direction at TRISE0_bit;
sbit lcd_en_direction at TRISE2_bit;
sbit lcd_d7_direction at TRISD7_bit;
sbit lcd_d6_direction at TRISD6_bit;
sbit lcd_d5_direction at TRISD5_bit;
sbit lcd_d4_direction at TRISD4_bit;


unsigned char sText[16];
unsigned int iAN0;

void config_io()
{
 ADCON1=0x0E;
 TRISE=0x00;
 TRISD=0x00;
 PORTE.RE1=0;
}

void main()
{
 config_io();
 ADC_Init();
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 LCD_Out(1,1,"Valor da A/D PIC");

 while(1)
 {

 iAN0= ADC_Read(0);
 IntToStr(iAN0,sText);
 LCD_Out(2,1,"A/D:");
 LCD_Out(2,5,sText+2);

 }
}
