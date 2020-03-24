	thumb
	
	extern TabSin
	extern TabCos
	extern TabSig
	import calcul_preliminaire
	
	
	area  moncode, code, readonly
	export somme_carre 
		
somme_carre proc
	push	{r4,r5,r6,lr}				;les arguments de la fonction : adresse de tabsig en r0, k en r1
	
; ************ Calcul de la partie r�elle ********************* 
	ldr r2, =TabCos  				; on r�cup�re l'adresse de Tabcos 
	mov r4, r0 
	bl calcul_preliminaire 
	mov r5, r0 						; on a la partie r�elle 
	mul r5, r5, r5                    ; on stocke la partie r�elle au carr� 
	
; ************ Calcul de la partie imaginaire********************* 	
	ldr r2, =TabSin 
	mov r4, r0 
	bl calcul_preliminaire 
	mov r6, r0         				; on a la partie imaginaire 
	mul r6, r6,r6					; on stocke la partie imaginaire au carr� 
	
	
; ***************** Addition**************************************

	add r5,r6                   ;  Re(k)� + Im(k)� 
	mov r0,r5						   ; on garde les 32 bits de poids forts de la multiplication dans r0
	
fin	pop {r4,r5,r6,pc}				;derni�re instruction de la fonction
	endp
;
	end
	
	
	
	
	
	