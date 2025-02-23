org 00h

	mov p0, #0FFh
	mov p0, #0Fh
	mov a, #00h
main: 
	jnb P2.2, statechange
	jmp main

statechange:
	jb acc.0, statea
	jnb acc.0, stateb

statea:
	jnb P2.2, statea
	mov p0, #0Fh
	mov a, #00h
	jmp main

stateb: 
	jnb P2.2, stateb
	mov p0, #0F0h
	mov a, #0FFh
	jmp main

end
