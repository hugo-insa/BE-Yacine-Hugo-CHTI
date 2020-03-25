int tab[64];
int s_carre(int a);	
int max = 0 ; 
int min = 0x7ffffff ; 

int main(void)
{
	int b = 0 ; 
	for (int i=0;i<64;i++){
		b = s_carre(i) ; 
		
		if(b>max){
			max = b ; 
		}
		if(b<min){
			min = b ; 
		}
	}
	while (1) {
	
	}
} 
