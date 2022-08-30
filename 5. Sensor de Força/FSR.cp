#line 1 "C:/Users/profb/Documents/Projetos/Programação Aplicada 2/Módulo Analógico_EXSTO_XM119/5. Sensor de Força/FSR.c"
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








unsigned char sForce[16];
float rAN0;
float rForce;
char sD1;
char sD2;
char sD3;

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
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 while(1)
 {
 rAN0= ADC_Read(0);
 rForce= rAN0/8.52;
 FloatToStr(rForce,sForce);

 if( PORTB.RB0  == 0)
 {
 LCD_Out(1,3,"SENSOR FORCE");
 LCD_Out(2,1,"FORCE: ");
 LCD_Out(2,8,sForce);
 LCD_Out(2,12," kg     ");
 delay_ms(500);
 }
 else if ( PORTB.RB0  == 1)
 {
 LCD_Out(1,4,"LED STATUS");
 LCD_Out(2,1,"D1:");
 Lcd_Chr(2,4,sD1);
 LCD_Out(2,5," D2:");
 Lcd_Chr(2,9,sD2);
 LCD_Out(2,10," D3:");
 Lcd_Chr(2,14,sD3);
 }

 if(rForce < 20)
 {
 sD1 = '1';
 sD2 = '0';
 sD3 = '0';
 PORTC = 0XFE;

 }
 else if (rForce >= 20 && rForce < 60)
 {
 sD1 = '0';
 sD2 = '1';
 sD3 = '0';
 PORTC = 0XFD;

 }
 else if (rForce >= 60 && rForce < 90)
 {
 sD1 = '1';
 sD2 = '1';
 sD3 = '0';
 PORTC = 0XFC;

 }
 else if (rForce >= 90)
 {
 sD1 = '0';
 sD2 = '0';
 sD3 = '1';
 PORTC = 0XFB;

 }

 }
}
