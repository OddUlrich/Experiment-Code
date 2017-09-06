#include "p16F1786.inc"

; CONFIG1
; __config 0xFFE4
 __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _CLKOUTEN_OFF & _IESO_ON & _FCMEN_ON
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _WRT_OFF & _VCAPEN_OFF & _PLLEN_ON & _STVREN_ON & _BORV_LO & _LPBOR_OFF & _LVP_ON

    ;udata_shr
    ;RST code 0000h
                                ;pagesel main
    GPR_VAR UDATA
	freq res 1
    RES_VECT CODE 0000h
    goto START
    ISR CODE  0004h
    ;; check if it is a timer2 interrupt
    banksel PIR1
    btfss PIR1,1
    goto l1
	bcf PIR1,1
	decfsz 0x70,f
	goto l2


	banksel freq
        movf freq,w
        movwf 0x70
	banksel LATA
	comf LATA,f
    goto l2

    ;; check if it is an IOC
 l1 
    banksel IOCBF
    btfss IOCBF,4
    goto l2 
    banksel IOCBF

    movlw 0xff
    xorwf IOCBF,w
    andwf IOCBF,f         ;RB1
    banksel freq
    comf freq
 l2 retfie

    MAIN_PROG CODE
    START

    banksel freq
    movlw 0xfa
    movwf freq
    
    banksel ANSELB 
    clrf ANSELB 
    banksel IOCBP
    movlw b'00010000';0xff
    movwf IOCBP   
    ;; clear flag
    banksel IOCBF
    clrf IOCBF

    ;; 初始化端口
    banksel TRISA
    clrf TRISA
    bsf PIE1,1 ; TMR2IE匹配中断允许位
    banksel LATA
    clrf LATA
    banksel TRISB
    bsf TRISB,4
    banksel LATB
    clrf LATB
    banksel INTCON
    bsf INTCON,3  ; IOCIE
    bsf INTCON,6  ; 外部
    bsf INTCON,7  ; GIE全局
   
    ;; 打开timer2
    banksel T2CON
    bsf T2CON,2
    ;; 设置前分频1:1
    bcf T2CON,0
    bcf T2CON,1
    ;; 设置后分频1:1
    bcf T2CON,3
    bcf T2CON,4
    bcf T2CON,5
    bcf T2CON,6
    ;; 设置比较值
    banksel PR2
    ;movlw b'11111010'; 250
    movlw b'11111001'; 250 ；249
    movwf PR2

    ;; 延迟0.5s
    ;; 初始化TMR2IF1
    ;; 循环计数器，注意是0.5s延迟
    movlw b'11111010'; 250
    ;movlw b'00000010'
    movwf 0x70
    clrf TMR2

    banksel PIR1
    bcf PIR1,1
    
loop  nop
      goto loop
   
    end
