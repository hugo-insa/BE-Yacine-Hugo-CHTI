#include <gassp72.h>

//unsigned int somme_carre(short *,int);

//int dft;
extern int TabSig2;
extern int TabCos;
extern int TabSin;
//int tabdft[17];
int resultat[17];
int somme_carre(int*,int);
int main(void)
{

	int k;
	for(k=1;k<17;k++){
		//tabdft[i] =somme_carre(&TabSig, i);
		resultat[k]=somme_carre(&TabSig2,k+1);
}
	while(1) {}
}
