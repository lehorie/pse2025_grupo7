org 00h

	init:
		mov P1,#0FFh
		jnb p2.0, start
		jmp init

	start:
		mov P1,#07Fh
		jmp wait

	wait:
		jnb P2.1, rotate
		jnb P2.2, fill_up
		jb P2.0, init; verificate if the machine was turned off
		jmp wait
		
	rotate:
		jnb P1.0, ring_buffer
		
		setb c
		mov A, P1
		rrc 	A
		mov P1, A

		sjmp not_ovf
		ring_buffer: mov P1, #07Fh
		
		not_ovf:

		wait_btn: jb P2.0, init; verificate if the machine was turned off
		jb P2.1, wait
		SJMP wait_btn

		fill_up: 
		jb P2.0, init; verificate if the machine was turned off

	jmp wait
end