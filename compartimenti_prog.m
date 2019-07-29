[paziente tempo glucosio]=textread('glucosio_asl_1_Regione1.txt','%d %.1f %.1f','headerlines',1,'delimiter',' ');
lista_pazienti=unique(paziente);
for i=1:length(lista_pazienti)
    figure(i)
    posizione_paz_iesimo=find(lista_pazienti(i)==paziente);
    tempo_paziente=tempo(posizione_paz_iesimo);
    glucosio_paziente=glucosio(posizione_paz_iesimo);
    [w ,res]=lsqcurvefit(@bgp,[20 1.73.4],tempo_paziente,glucosio_paziente-glucosio_paziente(1));
    global D;
    global V;
    global k;
    D=10000;
    k(1)=w(2);
    k(2)=w(3);
    V=(D/w(1))*(k(2)/(k(2)-k(1)));
    y=bgp(w,0:0.1:5);
    K{i}=k;
    [t, q]=ode23(@comp,[0:0.1:4],[D 0]);
    %plot(t,q(:,1),'g',t,q(:,2),'r')
    plot(tempo_paziente,glucosio_paziente,'*',0:0.1:5,y+glucosio_paziente(1))
end



