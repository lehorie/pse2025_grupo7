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
		jb	P2.3, partida_inicial	;Aguarda  o operador acionar o botão para ligar o motor
        	jnb	P2.3, $
		mov	ie, #10000101b
       		mov	tcon, #00000101b
		cpl 	P1.0
		cpl 	P1.2
		setb 	P2.4
		setb 	P2.5

loop:
		jnb 	P2.5, desliga_motor
		jmp 	check_inversao

check_inversao:
		jnb 	P2.4, inverte_sentido
		jmp 	loop

desliga_motor:
		jnb 	P2.5, desliga_motor
		clr	P3.2
		setb 	P3.2
		jmp 	partida_inicial

inverte_sentido:
		jnb 	P2.4, inverte_sentido ;Aguarda o pulso de subida
		clr 	P3.3 ;ativa interrupção 1        
		setb 	P3.3
		jmp 	loop

        	end
