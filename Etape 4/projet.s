; ce programme est pour l'assembleur RealView (Keil)
	thumb
	
	include etat.inc 
	extern StructSon 

TIM3_CCR3	equ	0x4000043C	; adresse registre PWM
	
	area mesdata, data , readwrite
	
	area  moncode, code, readonly
	export timer_callback
	
timer_callback	proc
	ldr r0,=StructSon ; 
	ldr r1, [r0, #E_POS] ; 
	ldr r2, [r0, #E_TAI] ; 
	ldr r3, =TIM3_CCR3;
	add r2,#1 ; 
	cmp r1, r2 ; 
	BEQ Silence ; 
	
; sinon 
	push {r4-r8} ; 
	ldr r4, [r0,#E_SON] ; 
	ldrsh r4, [r4,r1,LSL #1] ; 
	
	add r4, #0x8000;
	ldr r5, [r0, #E_RES] ; 
	mul r4,r5 ; 
	lsr r4, #0x10 ; 
	
	str r4,[r3] ; 
	add r1,#1 ; 
	str r1,[r0,#E_POS] ; 
	b Test
	 	
Silence 
	mov r2, #0
	str r2,[r3] 
	
Test
	pop{pc}
	endp 
	end 
		
end 
; N.B. le registre BSRR est write-only, on ne peut pas le relire