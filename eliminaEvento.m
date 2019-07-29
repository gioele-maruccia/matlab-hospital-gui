%elimina un evento
[dateTime testo] = textread('eventi.txt','%s %s','delimiter','_');
  for i=1:length(testo)
      if strcmp(handles.eliminaElemento,testo{i})
          iDaEliminare = i;
      end
  end
  %riscrivo il file eventi.txt senza l'evento da eliminare
      fid = fopen('eventi.txt','w');
    for i=1:length(testo)
               if strcmp(testo{i},testo{iDaEliminare})==0 
                   disp('ciao')
                   perFile = strcat(dateTime{i},'_',testo{i})
                 if i==1
                     fprintf(fid,'%s', perFile);
                    else
                     fprintf(fid,'\n%s',perFile);
                 end
              end
      end
  