//Etec Presidente Vargas - Automa��o Industrial
//Programa��o Aplicada II
//Projeto: Controle de Nivel - com IHM e Drive de Pot�ncia
//Prof� Dr. Bruno Medina Pedroso

//***********LCD: direcionamento dos pinos************//
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

//**************Constantes para I/O******************//
#define S1 PORTB.RB0
#define V1 PORTC.RC0
#define B1 PORTC.RC2
#define V2 PORTC.RC1


//******* Variaveis globais*************************//
unsigned char sNivel[16]; // cria uma string para utiliza��o na convers�o do canal anal�gico.
float rAN0;               // vari�vel para a leitura do canal anal�gico AN0
float rNivel;             // vari�vel para o valor em litros

 //***********Fun��o para defini��o dos pinos de I/O e do canal A/D*******//
void config_io()
{
    ADCON1=0x0E;    // Configura o Pino (AN0) como canal anal�gico e o restante com digital
    TRISE=0x00;     // Configura como Pinos de sa�da Digital
    TRISD=0x00;     // Configura como Pinos de sa�da Digital
    TRISB=0X01;     // RB0 como entrada digital
    TRISC=0X00;     // PORTC como sa�da digital
    PORTE.RE1=0;    // Seleciona como '0' o pino RE1 (R/W do display de lCD)
    PORTD=0x00;     // Seleciona como '0' os pinos D0, D1, D2 E D3 para limpar o PORTD (pinos do display de LCD)
}

//***********La�o Principal****************//
void main()
{
    ADC_Init();                 // Inicia o canal anal�gico
    config_io();                // inicializa fun��o de configura��o dos pinos de IO
    Lcd_Init();                 // Inicia o LCD
    Lcd_Cmd(_LCD_CURSOR_OFF);   // Desliga o cursor do LCD

    while(1)
    {
        rAN0= ADC_Read(0);              // Efetua a leitua de AN0
        rNivel= rAN0 / 8.52;            // Equa��o do sensor 0 - 1023 / 0L - 120L
        sprintf(sNivel,"%.1f",rNivel);  // Fun��o para convers�o de Float para String com formata��o
        
//******************L�gica de Controle*****************//
        if(S1 == 1)
        {
             // Lcd_Cmd(_LCD_CLEAR);          // Limpa o Display de LCD
              LCD_Out(1,1,"LEVEL CONTROL");
              LCD_Out(2,1,"LEVEL:");
              LCD_Out(2,7,sNivel);
              LCD_Chr(2,12,'L');
              delay_ms(100);
        }
        else if (S1 == 0)
        {
              LCD_Out(1,1,"    ETEC - PV     ");
              LCD_Out(2,1," AUTOMACAO IND.");
        }
        
        if(rNivel <= (0.25 * 120))
        {
              V1 = 1;
              V2 = 0;
              B1 = 1;
        }
        else if (rNivel > (0.25 * 120) && rNivel <= (0.50 * 120))
        {
              V1 = 1;
              V2 = 0;
              B1 = 1;
        }
        else if (rNivel > (0.50 * 120) && rNivel <= (0.75 * 120))
        {
              V1 = 1;
              V2 = 1;
              B1 = 1;
        }
        else if (rNivel > (0.75 * 120))
        {
              V1 = 0;
              V2 = 1;
              B1 = 0;
        }
    }
}