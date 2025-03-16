org    0000h
jmp    partida_inicial

org    0003h
jmp    isrext0	;Desligar o motor

org    0013h	
jmp    isrext1	;Inverter o sentido de rotação

isrext0:
		setb P1.0
		setb P1.1
		setb P1.2
		setb P1.3
		mov R0, #06h
		acall delayN500ms; ESPERA 3 S
		reti

isrext1: 
		setb P1.0
		setb P1.1
		setb P1.2
		setb P1.3
		mov R0, #06h
		acall delayN500ms; ESPERA 3 S
		clr P1.2
		mov C, ACC.0
		mov P1.1, C		
		mov C, ACC.1		
		mov P1.0, C
		jmp tempo_comuta
		reti

partida_inicial:
		jb P2.3, partida_inicial	;Aguarda  o operador acionar o botão para ligar o motor
        fica1:
			jnb P2.3, fica1
		mov ie, #10000101b
        	mov tcon, #00000101b
		setb P2.4
		setb P2.5
		clr P1.2
		clr P1.0
tempo_comuta:
		jnb P2.2, L ;primeiro bit low
		jb P2.2, H

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
		mov R0, #02h
		acall	delayN500ms; ESPERA t0
		setb P1.2
		acall delay100ms;delay de 100ms
		clr	P1.3
		jmp loop

LLH:
		mov R0, #04h
		acall	delayN500ms; ESPERA t1
		setb P1.2
		acall delay100ms;delay de 100ms
		clr	P1.3
		jmp loop

LHL:
		mov R0, #06h
		acall	delayN500ms;ESPERA t2
		setb P1.2
		acall delay100ms;delay de 100ms
		clr	P1.3
		jmp loop

LHH:
		mov R0, #08h
		acall	delayN500ms;ESPERA t3
		setb P1.2
		acall delay100ms;delay de 100ms
		clr	P1.3
		jmp loop

HLL:
		mov R0, #0Ah
		acall	delayN500ms;ESPERA t4
		setb P1.2
		acall delay100ms;delay de 100ms
		clr	P1.3
		jmp loop

HLH:
		mov R0, #0Ch
		acall	delayN500ms;ESPERA t5
		setb P1.2
		acall delay100ms;delay de 100ms
		clr	P1.3
		jmp loop
	
HHL:
		mov R0, #0Eh
		acall	delayN500ms;ESPERA t6
		setb P1.2
		acall delay100ms;delay de 100ms
		clr	P1.3
		jmp loop

HHH:
		mov R0, #010h
		acall	delayN500ms;ESPERA t7
		nop
		nop
		nop
		setb P1.2
		acall delay100ms;delay de 100ms
		clr	P1.3
		jmp loop

loop:
		jnb P2.5, desliga_motor
		jnb P2.4, inverte_sentido
		jmp loop

desliga_motor:
		jnb P2.5, desliga_motor
		clr	P3.2
		setb P3.2
		jmp partida_inicial

inverte_sentido:
		jnb P2.4, inverte_sentido ;Aguarda o pulso de subida
		mov C, P1.0
		mov ACC.0, C		
		mov C, P1.1		
		mov ACC.1, C
		jmp isrext1
		jmp loop

delayN500ms: ;Nx500ms
	; N deve ser salvo em R0
	jmp aux0

aux0:                       ; daqui até djnz R1, aux1 gera aproximadamente 500ms de delay
	mov R1, #0FAh

aux1:
	mov	R2, #0F9h
	nop
	nop
	nop
	nop
	nop

aux2:
	nop
	nop
	nop
	nop
	nop
	nop

	djnz R2, aux2
	djnz R1, aux1           ; de aux0 até aqui gera aproximadamente 500ms de delay
	djnz R0, aux0
	
	ret


delay100ms: ;Nx100ms
	mov R3, #01h
	jmp aux3

aux3:                       ; daqui até djnz R1, aux1 gera aproximadamente 500ms de delay
	mov R1, #032h

aux4:
	mov	R2, #0F9h
	nop
	nop
	nop
	nop
	nop

aux5:
	nop
	nop
	nop
	nop
	nop
	nop

	djnz R2, aux5
	djnz R1, aux4           ; de aux0 até aqui gera aproximadamente 500ms de delay
	djnz R3, aux3
	
	ret

end






