#include <gassp72.h>
#include "etat.h"

int M2(int, unsigned short *);	
unsigned short dma_buf[64]; 
int compteurs[6]={0,0,0,0,0,0};
int score[6] = {0};
int SYSTICK_PER = 5*72000; //5ms en ticks d'horloge à 72MHz
int M2TIR = 985661 ; 
extern	unsigned short TabSig[64];
int k ; 
int index_in ; 

//int max = -1000000000 ; 
//int min = 1000000000 ; 

extern void timer_callback(void);
#define tick_horloge	720000
extern short Son;
extern int LongueurSon;
extern int PeriodeSonMicroSec;
int resolution;
type_etat StructSon;


void sys_callback() {
	
	GPIO_Set(GPIOB, 1);
	
// Démarrage DMA pour 64 points
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	
	/* Calcul de la DFT pour les 6 fréquence avec un pas de Delta_f = 5 khz , k = 17 -> 85 kHz ...*/
	int dft ; 
	
	for( int k = 17 ; k<=24 ; k++) {
		dft = M2(k, dma_buf) ; 
		
		/* Test max/min pour montrer que la dft marche 
		if ( max < dft ) {
			max = dft ; 
		} else if (min > dft) {
			min = dft ; 
		}*/
		
		if (dft >= M2TIR){ // incrémentation chaque fois que M2(k) dépasse le seuil fixé M2TIR
			switch(k) {
                case 17:
                    compteurs[0]++;
										index_in = 0 ; 
                    break;
                case 18:
                    compteurs[1]++;
										index_in = 1 ; 
                    break;
                case 19:
                    compteurs[2]++;
										index_in = 2 ; 
                    break;
                case 20:
                    compteurs[3]++;
										index_in = 3 ; 
                    break;
                case 23:
                    compteurs[4]++;
										index_in = 4 ; 
                    break;
                case 24:
                    compteurs[5]++;
										index_in = 5 ; 
                    break;
							}
			
						}else {
			switch(k) {
                case 17:
                    compteurs[0]=0;
                    break;
                case 18:
                    compteurs[1]=0;
                    break;
                case 19:
                    compteurs[2]=0;
                    break;
                case 20:
                    compteurs[3]=0;
                    break;
                case 23:
                    compteurs[4]=0;
                    break;
                case 24:
                    compteurs[5]=0;
                    break;
				} 
		}
		GPIO_Clear(GPIOB, 1);
	}
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
	Init_TimingADC_ActiveADC_ff( ADC1, 0x43 );
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
	
	float Periode_PWM_en_Tck = 720000;
	
	
	StructSon.position=0;
	StructSon.taille=LongueurSon;
	StructSon.son=&Son;
	StructSon.periode_ticks=72*PeriodeSonMicroSec;
	
		// activation de la PLL qui multiplie la fréquence du quartz par 9
	CLOCK_Configure();
	// config port PB1 pour être utilisé en sortie
	GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
			StructSon.resolution = PWM_Init_ff( TIM3, 3, Periode_PWM_en_Tck );
	// initialisation du timer 4
	// Periode_en_Tck doit fournir la durée entre interruptions,
	// exprimée en périodes Tck de l'horloge principale du STM32 (72 MHz)
	Timer_1234_Init_ff( TIM4, StructSon.periode_ticks  );
	// enregistrement de la fonction de traitement de l'interruption timer
	// ici le 2 est la priorité, timer_callback est l'adresse de cette fonction, a créér en asm,
	// cette fonction doit être conforme à l'AAPCS
	Active_IT_Debordement_Timer( TIM4, 2, timer_callback );
	// lancement du timer
	Run_Timer( TIM4 );
		
	while	(1)
		{
			if(compteurs[index_in] == 1)
			{
				score[index_in]++;
				StructSon.position = 0;
			}
			else if (compteurs[index_in] == 0)
			{
				StructSon.position = -1;
			}

		}
}
