/***************  main.asm  *************************/
; CONFIG1
; __config 0xFFE7
 __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _CLKOUTEN_OFF & _IESO_ON & _FCMEN_ON
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _WRT_OFF & _VCAPEN_OFF & _PLLEN_ON & _STVREN_ON & _BORV_LO & _LPBOR_OFF & _LVP_ON 

RES_VECT  CODE    0x0000            ; processor reset vector
GOTO    START                        ; go to beginning of program 

MAIN_PROG CODE                      ; let linker place main program
START
    BANKSEL TRISA;
    CLRF TRISA;
    BANKSEL LATA;
  
    movlw 0x02
    movwf 0x22                           ; flag

l0  movlw 0xff
    movwf 0x20
l4  movlw 0xff
    movwf 0x21
l1  decfsz 0x21,1
    goto l1
    decfsz 0x20,1
    goto l4
    
    decfsz 0x22,1
    goto l2
   
    movlw b'00000010'
    movwf LATA;                           ; light on
    movlw 0x02
    movwf 0x22
    goto l0

l2  movlw b'00000000'           
    movwf LATA                            ; light off
    goto l0
    
    END
/*****************  END  ******************/
