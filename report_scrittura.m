%creo il report delle spese ospedaliere
function []=report_scrittura(osp,rimb_osp,degenza_osp,dimessi_osp,drg_osp)
%creo radice e il suo tag
asl=com.mathworks.xml.XMLUtils.createDocument('asl')
radice=asl.getDocumentElement
%creo l'attributo della radice
radice.setAttribute('codice_asl','70001')
%creo il primo figlio della radice
aziende_ospedaliere=asl.createElement('aziende_ospedaliere')
radice.appendChild(aziende_ospedaliere)
%ciclo per creare tutti gli attributi di ogni azienda_ospedaliera
for i=1:length(osp)
    azienda_ospedaliera(i)=asl.createElement('azienda_ospedaliera')
    aziende_ospedaliere.appendChild(azienda_ospedaliera(i))
    %inserisco gli attributi
    azienda_ospedaliera(i).setAttribute('codice_ospedale',osp{i})
    azienda_ospedaliera(i).setAttribute('rimborso_totale_ospedale',rimb_osp{i})
    azienda_ospedaliera(i).setAttribute('totale_giorni_degenza',degenza_osp{i})
    azienda_ospedaliera(i).setAttribute('totale_numero_dimessi',dimessi_osp{i})
    azienda_ospedaliera(i).setAttribute('numero_drg_effettuati',drg_osp{i})
end

    % stampo in un file il risultato del report
    a = xmlwrite(asl) ;
    fid = fopen('reportSpeseOsp.xml','w');
    fprintf(fid,'\n%s', a);
    fclose(fid);    
    
