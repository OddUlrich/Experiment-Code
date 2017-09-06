#include <p16f1786.inc>

; CONFIG1
; __config 0xFFE4
 __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _CLKOUTEN_OFF & _IESO_ON & _FCMEN_ON
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _WRT_OFF & _VCAPEN_OFF & _PLLEN_ON & _STVREN_ON & _BORV_LO & _LPBOR_OFF & _LVP_ON

    udata_shr
    RST code 0x0
    pagesel main
    goto main

    code
    main
    banksel TRISA
    clrf TRISA
    banksel PORTA
    clrf PORTA

    banksel PR2
    movlw 0xf9
    movwf PR2
    
    banksel T2CON
    bsf T2CON,2
    bcf T2CON,0
    bcf T2CON,1
    bcf T2CON,3
    bcf T2CON,4
    bcf T2CON,5
    bcf T2CON,6
    
l0  movlw 0xfa
    movwf 0x70

l2  nop
    bcf PIR1,1
l1  btfss PIR1,1
    goto l1
    decfsz 0x70,f
    goto l2
    
movlw b'11111111'
    banksel PORTA
    movwf PORTA
    movlw 0xfa
    movwf 0x70

l3  nop
    bcf PIR1,1
l4  btfss PIR1,1
    goto l4
    decfsz 0x70,f
    goto l3

    banksel PORTA
    clrf PORTA
    goto l0
    end
