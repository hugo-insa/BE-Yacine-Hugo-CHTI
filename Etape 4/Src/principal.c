#include <gassp72.h>
#include "etat.h"

extern void timer_callback(void);
#define tick_horloge	720000
extern short Son;
extern int LongueurSon;
extern int PeriodeSonMicroSec;
int resolution;
type_etat StructSon;

int main(void)
{
	StructSon.position=0;
	StructSon.taille=LongueurSon;
	StructSon.son=&Son;
	StructSon.periode_ticks=72*PeriodeSonMicroSec;
	
	float Periode_PWM_en_Tck = 720000;
	
	
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
	}
}
