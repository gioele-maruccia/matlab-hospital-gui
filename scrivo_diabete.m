function []=scrivo_diabete(codice_osp,media,dev_standard,cod_paz,w)
% creo la radice e il suo tag e allego gli attributi
diabete_mellito=com.mathworks.xml.XMLUtils.createDocument('diabete_mellito');
radice=diabete_mellito.getDocumentElement;
radice.setAttribute('codice_asl','70001');
% creo due elementi figli di radice
aziende_ospedaliere=diabete_mellito.createElement('aziende_ospedaliere');
ambulatori=diabete_mellito.createElement('ambulatori');
radice.appendChild(aziende_ospedaliere);
radice.appendChild(ambulatori);
% ciclo per poter riempire ogni azienda ospedalieri con i relativi
% attributi
for i=1:length(codice_osp)
    azienda_ospedaliera(i)=diabete_mellito.createElement('azienda_ospedaliera');
    aziende_ospedaliere.appendChild(azienda_ospedaliera(i));
    azienda_ospedaliera(i).setAttribute('codice_ospedale',codice_osp{i});
    azienda_ospedaliera(i).setAttribute('media_parametri_cinetici',media{i});
    azienda_ospedaliera(i).setAttribute('deviazione_standard',dev_standard{i});
end
% creo e appendo un nuovo figlio a ambulatori
pazienti=diabete_mellito.createElement('pazienti');
ambulatori.appendChild(pazienti);
% ciclo per riempire ogni paziente con i relativi figli e attributi
for j=1:length(cod_paz)
    paziente(j)=diabete_mellito.createElement('paziente');
    % creo l'attributo a paziente
    pazienti.appendChild(paziente(j));
    % creo tre elementi figli dei relativi parametri e li riempio con dei
    % PCData ossia dei testi
    paziente(j).setAttribute('codice_paziente',(cod_paz{j}));
    A(j)=diabete_mellito.createElement('A');
    a(j)=diabete_mellito.createElement('a');
    b(j)=diabete_mellito.createElement('b');
    paziente(j).appendChild(A(j));
    paziente(j).appendChild(a(j));
    paziente(j).appendChild(b(j));
    var=w{j};
    newtextA=diabete_mellito.createTextNode(num2str(var(1)));
    newtexta=diabete_mellito.createTextNode(num2str(var(2)));
    newtextb=diabete_mellito.createTextNode(num2str(var(3)));
    A(j).appendChild(newtextA);
    a(j).appendChild(newtexta);
    b(j).appendChild(newtextb);
    
end
fileDaScrivere = xmlwrite(diabete_mellito);
global fileDaScrivere;




