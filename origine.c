int somma_pari(char *st, int d)
{ int i,somma;
somma=0;
for(i=0;i<d;i++)
if(st[i]%2==0)
somma++;
return somma;
}
main() {
char ST[16];
int i,cnt;
for(i=0;i<2;i++){
printf("Inserisci una stringa di numeri)\n");
scanf("%s",ST);
cnt=somma_pari(ST,strlen(ST));
printf(" Numero= %d \n",cnt);
}
}
