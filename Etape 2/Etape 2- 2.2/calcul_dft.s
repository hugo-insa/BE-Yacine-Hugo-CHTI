	thumb
		
	extern TabSig

	area  moncode, code, readonly
	export calcul_preliminaire 
	;

; pour cette fonction, on va utiliser les registres compris entre R4 et R11 
; En effet, ces registres vont être utilisés comme stockage temporaire à condition de les push et pop avant le retour 

calcul_preliminaire proc 
	push {r6}
	push {r7} 
	push {r8}  
	push {r9}
	push {r10}
	mov r8,#0 							; cela va nous permettre de stocker la variable d'incrémentation "i" 
	mov r10,#0 							; on va utiliser ce registre pour sommer 
loop 	ldrsh r7, [r0,r8, LSL#1] 		; on sauvegarde x(i) 
	mul r9,r8,r1  						; r9 = r8 * r1 = i*k : index d'entrée dans les tables trigo
	and	r9, #0x3F 						; r9 = i*k mod N=64
	
	ldrsh r12, [r2,r9, LSL#1] 			; explication ci-dessous 
										; soit pour la partie réelle : cos(i*k*2pi/N)= tabcos(i*k mod N)
										; soit pour la partie imaginaire : sin(i*k*2pi/N)=tabsin(i*k mod N)
	mla r10, r7, r12, r10				; somme((x(i)*(tabcos(i*k mod N) ou tabsin(i*k mod N))): 
	
	add r8 , #1 						; i= 1
	cmp r8, #4 						; jusqu'à i = 64 
	blo loop 
	
	mov r0, r10
	pop{r10}
	pop{r9}
	pop{r8}
	pop{r7}
	pop{r6} 
	
fin bx lr 
	endp 
; 
	end 
	
	
	