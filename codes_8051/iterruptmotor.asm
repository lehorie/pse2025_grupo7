org    0000h
jmp    inicio

org    0003h
jmp    isrext0	;Desligar o motor

org    0013h	
jmp    isrext1	;Reversão do sentido de rotação

isrext0:
        rl      a
        mov     P0, a
        reti

isrext1:
        rr      a
        mov     P0, a
        reti

inicio:
		jb		P2.3, inicio	;Aguarda  o operador acionar o botão para ligar o motor
        jnb		P2.3, $
		mov     a, #10000101b
        mov     ie, a
        mov     a, #00h
        mov     ip, a
        mov     a, #00000101b
        mov     tcon, a
		mov     a, #00h
		cpl P1.0
		cpl P1.2
		
        jmp    $

        end