#include <gassp72.h>

int M2(int, unsigned short *);	
unsigned short dma_buf[64]; 
int compteur[6]={0,0,0,0,0,0};
int SYSTICK_PER = 5*72000; //5ms en ticks d'horloge à 72MHz
int M2TIR = 9 ; 
int led = 0 ; 
extern	unsigned short TabSig[64];
int k ; 

void sys_callback() {
	
	GPIO_Set(GPIOB, 1);
	
// Démarrage DMA pour 64 points
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	
	/* Calcul de la DFT pour les 6 fréquence avec un pas de Delta_f = 5 khz , k = 17 -> 85 kHz */
	int dft ; 
	for( int k = 0 ; k<=64 ; k++) {
		dft = M2(k, dma_buf) ; 
		if (dft >= M2TIR){ // incrémentation chaque fois que M2(k) dépasse le seuil fixé M2TIR
			
			switch(k) {
				case 17:
					compteur[0]++;
					break;
				case 18:
					compteur[1]++;
					break;
				case 19:
					compteur[2]++;
					break;
				case 20:
					compteur[3]++;
					break;
				case 23:
					compteur[4]++;
					break;
				case 24:
					compteur[5]++;
					break;
			}
			led = 1; 
		}
		else {
			compteur[k] = 0 ; // remise à zero 
		}
	}
	GPIO_Clear(GPIOB, 1);
}
	
	
	
	
int main(void)
{
			// activation de la PLL qui multiplie la fréquence du quartz par 9
	CLOCK_Configure();
	// PA2 (ADC voie 2) = entrée analog
	GPIO_Configure(GPIOA, 2, INPUT, ANALOG);
	// PB1 = sortie pour profilage à l'oscillo
	GPIO_Configure(GPIOB, 1, OUTPUT, OUTPUT_PPULL);
	// PB14 = sortie pour LED
	GPIO_Configure(GPIOB, 14, OUTPUT, OUTPUT_PPULL);

	// activation ADC, sampling time 1us
	Init_TimingADC_ActiveADC_ff( ADC1, 72 );
	Single_Channel_ADC( ADC1, 2 );
	// Déclenchement ADC par timer2, periode (72MHz/320kHz)ticks
	Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
	// Config DMA pour utilisation du buffer dma_buf (a créér)
	Init_ADC1_DMA1( 0, dma_buf );

	// Config Timer, période exprimée en périodes horloge CPU (72 MHz)
	Systick_Period_ff( SYSTICK_PER );
	// enregistrement de la fonction de traitement de l'interruption timer
	// ici le 3 est la priorité, sys_callback est l'adresse de cette fonction, a créér en C
	Systick_Prio_IT( 3, sys_callback );
	SysTick_On;
	SysTick_Enable_IT;
		
	while (1) {
		
		if(led) {
			GPIO_Set(GPIOB, 14); // Activation de la LED (câblée sur PB14)
			led = 0 ; 
		}
	}
}
