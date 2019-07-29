%colorEventDate, questo script colora i pulsanti che hanno registrato un
%evento

meseScelto = handles.meseScelto;
annoScelto = handles.anno;
mesi ={'Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno','Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'};

[dateTime testo] = textread('eventi.txt','%s %s','delimiter','_');
for giorno=01:31
    for i=1:12
        if strcmp(mesi{i},meseScelto)
            salvai = i;
        end
    end
    if giorno<10
        giornoStr =strcat('0',num2str(giorno));
    else
        giornoStr = num2str(giorno);
    end
    dataConc = strcat(giornoStr,'-',handles.stringaMesi{salvai},'-',annoScelto);
    for j=1:length(dateTime)
        if(strcmp(dateTime{j},dataConc))
            switch giorno
                case 1
                    set(handles.pushbutton01,'background',[0.3 0.9 0.1]);
                case 2
                    set(handles.pushbutton02,'background',[0.3 0.9 0.1]);
                case 3
                    set(handles.pushbutton03,'background',[0.3 0.9 0.1]);
                case 4
                    set(handles.pushbutton04,'background',[0.3 0.9 0.1]);
                case 5
                    set(handles.pushbutton05,'background',[0.3 0.9 0.1]);
                case 6
                    set(handles.pushbutton06,'background',[0.3 0.9 0.1]);
                case 7
                    set(handles.pushbutton07,'background',[0.3 0.9 0.1]);
                case 8
                    set(handles.pushbutton08,'background',[0.3 0.9 0.1]);
                case 9
                    set(handles.pushbutton09,'background',[0.3 0.9 0.1]);
                case 10
                    set(handles.pushbutton10,'background',[0.3 0.9 0.1]);
                case 11
                    set(handles.pushbutton11,'background',[0.3 0.9 0.1]);
                case 12
                    set(handles.pushbutton12,'background',[0.3 0.9 0.1]);
                case 13
                    set(handles.pushbutton13,'background',[0.3 0.9 0.1]);
                case 14
                    set(handles.pushbutton14,'background',[0.3 0.9 0.1]);
                case 15
                    set(handles.pushbutton15,'background',[0.3 0.9 0.1]);
                case 16
                    set(handles.pushbutton16,'background',[0.3 0.9 0.1]);
                case 17
                    set(handles.pushbutton17,'background',[0.3 0.9 0.1]);
                case 18
                    set(handles.pushbutton18,'background',[0.3 0.9 0.1]);
                case 19
                    set(handles.pushbutton19,'background',[0.3 0.9 0.1]);
                case 20
                    set(handles.pushbutton20,'background',[0.3 0.9 0.1]);
                case 21
                    set(handles.pushbutton21,'background',[0.3 0.9 0.1]);
                case 22
                    set(handles.pushbutton22,'background',[0.3 0.9 0.1]);
                case 23
                    set(handles.pushbutton23,'background',[0.3 0.9 0.1]);
                case 24
                    set(handles.pushbutton24,'background',[0.3 0.9 0.1]);
                case 25
                    set(handles.pushbutton25,'background',[0.3 0.9 0.1]);
                case 26 
                    set(handles.pushbutton26,'background',[0.3 0.9 0.1]);
                case 27
                    set(handles.pushbutton27,'background',[0.3 0.9 0.1]);
                case 28
                    set(handles.pushbutton28,'background',[0.3 0.9 0.1]);
                case 29
                    set(handles.pushbutton29,'background',[0.3 0.9 0.1]);
                case 30
                    set(handles.pushbutton30,'background',[0.3 0.9 0.1]);
                case 31
                    set(handles.pushbutton31,'background',[0.3 0.9 0.1]);
            end
                

                    
        end
    end
end
