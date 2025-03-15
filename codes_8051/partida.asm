org    0000h
jmp    partida_inicial

org    0003h
jmp    isrext0	;Desligar o motor

org    0013h	
jmp    isrext1	;Reversão do sentido de rotação

isrext0:
		setb P1.0
		setb P1.1
		setb P1.2
		setb P1.3
		reti

isrext1:
		cpl P1.0
		cpl P1.1
		reti

partida_inicial:
		jb P2.3, partida_inicial	;Aguarda  o operador acionar o botão para ligar o motor
        	jnb P2.3, $
		mov ie, #10000101b
        	mov tcon, #00000101b
		setb P2.4
		setb P2.5
		clr P1.2
		clr P1.0
		jnb P2.2, L ;primeiro bit low
		jb P2.2, H ;primeiro bit high

;Identificando o valor de entrada p2.2 p2.1 p2.0 do usuário e aplicando o respectivo intervalo
L:
		jnb P2.1, LL
		jb P2.1, LH
LL:
		jnb P2.0, LLL
		jb P2.0, LLH
LH:
		jnb P2.0, LHL
		jb P2.0, LHH

H:
		jnb P2.1, HL
		jb P2.1, HH
HL:
		jnb P2.0, HLL
		jb P2.0, HLH

HH:
		jnb P2.0, HHL
		jb P2.0, HHH
LLL:
		;ESPERA t1
		setb P1.2
		;delay de 100ms
		clr	P1.3
		jmp loop
HLL:
		;ESPERA t2
		setb P1.2
		;delay de 100ms
		clr	P1.3
		jmp loop

LHL:
		;ESPERA t3
		setb P1.2
		;delay de 100ms
		clr	P1.3
		jmp loop

HHL:
		;ESPERA t4
		setb P1.2
		;delay de 100ms
		clr	P1.3
		jmp loop

LLH:
		;ESPERA t5
		setb P1.2
		;delay de 100ms
		clr	P1.3
		jmp loop

HLH:
		;ESPERA t6
		setb P1.2
		;delay de 100ms
		clr	P1.3
		jmp loop
	
LHH:
		;ESPERA t7
		setb P1.2
		;delay de 100ms
		clr	P1.3
		jmp loop

HHH:
		;ESPERA t8
		nop
		nop
		nop
		setb P1.2
		;delay de 100ms
		clr	P1.3
		jmp loop

loop:
		jnb P2.5, desliga_motor
		jmp check_inversao

check_inversao:
		jnb P2.4, inverte_sentido
		jmp loop

desliga_motor:
		jnb P2.5, desliga_motor
		clr	P3.2
		setb P3.2
		jmp partida_inicial

inverte_sentido:
		jnb P2.4, inverte_sentido ;Aguarda o pulso de subida
		clr P3.3 ;ativa interrupção 1 
		; ESPERA 3 S       
		setb P3.3
		jmp loop

        end
