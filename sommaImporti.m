function vettoreImporti= sommaImporti(mese,importo)
%somma gli importi con mesi uguali
for i=1:12
    posizioniMeseIesimo=find(mese==i);
    vettoreImporti(i)=sum(importo(posizioniMeseIesimo));
end
    
    