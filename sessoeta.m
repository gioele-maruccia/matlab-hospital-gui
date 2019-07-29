%Leggere i dati relativi a ASL e creare delle opportune variabili con
%contenuto
[codNosologico anno mese azErogante aslAssistito comAssistito sesso eta ricetta disciplinaErogatore prestazione numPrestazioni importo] = textread('ASL1_Regione1.txt','%s %d %d %s %s %s %s %d %d %d %s %d %f','delimiter','\t');

    %elimino righe con branche nulle
%     ind=find(ricetta==0);
%     eta(ind)=[];
%     cd_prat(ind)=[];
%     anno(ind)=[];
%     mese(ind)=[];
%     cd_azienda(ind)=[];
%     cd_asl(ind)=[];
%     cd_comune(ind)=[];
%     sesso(ind)=[];
%     branca(ind)=[];
%     disciplina(ind)=[];
%     cd_prest(ind)=[];
%     n_prest(ind)=[];
%     importo(ind)=[];
% 
%     %elimino righe con codici asl nulli
%     ind3=find(strcmp(cd_asl,''));
%     classe_eta(ind3)=[];
%     cd_prat(ind3)=[];
%     anno(ind3)=[];
%     mese(ind3)=[];
%     cd_azienda(ind3)=[];
%     cd_asl(ind3)=[];
%     cd_comune(ind3)=[];
%     sesso(ind3)=[];
%     branca(ind3)=[];
%     disciplina(ind3)=[];
%     cd_prest(ind3)=[];
%     n_prest(ind3)=[];
%     importo(ind3)=[];

%Contare il numero di pazienti maschi e femmine e creare relativo grafico 
contaM=length(find(strcmp(sesso,'M') | strcmp(sesso,'m')));
contaF=length(sesso)-contaM;
%Allego i grafici in un'unica figura
figure(1)
subplot(1,2,1)
PieMF=pie([contaM contaF]);
legend({'Maschi','Femmine'},'location','EastOutside');


%Creo il vettore eta1 uguale a eta ma senza elementi zero o maggiori delle
%classi possibili, conto il numero di persone per fascia di eta' e allegare grafico relativo
etaMin=1;
etaMax=22;
eta1=eta(eta>=etaMin & eta<=etaMax);
etaUnico=unique(eta1);
conta=zeros(1,etaMax);
for i=1:length(etaUnico)
    conta(i)=conta(i)+length(find(etaUnico(i)==eta1));
end
subplot(1,2,2)
barEta=bar([0:5:106],conta);
labels1={'0-5','6-10','11-15','16-20','21-25','26-30','31-35','36-40','41-45','46-50','51-55','56-60','61-65','66-70','71-75','76-80','81-85','86-90','91-95','96-100','101-105','>106'};
set(gca,'XTick',[0:5:106]);
set(gca,'XTickLabel',labels1);