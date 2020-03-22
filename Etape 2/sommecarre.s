	thumb
		
	extern TabSin
	extern TabCos
	extern TabSig
	import re_im

	area  moncode, code, readonly
	export M2
;
M2 proc
	push	{r4,r5,lr}				;les arguments de la fonction : adresse de tabsig en r0, k en r1
	ldr r2, =TabCos
	mov	r4,r0					;on sauve l'adresse du signal
	bl	re_im 					;on calcule la partie réelle de la dft et on la met dans r0
	mov r5,r0 					;on garde la valeur de la partie réelle
	ldr r2, =TabSin
	mov r0,r4					;on remet l'adresse du tableau dans r0 pour l'appel de la fonction. PS: r1 n'est pas modifié par dft du coup on a pas besoin de le re-load
	bl	re_im 					;calcul de la dft imaginaire
	SMULL r2, r3, r0, r0 		;on met au carré les deux morceaux de la dft
	SMLAL	r2, r3, r5, r5
	mov r0, r3					;on garde les 32 bits de poids forts de la multiplication dans r0
fin	pop {r4,r5,pc}				;dernière instruction de la fonction
	endp
;
	end