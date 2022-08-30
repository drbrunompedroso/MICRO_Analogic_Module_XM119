#line 1 "C:/Users/Bruno Medina Pedroso/Documents/Projetos/Programação Aplicada 2/Módulo Analógico_EXSTO_XM119/3. Controle de Nivel/level_control.c"






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









unsigned char sNivel[16];
float rAN0;
float rNivel;


void config_io()
{
 ADCON1=0x0E;
 TRISE=0x00;
 TRISD=0x00;
 TRISB=0X01;
 TRISC=0X00;
 PORTE.RE1=0;
 PORTD=0x00;
}


void main()
{
 ADC_Init();
 config_io();
 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);

 while(1)
 {
 rAN0= ADC_Read(0);
 rNivel= rAN0 / 8.52;
 sprintf(sNivel,"%.1f",rNivel);


 if( PORTB.RB0  == 1)
 {

 LCD_Out(1,1,"LEVEL CONTROL");
 LCD_Out(2,1,"LEVEL:");
 LCD_Out(2,7,sNivel);
 LCD_Chr(2,12,'L');
 delay_ms(100);
 }
 else if ( PORTB.RB0  == 0)
 {
 LCD_Out(1,1,"    ETEC - PV     ");
 LCD_Out(2,1," AUTOMACAO IND.");
 }

 if(rNivel <= (0.25 * 120))
 {
  PORTC.RC0  = 1;
  PORTC.RC1  = 0;
  PORTC.RC2  = 1;
 }
 else if (rNivel > (0.25 * 120) && rNivel <= (0.50 * 120))
 {
  PORTC.RC0  = 1;
  PORTC.RC1  = 0;
  PORTC.RC2  = 1;
 }
 else if (rNivel > (0.50 * 120) && rNivel <= (0.75 * 120))
 {
  PORTC.RC0  = 1;
  PORTC.RC1  = 1;
  PORTC.RC2  = 1;
 }
 else if (rNivel > (0.75 * 120))
 {
  PORTC.RC0  = 0;
  PORTC.RC1  = 1;
  PORTC.RC2  = 0;
 }
 }
}
