#include <xc.h>
#include <stdbool.h>
// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

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

#define SLAVE_W 0x90
#define SLAVE_R 0x91
#define TMP 0x01
typedef unsigned char uchar;
bool flag = true;

unsigned char cfg[4] = { 0xff, 0xf7, 0xfb, 0xfd};
unsigned char reg[11] = { 0xbf, 0xf9, 0xa4, 0xb0, 0x99, 
                          0x92, 0x82, 0xf8, 0x80, 0x90, 0xc0};
unsigned char val[4] = {0xbf, 0xbf, 0xbf, 0xbf};
unsigned char addr = 0x0;
int index = 0;
int reg_index = 0;
int val_index = 0;

void interrupt My_irs(void)
{
    if(    INTCONbits.IOCIE  && INTCONbits.IOCIF)
    {
unsigned char tmp = reg[index];
            eeprom_write(addr,tmp);
            INTCONbits.IOCIF = 0;
            IOCBFbits.IOCBF4 = 0;
            return;
}

if (PIE1bits.TMR2IE && PIR1bits.TMR2IF)
    {
        switch(reg_index)
        {
            case 0: 
                LATCbits.LATC5 = 0;
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
                LATCbits.LATC5 = 1;
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

void TMR2I_init(void)
{
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    PIE1bits.TMR2IE = 1;
    T2CONbits.TMR2ON = 1;
    T2CONbits.T2OUTPS = 0b0000;
    T2CONbits.T2CKPS = 0b00;
    PR2 = 0b11111001;
    TMR2 = 0;
    PIR1bits.TMR2IF = 0;
}

void reg_init(void)
{
    TRISCbits.TRISC0 = 0;
    TRISCbits.TRISC1 = 0;
    TRISCbits.TRISC2 = 0;
    TRISCbits.TRISC5 = 0;
    LATCbits.LATC0 = 1;
    LATCbits.LATC1 = 1;
    LATCbits.LATC2 = 1;
    LATCbits.LATC5 = 1;
    TRISA = 0x00;
    LATA = 0xbf;
}

void key_init(void)
{
    ANSELBbits.ANSB0 = 0;
    ANSELBbits.ANSB1 = 0;
    ANSELBbits.ANSB2 = 0;
    ANSELBbits.ANSB3 = 0;
    WPUBbits.WPUB0 = 1;
    WPUBbits.WPUB1 = 1;
    WPUBbits.WPUB2 = 1;
    WPUBbits.WPUB3 = 1;
    //OPTION_REG = 0b00000000;
}

int key_scan(void)
{
    int index = 0;
    int cnt = 0;
    int num = 0;
    unsigned char key_state = 0;
    
    for (index = 0; index < 4; ++index)
    {
        TRISB = cfg[index];
        LATB = TRISB;
        
        
        if (index == 0)
        {
            key_state = PORTB | 0xf0;  //屏蔽高4位
            key_state = key_state ^ cfg[index];  //异或，变化位为高
            switch (key_state)
            {
                case 0x00:num = 0;break;
                case 0x08:num = 7;break;
                case 0x04:num = 8;break;
                case 0x02:num = 9;break;
                case 0x01: num = 10;break;
                default:num = -1;break; 
            }
            if (num != 0)
            {
                return num;
            }
        }
        else if (index == 1)
        {
            key_state = PORTB | 0xf0;  //屏蔽高4位
            key_state = key_state ^ cfg[index];  //异或，变化位为高
            switch (key_state)
            {
                case 0x00:break;
                case 0x04:num = 1; ++cnt; break;
                case 0x02:num = 2; ++cnt; break;
                case 0x01:num = 4; ++cnt; break;
                default:num = -1;break; 
            }
            if (num == -1)
            {
                return num;
            }
        }
        else if (index == 2)
        {
            key_state = PORTB | 0xf8;  //屏蔽高5位
            key_state = key_state ^ cfg[index];  //异或，变化位为高
            switch (key_state)
            {
                case 0x00:break;
                case 0x02:num = 3; ++cnt; break;
                case 0x01:num = 5; ++cnt; break;
                default:num = -1;break; 
            }
            if (num == -1)
            {
                return num;
            }
        }
        else if (index == 3)
        {
            key_state = PORTB | 0xf4;  //屏蔽高6位
            key_state = key_state ^ cfg[index];  //异或，变化位为高
            switch (key_state)
            {
                case 0x00:break;
                case 0x01:num = 6; ++cnt; break;
                default:break; 
            }
        }
    }// end for for
    
    if (cnt > 1)
    {
        return -1;
    }
    else// if (cnt == 0 || cnt == 1)
    {
        return num;
    }
    
}//end for key_scan

void key2val(int num)
{
    if (4 == val_index)
    {
        val[0] = val[1];
        val[1] = val[2];
        val[2] = val[3];
        val[3] = reg[num];
    }
    else  
    {
        val[val_index] = reg[num];
        ++val_index;
    }
}

void vol2val(float res)
{
    int tmp1,tmp2,tmp3,tmp4;
    res = (int)(res*1000);
    tmp1 = res/1000;
    res = res - 1000*tmp1;
    tmp2 = res/100;
    res = res - 100*tmp2;
    tmp3 = res/10;
    tmp4 = res - 10*tmp3;
    
    if (tmp2 == 0)
    {
        tmp2 = 10;
    }
    if (tmp3 == 0)
    {
        tmp3 = 10;
    }    
    if (tmp4 == 0)
    {
        tmp4 = 10;
    }
    val[0] = reg[tmp1];
    val[1] = reg[tmp2];
    val[2] = reg[tmp3];
    val[3] = reg[tmp4];  
}

void temp2val(float temp)
{
    int tmp1,tmp2,tmp3,tmp4;
    temp = (int)(temp*100);
    tmp1 = temp/1000;
    temp = temp - 1000*tmp1;
    tmp2 = temp/100;
    temp = temp - 100*tmp2;
    tmp3 = temp/10;
    tmp4 = temp - 10*tmp3;
    
    if (tmp1 == 0)
    {
        tmp1 = 10;
    }
    if (tmp2 == 0)
    {
        tmp2 = 10;
    }
    if (tmp3 == 0)
    {
        tmp3 = 10;
    }    
    if (tmp4 == 0)
    {
        tmp4 = 10;
    }
    val[0] = reg[tmp1] - 0b10000000;
    val[1] = reg[tmp2];
    val[2] = reg[tmp3];
    val[3] = reg[tmp4];  
}

float ADC_Vol(void)
{
    FVRCONbits.FVREN=1;  // enable FVR module
    FVRCONbits.ADFVR1=0;
    FVRCONbits.ADFVR0=1;  // 1.024v
    while(!FVRCONbits.FVRRDY)
        ;                 // wait
    ADCON0bits.ADRMD = 0; // 12-bits result
    ADCON1bits.ADFM = 1;  // 2-complement result
    ADCON1bits.ADNREF = 0; // negative ref is ground
    ADCON1bits.ADPREF = 0b00;  // positive ref is Vdd
    ADCON2bits.CHSN = 0b1111;
    ADCON0bits.CHS = 0b11111; // choose FVR path
    ADCON0bits.ADON = 1;      // enable ADC module
    ADCON0bits.GO = 1;  // start a conversation
    while (!ADCON0bits.DONE)
        ;
    long adc_val = 0;
    adc_val = ADRESH << 8;
    adc_val |= ADRESL;
    float res = 0.0;
    res = 1024.0;
    res *= 4096.0;
    res /= adc_val;
    res /= 1000.0;
    return res;
}

float ADC_Temp(void)
{
    FVRCONbits.FVREN=1;  // enable FVR module
    FVRCONbits.ADFVR1=0;
    FVRCONbits.ADFVR0=1;  // 1.024v
    FVRCONbits.TSEN = 1;  //temp enable
    FVRCONbits.TSRNG = 1; //high voltage range
    while(!FVRCONbits.FVRRDY)
        ;                 // wait

    ADCON0bits.ADRMD = 0; // 12-bits result
    ADCON1bits.ADFM = 1;  // 2-complement result
    ADCON1bits.ADNREF = 0; // negative ref is ground/    
    ADCON1bits.ADPREF = 0b00;  // positive ref is Vdd
    ADCON2bits.CHSN = 0b1111;
    ADCON0bits.CHS = 0b11101; // choose FVR path
    ADCON0bits.ADON = 1;      // enable ADC module
    ADCON0bits.GO = 1;  // start a conversation
    while (!ADCON0bits.DONE)
        ;
    
    float Vdd = 5.0;
    long adc_val = 0;
    adc_val = ADRESH << 8;
    adc_val |= ADRESL;
    float res=0.0;
    res = adc_val/4095.0;
    res = 1.0 - res;
    res = Vdd/4.0*res;
    res = 0.659 - res;
    res /= 0.00132;
    res = res - 40.0;
    return res;
}

void WaitMSSP()
{
    while (!PIR1bits.SSP1IF)
        ;
    PIR1bits.SSP1IF = 0;
    return;
}
void check_ack()
{
    if (!SSPCON2bits.ACKSTAT)
    {
        flag = false;
    }
}

void I2C ()
{
 begin:
    SSPCON1 = 0b00101000;

    SSPSTAT = 0b10000000;

 I2CREAD:
    SSPCON2bits.RSEN = 1; // restart
    WaitMSSP();

    SSPBUF = SLAVE_W;
    WaitMSSP();

    if (!SSPCON2bits.ACKSTAT)
        goto I2CREAD;

    SSPBUF = TMP;
    WaitMSSP();
    check_ack();

    SSPCON2bits.RSEN = 1;
    WaitMSSP();

    SSPBUF = SLAVE_R;
    WaitMSSP();
    check_ack();

    SSPCON2bits.RCEN = 1; // enable receive mode
    WaitMSSP();
    
    _delay(5000);
    uchar c = SSPBUF;
    
    SSPCON2bits.ACKDT = 1; // ready to send NACK
    SSPCON2bits.ACKEN = 1;

    SSPCON2bits.PEN = 1;
    WaitMSSP();

    
    goto begin;
 }

void level_init(void) {
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    INTCONbits.IOCIE = 1;
    INTCONbits.IOCIF = 0;
    
    ANSELBbits.ANSB4 = 0;
    OPTION_REGbits.nWPUEN = 0;
    WPUBbits.WPUB4 = 0;   
    TRISBbits.TRISB4 = 1;
    IOCBFbits.IOCBF4 = 0;
    IOCBNbits.IOCBN4 = 1;
    return;
}

void ele_off(void)
{
    int num;
    key_init();
    reg_init();
    level_init();
    LATA = eeprom_read(addr);
    while (1)
    {
        num = key_scan();
        while (0 != num && -1 != num)
        {
            index = num;
        }
    }
}
