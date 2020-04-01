	thumb 
	area moncode, code, readonly 
	import TabSin
	import TabCos 
		
	export carre 

carre proc 
	
	ldr r1, =TabSin 
	ldr r2, =TabCos 
	
	ldrsh r3, [r1,r0, lsl#0x01] 
	ldrsh r12, [r2,r0, lsl#0x01]
	
	mul r3,r3 
	mul r12,r12
	
	add r3,r12 
	
	mov r0,r3
	b 				fin 
fin
	bx 				lr 
	endp 
	end 