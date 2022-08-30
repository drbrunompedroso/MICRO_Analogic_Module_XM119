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
unsigned char sText[16]; // cria uma string para utilização na conversão do canal analógico.
unsigned int iAN0; // variável para a leitura do canal analógico iAN0

void config_io()
{
    ADCON1=0x0E; // Configura o Pino (AN0) como canal analógico e o restante com digital
    TRISE=0x00; // Configura como Pinos de saída Digital
    TRISD=0x00; // Configura como Pinos de saída Digital
    PORTE.RE1=0; // Seleciona como '0' o pino RE1 (R/W do display de lCD)
}

void main()
{
    config_io(); // inicializa função de configuração dos pinos de IO
    ADC_Init(); // Inicia o canal analógico
    Lcd_Init(); // Inicia o LCD
    Lcd_Cmd(_LCD_CLEAR); // Limpa o Display de LCD
    Lcd_Cmd(_LCD_CURSOR_OFF); // Desliga o cursor do LCD

    LCD_Out(1,1,"Valor da A/D PIC");  // Texto inicial no display de lcd
    
    while(1)
    {

        iAN0= ADC_Read(0); // realiza a leitura do canal analógico AN0
        IntToStr(iAN0,sText); // converte a variável do tipo inteiro para string para impressão no Display de LCD
        LCD_Out(2,1,"A/D:"); // Texto no display de lcd
        LCD_Out(2,5,sText+2); // Imprime o valor convertido da A/D em string no lCD e desloca 2 casas para esquerda na string

    }
}