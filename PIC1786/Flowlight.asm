; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
#include "p16F1786.inc"

; CONFIG1
; __config 0xFFE4
 __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _CLKOUTEN_OFF & _IESO_ON & _FCMEN_ON
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _WRT_OFF & _VCAPEN_OFF & _PLLEN_ON & _STVREN_ON & _BORV_LO & _LPBOR_OFF & _LVP_ON
 #define Min_high PORTC,4
 #define Min_low PORTC,5
 #define Sec_high PORTC,6
 #define Sec_low PORTC,7
 
 udata_shr  
 tmp res 1
 tmp1 res 1
 arg1 res 1
 delay_time res 1
 min_high res 1
 min_low res 1
 sec_high res 1
 sec_low res 1
 mpx_cnt res 1
 cnt res 1
cnt1 res 1
 
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

MAIN_PROG CODE                      ; let linker place main program

START
    
    pagesel init
    call init
    
    ;init PIN_A
    banksel TRISA
    clrf TRISA
    banksel LATA
    movlw 0xff
    movwf LATA
    ;init PIN_C OUT
    banksel TRISC
    clrf TRISC
  
loop
    pagesel roll
    call roll
    pagesel oneToFour
    call oneToFour
    pagesel timer
    call timer
    goto loop
  ; loop forever

constants
    brw
    ;; b'gfedcba' ?????????7?????????
    retlw b'11000000'; 4FH ;number 0; 
    retlw b'11111001'; 79H ;number 1; 
    retlw b'10100100'; 24H ;number 2; 
    retlw b'10110000'; 30H ;number 3; 
    retlw b'10011001'; 19H ;number 4; 
    retlw b'10010010'; 12H ;number 5; 
    retlw b'10000010'; 02H ;number 6; 
    retlw b'11111000'; 78H ;number 7; 
    retlw b'10000000'; 00H ;number 8; 
    retlw b'10010000'; 10H ;number 9; 
    
table1
    brw
    retlw b'11111111'; black
    retlw b'10011001'; 19H ;number 4; 
    retlw b'10110000'; 30H ;number 3; 
    retlw b'10100100'; 24H ;number 2;
    retlw b'11111001'; 79H ;number 1;
    retlw b'11111111'; black
    retlw b'11111111'; black
    retlw b'11111111'; black
    retlw b'11111111'; black
   
table2
    brw
    retlw b'11111111'; black
    retlw b'11111111'; black
    retlw b'10011001'; 19H ;number 4; 
    retlw b'10110000'; 30H ;number 3; 
    retlw b'10100100'; 24H ;number 2; 
    retlw b'11111001'; 79H ;number 1; 
    retlw b'11111111'; black
    retlw b'11111111'; black
    retlw b'11111111'; black

table3
    brw
    retlw b'11111111'; black
    retlw b'11111111'; black
    retlw b'11111111'; black
    retlw b'10011001'; 19H ;number 4; 
    retlw b'10110000'; 30H ;number 3; 
    retlw b'10100100'; 24H ;number 2; 
    retlw b'11111001'; 79H ;number 1; 
    retlw b'11111111'; black
    retlw b'11111111'; black

table4
    brw
    retlw b'11111111'; black
    retlw b'11111111'; black
    retlw b'11111111'; black
    retlw b'11111111'; black
    retlw b'10011001'; 19H ;number 4; 
    retlw b'10110000'; 30H ;number 3; 
    retlw b'10100100'; 24H ;number 2; 
    retlw b'11111001'; 79H ;number 1; 
    retlw b'11111111'; black
 
getchar
    pagesel constants
    call constants
    movwf LATA
    return
    
init 
    banksel TRISB
    movlw 0xff
    movwf TRISB
    clrf PORTB
    banksel ANSELB
    clrf ANSELB
    ;使能电平中断          
    banksel INTCON
    bsf INTCON,IOCIE  
    bsf INTCON,GIE
    bsf INTCON,6
    ;RB4
    bsf IOCBP,4
    bcf IOCBN,4
    
    ;;使能timer2中断
    ;banksel PIE1
    ;bsf PIE1,1
    ;;打开timer2
    banksel T2CON
    bsf T2CON,2
    ;;预分频比为1：1
    bcf T2CON,0
    bcf T2CON,1
    ;;后分频比为1：1
    bcf T2CON,3
    bcf T2CON,4
    bcf T2CON,5
    bcf T2CON,6
    ;;比较器PR2=249
    movlw b'11111001'; 249
    movwf PR2
    return 
    
;??????delay_time,???1
delay 
    ;;延时部分
     ;??timer???
    banksel TMR2
    clrf TMR2
l2  ;;clear PIR1
    banksel PIR1
    bcf PIR1,1
    
l1  btfss PIR1,1
    goto l1
    
    ;; arg1--   
    decfsz delay_time,f
    goto l2
    return ; delay finish

oneToFour
    movlw  0x1
    movwf tmp ;tmp???1??
    banksel LATC
    movlw b'00010001'
    movwf LATC
    lp1  
	pagesel getchar   
        movf tmp,w
	call getchar
	
	;delay
        pagesel delay
        movlw 0xfa ; 250
	movwf delay_time
        call delay
	
	rlf PORTC,f
	btfss STATUS,C
	goto isZero
	bsf LATC,0
	goto next
isZero 
	bcf PORTC,0
next
	btfss tmp,2
	goto add_one
	movlw 0x1
	movwf tmp
	goto lp_end
add_one 
	incf tmp,f
lp_end  
	btfss PORTB,5
	goto lp1
    return

roll
    banksel PORTC
    clrf PORTC
    
    clrf cnt
    
outer
    movlw 0x7d
    movwf cnt1
inner    
    ; display minutes for 2ms
    movlw 0x1
    movwf delay_time
    pagesel delay
    call delay
    movf cnt,w
    pagesel table1
    call table1
    movwf PORTA
    banksel PORTC
    bcf Sec_low
    bsf Min_high;
    
    movlw 0x1
    movwf delay_time
    pagesel delay
    call delay
    movf cnt,w
    pagesel table2
    call table2
    movwf PORTA
    banksel PORTC
    bcf Min_high
    bsf Min_low
    
    movlw 0x1
    movwf delay_time
    pagesel delay
    call delay
    movf cnt,w
    pagesel table3
    call table3
    movwf PORTA
    banksel PORTC
    bcf Min_low
    bsf Sec_high
    
    movlw 0x1
    movwf delay_time
    pagesel delay
    call delay
    movf cnt,w
    pagesel table4
    call table4
    movwf PORTA
    banksel PORTC
    bcf Sec_high
    bsf Sec_low
    
    decfsz cnt1,f
    goto inner
    
    incf cnt,f
    movlw .9
    xorwf cnt,w
    btfss STATUS,Z
    goto r_end
    clrf cnt
r_end
    btfss PORTB,4
    goto outer
    
    return 

timer 
    banksel PORTC
    clrf PORTC
    clrf min_high
    clrf min_low
    clrf sec_high
    clrf sec_low
main_loop
    movlw 0x7d
    movwf mpx_cnt
mpx_loop    
    ; display minutes for 2ms
    movlw 0x1
    movwf delay_time
    pagesel delay
    call delay
    movf min_high,w
    pagesel getchar
    call getchar
    banksel PORTC
    bcf Sec_low
    bsf Min_high;
    
    movlw 0x1
    movwf delay_time
    pagesel delay
    call delay
    movf min_low,w
    pagesel getchar
    call getchar
    ;banksel PORTA
    ;bcf PORTA,7
     banksel PORTC
     bcf Min_high
    bsf Min_low;
    
    movlw 0x1
    movwf delay_time
    pagesel delay
    call delay
    movf sec_high,w
    pagesel getchar
    call getchar
     banksel PORTC
     bcf Min_low
    bsf Sec_high;
    
    movlw 0x1
    movwf delay_time
    pagesel delay
    call delay
    movf sec_low,w
    pagesel getchar
    call getchar
     banksel PORTC
     bcf Sec_high
    bsf Sec_low;
    
    decfsz mpx_cnt,f
    goto mpx_loop
    
    incf sec_low,f
    movlw .10
    xorwf sec_low,w
    btfss STATUS,Z
    goto end_inc
    
    clrf sec_low
    incf sec_high,f
    movlw .6
    xorwf sec_high,w
    btfss STATUS,Z
    goto end_inc
    
    clrf sec_high
    incf min_low,f
    movlw .10
    xorwf min_low,w
    btfss STATUS,Z
    goto end_inc
    
    clrf min_low
    incf min_high,f
    movlw .10
    xorwf min_high,w
    btfss STATUS,Z
    goto end_inc
    clrf min_high
end_inc
    btfss PORTB,1
    goto main_loop
    return
    END

