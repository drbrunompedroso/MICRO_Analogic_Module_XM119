#line 1 "C:/Users/Bruno Medina Pedroso/Documents/Projetos/Programação Aplicada 2/Módulo Analógico_EXSTO_XM119/2. Conversão AD_TENSAO/AD_TENSAO.c"
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


unsigned char sTensao[16];
float iAN0;
float iTensao;

void config_io()
{
 ADCON1=0x0E;
 TRISE=0x00;
 TRISD=0x00;
 TRISC=0X00;
 PORTE.RE1=0;
 PORTD=0x00;
 PORTC=0xFF;
}

void main()
{
 ADC_Init();
 config_io();
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 LCD_Out(1,1,"AD - TENSAO");

 while(1)
 {
 iAN0= ADC_Read(0);
 iTensao= iAN0 * 4.88e-3;
 FloatToStr(iTensao,sTensao);
 LCD_Out(2,1,"TENSAO:");
 LCD_Out(2,10,sTensao);
 LCD_Out(2,14,"V       ");
 delay_ms(500);

 if(iTensao < 1.25)
 {
 PORTC=0XFF;
 }
 else if(iTensao >= 1.25 && iTensao < 2.5)
 {
 PORTC=0XFE;
 }
 else if(iTensao >= 2.5 && iTensao < 4.65)
 {
 PORTC=0XFC;
 }
 else if(iTensao >= 4.65)
 {
 PORTC=0XF8;
 }

 }
}
