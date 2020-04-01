#include <gassp72.h>

int tab[64];
int M2(int, unsigned short *);	
extern	unsigned short TabSig2[64];
int k ; 
int main(void)
{

for (k=0; k<64; k++){
	tab[k]=M2(k, TabSig2);
}

while (1) {
}
}
