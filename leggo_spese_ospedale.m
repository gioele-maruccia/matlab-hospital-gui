function [codice_ospedale,rimborso_totale_previsto,giornate_degenza_d,num_prestazioni,codice_drg_d,modalita_di_dimissione_s]=leggo_spese_ospedale(nomeXML)

%creo il documento leggendo il file
Documento=xmlread(nomeXML);
%assegno una variabile alla radice del documento
azienda_ospedaliera=Documento.getDocumentElement;
%assegno una variabile all'attributo codice_ospedale
azJava=azienda_ospedaliera.getAttribute('codice_ospedale');
%converto la variabile in un vettore di char e ne faccio la trasposta per
%ottenere una stringa orizzontale
codice_ospedale=azJava.toCharArray()';
%assegno una variabile al figlio della radice
prestazioni=azienda_ospedaliera.getElementsByTagName('prestazioni');
%recupero i sottoelementi di prestazioni riferendomi al primo item
elenco_prestazioni=prestazioni.item(0);
%assegno una variabile all'attributo di prestazioni
rimbJava=elenco_prestazioni.getAttribute('rimborso_totale_previsto');
%converto la variabile in un vettore di char e lo traspongo
rimborso_totale_previsto=rimbJava.toCharArray()';
%creo una variabile che contenga i figli di prestazioni (uso
%elenco_prestazioni perchè ogni specifico sottoalbero viene identificato
%dalla proprietà item e l'indice corrispondente)
prestazione=elenco_prestazioni.getElementsByTagName('prestazione');
%conto quanti elementi di tipo prestazione ho
num_prestazioni = prestazione.getLength();
%ciclo su ogni elemento per estrarne attributi e\o elementi
for i=1:num_prestazioni
    %recupero i sottoelementi della prestazione iesima riferendomi al primo
    %item (uso (i-1) perchè Java parte da 0 e matlab da 1)
    nprest=prestazione.item(i-1);
    %assegno variabili agli attributi e le converto in vettori di caratteri
    codice_nosologicoJava=nprest.getAttribute('codice_nosologico');
    codice_nosologico_p{i}=codice_nosologicoJava.toCharArray()';
    regime_ricoveroJava=nprest.getAttribute('regime_ricovero');
    regime_ricovero_p{i}=regime_ricoveroJava.toCharArray()';
    modalita_accessoJava=nprest.getAttribute('modalita_accesso');
    modalita_accesso_p{i}=modalita_accessoJava.toCharArray()';
    provenienzaJava=nprest.getAttribute('provenienza');
    provenienza_p{i}=provenienzaJava.toCharArray()';
    comune_residenzaJava=nprest.getAttribute('comune_residenza');
    comune_residenza_p{i}=comune_residenzaJava.toCharArray()';
    %creo una variabile che contenga il primo figlio di prestazione
    sdo=nprest.getElementsByTagName('sdo');
    %recupero i sottoelementi di sdo riferendomi al primo item (0 perchè ho
    %una sola sdo per prestazione)
    nsdo=sdo.item(0);
    %assegno variabili agli attributi e le converto in vettori di caratteri
    etaJava=nsdo.getAttribute('eta');
    eta_s{1,i}=etaJava.toCharArray()';
    sessoJava=nsdo.getAttribute('sesso');
    sesso_s{1,i}=sessoJava.toCharArray()';
    diagnosi_principaleJava=nsdo.getAttribute('diagnosi_principale');
    diagnosi_principale_s{1,i}=diagnosi_principaleJava.toCharArray()';
    diagnosi_concomitante_1Java=nsdo.getAttribute('diagnosi_concomitante_1');
    diagnosi_concomitante_1_s{1,i}=diagnosi_concomitante_1Java.toCharArray()';
    diagnosi_concomitante_2Java=nsdo.getAttribute('diagnosi_concomitante_2');
    diagnosi_concomitante_2_s{1,i}=diagnosi_concomitante_2Java.toCharArray()';
    diagnosi_concomitante_3Java=nsdo.getAttribute('diagnosi_concomitante_3');
    diagnosi_concomitante_3_s{1,i}=diagnosi_concomitante_3Java.toCharArray()';
    diagnosi_concomitante_4Java=nsdo.getAttribute('diagnosi_concomitante_4');
    diagnosi_concomitante_4_s{1,i}=diagnosi_concomitante_4Java.toCharArray()';
    intervento_principaleJava=nsdo.getAttribute('intervento_principale');
    intervento_principale_s{1,i}=intervento_principaleJava.toCharArray()';
    intervento_secondario_1Java=nsdo.getAttribute('intervento_secondario_1');
    intervento_secondario_1_s{1,i}=intervento_secondario_1Java.toCharArray()';
    intervento_secondario_2Java=nsdo.getAttribute('intervento_secondario_2');
    intervento_secondario_2_s{1,i}=intervento_secondario_2Java.toCharArray()';
    intervento_secondario_3Java=nsdo.getAttribute('intervento_secondario_3');
    intervento_secondario_3_s{1,i}=intervento_secondario_3Java.toCharArray()';
    intervento_secondario_4Java=nsdo.getAttribute('intervento_secondario_4');
    intervento_secondario_4_s{1,i}=intervento_secondario_4Java.toCharArray()';
    modalita_di_dimissioneJava=nsdo.getAttribute('modalita_di_dimissione');
    modalita_di_dimissione_s{1,i}=modalita_di_dimissioneJava.toCharArray()';
    %creo una variabile che contenga il secondo figlio di prestazione
    dati_drg=nprest.getElementsByTagName('dati_drg');
    %recupero i sottoelementi di elenco_drg riferendomi al primo item
    elenco_drg=dati_drg.item(0);
    %assegno variabili agli attributi e le converto in vettori di caratteri
    codice_drgJava=elenco_drg.getAttribute('codice_drg');
    codice_drg_d{1,i}=codice_drgJava.toCharArray()';
    importoJava=elenco_drg.getAttribute('importo');
    importo_d{1,i}=importoJava.toCharArray()';
    giornate_degenzaJava=elenco_drg.getAttribute('giornate_degenza');
    giornate_degenza_d{1,i}=giornate_degenzaJava.toCharArray()';
end