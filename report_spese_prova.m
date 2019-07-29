%nomeXML vettore che contiene i nomi dei singoli report
nomeXML(1)={'esempio_ospedale.xml'};
nomeXML(2)={'esempio_ospedale2.xml'};
% codici_ospedali=zeros(1,length(nomeXML));
% rimborsi_totali=zeros(1,length(nomeXML));
% giornate_degenza=zeros(1,length(nomeXML));
% num_prestazioni=zeros(1,length(nomeXML));
% codici_drg=zeros(1,length
for i=1:length(nomeXML)
    [codice_ospedale,rimborso_totale_previsto,giornate_degenza_d,num_prestazioni,codice_drg_d,modalita_di_dimissione_s]=leggo_spese_ospedale(nomeXML{i});
    for j=1:length(giornate_degenza_d)
        A(j)=str2num(giornate_degenza_d{j});
        dimessi(j)=str2num(modalita_di_dimissione_s{j});
    end
    giornate_degenza{i}=num2str(sum(A));
    codici_ospedali{i}=codice_ospedale;
    rimborsi_totali{i}=rimborso_totale_previsto;

    
    numeri_dimessi{i}=num2str(length(find(dimessi>2)));
    codici_drg{i}=num2str(num_prestazioni);
end
report_scrittura(codici_ospedali,rimborsi_totali,giornate_degenza,numeri_dimessi,codici_drg)
    
