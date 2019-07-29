% scriviSuFile l'evento appena scritto
meseScelto = handles.meseScelto;
annoScelto = handles.anno;
giornoScelto = handles.giorno
mesi ={'Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno','Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'};
for i=1:12
    if strcmp(mesi{i},meseScelto)
        salvai = i;
    end
end
dataConc = strcat(handles.giorno,'-',handles.stringaMesi{salvai},'-',annoScelto);
perFile = strcat(dataConc,'_',testoScritto);
fid = fopen('eventi.txt','a');
    fprintf(fid,'\n%s', perFile);
fclose(fid);

