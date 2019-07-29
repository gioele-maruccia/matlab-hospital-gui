function [] = leggo_regione(nomeXML)
    %creo il documento leggendo il file
    Documento=xmlread(nomeXML);
    %assegno una variabile alla radice del documento
    asl=Documento.getDocumentElement;
    %assegno variabili agli attributi e li converto in vettori di dcaratteri
    codiceJava=asl.getAttribute('codice_asl');
    codice_asl=codiceJava.toCharArray()';
    efficienzaJava=asl.getAttribute('efficienza');
    efficienza=efficienzaJava.toCharArray()';
    %recupero i sottoelementi di asl riferendomi al primo item
    %nasl=asl.item(0);
    %assegno una variabile ai figli della radice
    azienda_ospedaliera=asl.getElementsByTagName('azienda_ospedaliera');
    %conto quanti elementi di tipo azienda_ospedaliera ho
    num_aziende=azienda_ospedaliera.getLength();
    %ciclo su ogni elemento
    for i=1:num_aziende
        %recupero i sottoelementi dell'azienda iesima riferendomi al primo item
        %(i-1)
        naz=azienda_ospedaliera.item(i-1);
        %assegno variabili agli attributi e le converto in vettori di caratteri
        codiceJava=naz.getAttribute('codice_ospedale');
        codice_ospedale{i}=codiceJava.toCharArray()';
        icpJava=naz.getAttribute('icp');
        icp{i}=icpJava.toCharArray()';
        icmJava=naz.getAttribute('icm');
        icm{i}=icmJava.toCharArray()';
        %creo una variabile che contenga i figli di azienda_ospedaliera
        drg=naz.getElementsByTagName('drg');
        %conto quanti elementi di tipo sdo ho
        num_drg=drg.getLength();
        %ciclo su ogni elemento
        for j=1:num_drg
            %recupero i sottoelementi del drg jesimo riferendomi al primo item
            ndrg=drg.item(j-1);
            %assegno variabili agli attributi e le converto in caratteri
            codice_drgJava=ndrg.getAttribute('codice_drg');
            codice_drg{j,i}=codice_drgJava.toCharArray;
            DjJava=ndrg.getAttribute('Dj');
            Dj{j,i}=DjJava.toCharArray()';
            PjJava=ndrg.getAttribute('Pj');
            Pj{j,i}=PjJava.toCharArray()';
        end
    end
end