#include <gassp72.h>

unsigned int M2(short *,int);
int i=0;
int dft;
extern short TabSig;
int tabdft[64];

int main(void)
{

for(i=1;i<64;i++){
	
tabdft[i] = M2(&TabSig, i);
}
	while(1) {}
}