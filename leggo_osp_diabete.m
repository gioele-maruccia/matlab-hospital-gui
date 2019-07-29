function [codice_paziente,A,a,b,codice_ospedale]=leggo_osp_diabete(nomeXML)
%creo il documento leggendo il file
Documento=xmlread(nomeXML);
%assegno una variabile alla radice del documento
diabete_mellito=Documento.getDocumentElement;
%assegno una variabile al primo attributo di diabete_mellito
codJava=diabete_mellito.getAttribute('codice_ospedale');
%converto la variabile in un vettore di char e ne faccio la trasposta, per
%ottenere una stringa orizzontale
codice_ospedale=codJava.toCharArray()';
%ripeto l'operazione per oggetto
oggJava=diabete_mellito.getAttribute('oggetto');
oggetto=oggJava.toCharArray()';
%creo una variabile che contiene gli elementi figli della radice
pazienti=diabete_mellito.getElementsByTagName('pazienti');
%recupero i sottoelementi di pazienti riferendomi al primo item
elenco_pazienti=pazienti.item(0);
%creo una variabile che contenga i figli di pazienti (uso
%elenco_pazienti perchè ogni specifico sottoalbero viene identificato
%dalla proprietà item e l'indice corrispondente)
paziente=elenco_pazienti.getElementsByTagName('paziente');
%conto quanti elementi di tipo paziente ho
num_pazienti=paziente.getLength();
%ciclo sul numero di pazienti per estarne gli attributi e\o elementi
for i=1:num_pazienti
    %recupero i sottoelementi del paziente iesimo riferendomi al primo
    %item (uso (i-1) perchè Java parte da 0 e matlab da 1)
    npaz=paziente.item(i-1);
    %assegno una variabile all'attributo di paziente e la converto in un
    %vettore di caratteri
    codpazJava=npaz.getAttribute('codice_paziente');
    codice_paziente{i}=codpazJava.toCharArray()';
    %creo variabili che contengano i figli di pazienti 
    Apaz=npaz.getElementsByTagName('A');
    apaz=npaz.getElementsByTagName('a');
    bpaz=npaz.getElementsByTagName('b');
    %recupero i sottoelementi della prima variabile riferendomi al primo
    %item (0 perchè ho una sola A per paziente)
    nA=Apaz.item(0);
    %recupero gli elementi testuali di A
    A{1,i}=char(nA.item(0).getData);
    %ripeto l'operazione per a e b
    na=apaz.item(0);
    a{1,i}=char(na.item(0).getData);
    nb=bpaz.item(0);
    b{1,i}=char(nb.item(0).getData);
end
    