function [Max Min totale ricetta_unica]=statisticaAslCom(assistito, ricetta)
%lista degli assistiti e delle branche ricetta presi una sola volta
assistito_unico=unique(assistito);
ricetta_unica=unique(ricetta);
%seleziono un assistito alla volta e calcolo quante volte utilizza ogni branca
%ricetta
for i=1:length(assistito_unico)
    %vettore con le posizioni dell'assistito iesimo nel vettore assistito
   assistito_iesimo=find(strcmp(assistito_unico{i},assistito));
   for j=1:length(ricetta_unica)
       %vettore che contiene quante volte e` utilizzata la branca jesima dall'assistito iesimo 
        conta(j)=length(find(ricetta(assistito_iesimo)==ricetta_unica(j)));
   end
   %calcolo branche piu` e meno utilizzate
    [MAX_val inM(i)]=max(conta);
    [MIN_val inm(i)]=min(conta);
    totale{i}=conta;
    Max(i)=ricetta_unica(inM(i));
    Min(i)=ricetta_unica(inm(i));
    
    %grafico
    figure(5+i)
    barBranca1=bar(totale{i});
    set(gca,'XTick',[1:length(ricetta_unica)]);
    set(gca,'XTickLabel',ricetta_unica);
    
end
