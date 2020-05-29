;  ce programme est pour l'assembleur RealView (Keil)
	thumb
	
	include etat.inc
		
	extern StructSon
	extern Position
	
TIM3_CCR3	equ	0x4000043C	; adresse registre PWM

	area  moncode, code, readonly
	export timer_callback
;
timer_callback	proc
	ldr r0,=StructSon			; on charge l'adressse de la structure son
	ldr r1, =TIM3_CCR3			; on met l'adresse du registre de PWM dans r3 
	ldr r2,[r0] 				; on r�cup�re la position actuelle 
	ldr r3,[r0, #E_TAI]			; on r�cup�re la taille de notre �chantillon 
	cmp r2,r3 					; on continue si position < taille
	bhs silence 				; on quitte le programme si on est � la fin 
	
; sinon 
	push {r4,r5}                ; on push les registres r4 et r5 
	ldr r4, [r0,#E_SON]			; on charge notre �chantillon dans le registre r4 
	ldrsh r12 ,[r4, r2, LSL #1] ; on acc�de � l'�chantillon actuel 
	
; Avant d'�tre envoy� au modulateur d'impulsions, chaque �chantillon devra :
;	- �tre additionn� d'une composante continue telle que sa valeur soit toujours positive (entre 0 et 2^16 - 1) : (1) 
; 	- �tre multipli� par un facteur d'�chelle tel que sa valeur soit inf�rieure � la pleine �chelle du modulateur ou "r�solution". (2)
; 	- Cette r�solution est rendue par la fonction d'initialisation du modulateur PWM (elle est inf�rieure � 2^16) (3) 

	add r12, #0x8000           ; correspond au premier crit�re que notre valeur soit toujours positive avec choix comme composante : 32768 ( qui est la moiti� l'intervalle [0,2^16 -1]			
	ldr r5, [r0, #E_RES]	   ; on d�termine la r�solution et on l'affecte au registre r5
	mul r12,r5				   ; on effectue la multiplication de la r�solution pr�cedemment d�termin�e avec notre �chantillon respectant le (1) 
	lsr r12,#16 			   ; division par 2^16 
	
	; transmission 
	add r2,#1 				   ; on ajoute pour mettre � jour la position 
	str r2,[r0]                ; on stocke la nouvelle position dans la structure son
	str r12,[r1] 			   ; on stocke l'�chantillon modifi� dans le registre PWM 
	pop {r5,r4};			   ; on lib�re la m�moire utilis�e pour les registres r4 et r5 
	b	fin
	
silence ldr r12, [r0, #E_RES]  ; on charge la structure 
		lsr r12, #1            ; division par 2^1 
		str r12,[r1]           ; on stocke r12 dans le registre de PWM 
		B fin
		
fin	bx	lr	; derni�re instruction de la fonction
	endp
;
	end