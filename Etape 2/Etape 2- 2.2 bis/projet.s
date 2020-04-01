; ce programme est pour l'assembleur RealView (Keil)
	thumb
		
	export 	FLAG  
	area mesdata, data , readwrite
FLAG DCD 0; 
	area  moncode, code, readonly
	export timer_callback
GPIOB_BSRR	equ 0x40010C10
	
timer_callback	proc

	ldr r0,=FLAG ; adresse du flag
	ldr		r2,[r0] ; valeur du flag
	cbz		r2,si_alors
	b sinon
	
si_alors ; mise à 1
	ldr	r3, =GPIOB_BSRR
	mov	r1, #0x00000002;mise à 1
	str	r1, [r3]
	mov	r2, #0x1
	str	r2,	[r0]
	b fin
sinon ; mise à 0
	ldr	r3, =GPIOB_BSRR
	mov	r1, #0x00020000
	str	r1, [r3]
	mov	r2,	#0x0
	str	r2,	[r0]
	
fin	
	bx	lr
	endp
	end
; N.B. le registre BSRR est write-only, on ne peut pas le relire