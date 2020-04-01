#include <gassp72.h>

int tab[64];
int M2(int, unsigned short *);	
extern	unsigned short TabSig2[64];
int k ; 
int Re[64] ; 
int Im[64]; 
extern unsigned short calcul_Reel(int, unsigned short *) ; 
extern unsigned short calcul_Imaginaire(int, unsigned short *) ; 
int main(void)
{

for (k=0; k<64; k++){
	Re[k] = calcul_Reel(k,TabSig2) ; 
	Im[k]= calcul_Imaginaire(k,TabSig2) ; 
	tab[k]=M2(k, TabSig2);
}

while (1) {
}
}
