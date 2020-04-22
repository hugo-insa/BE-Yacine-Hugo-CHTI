	thumb
		
	extern TabSin
	extern TabCos
	extern TabSig

	area  moncode, code, readonly 
	;export calcul_Reel 
	;export calcul_Imaginaire 
	export M2 
		
M2 proc 
	; r0 contient k
	; r1 contient @ de signal
	; r2 contient la partie Imaginaire 
	; r3 contient la partie Réel 

	push {LR, r0, r1,r7-r10} 
	ldr r2, =TabCos
	bl 	dft_reel_imaginaire
	mov r3, r0 ; Re dans r1
	pop {r0,r1}
	ldr r2, =TabSin
	bl 	dft_reel_imaginaire
	mov r2, r0 ; Im dans r2

	
	smull r7, r8,r3,r3 ; Re²
	smull r9,r10,r2,r2 ; Im²
	add r8,r10 ; Re²+Im²
	mov r0,r8
	pop {r7-r10}
	pop {LR}


	BX LR
	endp


; Pour ces fonctions, on va utiliser les registres compris entre R4 et R11 
; En effet, ces registres vont être utilisés comme stockage temporaire à condition de les push et pop avant le retour 
masque equ 0x3F ; pour faire un modulo 64

; ****************** Explications*******************************************************

;		r0 contient k
; 		r1 contient @Signal 
; 		r2 cotient TabCos ou TabSin
; 		r3 contient x(i) échantillon signal
; 		r4 contient cos(i*k) ou sin(i*k)
; 		r5 contient i*k
; 		r6 la somme des x(i)*cos(i*k) ou x(i)*sin(i*k)
; 		r7 contient x(i)*cos(i*k) ou x(i) * sin(i*k)
; 		r12 contient i


dft_reel_imaginaire proc
	push {r3-r7}
	mov r12, #0x00 									
	b	loop

loop

; A partir de la sauvegarde des adresses dans r2, on va pouvoir calculer la partie réelle  et imaginaire
	mul r5,r12,r0 ; 									i * k 
	and  r5, #masque ; 									i * k mod 64 
	
	ldrsh r4, [r2, r5, lsl #0x01] ; 					cos(i*k) | sin(i*k) 
	
	ldrsh r3, [r1,r12, lsl #0x01] ; 					x(i)
	
	mul r7,r3,r4 ; 										x(i)*cos(i*k)| x(i)*sin(i*k)

	
	
	add r6,r7 ; 										somme des x(i)*cos(ik) | x(i)*sin(ik)
	
	add r12, #0x01 ;									i=0 
	cmp r12,#64    ;                                    à i=64
	bne loop
	
	;													sinon on quitte la boucle 	
	mov r0,r6
	b fin
	


fin
	pop {r3-r7}
	bx lr
	endp 
	end
		