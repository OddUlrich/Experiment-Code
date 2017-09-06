
#include <xc.h>

// CONFIG1
#pragma config FOSC = INTOSC    // Oscillator Selection (INTOSC oscillator: I/O function on CLKIN pin)
#pragma config WDTE = OFF       // Watchdog Timer Enable (WDT disabled)
#pragma config PWRTE = OFF      // Power-up Timer Enable (PWRT disabled)
#pragma config MCLRE = ON       // MCLR Pin Function Select (MCLR/VPP pin function is MCLR)
#pragma config CP = OFF         // Flash Program Memory Code Protection (Program memory code protection is disabled)
#pragma config CPD = OFF        // Data Memory Code Protection (Data memory code protection is disabled)
#pragma config BOREN = ON       // Brown-out Reset Enable (Brown-out Reset enabled)
#pragma config CLKOUTEN = OFF   // Clock Out Enable (CLKOUT function is disabled. I/O or oscillator function on the CLKOUT pin)
#pragma config IESO = ON        // Internal/External Switchover (Internal/External Switchover mode is enabled)
#pragma config FCMEN = ON       // Fail-Safe Clock Monitor Enable (Fail-Safe Clock Monitor is enabled)

// CONFIG2
#pragma config WRT = OFF        // Flash Memory Self-Write Protection (Write protection off)
#pragma config VCAPEN = OFF     // Voltage Regulator Capacitor Enable bit (Vcap functionality is disabled on RA6.)
#pragma config PLLEN = ON       // PLL Enable (4x PLL enabled)
#pragma config STVREN = ON      // Stack Overflow/Underflow Reset Enable (Stack Overflow or Underflow will cause a Reset)
#pragma config BORV = LO        // Brown-out Reset Voltage Selection (Brown-out Reset Voltage (Vbor), low trip point selected.)
#pragma config LPBOR = OFF      // Low Power Brown-Out Reset Enable Bit (Low power brown-out is disabled)
#pragma config LVP = ON         // Low-Voltage Programming Enable (Low-voltage programming enabled)

unsigned char RC_DATA = 0x00;
unsigned char RC_FLAG;
unsigned char cfg[4] = { 0xff, 0xf7, 0xfb, 0xfd};

unsigned char reg[11] = { 0xc0, 0xf9, 0xa4, 0xb0, 0x99, 
                          0x92, 0x82, 0xf8, 0x80, 0x90, 0xc0};
unsigned char val[4] = {0xbf, 0xbf, 0xbf, 0xbf};

int reg_index = 0;
int val_index = 0;

unsigned char c;


void TMR2I_init(void)
{
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.TMR2IE = 1;
    T2CONbits.TMR2ON = 1;
    T2CONbits.T2OUTPS = 0b1111;
    T2CONbits.T2CKPS = 0b00;
    PR2 = 0b11111001;
    TMR2 = 0;
    PIR1bits.TMR2IF = 0;
}

void reg_init(void)
{
    TRISA = 0x00;
    LATA = 0xbf;
    TRISCbits.TRISC0 = 0;
    TRISCbits.TRISC1 = 0;
    TRISCbits.TRISC2 = 0;
    TRISCbits.TRISC3 = 0;    
    LATCbits.LATC0 = 1;
    LATCbits.LATC1 = 1;
    LATCbits.LATC2 = 1;
    LATCbits.LATC3 = 1;
    
}

void init_fosc(void)

{
     //OSCCONbits.IRCF = 0b1110;//
    OSCCON = 0xf0;
}

void init_eusart()
{
    APFCONbits.TXSEL = 0;//RC6
    APFCONbits.RXSEL = 0;//RC7
    TRISCbits.TRISC6 = 0;
    TRISCbits.TRISC7 = 1;//RC7 RX input
    SPBRGH = 0x00;//
    SPBRGL = 138;// Baud rate 57600
    TXSTAbits.BRGH = 1; //low speed
    BAUDCONbits.BRG16 = 1; //8bit Baud rate Generator is used
    TXSTAbits.SYNC   =0; //Asynchronous mode

    PIE1bits.RCIE = 1; //enables the USART Receive interrupt
    INTCONbits.PEIE = 1;
    INTCONbits.GIE  = 1;

    RCSTAbits.CREN = 1;//Enables receiver
    TXSTAbits.TXEN = 1;//Transmit enabled
    RCSTAbits.SPEN = 1; //serial port enable

}

void tx_eusart(unsigned char tx_data)
{
    TXREG = tx_data;
    while(TRMT==0);// loop
}

void interrupt isr(void)
{
     if (RCIE && RCIF) 
     {
        if(RCSTAbits.FERR)
        {
            PORTBbits.RB5=1;
            c = RCREG;
            //RCSTAbits.SPEN = 0;
            //RCSTAbits.SPEN = 1;
        }
        if(RCSTAbits.OERR)
        {
            RCSTAbits.CREN = 0;
            RCSTAbits.CREN = 1;
        }
        
        val[val_index] = reg[RCREG];
        ++val_index;
        LATBbits.LATB5 = 1;

        if (4 == val_index)
        {
            val_index = 0;
        }
    }
     
     if (PIE1bits.TMR2IE && PIR1bits.TMR2IF)
    {
        switch(reg_index)
        {
            case 0: 
                LATCbits.LATC3 = 0;
                LATA = val[0];
                LATCbits.LATC0 = 1;
                break;
            case 1:
                LATCbits.LATC0 = 0;
                LATA = val[1];
                LATCbits.LATC1 = 1;
                break;
            case 2:
                LATCbits.LATC1 = 0;
                LATA = val[2];
                LATCbits.LATC2 = 1;
                break;
            case 3:
                LATCbits.LATC2 = 0;
                LATA = val[3];
                LATCbits.LATC3 = 1;
                break;
            default: break;
        }
        if(4 == ++reg_index)
        {
            reg_index = 0;
        }
        PIR1bits.TMR2IF = 0;
    }
    return;
}

int main(int argc, char** argv) {

    init_fosc();
    init_eusart();
    reg_init();
    TMR2I_init();

    //tx_eusart(RC_DATA);
    TRISBbits.TRISB5 = 0;
    LATBbits.LATB5 = 0;

    while(1)
    {
//        _delay(1000000);
//        LATBbits.LATB5 = 0;
//        
//        ++RC_DATA;
//        if(0x0c == RC_DATA)
//        {
//            RC_DATA = 0x00;
//        }
//        tx_eusart(RC_DATA);

        
    }
}
