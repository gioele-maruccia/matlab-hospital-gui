function varargout = homepage(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @homepage_OpeningFcn, ...
    'gui_OutputFcn',  @homepage_OutputFcn, ...
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

function homepage_OpeningFcn(hObject, eventdata, handles, varargin)
%% apertura gui
% sfondo per pulsante info
    bg_image = imread('img/infoFoto.png');
    set(handles.info,'CData',bg_image);
    % creo un axes che si estende per tutta la gui
    ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
    % importo l'immagine di background e la visualizzo sull'axes precedente
    bg = imread('img/homegroundLogo.jpg'); imagesc(bg);
    % controllo che l'immagine non si estenda oltre l'axes
    set(ah,'handlevisibility','off','visible','off');
    % porto l'immagine di background "dietro" tutti gli altri oggetti grafici
    % all'interno della gui
    uistack(ah, 'bottom');
    handles.output = hObject;
    % aggiornamento degli handles
    guidata(hObject, handles);

function varargout = homepage_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

function editUser_Callback(hObject, eventdata, handles)
    
function editUser_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function editPass_Callback(hObject, eventdata, handles)  

function editPass_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
function accedi_Callback(hObject, eventdata, handles)
    % leggo dal file contenente gli utenti registrati
    [CF nome cognome password tipoUtente] = textread( 'utenti.txt', '%s %s %s %s %d' );
    % prelevo username (CF) dal form di accesso
    myUser = get( handles.editUser, 'String' );
    % prelevo password dal form di accesso
    myPass = get( handles.editPass, 'String' );
    % controllo che l'utente sia presente e verifico il tipo di utente (0
    % se SUPERUSER, 1 se utente standard), dopodichè lo indirizzo alla
    % pagina specifica
    if( length( find( ( strcmp( myUser, CF ).*strcmp( myPass, password ) ).*( tipoUtente == 0 ) ) ) == 1 )
        % aggiorno registro accessi
        aggiornaAccessi( myUser );
        % passo nome e cognome per frase di benvenuto
        setappdata( 0, 'passoNome', nome( find( strcmp( myUser, CF ) ) ) );
        setappdata( 0, 'passoCognome', cognome( find( strcmp( myUser, CF ) ) ) );
        setappdata( 0, 'passoCf', myUser );
        nome = getappdata(0,'passoNome');
        cognome = getappdata(0,'passoCognome');
        benvenuto=strcat('Benvenuto',{' '},nome,{' '},cognome);
        voce(benvenuto, 'Alice');
        % passo tipoUtente per poi controllare (in agenda e comunicazioni)
        % se l'utente ha il privilegio di creare nuovi eventi o
        % comunicazioni
        setappdata( 0, 'passoTipo', 0 );
        % chiudo homepage
        close( homepage );
        % apro pagina di gestione
        managepage
    elseif( length( find( ( strcmp(myUser,CF).*strcmp(myPass,password)).*(tipoUtente==1)))==1)
        % aggiorno registro accessi
        aggiornaAccessi( myUser );
        % passo nome e cognome per frase di benvenuto
        setappdata( 0, 'passoNome', nome( find( strcmp( myUser, CF ) ) ) );
        setappdata( 0, 'passoCognome', cognome( find( strcmp( myUser, CF ) ) ) );
        setappdata( 0, 'passoCf', myUser );
        nome = getappdata(0,'passoNome');
        cognome = getappdata(0,'passoCognome');
        benvenuto=strcat('Benvenuto',{' '},nome,{' '},cognome);
        voce(benvenuto, 'Alice');

        % passo tipoUtente per poi controllare (in agenda e comunicazioni)
        % se l'utente ha il privilegio di creare nuovi eventi o
        % comunicazioni
        setappdata( 0, 'passoTipo', 1 );
        % chiudo homepage
        close( homepage );
        % apro pagina statistiche
        myFigure
    else
        % messaggio di errore in caso di errore di accesso
        msgbox('Utente non presente o credenziali sbagliate','ERRORE','error');
    end


function info_Callback(hObject, eventdata, handles)
    %% area informazioni
    helpdlg('AMS consente di effettuare e visualizzare statistiche su dati ospedalieri e/o distribuzione di dati su popolazioni o campioni. Accedi per visualizzare statistiche o per accedere alla gestione utenti ',...
        'Area informazioni');
