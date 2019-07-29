nomeXML{1}='esempio_osp_diabete.xml';
media=zeros(1,3);
for j=1:length(nomeXML)
    [codice_paziente,A,a,b,codice_ospedale{j}]=leggo_osp_diabete(nomeXML{j});
    [media_parametri_cinetici,deviazione_standard]=calcolo_osp_dati(A,a,b);
    media=media+media_parametri_cinetici;
    MEDIA{j}=[num2str(media_parametri_cinetici(1)),',',num2str(media_parametri_cinetici(2)),',',num2str(media_parametri_cinetici(3))];
    STD{j}=[num2str(deviazione_standard(1)),',',num2str(deviazione_standard(2)),',',num2str(deviazione_standard(3))];
end
media_tot=media./length(nomeXML);
media_k(1)=media_tot(2);
media_k(2)=media_tot(3);
%ricavo i parametri dei miei pazienti
[paziente tempo glucosio]=textread('glucosio_asl_1_Regione1.txt','%s %.1f %.1f','headerlines',1,'delimiter',' ');
lista_pazienti=unique(paziente);
for j=1:length(lista_pazienti)
    posizione_paz_iesimo=find(strcmp(lista_pazienti{j},paziente));
    tempo_paziente=tempo(posizione_paz_iesimo);
    glucosio_paziente=glucosio(posizione_paz_iesimo);
    
    [w ,res]=lsqcurvefit(@bgp,[25 0.05 0.1],tempo_paziente,glucosio_paziente-glucosio_paziente(1));
    parametriW{j}=w;
    prametriK{j}=[w(2) w(3)];
     % k(1)=w(2);
     % k(2)=w(3);
end
scrivo_diabete(codice_ospedale,MEDIA,STD,lista_pazienti,parametriW);
