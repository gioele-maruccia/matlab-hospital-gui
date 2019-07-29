function varargout = myfigure2(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                    'gui_Singleton',  gui_Singleton, ...
                    'gui_OpeningFcn', @myfigure2_OpeningFcn, ...
                    'gui_OutputFcn',  @myfigure2_OutputFcn, ...
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

function myfigure2_OpeningFcn(hObject, eventdata, handles, varargin)
    %% apertura Gui
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
    % recupero la pathname selezionata nella gui precedente
    pathFile = getappdata(0,'pathFile');
    % uso try-catch per evitare errori nel caricamento del file
    try
        % uso %* per saltare variabili inutilizzate in questa gui
        [handles.sesso handles.eta] = textread(pathFile,'%*s %*s %*d %*s %*s %*s %s %d %*d %*d %*s %*d %*f','delimiter','\t');
        %Conto il numero di pazienti maschi e pazienti femmine
        contaM=length(find( strcmp(handles.sesso,'M') | strcmp(handles.sesso,'m') )); %piu veloce di upper()
        contaF=length(find( strcmp(handles.sesso,'F') | strcmp(handles.sesso,'f') ));
        subplot(2,2,1)
        % grafico a torta della popolazione in base a M/F
        pieMF=pie([contaM contaF]);
        % setto colore al grafico
        hp = findobj(pieMF, 'Type', 'patch');
        set(hp(1), 'FaceColor', [0.2 0.6 1]);
        set(hp(2), 'FaceColor', [1.0 0.6 0.8]);
        % inserisco legenda
        legend({'Maschi','Femmine'},'location','eastOutside');
        % calcolo eta minima (range) ed eta massima (range) verificando che
        % non ci siano valori errati
        [etaMin etaMax] = etaMaxMin(handles.eta);
        % rimpiazzo eta con etaCorretto che non conterrà eventuali valori
        % errati 
        etaCorretto = handles.eta((handles.eta>=etaMin) & (handles.eta<=etaMax));
        % elimino eta perchè non servirà più
        clearvars eta etaMin;
        % isolo le classi di età con una unique()
        etaUnico=unique(etaCorretto);
        % popolo il menù a tendina con le classi di età
        set(handles.menueta, 'String', etaUnico);
        %conta è un vettore che conterrà il num di persone per una data
        %classe di età
        conta=zeros(1,etaMax);
        for i=1:length(etaUnico)
            % conto quante volte è presente una data classe di età
            conta(i)=conta(i)+length(find(etaUnico(i)==handles.eta));
        end
        subplot(2,2,[3:4])
        % grafico num di persone per range di età
        barEta=bar([0:5:106],conta);
        labelsRange={'0-5','6-10','11-15','16-20','21-25','26-30','31-35','36-40','41-45','46-50','51-55','56-60','61-65','66-70','71-75','76-80','81-85','86-90','91-95','96-100','101-105','>106'};
        % divido in range l'asse delle x
        set(gca,'XTick',[0:5:106]);
        % assegno ad ogni colonna del grafico il relativo range
        set(gca,'XTickLabel',labelsRange);
        % setto la grandezza dei caratteri
        set(gca,'FontSize',11);
        % posiziono il grafico e ne setto la grandezza rispetto alla gui
        set(gca, 'Position', [0.11 0.1 0.8 0.4]);
        % setto il nome delle ascisse
        xlabel('RANGE DI ETA');
        % setto il nome delle ordinate
        ylabel('NUMERO PAZIENTI');
        % miglioro capibilità grafico cambiando misure degli assi
        axis([-5 110 0  max(conta)+(max(conta)*2/100)]);
        % errore nelle operazioni di lettura
    catch
        msgbox('File non presente o file errato!','ERRORE','error');
        %ritorno alla gui precedente
        close(gca);
        myFigure
    end
    handles.output = hObject;
    % aggiornamento degli handles
    guidata(hObject, handles);

function varargout = myfigure2_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

function menueta_Callback(hObject, eventdata, handles)
    %% menù a tendina con classi di età
    % nascondo la static text del secondo pie
    set(handles.text3,'Visible','off');
    % recupero l'elemento selezionato nel popupmenu
    contenuto = get(handles.menueta,'String');
    value = get(handles.menueta,'Value'); % indice dell'elemento selezionato
    classe_sel = str2double(contenuto(value));
    % ricavo gli indici a cui corrisponde la classe età selezionata 
    ind_classe=find(handles.eta==classe_sel);
    %conto maschi e femmine di una data classe di età
    contaM=length(find( strcmp(handles.sesso(ind_classe),'M') | strcmp(handles.sesso(ind_classe),'m') ));
    contaF=length(find( strcmp(handles.sesso(ind_classe),'F') | strcmp(handles.sesso(ind_classe),'f') ));
    subplot(2,2,2)
    PieMF=pie([contaM contaF]);
    hp = findobj(PieMF, 'Type', 'patch');
    set(hp(1), 'FaceColor', [0.2 0.6 1]);
    set(hp(2), 'FaceColor', [1.0 0.6 0.8]);
    % creo legenda
    legend({'Maschi','Femmine'},'location','EastOutside');

function menueta_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    function indietro_Callback(hObject, eventdata, handles)
     % link a gui precedente
    myFigure
    close(myfigure2)

function info_Callback(hObject, eventdata, handles)
    %% area informazioni
    helpdlg('Sei nell area statistiche per genere e per classe di et?; in basso Ë presente il grafico per range di et? su tutti gli utenti che hanno avuto accesso a prestazioni fornite dalla nostra asl, in alto a sinistra vi Ë un grafico percentuale sulla distribuzione degli utenti per genere, in alto a destra vi Ë un grafico con la distribuzione di un campione (selezionato per classe di et?)  per genere.',...
        'Area informazioni');


function saveFigure_Callback(hObject, eventdata, handles)
    % salvo l immagine
    set(gcf, 'PaperPositionMode','auto')
    print -dtiff -r0 myFigure2.tiff
        
