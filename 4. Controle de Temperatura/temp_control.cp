#line 1 "C:/Users/profb/Documents/Projetos/Programação Aplicada 2/Módulo Analógico_EXSTO_XM119/4. Controle de Temperatura/temp_control.c"
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






unsigned char sTemp[16];
float rRA0;
float rTemp;

void config_io()
{
 ADCON1=0x0E;
 TRISE=0x00;
 TRISD=0x00;
 TRISC=0X00;
 PORTC=0XFF;
 PORTE.RE1=0;
 PORTD=0xFF;
}

void main()
{
 ADC_Init();
 config_io();
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 LCD_Out(1,1,"TEMP CONTROL");

 while(1)
 {
 rRA0= ADC_Read(0);
 rTemp= rRA0/4.09;
 FloatToStr(rTemp,sTemp);
 LCD_Out(2,1,"TEMP:");
 LCD_Out(2,6,sTemp);
 LCD_Out(2,11,"C     ");
 delay_ms(500);

 if(rTemp < 62.5)
 {
  PORTC.RC0  = 0;
  PORTC.RC1  = 1;
  PORTC.RC2  = 1;
 delay_ms(500);
  PORTC.RC0  = 1;
  PORTC.RC1  = 1;
  PORTC.RC2  = 1;
 delay_ms(500);
 }
 else if (rTemp >= 62.5 && rTemp < 125)
 {
  PORTC.RC0  = 1;
  PORTC.RC1  = 0;
  PORTC.RC2  = 1;
 delay_ms(500);
  PORTC.RC0  = 1;
  PORTC.RC1  = 1;
  PORTC.RC2  = 1;
 delay_ms(500);
 }
 else if (rTemp >= 125 && rTemp < 187.5)
 {
  PORTC.RC0  = 1;
  PORTC.RC1  = 1;
  PORTC.RC2  = 0;
 delay_ms(500);
  PORTC.RC0  = 1;
  PORTC.RC1  = 1;
  PORTC.RC2  = 1;
 delay_ms(500);
 }
 else if (rTemp >= 187.5)
 {
  PORTC.RC0  = 0;
  PORTC.RC1  = 0;
  PORTC.RC2  = 0;
 delay_ms(500);
  PORTC.RC0  = 1;
  PORTC.RC1  = 1;
  PORTC.RC2  = 1;
 delay_ms(500);
 }
 }
}
