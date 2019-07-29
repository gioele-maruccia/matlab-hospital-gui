function varargout = farmacoCinetica(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @farmacoCinetica_OpeningFcn, ...
        'gui_OutputFcn',  @farmacoCinetica_OutputFcn, ...
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

function farmacoCinetica_OpeningFcn(hObject, eventdata, handles, varargin)
%% apertura farmacocinetica
    % sfondo per pulsante info
    bg_image = imread('img/infoFoto.png');
    set(handles.info,'CData',bg_image);
    % creo un axes che si estende per tutta la gui
    ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
    % importo l'immagine di background e la visualizzo sull'axes precedente
    bg = imread('img/homeground.jpg'); imagesc(bg);
    % controllo che l'immagine non si estenda oltre l'axes
    set(ah,'handlevisibility','off','visible','off');
    % porto l'immagine di background "dietro" tutti gli altri oggetti grafici
    % all'interno della gui
    uistack(ah, 'bottom');
    set(handles.popupPazienti,'Enable','off');
    set(handles.param,'Visible','off');
    set(handles.comp,'Visible','off');
    handles.output = hObject;
    guidata(hObject, handles);

function varargout = farmacoCinetica_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;

function popupPazienti_Callback(hObject, eventdata, handles)
%% popup di scelta dei pazienti
    set(handles.param,'Visible','on');
    set(handles.comp,'Visible','on');
    % recupero l'elemento selezionato nel popupmenu
    contenuto = get(handles.popupPazienti,'String');
    value = get(handles.popupPazienti,'Value'); % indice dell'elemento selezionato
    pazienteSel = str2double(contenuto(value));
    % cerco dove il paziente selezionato compare nei dati originari
    posizioniPazIesimo=find(pazienteSel == handles.paziente);
    % calcolo del paziente selezionato il vettore TEMPO e CONCENTRAZIONE
    % GLUCOSIO
    tempoPaziente = handles.tempo(posizioniPazIesimo)
    glucosioPaziente = handles.glucosio(posizioniPazIesimo);
    % fitting della funzione BGP, stando attenti a eliminare la
    % concentrazione di glucosio del paziente prima del trattamento
    [w ,res]=lsqcurvefit(@bgp,[20 1.7 3.4],tempoPaziente,glucosioPaziente-glucosioPaziente(1));
    global D;
    global V;
    global k;
    D=10000;
    % calcolo i parametri K02 = k(1) e k21=k(2), e il volume del
    % compartimento 2
    k(1)=w(2);
    k(2)=w(3);
    V=(D/w(1))*(k(2)/(k(2)-k(1)));
    
    
    % ricalcolo la funzione BGP con i parametri fittati
    y=bgp(w,0:0.1:5);
    
    set(handles.text2,'Visible','off');
    subplot(1,2,1)
    % grafico il fitting ottenuto sovrapponendo la simulazione ai dati
    plot(tempoPaziente,glucosioPaziente,'*',0:0.1:5,y+glucosioPaziente(1))
    set(gca, 'Position', [0.075 0.26 0.4 0.4])
    xlabel('TEMPO (hh)');
    ylabel('CONCENTRAZIONE (mg/dl)');
    % simulo il modello della ode23 usando i parametri k e come ingresso
    % iniziale D (iniezione)
    [t, q]=ode23(@comp,[0:0.1:4],[D 0]);
    subplot(1,2,2)
    % creo il grafico relativo alla simulazione
    %plot(t,q(:,1),'g',t,q(:,2),'r','LineWidth',2)
    plot(t,q(:,2)/V)
    % settaggio posizione grafico
    set(gca, 'Position', [0.55 0.26 0.4 0.4])
    % nome label assi
    xlabel('TEMPO (hh)');
    ylabel('CONCENTRAZIONE (mg/dl)');
    % creo legenda grafico
    legend('Compartimento 1','Compartimento 2');

function popupPazienti_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function pushBrowse_Callback(hObject, eventdata, handles)
%% caricamento file e aggiornamento menù a tendina dei pazienti
    [file path] = uigetfile('*.txt*');
    filepath = strcat(path, file);
    set(handles.editFile, 'String', filepath);
    try
        [handles.paziente handles.tempo handles.glucosio]=textread(filepath,'%d %.1f %.1f','headerlines',1,'delimiter',' ');
        pazienteUnico = unique(handles.paziente);
        % popolo menù di scelta dei pazienti
        set(handles.popupPazienti,'String',pazienteUnico);
        % abilito popup pazienti
        set(handles.popupPazienti,'Enable','on');
    catch
        % messaggio di errore in caso di fallito caricamento del file o di
        % errore nelle operazioni di lettura
        msgbox('File non presente o file errato!','ERRORE','error');
        %ritorno alla gui precedente
        close(gca);
        myFigure
    end
    % aggiornamento degli handles
    guidata(hObject, handles);

function indietro_Callback(hObject, eventdata, handles)
%% link a figura precedente
    close(farmacoCinetica);
    myFigure

function info_Callback(hObject, eventdata, handles)
 %% area informazioni
    helpdlg('Sei nell area farmacocinetica dedicata alla nostra asl; selezionando il file glucosio dell asl potrai scegliere lo specifico paziente e visualizzarne un grafico relativo alla simulazione compartimentale ed uno relativo ai parametri fittanti.',...
        'Area informazioni');

function screen_Callback(hObject, eventdata, handles)
    % salvo l immagine
    set(gcf, 'PaperPositionMode','auto')
    print -dtiff -r0 farmacoCinetica.tiff
        
