function varargout = calendario(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @calendario_OpeningFcn, ...
        'gui_OutputFcn',  @calendario_OutputFcn, ...
        'gui_LayoutFcn',  [] , ...
        'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end

function calendario_OpeningFcn(hObject, eventdata, handles, varargin)
%% posiziono tutti i pulsanti, imposto l'immagine di background,

% sfondo per pulsante info
    bg_image = imread('img/infoFoto.png');
    set(handles.info,'CData',bg_image);
    
    set(handles.pushbutton01,'Position', [38 35 17 8])
    set(handles.pushbutton02,'Position', [56 35 17 8])
    set(handles.pushbutton03,'Position', [74 35 17 8])
    set(handles.pushbutton04,'Position', [92 35 17 8])
    set(handles.pushbutton05,'Position', [110 35 17 8])
    set(handles.pushbutton06,'Position', [128 35 17 8])
    set(handles.pushbutton07,'Position', [146 35 17 8])
    set(handles.pushbutton08,'Position', [164 35 17 8])
    set(handles.pushbutton09,'Position', [38 26 17 8])
    set(handles.pushbutton10,'Position', [56 26 17 8])
    set(handles.pushbutton11,'Position', [74 26 17 8])
    set(handles.pushbutton12,'Position', [92 26 17 8])
    set(handles.pushbutton13,'Position', [110 26 17 8])
    set(handles.pushbutton14,'Position', [128 26 17 8])
    set(handles.pushbutton15,'Position', [146 26 17 8])
    set(handles.pushbutton16,'Position', [164 26 17 8])
    set(handles.pushbutton17,'Position', [38 17 17 8])
    set(handles.pushbutton18,'Position', [56 17 17 8])
    set(handles.pushbutton19,'Position', [74 17 17 8])
    set(handles.pushbutton20,'Position', [92 17 17 8])
    set(handles.pushbutton21,'Position', [110 17 17 8])
    set(handles.pushbutton22,'Position', [128 17 17 8])
    set(handles.pushbutton23,'Position', [146 17 17 8])
    set(handles.pushbutton24,'Position', [164 17 17 8])
    set(handles.pushbutton25,'Position', [38 8 17 8])
    set(handles.pushbutton26,'Position', [56 8 17 8])
    set(handles.pushbutton27,'Position', [74 8 17 8])
    set(handles.pushbutton28,'Position', [92 8 17 8])
    set(handles.pushbutton29,'Position', [110 8 17 8])
    set(handles.pushbutton30,'Position', [128 8 17 8])
    set(handles.pushbutton31,'Position', [146 8 17 8])
    % creo un axes che si estende per tutta la gui
    ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
    % importo l'immagine di background e la visualizzo sull'axes precedente
    bg = imread('img/homeground.jpg'); imagesc(bg);
    % controllo che l'immagine non si estenda oltre l'axes
    set(ah,'handlevisibility','off','visible','off');
    % porto l'immagine di background "dietro" tutti gli altri oggetti grafici
    % all'interno della gui
    uistack(ah, 'bottom');
    % nascondo l'axes che conteerrà l'albero di natale
    set(handles.buoneFeste,'Visible','off');
    % prelevo tipo utente e non permetto al normale utente di aggiungere o eliminare eventi
    tipoUtente = getappdata(0,'passoTipo')
    if(tipoUtente == 1)
        set(handles.edit1,'Visible','off');
        set(handles.pushInserisci,'Visible','off');
    end
    % creo vettore mesi da inserire nel popupMese, stessa cosa per gli anni
    mesi ={'Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno','Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'};
    anni = {'2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024'};
    set(handles.popupMese,'String', mesi);
    set(handles.popupAnno,'String',anni);
    % data attuale
    dateNow = datestr(clock,0);
    % ricavo l'anno
    annoNow = dateNow(8:11);
    %setto l'anno attuale come anno di default
    set(handles.popupAnno, 'Value', str2num(annoNow)-2013) ; 
    contenuto = get(handles.popupAnno,'String');
    value = get(handles.popupAnno,'Value');
    handles.anno = contenuto{value};
    meseNow =dateNow(4:6);
    % stringa mesi è utile perchè la data odierna presa dal pc è nel
    % formato gg-'mese'-hhhh ; con 'mese' scritto in inglese
    handles.stringaMesi={'Jan','Feb','Mar','Apr','May','June','July','Aug','Sept','Oct','Nov','Dec'};
    %ricavo l'indice corrispondente al mese attuale per poter settare la
    %listbox
    %setto il mese attuale come default
    for i=1:12
        if strcmp(handles.stringaMesi{i},meseNow)
            salvai =i;
        end
    end
    set(handles.popupMese,'Value',salvai);
    contenutoMese = get(handles.popupMese,'String');
    valueMese = get(handles.popupMese,'Value');
    handles.meseScelto = contenutoMese{valueMese};
    handles.giorno = '01';
    if (strcmp(contenuto{value},annoNow) && strcmp(handles.stringaMesi{salvai},meseNow))
        coloraToday
    end
    set(handles.pushElimina,'Visible','off');
    set(handles.listbox1,'Visible','off');
    set(handles.pushElimina,'Enable','off');
    handles.output = hObject;
    colorEventDate
    handles.numVolte = 0;
    % aggiorno gli handles
    guidata(hObject, handles);

function varargout = calendario_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;

function pushbutton01_Callback(hObject, eventdata, handles)
%% la funzione eventoDelGiorno controlla nel file eventi.txt se alla data selezionata corrisponde un evento, se si lo visualizza sulla textbox superiore, 
% uguale per tutti e 31 i bottoni
    handles.giorno = '01';
    eventoDelGiorno;
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton02_Callback(hObject, eventdata, handles)
    handles.giorno = '02';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton03_Callback(hObject, eventdata, handles)
    handles.giorno ='03';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton04_Callback(hObject, eventdata, handles)
    handles.giorno = '04';
    eventoDelGiorno    set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton05_Callback(hObject, eventdata, handles)
    handles.giorno = '05';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton06_Callback(hObject, eventdata, handles)
    handles.giorno = '06';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton07_Callback(hObject, eventdata, handles)
    handles.giorno = '07';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton08_Callback(hObject, eventdata, handles)
    handles.giorno = '08';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton09_Callback(hObject, eventdata, handles)
    handles.giorno = '09';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton10_Callback(hObject, eventdata, handles)
    handles.giorno = '10';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton11_Callback(hObject, eventdata, handles)
    handles.giorno = '11';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton12_Callback(hObject, eventdata, handles)
    handles.giorno = '12';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton13_Callback(hObject, eventdata, handles)
    handles.giorno = '13';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton14_Callback(hObject, eventdata, handles)
    handles.giorno = '14';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton15_Callback(hObject, eventdata, handles)
    handles.giorno = '15';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton16_Callback(hObject, eventdata, handles)
    handles.giorno = '16';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton17_Callback(hObject, eventdata, handles)
    handles.giorno = '17';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton18_Callback(hObject, eventdata, handles)
    handles.giorno = '18';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton19_Callback(hObject, eventdata, handles)
    handles.giorno = '19';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton20_Callback(hObject, eventdata, handles)
    handles.giorno = '20';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton21_Callback(hObject, eventdata, handles)
    handles.giorno = '21';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton22_Callback(hObject, eventdata, handles)
    handles.giorno = '22';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton23_Callback(hObject, eventdata, handles)
    handles.giorno = '23';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton24_Callback(hObject, eventdata, handles)
    handles.giorno = '24';
    eventoDelGiorno
    set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton25_Callback(hObject, eventdata, handles)
    handles.giorno = '25';
    eventoDelGiorno
    handles.meseScelto
    % se viene cliccato il 25 dicembre viene mostrato a video un albero di
    % natale 
    if strcmp(handles.meseScelto,'Dicembre')
        voce('Buon natale!!!', 'Alice');
        set(handles.textFeste,'Visible','off');
        set(handles.buoneFeste,'Visible','on');
        axes(handles.buoneFeste)
        r = 1.0;
        h = 2.0;
        m = h/r;
        [R,A] = meshgrid(linspace(0,r,11),linspace(0,2*pi,41));
        X1 = R .* cos(A);
        Y1 = R .* sin(A);
        Z1 = -m*R;
        X2=X1(1:5:end);
        Y2=Y1(1:5:end);
        Z2=Z1(1:5:end);
        for k=1:5
            surf(X1*(k*0.1+1),Y1*(k*0.1+1),Z1-k-1); hold on;
            scatter3(reshape(X2*(k*0.1+1),1,numel(X2)),...
                reshape(Y2*(k*0.1+1),1,numel(Y2)),...
                reshape(Z2-k-+0.1,1,numel(Z2)),ones(1,numel(X2))*30,...
                randn(1,numel(X2)),'filled');
        end
        handles.numVolte = handles.numVolte +1;
        vettColori = {'hsv','hot','gray','bone','copper','pink','white','flag','lines','colorcube','vga','jet','prism','cool','autumn','spring','winter'};
                indACaso = round(1+14*rand(1))
        if handles.numVolte == 1
            colormap('summer');
        else
            colormap(vettColori{indACaso})
        end
        % direzione di provenienza della luce
        camlight('right');
        axis equal
        grid off

    end
    set(handles.buoneFeste,'Visible','off');
    guidata(hObject, handles);

function pushbutton26_Callback(hObject, eventdata, handles)
    handles.giorno = '26';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton27_Callback(hObject, eventdata, handles)
    handles.giorno = '27';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton28_Callback(hObject, eventdata, handles)
    handles.giorno = '28';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton29_Callback(hObject, eventdata, handles)
    handles.giorno = '29';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton30_Callback(hObject, eventdata, handles)
    handles.giorno = '30';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function pushbutton31_Callback(hObject, eventdata, handles)
    handles.giorno = '31';
    eventoDelGiorno
        set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    guidata(hObject, handles);

function popupMese_Callback(hObject, eventdata, handles)
    %% imposto, in base al mese, i pulsanti(giorni) da visualizzare; e nel casi in cui l'anno sia bisestile febbraio avrà 29 giorni anzichè 28
    set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    
    contenuto = get(handles.popupMese,'String');
    handles.valueMese = get(handles.popupMese,'Value');
    handles.meseScelto = contenuto{handles.valueMese}
    eventoDelGiorno
    %si occupa di colorare il giorno se corrisponde al giorno attuale
    dateNow = datestr(clock,0);
    meseNow =dateNow(4:6);
    annoNow = dateNow(8:11);
    for i=1:12
        if strcmp(handles.stringaMesi{i},meseNow)
            salvai =i;
        end
    end
    if (strcmp(handles.anno,annoNow) && strcmp(handles.stringaMesi{salvai},handles.stringaMesi{handles.valueMese}))
        coloraToday
    else
        scolora
    end
    switch(handles.valueMese)
        case 1
            set(handles.pushbutton28,'Visible','on')
            set(handles.pushbutton29,'Visible','on')
            set(handles.pushbutton30,'Visible','on')
            set(handles.pushbutton31,'Visible','on')
        case 2
            %controllo che l 'anno non sia bisestile
            bisestile = 0
            if mod(str2num(handles.anno),400)==0 || (mod(str2num(handles.anno),100)~=0  && mod(str2num(handles.anno),4)==0)
                bisestile = 1;
            end
            if bisestile==0
                set(handles.pushbutton29,'Visible','off')
            else
                set(handles.pushbutton29,'Visible','on');
            end
            set(handles.pushbutton30,'Visible','off')
            set(handles.pushbutton31,'Visible','off')
        case 3
            set(handles.pushbutton28,'Visible','on')
            set(handles.pushbutton29,'Visible','on')
            set(handles.pushbutton30,'Visible','on')
            set(handles.pushbutton31,'Visible','on')
        case 4
            set(handles.pushbutton28,'Visible','on')
            set(handles.pushbutton29,'Visible','on')
            set(handles.pushbutton30,'Visible','on')
            set(handles.pushbutton31,'Visible','off')
        case 5
            set(handles.pushbutton28,'Visible','on')
            set(handles.pushbutton29,'Visible','on')
            set(handles.pushbutton30,'Visible','on')
            set(handles.pushbutton31,'Visible','on')
        case 6
            set(handles.pushbutton28,'Visible','on')
            set(handles.pushbutton29,'Visible','on')
            set(handles.pushbutton30,'Visible','on')
            set(handles.pushbutton31,'Visible','off')
        case 7
            set(handles.pushbutton28,'Visible','on')
            set(handles.pushbutton29,'Visible','on')
            set(handles.pushbutton30,'Visible','on')
            set(handles.pushbutton31,'Visible','on')
        case 8
            set(handles.pushbutton28,'Visible','on')
            set(handles.pushbutton29,'Visible','on')
            set(handles.pushbutton30,'Visible','on')
            set(handles.pushbutton31,'Visible','on')
        case 9
            set(handles.pushbutton28,'Visible','on')
            set(handles.pushbutton29,'Visible','on')
            set(handles.pushbutton30,'Visible','on')
            set(handles.pushbutton31,'Visible','off')
        case 10
            set(handles.pushbutton28,'Visible','on')
            set(handles.pushbutton29,'Visible','on')
            set(handles.pushbutton30,'Visible','on')
            set(handles.pushbutton31,'Visible','on')
        case 11
            set(handles.pushbutton28,'Visible','on')
            set(handles.pushbutton29,'Visible','on')
            set(handles.pushbutton30,'Visible','on')
            set(handles.pushbutton31,'Visible','off')
        case 12
            set(handles.pushbutton28,'Visible','on')
            set(handles.pushbutton29,'Visible','on')
            set(handles.pushbutton30,'Visible','on')
            set(handles.pushbutton31,'VIsible','on')
    end
    scoloraTutti
    colorEventDate
    guidata(hObject, handles);

function popupMese_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function popupAnno_Callback(hObject, eventdata, handles)
    set(allchild(handles.buoneFeste),'Visible','off');
    set(handles.buoneFeste,'visible','off');
    
    eventoDelGiorno
    contenutoAnno = get(handles.popupAnno,'String');
    valueAnno = get(handles.popupAnno,'Value');
    handles.anno = contenutoAnno{valueAnno}
    % si occupa di colorare il giorno se corrisponde al giorno attuale
    dateNow = datestr(clock,0);
    meseNow =dateNow(4:6);
    annoNow = dateNow(8:11);
    for i=1:12
        if strcmp(handles.stringaMesi{i},meseNow)
            salvai =i;
        end
    end
    if (strcmp(handles.anno,annoNow) && strcmp(handles.stringaMesi{salvai},handles.stringaMesi{handles.valueMese}))
        %disp('ciao')
        coloraToday
    else
        scolora
    end
    contenutoMese = get(handles.popupMese,'String');
    handles.valueMese = get(handles.popupMese,'Value')
    switch(handles.valueMese)
        case 1
            set(handles.pushbutton28,'Visible','on')
            set(handles.pushbutton29,'Visible','on')
            set(handles.pushbutton30,'Visible','on')
            set(handles.pushbutton31,'Visible','on')
        case 2
            %controllo che l 'anno non sia bisestile
            bisestile = 0
            if mod(str2num(handles.anno),400)==0 || (mod(str2num(handles.anno),100)~=0  && mod(str2num(handles.anno),4)==0)
                bisestile = 1;
            end
            if bisestile==0
                set(handles.pushbutton29,'Visible','off')
            else
                set(handles.pushbutton29,'Visible','on');
            end
            set(handles.pushbutton30,'Visible','off');
            set(handles.pushbutton31,'Visible','off');
        case 3
            set(handles.pushbutton28,'Visible','on');
            set(handles.pushbutton29,'Visible','on');
            set(handles.pushbutton30,'Visible','on');
            set(handles.pushbutton31,'Visible','on');
        case 4
            set(handles.pushbutton28,'Visible','on');
            set(handles.pushbutton29,'Visible','on');
            set(handles.pushbutton30,'Visible','on');
            set(handles.pushbutton31,'Visible','off');
        case 5
            set(handles.pushbutton28,'Visible','on');
            set(handles.pushbutton29,'Visible','on');
            set(handles.pushbutton30,'Visible','on');
            set(handles.pushbutton31,'Visible','on');
        case 6
            set(handles.pushbutton28,'Visible','on');
            set(handles.pushbutton29,'Visible','on');
            set(handles.pushbutton30,'Visible','on');
            set(handles.pushbutton31,'Visible','off');
        case 7
            set(handles.pushbutton28,'Visible','on');
            set(handles.pushbutton29,'Visible','on');
            set(handles.pushbutton30,'Visible','on');
            set(handles.pushbutton31,'Visible','on');
        case 8
            set(handles.pushbutton28,'Visible','on');
            set(handles.pushbutton29,'Visible','on');
            set(handles.pushbutton30,'Visible','on');
            set(handles.pushbutton31,'Visible','on');
        case 9
            set(handles.pushbutton28,'Visible','on');
            set(handles.pushbutton29,'Visible','on');
            set(handles.pushbutton30,'Visible','on');
            set(handles.pushbutton31,'Visible','off');
        case 10
            set(handles.pushbutton28,'Visible','on');
            set(handles.pushbutton29,'Visible','on');
            set(handles.pushbutton30,'Visible','on');
            set(handles.pushbutton31,'Visible','on');
        case 11
            set(handles.pushbutton28,'Visible','on');
            set(handles.pushbutton29,'Visible','on');
            set(handles.pushbutton30,'Visible','on');
            set(handles.pushbutton31,'Visible','off');
        case 12
            set(handles.pushbutton28,'Visible','on');
            set(handles.pushbutton29,'Visible','on');
            set(handles.pushbutton30,'Visible','on');
            set(handles.pushbutton31,'Visible','on');
    end
    colorEventDate
    guidata(hObject,handles);

function popupAnno_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function listbox1_Callback(hObject, eventdata, handles)
    contenutoBox = get(handles.listbox1,'String');
    indiceBox = get(handles.listbox1,'Value');
    handles.eliminaElemento = contenutoBox{indiceBox};
    % una volta selezionato l'evento abilito il pulsante ELIMINA
        tipoUtente = getappdata(0,'passoTipo')

        if(tipoUtente == 1)
            set(handles.pushElimina,'Visible','off');
        else
            set(handles.pushElimina,'Enable','on');
        end
    guidata(hObject,handles);

function listbox1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function pushElimina_Callback(hObject, eventdata, handles)
    % utilizzo la funzione eliminaEvento per eliminare l'evento selezionato
    eliminaEvento
    close(calendario);
    calendario

function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function pushInserisci_Callback(hObject, eventdata, handles)
    testoScritto = get(handles.edit1,'String')
        scriviSuFile
        %close(calendario);
        calendario

function buoneFeste_CreateFcn(hObject, eventdata, handles)
%% axes che conterrà l'albero di natale


function info_Callback(hObject, eventdata, handles)
helpdlg('Sei nella pagina calendario, il giorno di colore giallo corrisponde alla data odierna, quelli di colore verde hanno in registro un evento. Per aggiungere un evento cliccare su un giorno, dopodiche inserire l evento nella textEdit in basso, per poi cliccare <inserisci>. Per eliminare un evento selezionare il giorno con un evento registrato, selezionare l evento nella listbox dopodichè cliccare su <elimina>',...
        'Area informazioni');
