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

#define B1 PORTB.RB0
#define D1 PORTC.RC1
#define D2 PORTC.RC0
#define D3 PORTC.RC2


// insere as variaveis globais
unsigned char sForce[16]; // cria uma string para utilização na conversão do canal analógico.
float rAN0; // variável para a leitura do canal analógico RA0
float rForce;
char sD1;
char sD2;
char sD3;

void config_io()
{
    ADCON1=0x0E; // Configura o Pino (RA0) como canal analógico e o restante com digital
    TRISE=0x00; // Configura como Pinos de saída Digital
    TRISD=0x00; // Configura como Pinos de saída Digital
    TRISB=0X01; // RB0 como entrada digital
    TRISC=0X00; // PORTC como saída digital
    PORTE.RE1=0; // Seleciona como '0' o pino RE1 (R/W do display de lCD)
    PORTD=0x00; // Seleciona como '0' os pinos D0, D1, D2 E D3 para limpar o PORTD (pinos do display de LCD)
}

void main()
{
    ADC_Init(); // Inicia o canal analógico
    config_io(); // inicializa função de configuração dos pinos de IO
    Lcd_Init(); // Inicia o LCD
    Lcd_Cmd(_LCD_CLEAR); // Limpa o Display de LCD
    Lcd_Cmd(_LCD_CURSOR_OFF); // Desliga o cursor do LCD

    while(1)
    {
        rAN0= ADC_Read(0);
        rForce= rAN0/8.52;    // Equação do sensor 0 - 1023 / 0L - 120kg
        FloatToStr(rForce,sForce);
        
        if(B1 == 0)
        {
              LCD_Out(1,3,"SENSOR FORCE");
              LCD_Out(2,1,"FORCE: ");
              LCD_Out(2,8,sForce);
              LCD_Out(2,12," kg     ");
              delay_ms(500);
        }
        else if (B1 == 1)
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