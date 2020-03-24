#include <gassp72.h>

unsigned int somme_carre(short *,int);
int i=0;
int dft;
extern short TabSig;
int tabdft[64];

int main(void)
{

for(i=1;i<64;i++){
	
tabdft[i] =somme_carre(&TabSig, i);
}
	while(1) {}
}
