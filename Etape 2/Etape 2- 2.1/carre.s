	thumb 
	area moncode, code, readonly 
	
	import TabSin 
	import TabCos 
		
	export s_carre 
		
s_carre proc
	
	ldr r1, =TabSin 				; copie dans r1 , TabSin stockée en ROM
	ldr r2, =TabCos 				; copie dans r2 , TabSin stockée en ROM
	
	ldrsh r3, [r1,r0, lsl #0x01]    ; r4 contient la valeur de sin 
	ldrsh r12, [r2,r0, lsl #0x01]	; r5 contient la valeur de cos 
	
	mul r3, r3 
	mul r12, r12 
	
	add r3,r12
	
	mov r0,r3

	b 				fin
fin 
	bx 				lr 
	endp 
	end 
	
	
	