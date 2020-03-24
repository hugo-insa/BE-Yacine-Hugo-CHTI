	thumb
	
	extern TabSin
	extern TabCos
	extern TabSig
	import calcul_preliminaire
	
	
	area  moncode, code, readonly
	export somme_carre 
		
somme_carre proc
	push	{r4,r5,r6,lr}				;les arguments de la fonction : adresse de tabsig en r0, k en r1
	
; ************ Calcul de la partie réelle ********************* 
	ldr r2, =TabCos  				; on récupère l'adresse de Tabcos 
	mov r4, r0 
	bl calcul_preliminaire 
	mov r5, r0 						; on a la partie réelle 
	mul r5, r5, r5                    ; on stocke la partie réelle au carré 
	
; ************ Calcul de la partie imaginaire********************* 	
	ldr r2, =TabSin 
	mov r4, r0 
	bl calcul_preliminaire 
	mov r6, r0         				; on a la partie imaginaire 
	mul r6, r6,r6					; on stocke la partie imaginaire au carré 
	
	
; ***************** Addition**************************************

	add r5,r6                   ;  Re(k)² + Im(k)² 
	mov r0,r5						   ; on garde les 32 bits de poids forts de la multiplication dans r0
	
fin	pop {r4,r5,r6,pc}				;dernière instruction de la fonction
	endp
;
	end
	
	
	
	
	
	