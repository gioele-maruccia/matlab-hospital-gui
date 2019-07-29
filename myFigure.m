function varargout = myFigure(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                    'gui_Singleton',  gui_Singleton, ...
                    'gui_OpeningFcn', @myFigure_OpeningFcn, ...
                    'gui_OutputFcn',  @myFigure_OutputFcn, ...
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
    
function myFigure_OpeningFcn(hObject, eventdata, handles, varargin)

% aumento grandezza gui
set(gcf, 'units','normalized','outerposition',[0 0 0.95 0.95]);
%% sfondo pulsanti e sfondo gui
    % sfondo per pulsante info
    bg_image = imread('img/infoFoto.png');
    set(handles.info,'CData',bg_image);
    % sfondo per area Ospedali
    bg_image = imread('img/ospFoto.jpg');
    set(handles.push4Osp,'CData',bg_image);
    % sfondo per report
    bg_image = imread('img/reportFoto.png');
    set(handles.report,'CData',bg_image);
    % sfondo per browse
    bg_image = imread('img/cartella.jpg');
    set(handles.browse,'CData',bg_image);
    % sfondo per il link a m/f
    bg_image = imread('img/pieFoto.jpg');
    set(handles.pushMF, 'CData', bg_image);
    % sfondo per il link a importi
    bg_image = imread('img/importiFoto.png');
    set(handles.pushImporti, 'CData', bg_image);
    % sfondo per il link a ricetta
    bg_image = imread('img/barFoto.jpg');
    set(handles.pushRicetta, 'CData', bg_image);
    % sfondo per il link ad agenda
    bg_image = imread('img/agenda.png');
    set(handles.agenda, 'CData', bg_image);
    % sfondo per il link a comunicazioni 
    bg_image = imread('img/megafono2.png');
    set(handles.comunicazioni, 'CData', bg_image);
    % creo un axes che si estende per tutta la gui
    ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
    % importo l'immagine di background e la visualizzo sull'axes precedente
    bg = imread('img/homeground.jpg'); imagesc(bg);
    % controllo che l'immagine non si estenda oltre l'axes
    set(ah,'handlevisibility','off','visible','off');
    % porto l'immagine di background "dietro" tutti gli altri oggetti grafici
    % all'interno della gui
    uistack(ah, 'bottom');
    %% frase di benvenuto
    % recupero nome e cognome passati in appdata dalla login, compongo e
    % stampo la frase di benvenuto
    nome = getappdata(0,'passoNome');
    cognome = getappdata(0,'passoCognome');
    benvenuto=strcat('Benvenuto',{' '},nome,{' '},cognome);
    set(handles.text1,'String',benvenuto);
    
    %voce(benvenuto, 'Alice');
    
    % libero memoria eliminano variabili che non verranno più utilizzate
    clearvars nome cognome benvenuto;
    filename = getappdata(0,'pathFile');
    set(handles.editFile, 'String', filename);  
    handles.output = hObject;
    % aggiornamento degli handles
    guidata(hObject, handles);

function varargout = myFigure_OutputFcn(hObject, eventdata, handles) 
        varargout{1} = handles.output;
 
function editFile_Callback(hObject, eventdata, handles)

function editFile_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function browse_Callback(hObject, eventdata, handles)
%% path assoluta file
    % salvo il nome del file selezionato e lo visualizzo nella gui
    [file path] = uigetfile('*.txt');
    filepath = strcat(path, file);
    set(handles.editFile, 'String', filepath);  
    % aggiungo pathfile alle variabili globali
    setappdata(0,'pathFile',filepath);

    
function pushMF_Callback(hObject, eventdata, handles)
%% link a gui "sesso / età"
    filename = getappdata(0,'pathFile');
    % link alla figura contenente statistiche M/F e sesso
    myfigure2
    close(myFigure);
    %memorizzo gli handles
    guidata(hObject,handles);
    
function pushRicetta_Callback(hObject, eventdata, handles)
%% link a gui "branca ricetta"
    filename = getappdata(0,'pathFile');
    % link alla figura contenente statistiche sulla branca ricetta
    figRicetta
    close(myFigure);
    
function pushImporti_Callback(hObject, eventdata, handles)
%% link a gui "importi"
    filename = getappdata(0,'pathFile');
    % apro la figura contenente i grafici statistici
    figImporti
    close(myFigure);

function comunicazioni_Callback(hObject, eventdata, handles)
    % link alla gui per le comunicazioni
    forum

function agenda_Callback(hObject, eventdata, handles)
    % link alla gui con agenda
    calendario
function logout_Callback(hObject, eventdata, handles)
%% ritorno alla homepage
    % "svuoto" frase di benvenuto
    set(handles.text1,'String',' ');
    voce('arrivederci', 'Alice');

    % link alla gui precedente
    close(myFigure);
    homepage

function pushCinetica_Callback(hObject, eventdata, handles)
    close(myFigure);
    farmacoCinetica

function report_Callback(hObject, eventdata, handles)
    close(myFigure);
    guiReport

function push4Osp_Callback(hObject, eventdata, handles)
    close(myFigure);
    ospGui

function info_Callback(hObject, eventdata, handles)
helpdlg('Sei nella prima pagina dedicata all utente; cliccando sugli appositi pulsanti, dopo aver caricato il file ASL, Ë possibile visualizzare le statistiche su importi, genere ed et?, ricetta. Inoltre potrai accedere ad un area dedicata all eleborazione e al calcolo dei dati ospedalieri. Il link report permette di accedere ad un area spoglia esteticamente ma di grande utilit? nell interazione tra diverse strutture gestionali sanitarie. Esistono due aree dedicate alla farmacocinetica: una dedicata ai dati relativi agli ospedali, ed una all ASL, che permette di monitorare i pazienti con cui l asl stessa Ë impegnata. In basso a destra sono presenti inoltre due link aggiuntivi dedicati agli eventi aziendali o circolari.',...
        'Area informazioni');
