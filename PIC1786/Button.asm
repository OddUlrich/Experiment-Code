; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
#include "p16F1786.inc"


; CONFIG1
; __config 0xFFE4
 __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _CLKOUTEN_OFF & _IESO_ON & _FCMEN_ON
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _WRT_OFF & _VCAPEN_OFF & _PLLEN_ON & _STVREN_ON & _BORV_LO & _LPBOR_OFF & _LVP_ON


#define ONCE 0xd
#define DOUBLE 0xc
#define LONG 0xb
#define ERR 0XFF ; 
#define FIRST_TUBE PORTC,0
#define SECOND_TUBE PORTC,1
#define THIRD_TUBE PORTC,2
#define FOURTH_TUBE PORTC,3
 
udata_shr
cur_key res 1
prev_key res 1
 
key_val res 1
key_type res 1
LONG_KEY res 1

index res 1  ;
index_edg res 1  ;
scan_state res 1  ;
cnt res 1    ; 
num res 1    ;
num1 res 1   ;
swap res 1   ;
flag res 1   ;
     
;;delay1ms
delay_cnt1 res 1  
delay_cnt2 res 1
tmp res 1

udata 
timer0_cnt res 1 
timer2_cnt res 1
 
RES_VECT  CODE    0000h            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED
ISR CODE 0004h
TIMER1 
    banksel PIR1
    btfss PIR1,TMR1IF
    goto TIMER0
    bcf PIR1,TMR1IF
    
    movf key_val,w
    pagesel getchar
    call getchar
    banksel PORTC
    clrf PORTC
    bsf PORTC,0
    pagesel delay1ms
    call delay1ms
    banksel PORTC
    bcf PORTC,0
   
    movf key_type,w
    pagesel getchar
    call getchar
    banksel PORTC
    clrf PORTC
    bsf PORTC,3
    pagesel delay1ms
    call delay1ms
    banksel PORTC
    bcf PORTC,3
    
    banksel TMR1H
    movlw 0xff
    movwf TMR1H
    movlw 0x00
    movwf TMR1L
retfie

TIMER0
    banksel INTCON
    btfss INTCON,TMR0IF
    goto TIMER2
    ; clear flag and timer
    bcf INTCON,TMR0IF
    banksel TMR0
    clrf TMR0
    banksel timer0_cnt
    incf timer0_cnt ; remember to init cnt
    btfss timer0_cnt,1
    retfie
    movlw 0x1
    movwf LONG_KEY
    banksel timer0_cnt
    clrf timer0_cnt
    ; close timer0 interrupt
    banksel INTCON
    bcf INTCON,TMR0IE
retfie

TIMER2
    banksel PIR1
    btfss PIR1,TMR2IF
    goto int_end
    bcf PIR1,TMR2IF
    banksel TMR2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    clrf TMR2
    
    movlw 0x0
    xorwf prev_key,w
    banksel STATUS
    btfsc STATUS,Z
    goto int_end
    movf prev_key,w
    movwf key_val
    movlw ONCE
    movwf key_type
    clrf prev_key
    clrf LONG_KEY
    ; close timer2 interrupt
    banksel PIE1
    bcf PIE1,TMR2IE
int_end
retfie

MAIN_PROG CODE                      ; let linker place main program

START
    pagesel init
    call init
    movlw 0x0
    movwf key_val
    movwf key_type
l1   
    pagesel get_safe
    call get_safe
   ; movwf key_val
    ;movlw LONG
    ;movwf key_type
    ;movwf key_val
    pagesel get_type
    call get_type
    goto l1

init 
    ;??PORTA,PORTC,TRISA,TRISA
    banksel TRISA
    clrf TRISA
    banksel LATA
    movlw 0xff
    movwf LATA
    ;init PIN_C OUT
    banksel TRISC
    clrf TRISC
    clrf PORTC
    
    ; init timer0 1048ms
    banksel INTCON
    bsf INTCON,GIE
    bsf INTCON,PEIE
    banksel OPTION_REG
    bcf OPTION_REG,PSA
    bcf OPTION_REG,TMR0CS
    bsf OPTION_REG,0
    bsf OPTION_REG,1
    bsf OPTION_REG,2
    bsf OPTION_REG,6
    bcf OPTION_REG,7
    ;?????
    bcf FIRST_TUBE
    bcf SECOND_TUBE
    bcf THIRD_TUBE
    bcf FOURTH_TUBE
    
    ;init timer1 interrupt
    banksel TMR1H
    clrf TMR1H
    clrf TMR1L
    banksel T1CON
    bsf T1CON,TMR1ON
    banksel PIE1
    bsf PIE1,TMR1IE
    banksel INTCON
    bsf INTCON,PEIE
    bsf INTCON,GIE
    ;choose timer1 clock 
    banksel T1CON
    bsf T1CON,4
    bcf T1CON,5
    ; after 256 cycles, the timer will overflow 2.048ms
    movlw 0xff
    banksel TMR1H
    movwf TMR1H
    clrf TMR1L
    ; close menkong
    bcf T1GCON,TMR1GE
    
    ; init timer2 500ms
    ; hou fen pin 1:16
    banksel T2CON
    bsf T2CON,3
    bsf T2CON,4
    bsf T2CON,5
    bcf T2CON,6
    ;enable timer2
    bsf T2CON,2
    ; yu fen pin 1:64
    bsf T2CON,0
    bsf T2CON,1
    ; PR2=249
    banksel PR2
    movlw 0x3c
    movwf PR2
    ; init vars
    clrf LONG_KEY
    clrf prev_key
    clrf timer2_cnt
    clrf timer0_cnt
    return
    
table_num
    brw
    retlw b'11111111'; all black
    retlw b'11111001'; 79H ;number 1; 
    retlw b'10100100'; 24H ;number 2; 
    retlw b'10110000'; 30H ;number 3; 
    retlw b'10011001'; 19H ;number 4; 
    retlw b'10010010'; 12H ;number 5; 
    retlw b'10000010'; 02H ;number 6; 
    retlw b'11111000'; 78H ;number 7; 
    retlw b'10000000'; 00H ;number 8; 
    retlw b'10010000'; 10H ;number 9; 
    retlw b'11000000'; 4FH ;number 0; 
    retlw b'11000111' ; 'L'
    retlw b'11000000' ; '0'
    retlw b'11000110' ; 'C'

getchar
    pagesel table_num
    call table_num
    movwf LATA
    return

delay1ms ;1ms
    movlw 0xa
    banksel cnt
    movwf cnt
delay1ms_loop  
    decfsz cnt,f
    goto delay1ms_loop
    return 

get_safe
begin    ;label;
banksel index
	clrf index
	banksel cnt
	clrf cnt

	pagesel scan
	call scan     
	movwf num1
	pagesel delay    ; 
	call delay
	pagesel scan
	call scan
	xorwf num1,w
	movwf swap
	comf swap,1
	incfsz swap,1   ;
	goto begin

	movf num1,w
return
    
    scan
       banksel ANSELB ;
       clrf ANSELB
       banksel WPUB ;
       movlw b'11111111'
       movwf WPUB

    loop ;; 
	btfsc index,2 ; d'4' = b'0000_0100'
	goto back
	
	banksel TRISB
	movf index,0
	pagesel table_cfg
	call table_cfg
	movwf TRISB  ;
	banksel PORTB
	movwf PORTB
	movf PORTB,0
	movwf scan_state  ;
	movlw b'11110000'
	iorwf scan_state,1 ; 

	movf index,0
	pagesel table_cfg
	call table_cfg
	xorwf scan_state,0
	movwf swap
	comf swap,1
	incfsz swap,1    ;
	goto match
	incf index,f
	goto loop
	
	match
	    movf index,0
	    pagesel table_cfg
	    call table_cfg
	    movwf flag
	    incf index,f
	    incfsz flag,1  ;
	    goto match_sec
	    goto prior1 ; 
	    match_sec
	        decf flag,1
	        btfss flag,3
		goto prior2
		btfss flag,2
		goto prior3
		btfss flag,1
		goto prior4
	

prior1  ;;
btfsc scan_state,3
	goto key8
	movlw b'00000111' ; 7
	movwf num
	incf cnt,f

	key8
	btfsc scan_state,2
	goto key9
	movlw b'00001000' ; 8
	movwf num
	incf cnt,f

	key9
	btfsc scan_state,1
	goto key0
	movlw b'00001001' ; 9
	movwf num
	incf cnt,f

	key0
	btfsc scan_state,0
	goto back
	movlw b'00001010' ; 10
	movwf num
	incf cnt,f
	goto back   ;

prior2  ;;
btfsc scan_state,2
	goto key2
	movlw b'00000001' ; 1
	movwf num
	incf cnt,f

	key2
	btfsc scan_state,1
	goto key4
	movlw b'00000010' ; 2
	movwf num
	incf cnt,f

	key4
	btfsc scan_state,0
	goto loop
	movlw b'00000100' ; 4
	movwf num
	incf cnt,f
	goto loop

prior3  ;;
	btfsc scan_state,1
	goto key5
	movlw b'00000011' ; 3
	movwf num
	incf cnt,f

	key5
	btfsc scan_state,0
	goto loop
	movlw b'00000101' ; 5
	movwf num
	incf cnt,f
	goto loop
    
    prior4  ;;
        btfsc scan_state,0
	goto loop
	movlw b'00000110' ; 6
	movwf num
	incf cnt
	goto loop
    
    back ;
	clrf index
	decfsz cnt,f
	goto non
	movf num,0
	return
	non
	    incfsz cnt,f
	    goto err
	    clrf num
	    movf num,w
	    return
	    err
		movlw ERR
		movwf num
		clrf cnt
		movf num,0
	    return


    delay  ;8ms/125kHz 
	movlw b'00010000' ; 50
	movwf delay_cnt2
	delay_loop2
	    movlw b'00011001' ; 25
	    movwf delay_cnt1
	delay_loop1
	    decfsz delay_cnt1
	    goto delay_loop1	
	    decfsz delay_cnt2
	    goto delay_loop2
	return

    table_cfg
	brw
	retlw b'11111111' ; 
	retlw b'11110111' ; 
	retlw b'11111011' ; 
	retlw b'11111101' ; 

get_type
	movwf cur_key
	movlw ERR
	xorwf cur_key,w ;cur_key==ERR?
	banksel STATUS
	btfsc STATUS,Z
	goto end_check
	movlw 0x0
	xorwf cur_key,w ;cur_key==0?
	btfsc STATUS,Z
	goto end_check
	movf prev_key,w
	xorwf cur_key,w 
	btfsc STATUS,Z
	goto branch1 ; cur_key==prev_key?
	goto branch2
branch1 ;yes, cur_key==prev_key
	movlw DOUBLE
	pagesel display_key
	call display_key
	pagesel close_t2
	call close_t2
branch11 
	pagesel get_safe
	call get_safe
	movwf tmp
	movf cur_key,w
	xorwf tmp,w
	banksel STATUS
	btfsc STATUS,Z
	goto branch11
	goto end_check
branch2 ;cur_key!=prev_key
	movlw 0x0
	xorwf prev_key,w ;prev_key==0?
	banksel STATUS
	btfsc STATUS,Z
	goto branch3  ;prev_key==0
	movlw ONCE
	movwf key_type
	movf prev_key,w
	movwf key_val
	clrf prev_key
	pagesel close_t2
	call close_t2
branch3 ; yes, prev_key=0
	pagesel open_t0
	call open_t0
branch4
	pagesel get_safe
	call get_safe
	movwf tmp
	movf cur_key,w
	xorwf tmp,w ;tmp==cur_key?
	banksel STATUS
	btfss STATUS,Z
	goto branch5
	movlw 0x1
	xorwf LONG_KEY,w
	btfsc STATUS,Z
	goto branch5
	goto branch4
branch5 ; No
	movlw 0x1
	xorwf LONG_KEY,w
	banksel STATUS
	btfsc STATUS,Z
	goto branch6  ; yes
branch7 ; LONG_KEY!=1
	pagesel close_t0
	call close_t0
	clrf timer0_cnt
	movlw 0x0
	xorwf tmp,w
	banksel STATUS
	btfsc STATUS,Z
	goto branch8 ;yes
branch9
	goto end_check
branch8
	pagesel open_t2
	call open_t2
	movf cur_key,w
	movwf prev_key
	goto end_check
branch6
	movlw LONG
	movwf key_type
	movf cur_key,w
	movwf key_val
	clrf LONG_KEY
branch10
	pagesel get_safe
	call get_safe
	movwf tmp
	movf cur_key,w
	xorwf tmp,w
	banksel STATUS
	btfsc STATUS,Z
	goto branch10
end_check	
	return

; key_type is in w	
display_key
	movwf key_type
	movf prev_key,w
	movwf key_val
	clrf prev_key
	return

close_t0
	banksel INTCON
	bcf INTCON,TMR0IE
	return

close_t2
	banksel PIE1
	bcf PIE1,TMR2IE
	banksel T2CON
	bcf T2CON,TMR2ON
	return
	
open_t0
	banksel TMR0
	clrf TMR0
	banksel INTCON
	bcf INTCON,TMR0IF
	bsf INTCON,TMR0IE
	clrf timer0_cnt
	return 

open_t2
	banksel PIR1
	bcf PIR1,TMR2IF
	banksel TMR2
	clrf TMR2
	banksel PIE1
	bsf PIE1,TMR2IE
	banksel T2CON
	bsf T2CON,TMR2ON
	return 
    END 
