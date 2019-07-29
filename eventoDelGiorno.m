%compongo la data prendendo i valori dalle popupAnno e popupMese
set(handles.pushElimina,'Visible','on');
set(handles.listbox1,'Visible','on');
set(handles.listbox1,'Enable','off');
set(handles.listbox1,'String',' ');
meseScelto = handles.meseScelto;
annoScelto = handles.anno;
giornoScelto = handles.giorno;
mesi ={'Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno','Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'};
for i=1:12
    if strcmp(mesi{i},meseScelto)
        salvai = i;
    end
end
dataConc = strcat(handles.giorno,'-',handles.stringaMesi{salvai},'-',annoScelto);

[dateTime testo] = textread('eventi.txt','%s %s','delimiter','_');
j=0;
  for i=1:length(dateTime)
      if strcmp(dataConc,dateTime{i})
          j=j+1;
          myEventi{j} = testo{i};
      end
  end
  if(j~=0)
      set(handles.listbox1,'Enable','on');
     set(handles.listbox1,'String',myEventi);
  else
      set(handles.listbox1,'String','NO EVENTI');
  end

%set(handles.text2,'String',testo)