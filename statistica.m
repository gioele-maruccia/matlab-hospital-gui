% statistica : calcolo valori statistici su branca ricetta
% input : <ricetta> , output :<max min conta ricettaUnica>
function [Max Min conta ricettaUnica]=statistica(ricetta)
%controllo validità ricetta < 26
ricetta1=ricetta(ricetta>0 & ricetta<=26);
%prendo tutte le ricette una volta
ricettaUnica=unique(ricetta1);
conta=zeros(1,length(ricettaUnica));
%conto quante volte e` utilizzata una ricetta
for i=1:length(ricettaUnica)
    conta(i)=length(find(ricettaUnica(i)==ricetta1));
end
[Max inM]=max(conta);
[Min inm]=min(conta);