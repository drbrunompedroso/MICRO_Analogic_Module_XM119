sbit lcd_rs at RE0_bit;
sbit lcd_en at RE2_bit;
sbit lcd_d7 at RD7_bit;
sbit lcd_d6 at RD6_bit;
sbit lcd_d5 at RD5_bit;
sbit lcd_d4 at RD4_bit;
//LCD: direcionamento dos pinos
sbit lcd_rs_direction at TRISE0_bit;
sbit lcd_en_direction at TRISE2_bit;
sbit lcd_d7_direction at TRISD7_bit;
sbit lcd_d6_direction at TRISD6_bit;
sbit lcd_d5_direction at TRISD5_bit;
sbit lcd_d4_direction at TRISD4_bit;

#define D1 PORTC.RC0
#define D2 PORTC.RC1
#define D3 PORTC.RC2

// insere as variaveis globais
unsigned char sTemp[16]; // cria uma string para utilização na conversão do canal analógico.
float rRA0; // variável para a leitura do canal analógico RA0
float rTemp;

void config_io()
{
    ADCON1=0x0E; // Configura o Pino (AN0) como canal analógico e o restante com digital
    TRISE=0x00; // Configura como Pinos de saída Digital
    TRISD=0x00; // Configura como Pinos de saída Digital
    TRISC=0X00;
    PORTC=0XFF;
    PORTE.RE1=0; // Seleciona como '0' o pino RE1 (R/W do display de lCD)
    PORTD=0xFF; // Seleciona como '0' os pinos D0, D1, D2 E D3 para limpar o PORTD (pinos do display de LCD)
}

void main()
{
    ADC_Init(); // Inicia o canal analógico
    config_io(); // inicializa função de configuração dos pinos de IO
    Lcd_Init(); // Inicia o LCD
    Lcd_Cmd(_LCD_CLEAR); // Limpa o Display de LCD
    Lcd_Cmd(_LCD_CURSOR_OFF); // Desliga o cursor do LCD

    LCD_Out(1,1,"TEMP CONTROL");  // Texto inicial no display de lcd

    while(1)
    {
        rRA0= ADC_Read(0);
        rTemp= rRA0/4.09;    // Equação do sensor 0 - 1023 / 0ºC - 250°C
        FloatToStr(rTemp,sTemp);
        LCD_Out(2,1,"TEMP:");
        LCD_Out(2,6,sTemp);  // Mostra a variável no display
        LCD_Out(2,11,"C     ");
        delay_ms(500);
        
        if(rTemp < 62.5)
        {
           D1 = 0;
           D2 = 1;
           D3 = 1;
           delay_ms(500);
           D1 = 1;
           D2 = 1;
           D3 = 1;
           delay_ms(500);
        }
        else if (rTemp >= 62.5 && rTemp < 125)
        {
           D1 = 1;
           D2 = 0;
           D3 = 1;
           delay_ms(500);
           D1 = 1;
           D2 = 1;
           D3 = 1;
           delay_ms(500);
        }
        else if (rTemp >= 125 && rTemp < 187.5)
        {
           D1 = 1;
           D2 = 1;
           D3 = 0;
           delay_ms(500);
           D1 = 1;
           D2 = 1;
           D3 = 1;
           delay_ms(500);
        }
        else if (rTemp >= 187.5)
        {
           D1 = 0;
           D2 = 0;
           D3 = 0;
           delay_ms(500);
           D1 = 1;
           D2 = 1;
           D3 = 1;
           delay_ms(500);
        }
    }
}