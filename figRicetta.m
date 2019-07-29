function varargout = figRicetta(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @figRicetta_OpeningFcn, ...
                   'gui_OutputFcn',  @figRicetta_OutputFcn, ...
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

function figRicetta_OpeningFcn(hObject, eventdata, handles, varargin)
%% apertura gui
% sfondo per pulsante info
    bg_image = imread('img/infoFoto.png');
    set(handles.info,'CData',bg_image);
    % nego l'utilizzo del tasto COMUNI
    set(handles.comPop,'Enable','off');
    % creo un axes che si estende per tutta la gui
    ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
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
        [handles.aslAssistito handles.comAssistito handles.ricetta] = textread(pathFile,'%*s %*s %*d %*s %s %s %*s %*d %d %*d %*s %*d %*f','delimiter','\t');
        % isolo i codici delle ASL con una unique(), tengo conto anche
        % delle asl non classificate, ovvero quelle "vuote", che non sono
        % classificate nominalmente ma di cui possiamo comunque esporre un
        % grafico riassuntivo relativo alla branca ricetta
        aslUnico=unique(handles.aslAssistito);
        aslEsterne=handles.aslAssistito(find(not(strcmp(handles.aslAssistito(1),'7'))));
        % popolo il menù a tendina con i codici ASL
        set(handles.aslPop, 'String', aslEsterne);
        % recupero dati statistici con funzione statistica(vettoreDelleRicette)
        [brancaMaxComplex, brancaMinComplex, contaBrancaComplex, handles.ricetta_unica]=statistica(handles.ricetta);
        % visualizzo il massimo e il minimo assoluto
        set(handles.maxTot,'String',strcat('Max:',{' '},num2str(brancaMaxComplex)));
        set(handles.minTot,'String',strcat('Min:',{' '},num2str(brancaMinComplex)));
        subplot(2,2,3:4)
        % grafico branca ricetta per frequenza di utilizzo
        barRicTot=bar(contaBrancaComplex); 
        % divido l'asse delle ascisse in base al numero di ricette in
        % circolazione
        set(gca,'XTick',[1:length(handles.ricetta_unica)]);
        % assegno ad ogni colonna del grafico il nome (o numero) della
        % ricetta considerata
        set(gca,'XTickLabel',handles.ricetta_unica);
        % setto la grandezza dei caratteri
        set(gca,'FontSize',11);
        % posiziono il grafico e ne setto la grandezza rispetto alla gui
        set(gca, 'Position', [0.1 0.07 0.8 0.36]);
        % setto il nome delle ascisse
        xlabel('BRANCA  RICETTA');
        % setto il nome delle ordinate
        ylabel('NUMERO PAZIENTI');
        % miglioro capibilità grafico cambiando misure degli assi
        axis([0 length(handles.ricetta_unica)+1 0  max(contaBrancaComplex)+(max(contaBrancaComplex)*2/100)]);
    catch
        % messaggio di errore in caso di fallito caricamento del file o di
        % errore nelle operazioni di lettura
        msgbox('File non presente o file errato!','ERRORE','error');
        %ritorno alla gui precedente
        close(gca);
        myFigure
    end
    handles.output = hObject;
    % aggiornamento degli handles
    guidata(hObject, handles);
function varargout = figRicetta_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

function aslPop_Callback(hObject, eventdata, handles)
%% popup codici asl
    % plotto un finto grafico al posto del grafico COMUNI per evitare che
    % cambiando l'ASL dal menù rimanga plottato il grafico dell'asl
    % precedentemente scelta
    subplot(2,2,2);
    plot(0);
    set(gca, 'Position', [0.08 0.53 0.4 0.3]);
    % nascondo la static text di invito a scegliere l'ASL
    set(handles.text2,'Visible','off');
    % nascondo max e min dei comuni
    set(handles.maxCom,'String',' ');
    set(handles.minCom,'String',' ');
    % abilito l'uso del menù COMUNI
    set(handles.comPop,'Enable','on');
    % recupero l'elemento selezionato in questo popupmenu
    contenuto = get(handles.aslPop,'String'); 
    value = get(handles.aslPop,'Value'); 
    aslSel = contenuto{value};
    % ricerco le ricette relative all'ASL scelta
    ricetta4asl = handles.ricetta(find(strcmp(contenuto(value),handles.aslAssistito)));
    % recupero dati statistici con funzione statistica(vettoreDelleRicettePerASL)
    [brancaMaxComplex, brancaMinComplex, conta, ricettaUnica]=statistica(ricetta4asl);
    % visualizzo il massimo e il minimo assoluto
    set(handles.maxAsl,'String',strcat('Max:',{' '},num2str(brancaMaxComplex)));
    set(handles.minAsl,'String',strcat('Min:',{' '},num2str(brancaMinComplex)));
    
    aslEsterne2=find(not(strcmp(handles.aslAssistito(1),'7')));
    ricetta4esterne=handles.ricetta(aslEsterne2);
   [brancaMax, brancaMin, conta2, ricettaUnica]=statistica(ricetta4esterne);
   barRic4Aslesterne=bar(conta2);
    subplot(2,2,1)
    % divido l'asse delle ascisse in base al numero di ricette utilizzate
    set(gca,'XTick',[1:length(handles.ricetta_unica)]);
    % assegno ad ogni colonna del grafico il nome (o numero) della
    % ricetta considerata
    set(gca,'XTickLabel',handles.ricetta_unica);
    % posiziono il grafico e ne setto la grandezza rispetto alla gui
    set(gca, 'Position', [0.08 0.53 0.4 0.3]);
    % setto il nome delle ascisse
    xlabel('BRANCA  RICETTA');
    % setto il nome delle ordinate
    ylabel('FREQUENZA UTILIZZO');
%     subplot(2,2,1)
%     % grafico branca ricetta per frequenza di utilizzo dell'Asl scelta
%     barRic4Asl=bar(conta);
%     % divido l'asse delle ascisse in base al numero di ricette utilizzate
%     set(gca,'XTick',[1:length(handles.ricetta_unica)]);
%     % assegno ad ogni colonna del grafico il nome (o numero) della
%     % ricetta considerata
%     set(gca,'XTickLabel',handles.ricetta_unica);
%     % posiziono il grafico e ne setto la grandezza rispetto alla gui
%     set(gca, 'Position', [0.08 0.53 0.4 0.3]);
%     % setto il nome delle ascisse
%     xlabel('BRANCA  RICETTA');
%     % setto il nome delle ordinate
%     ylabel('FREQUENZA UTILIZZO');
%     % ricavo i comuni di competenza dell'Asl selezionata
    comProv = handles.comAssistito(find(strcmp(aslSel,handles.aslAssistito)));
    % isolo i codici dei comuni con una unique()
    comUnico = unique(comProv);
    % popolo il menù a tendina con i codici dei comuni
    set(handles.comPop, 'String', comUnico);
      
function aslPop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function comPop_Callback(hObject, eventdata, handles)
%% popup codici comuni
    % nascondo la static text di invito a scegliere il COMUNE
    set(handles.text4,'Visible','off');
    % recupero l'elemento selezionato in questo popupmenu
    contenuto2 = get(handles.comPop,'String');
    value2 = get(handles.comPop,'Value'); 
    % ricerco le ricette relative al COMUNE scelto
    ricetta4com = handles.ricetta(find(strcmp(contenuto2{value2},handles.comAssistito)));
    % recupero dati statistici con funzione statistica(vettoreDelleRicettePerCOMUNE)
    [brancaMaxComplex, brancaMinComplex, conta, ricettaUnica]=statistica(ricetta4com);
    % visualizzo il massimo e il minimo assoluto
    set(handles.maxCom,'String',strcat('Max:',{' '},num2str(brancaMaxComplex)));
    set(handles.minCom,'String',strcat('Min:',{' '},num2str(brancaMinComplex)));
    subplot(2,2,2)
    % grafico branca ricetta per frequenza di utilizzo del comune scelta
    barRic4Com = bar(conta);
    % divido l'asse delle ascisse in base al numero di ricette utilizzate
    set(gca,'XTick',[1:length(ricettaUnica)]);
    % assegno ad ogni colonna del grafico il nome (o numero) della
    % ricetta considerata
    set(gca,'XTickLabel',ricettaUnica);
    % posiziono il grafico e ne setto la grandezza rispetto alla gui
    set(gca, 'Position', [0.53 0.53 0.4 0.3]);
     % setto il nome delle ascisse
    xlabel('BRANCA  RICETTA');
    % setto il nome delle ordinate
    ylabel('FREQUENZA UTILIZZO');
  
function comPop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function indietro_Callback(hObject, eventdata, handles)
%% link gui precedente
    close(figRicetta);  
    myFigure;

function info_Callback(hObject, eventdata, handles)
%% area informazioni
    helpdlg('Sei nell area dedicata alle statistiche per ricetta; in basso Ë visualizzato il grafico delle frequenze di utilizzo complessivo per branca ricetta, in alto a sinistra Ë possibile selezionare il codice di una asl e visualizzare il grafico delle prestazioni per branca ricetta fornite dalla nostra asl per utenti facenti capo alla asl in esame. Inoltre, una volta selezionata l asl, verr? abilitata la scelta del codice di un comune ricompreso nell ambito territoriale di tale asl, e verr? presentato il grafico relativo al comune selezionato',...
        'Area informazioni');

function screen_Callback(hObject, eventdata, handles)
    % salvo l immagine
    set(gcf, 'PaperPositionMode','auto')
    print -dtiff -r0 figRicetta.tiff
        
