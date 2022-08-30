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

// insere as variaveis globais
unsigned char sTensao[16]; // cria uma string para utilização na conversão do canal analógico.
float iAN0; // variável para a leitura do canal analógico AN0
float iTensao;

void config_io()
{
    ADCON1=0x0E; // Configura o Pino (AN0) como canal analógico e o restante com digital
    TRISE=0x00; // Configura como Pinos de saída Digital
    TRISD=0x00; // Configura como Pinos de saída Digital
    TRISC=0X00; // Configura como Pinos de saída Digital
    PORTE.RE1=0; // Seleciona como '0' o pino RE1 (R/W do display de lCD)
    PORTD=0x00; // Seleciona como '0' os pinos D0, D1, D2 E D3 para limpar o PORTD (pinos do display de LCD)
    PORTC=0xFF; // Limpa o PORTC
}

void main()
{
    ADC_Init(); // Inicia o canal analógico
    config_io(); // inicializa função de configuração dos pinos de IO
    Lcd_Init(); // Inicia o LCD
    Lcd_Cmd(_LCD_CLEAR); // Limpa o Display de LCD
    Lcd_Cmd(_LCD_CURSOR_OFF); // Desliga o cursor do LCD

    LCD_Out(1,1,"AD - TENSAO");  // Texto inicial no display de lcd

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