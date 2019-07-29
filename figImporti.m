function varargout = figImporti(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @figImporti_OpeningFcn, ...
                   'gui_OutputFcn',  @figImporti_OutputFcn, ...
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

function figImporti_OpeningFcn(hObject, eventdata, handles, varargin)
%% apertura GUI
    % sfondo per pulsante info
    bg_image = imread('img/infoFoto.png');
    set(handles.info,'CData',bg_image);
    % creo un axes che si estende per tutta la gui
    ah = axes('unit','normalized','position', [0 0 1 1]); 
    % importo l'immagine di background e la visualizzo sull'axes precedente
    bg = imread('img/homeground.jpg'); imagesc(bg);
    % controllo che l'immagine non si estenda oltre l'axes
    set(ah,'handlevisibility','off','visible','off');
    % porto l'immagine di background "dietro" tutti gli altri oggetti grafici
    % all'interno della gui
    uistack(ah, 'bottom');
    % recupero la pathname selezionata nella gui precedente
    pathFile = getappdata(0,'pathFile');
    % uso try-catch per evitare errori nel caricamento del file
    try
        % uso %* per saltare variabili inutilizzate in questa gui
        [handles.mese handles.aslAssistito handles.ricetta handles.importo] = textread(pathFile,'%*s %*s %d %*s %s %*s %*s %*d %s %*s %*s %*d %f','delimiter','\t');
        % creo un vettore di 12 elementi che conterrà la somma degli
        % importi totali suddivisi per mese
        vettoreImporti=sommaImporti(handles.mese, handles.importo);
        subplot(2,2,3:4)
        % grafico importi per mese
        plot([1:12],vettoreImporti,'LineWidth',4);
        % divido l'asse delle ascisse in base al numero di mesi
        set(gca,'XTick',[1:12]);
        % preparo un vettore con i nomi dei mesi (ascissa grafico)
        handles.labelsMesi={'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sept','Oct','Nov','Dec'};
        % assegno ad ogni colonna del grafico il relativo mese
        set(gca,'XTickLabel',handles.labelsMesi);
        % posiziono il grafico e ne setto la grandezza rispetto alla gui
        set(gca, 'Position', [0.1 0.07 0.8 0.36]);
        % setto il nome delle ascisse
        xlabel('MESI');
        % setto il nome delle ordinate
        ylabel('IMPORTO');
        % attivo la griglia
        grid on
        % isolo i codici delle ASL con una unique(), tengo conto anche
        % delle asl non classificate, ovvero quelle "vuote", che non sono
        % classificate nominalmente ma di cui possiamo comunque esporre un
        % grafico riassuntivo relativo alla branca ricetta
        aslUnico=unique(handles.aslAssistito); 
        % popolo il menù a tendina con i codici ASL
        set(handles.aslPop, 'String', aslUnico);
        % isolo le branche ricetta
        ricettaUnico = unique(handles.ricetta)
        % popolo il menù a tendina con le branca ricetta
        set(handles.ricettaPop, 'String', ricettaUnico);
    catch
        % messaggio di errore in caso di fallito caricamento del file o di
        % errore nelle operazioni di lettura
        msgbox('File non presente o file errato!','ERRORE','error');
        % ritorno alla gui precedente
        close(gca);
        myFigure
    end
    handles.output = hObject;
    % aggiornamento degli handles
    guidata(hObject, handles);

function varargout = figImporti_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

function aslPop_Callback(hObject, eventdata, handles)
%% menu a tendina codici ASL
    % nascondo la static text di invito a scegliere l'ASL
    set(handles.text1,'Visible','off');
    % recupero l'elemento selezionato in questo popupmenu
    contenuto = get(handles.aslPop,'String'); 
    value = get(handles.aslPop,'Value'); 
    aslSel = contenuto{value};
    % creo un vettore che contenga i mesi della sola ASL selezionata 
    mesi4asl=handles.mese(find(strcmp(aslSel,handles.aslAssistito)));
    % creo un vettore che contenga gli importi della sola ASL selezionata 
    importi4asl = handles.importo(find(strcmp(aslSel,handles.aslAssistito)));
    % creo un vettore di 12 elementi che conterrà la somma degli
    % importi totali suddivisi per mese
    vettoreImporti=sommaImporti(mesi4asl, importi4asl);
    subplot(2,2,1)
    % grafico importi per mese
    plot([1:12],vettoreImporti,'LineWidth',4);
    % divido l'asse delle ascisse in base al numero di mesi
    set(gca,'XTick',[1:12]);
    % assegno ad ogni colonna del grafico il relativo mese
    set(gca,'XTickLabel',handles.labelsMesi);
    % posiziono il grafico e ne setto la grandezza rispetto alla gui
    set(gca, 'Position', [0.08 0.53 0.4 0.3]);
    % setto il nome delle ascisse
    xlabel('MESI');
    % setto il nome delle ordinate
    ylabel('IMPORTO');
    % attivo la griglia    
    grid on
    
function aslPop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function ricettaPop_Callback(hObject, eventdata, handles)
%% menu a tendina branca ricetta
    % nascondo la static text di invito a scegliere la branca
    set(handles.text3,'Visible','off');
    % recupero l'elemento selezionato in questo popupmenu
    contenuto = get(handles.ricettaPop,'String'); 
    value = get(handles.ricettaPop,'Value'); 
    ricettaSel = contenuto{value};
    % creo un vettore che contenga i mesi della sola branca selezionata
    mesi4ricetta = handles.mese(find(strcmp(ricettaSel,handles.ricetta)))
    % creo un vettore che contenga gli importi della sola branca selezionata 
    importi4ricetta = handles.importo(find(strcmp(ricettaSel,handles.ricetta)))
    % creo un vettore di 12 elementi che conterrà la somma degli
    % importi totali suddivisi per mese
    vettoreImporti = sommaImporti(mesi4ricetta,importi4ricetta);
    subplot(2,2,2)
    % grafico importi per mese
    plot([1:12],vettoreImporti,'LineWidth',4);
    % divido l'asse delle ascisse in base al numero di mesi
    set(gca,'XTick',[1:12]);
    % assegno ad ogni colonna del grafico il relativo mese
    set(gca,'XTickLabel',handles.labelsMesi);
    % posiziono il grafico e ne setto la grandezza rispetto alla gui
    set(gca, 'Position', [0.56 0.53 0.4 0.3]);
    % setto il nome delle ascisse
    xlabel('MESI')
    % setto il nome delle ordinate
    ylabel('IMPORTO');
    % attivo la griglia
    grid on
    
function ricettaPop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function indietro_Callback(hObject, eventdata, handles)
%% link gui precedente
    myFigure;
    close(figImporti);


function info_Callback(hObject, eventdata, handles)
    %% area informazioni
    helpdlg('Sei nell area dedicata alle statistiche per importi; in basso viene visualizzato il grafico delle spese mensili complessivamente sostenute dalla asl; tali spese possono essere ripartite fra le asl richiedenti e il grafico importi di ciascuna asl puÚ essere visualizzato selezionando, in alto a sinistra, il codice dell asl che si intende esaminare, in alto a destra Ë possibile invece visualizzare la spesa relativa a ciascuna branca, selezionandola nella tendina.',...
        'Area informazioni');

function screen_Callback(hObject, eventdata, handles)
    % salvo l immagine
    set(gcf, 'PaperPositionMode','auto')
    print -dtiff -r0 figImporti.tiff
