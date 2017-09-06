#include <xc.h>

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

// CONFIG1
#pragma config FOSC = ECH       // Oscillator Selection (ECH, External Clock, High Power Mode (4-32 MHz): device clock supplied to CLKIN pin)
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


#define TIMERCNT 62500
#define TIMERMUL 10
#define TMRVALUE (65536 - TIMERCNT)  
#define TMRHVALUE (TMRVALUE & 0xFF00) 
#define TMRLVALUE (TMRVALUE & 0x00FF)
#define PORT_INIT_STATE -1
#define HIGH_LEVEL 1
#define LOW_LEVEL 0
void showClick();
void sendData();
void showLed();
void Timer2Int();
void initialization();
unsigned char var[4] = {0,0,0,0};  //???????
int num = 1; //?????????? 1-4
int key = 0;  //?? 1-10
int type = 0; //type = 0 ??;type = 1 ?? ;2 ??
int temp = 0;
int Current_status = 1;  //???????
int Current_mode = 0; //0?? 1??
int count[10] = {0,0,0,0,0,0,0,0,0,0};  //????

int zero_num = 0; //????0???
int currentCheckNum = 1 ; //???????? 1\2\3\4
int currentPort = PORT_INIT_STATE; //???0??? 0\1\2\3
unsigned char shouldSendData = 0;
const unsigned int buf[] = {0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000
 ,0b10010000,0b11111111};
void main(void) { 
    initialization();
    while(1)
    {

    }
}
void  interrupt  ISR(void)  
{  
    if(INTCONbits.TMR0IF == 1)
    {
        showLed(); //Timer0?????   
    }
    if(PIR1bits.TMR2IF == 1)
    {
        Timer2Int(); //Timer2?????       
    }

    return;
}  

void initialization()
{
//    OSCCON = 0xf0;
    OSCCONbits.IRCF = 0b1110;
    BAUDCONbits.BRG16 = 1;
    TXSTAbits.SYNC = 0;
    TXSTAbits.BRGH = 1;
    SPBRGL = 34; //配置系统频率为8MHZ,波特率为9600
    SPBRGH = 0;
    RCSTAbits.SPEN = 1;
    TXSTAbits.TXEN = 1;

    PORTA = 0;
    ANSELA = 0;
    TRISA = 0;
    LATA = 1;
    
    ANSELB = 0;
    TRISB = 0;
    LATB = 0;
    
    TRISC = 0;
    PORTC = 0;
    LATC = 0;
    
    OPTION_REGbits.nWPUEN = 0;
    
    T1GCONbits.TMR1GE = 0;
    
    T1CONbits.T1CKPS1 = 1;
    T1CONbits.T1CKPS0 = 1;
    T1CONbits.TMR1ON = 1;
    PIE1bits.TMR1IE = 1;
    PIR1bits.TMR1IF = 0;
    
    INTCONbits.GIE = 1;
    INTCONbits.TMR0IE = 1;
    INTCONbits.TMR0IF = 0; 
    INTCONbits.PEIE = 1;
    INTCONbits.IOCIE = 1;
    
    OPTION_REG = 0b01000000;
    
    PIE1bits.TMR2IE = 1;
    PIR1bits.TMR2IF = 0;
   
    T2CON = 0b00011101;
    TMR2 = 0;
    PR2 = 0xFF;
    
    IOCBPbits.IOCBP4 = 1;
    IOCBNbits.IOCBN4 = 1;
    TMR1H = 0;
    TMR1L = 0;
}
void sendData()
{
    TXREG = var[0];
    while(TXSTAbits.TRMT == 0);
    TXREG = var[1];
    while(TXSTAbits.TRMT == 0);
    TXREG = var[2];
    while(TXSTAbits.TRMT == 0);
    TXREG = var[3];
    while(TXSTAbits.TRMT == 0);
}

void singleClick()
{
    showClick();
    sendData();
}
void doubleClick()
{
    showClick();
    sendData();
}
void longClick()
{
    showClick();
    sendData();
}
void showClick()
{
    if(key == 10)
    {
        var[0] = 1;
        var[1] = 0;
    }
    else
    {
        var[0] = 0;
        var[1] = key;
    }
    if(count[key - 1] == 97)
        count[key - 1] = 0;
    
    if(type == 0)  //??
        count[key - 1]++;
    else if(type == 1)   //??
        count[key - 1] += 2;
    else if(type == 2)
        count[key  -1] += 3;
    var[2] = count[key - 1]/10;
    var[3] = count[key - 1]%10;
    return;
}

void showLed()
{
    INTCONbits.TMR0IF = 0;
    switch(num)
    {
        case 1:
            PORTA = buf[var[0]];
            PORTC = 0x01;
            num++;
            break;
        case 2:
            PORTA = buf[var[1]];
            PORTC = 0x02;
            num++;
            break;  
        case 3:
            PORTA = buf[var[2]];
            PORTC = 0x04;
            num++;
            break;
         case 4:
            PORTA = buf[var[3]];
            PORTC = 0x08;
            num = 1;
            break;            
    }
    return;
}

int LEVELDETECT()
{
   if(currentPort == 3)
   {
       if(PORTBbits.RB3 == HIGH_LEVEL)
           return HIGH_LEVEL;
       else
           return LOW_LEVEL;
   }
   if(currentPort == 2)
   {
       if(PORTBbits.RB2 == HIGH_LEVEL)
           return HIGH_LEVEL;
       else
           return LOW_LEVEL;
   }  
   if(currentPort == 1)
   {
       if(PORTBbits.RB1 == HIGH_LEVEL)
           return HIGH_LEVEL;
       else
           return LOW_LEVEL;
   }   
   if(currentPort == 0)
   {
       if(PORTBbits.RB0 == HIGH_LEVEL)
           return HIGH_LEVEL;
       else
           return LOW_LEVEL;
   }   
}

void getType()    
{
    temp = 0; //?????????
    switch(Current_status)
    {
        case 1:
            temp = LEVELDETECT();
            if(temp == LOW_LEVEL)
            {
                Current_status = 2;
            }
            break;
        case 2:
            temp = LEVELDETECT();
            if(temp == HIGH_LEVEL)
            {
                Current_status = 1;
            }
            else
            {
                Current_status = 3;
                TMR1L = 0;
                TMR1H = 0;
                PIR1bits.TMR1IF = 0;
            }
            break;
        case 3:
            if(PIR1bits.TMR1IF == 1)
            {
                Current_status = 11;
            }
            else
            {//????1s
                temp = LEVELDETECT();
                if(temp == HIGH_LEVEL)
                {
                    Current_status = 4;
                }
            }
            break;
        case 4:
            temp = LEVELDETECT();
            if(temp == HIGH_LEVEL)
            {
                Current_status = 5;
                TMR1L = 0;
                TMR1H = 0;
                PIR1bits.TMR1IF = 0;
            }
            else
            {
                Current_status = 3;
            }
            break;
        case 5:
            if(TMR1H >= 0xB0)
            {
                Current_status = 6;
            }
            else
            {
                PORTBbits.RB4 = 0;
                temp = LEVELDETECT();
                if(temp == LOW_LEVEL)
                {
                    Current_status = 7;
                }
            }
            break;
        case 6:
            type = 0;  //??
            singleClick();
            Current_mode = 0;
            Current_status = 1;
            return;
        case 7:
            temp = LEVELDETECT();
            if(temp == HIGH_LEVEL)
            {
                Current_status = 5;
            }
            else
            {
                Current_status = 8;
            }
            break;
        case 8:
            type = 1; //??
            doubleClick();
            Current_status = 9;
            break;
        case 9:
            temp = LEVELDETECT();
            if(temp == HIGH_LEVEL)
            {
                Current_status = 10;
            }
            break;
        case 10:
            temp = LEVELDETECT();
            if(temp == HIGH_LEVEL)
            {
                Current_status = 14;
            }
            else
            {
                Current_status = 9;
            }
            break;
        case 11:
            type = 2;
            longClick();
            Current_status = 12;
            break;            
        case 12:
            temp = LEVELDETECT();
            if(temp == HIGH_LEVEL)
            {
                Current_status = 13;
                return;
            }
            else
            {
                return;
            }
            break;
        case 13:
            temp = LEVELDETECT();
            if(temp == HIGH_LEVEL)
            {
                Current_status = 14;
            }
            else
            {
                Current_status = 12;
            }
            break;
        case 14:
            Current_mode = 0;
            Current_status = 1;
            break;            
    }
    return;
}

void checkClick()  
{
    WPUB = 0x0f;
    TRISB = 0x0f;
    key = 0;
    
    PORTBbits.RB4 = 1;  
    
    currentCheckNum = 1;  //?????
    currentPort = PORT_INIT_STATE; //???????? ???
    zero_num = 0;
    for(;zero_num < 1;)
    {
        switch(currentCheckNum)
        {        
             case 1://?????
                    if(PORTBbits.RB3 == 0)
                    {
                       // PORTBbits.RB4 = 0;                         
                        currentPort = 3;
                        zero_num++;
                        key = 7;
                    }
                     if(PORTBbits.RB2 == 0)
                    {
                         if(zero_num == 1)
                         {//1.???S8?2.???? 
                             key = 0;
                             return;
                         }
                         else
                         {
                            //PORTBbits.RB4 = 0; 
                             key = 8;
                             currentPort = 2;
                             zero_num++;
                         }
                    }
                     if(PORTBbits.RB1 == 0)
                    {
                         if(zero_num == 1)
                         {//1.???S9?2.????     
                             key = 0;
                             return;
                         }
                         else
                         {
                             //PORTBbits.RB4 = 0; 
                             key = 9;
                             currentPort = 1;
                             zero_num++;
                         }
                    }                           
                     if(PORTBbits.RB0 == 0)
                    {
                         if(zero_num == 1)
                         {//1.???S10?2.????   
                             key = 0;
                             return;
                         }
                         else
                         {
                             //PORTBbits.RB4 = 0; 
                             key = 10;
                             currentPort = 0;
                             zero_num++;
                         }
                    }   
                    if(key){
                        Current_mode = 1;
                        return;
                    }
                    else
                    {
                        currentCheckNum = 2;  //????????????
                    }
                 break;
                 
             case 2:
                // return;
                 WPUBbits.WPUB3 = 0;
                 TRISBbits.TRISB3 = 0;
                 PORTBbits.RB3 = 0;
                 if(PORTBbits.RB2 == 0)
                 {
                     currentPort = 2;
                     zero_num++;
                     key = 5;
                 }
                 if(PORTBbits.RB1 == 0)
                 {
                     if(zero_num == 1)
                     {
                         key = 0;
                         return;
                     }
                     else
                     {
                        currentPort = 1;
                        zero_num++;
                        key = 1;
                     }
                 }
                 if(PORTBbits.RB0 == 0)
                 {
                     if(zero_num == 1)
                     {
                         key = 0;
                         return;
                     }
                     else
                     {
                        currentPort = 0;
                        zero_num++;
                        key = 2;
                     }
                 }                 
                 if(key){
                     Current_mode = 1;
                     return;
                 }
                 else
                 {
                     currentCheckNum = 3;
                 }
                 break;  
            case 3:
                 WPUBbits.WPUB2 = 0;
                 TRISBbits.TRISB2 = 0;
                 PORTBbits.RB2 = 0;
                 if(PORTBbits.RB1 == 0)
                 {
                     currentPort = 1;
                     zero_num++;
                     key = 3;
                 } 
                 if(PORTBbits.RB0 == 0)
                 {
                     if(zero_num == 1)
                     {
                         key = 0;
                         return;
                     }
                     else
                     {
                        currentPort = 0;
                        zero_num++;
                        key = 4;
                     }
                 }                 
                if(key){
                     Current_mode = 1;
                     return;
                 }
                 else
                 {
                     currentCheckNum =4;
                 }
                 break;  
            case 4: 
                 WPUBbits.WPUB1 = 0;
                 TRISBbits.TRISB1 = 0;
                 PORTBbits.RB1 = 0;
                 if(PORTBbits.RB0 == 0)
                 {
                     currentPort = 0;
                     zero_num++;
                     key = 6;
                 }
                 if(key){
                     Current_mode = 1;
                     return;
                 }
                 else
                 {
                     currentCheckNum = 1;
                     return;
                 }
        }
        
    }
}


void Timer2Int()
{
    PIR1bits.TMR2IF = 0;
    if( Current_mode == 1)
        getType();
    else
        checkClick();
    return;
}



