function varargout = managepage(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @managepage_OpeningFcn, ...
        'gui_OutputFcn',  @managepage_OutputFcn, ...
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

function managepage_OpeningFcn(hObject, eventdata, handles, varargin)
%% apertura gui
    % creo un axes che si estende per tutta la gui
    ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
    % importo l'immagine di background e la visualizzo sull'axes precedente
    bg = imread('img/homeground.jpg'); imagesc(bg);
    % controllo che l'immagine non si estenda oltre l'axes
    set(ah,'handlevisibility','off','visible','off');
    % porto l'immagine di background "dietro" tutti gli altri oggetti grafici
    % all'interno della gui
    uistack(ah, 'bottom');
    % recupero nome e cognome passati in appdata dalla login, compongo e
    % stampo la frase di benvenuto
    nome = getappdata(0,'passoNome');
    cognome = getappdata(0,'passoCognome');
    benvenuto = strcat( 'Benvenuto', {' '}, nome, {' '}, cognome );
    set( handles.welcome, 'String', benvenuto );
  %  voce(benvenuto, 'Alice');
    % libero memoria eliminano variabili che non verranno più utilizzate
    clearvars nome cognome benvenuto;
    % disabilito temporaneamente pulsante Elimina e stampa dati
    set(handles.pushElimina,'enable','off');
    [handles.cfU handles.nomeU handles.cognomeU handles.passwordU handles.tipoUtenteU] = textread('utenti.txt','%s %s %s %s %d');
    % controllo se l'utente è presente nel registro accessi
    if  length(handles.cfU) == 0
        set(handles.text9,'String','Non sono presenti utenti ');
        set(handles.pushElimina,'visible','off');
        set(handles.dropPop,'visible','off');
    else
        set(handles.text9,'String','Seleziona utente ')
        rigaUtenti = strcat(handles.cfU,',',{' '},upper(handles.nomeU),',',{' '},upper(handles.cognomeU));
        % popolo menu a tendina degli utenti
        set(handles.dropPop,'String',rigaUtenti);
    end
    % se in fase di registrazione non specifico il tipo di utente questo
    % sarà di default impostato come normale utente
    handles.tipoUtente=1.1;
    % sfondo per il link a comunicazioni
    bg_image = imread('img/megafono.png');
    set(handles.comunicazioni, 'CData', bg_image);
    % sfondo per il link ad agenda
    bg_image2 = imread('img/agenda.png');
    set(handles.agenda,'CData',bg_image2);
    handles.output = hObject;
    set(handles.send2server,'Enable','off');
    % aggiornamento degli handles
    guidata(hObject, handles);

function varargout = managepage_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;

function editnNome_Callback(hObject, eventdata, handles)

function editnNome_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function editCognome_Callback(hObject, eventdata, handles)

function editCognome_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function editCf_Callback(hObject, eventdata, handles)

function editCf_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function radiobutton1_Callback(hObject, eventdata, handles)
%% utente amministratore
    % azzero altro radiobutton
    set(handles.radiobutton2, 'Value', 0);
    % tipo utente selezionato
    handles.tipoUtente = 0;
    handles.output = hObject;
    guidata(hObject,handles);

function radiobutton2_Callback(hObject, eventdata, handles)
%% utente normale
    % azzero altro radiobutton
    % tipo utente selezionato
    set(handles.radiobutton1, 'Value', 0);
    handles.tipoUtente = 1;
    handles.output = hObject;
    guidata(hObject,handles);

function pushREgistra_Callback(hObject, eventdata, handles)
%% registrazione utente
    % controllo che il codice fiscale non sia gia presente nel file utenti,
    % e verifico che la lunghezza del codice fiscale sia di 16 caratteri
    % dopodiche procedo con la scrittura sul file
    [cfU nomeU cognomeU passwordU tipoUtenteU] = textread('utenti.txt','%s %s %s %s %d');
    cf = get(handles.editCf, 'String');
    nome = get(handles.editnNome, 'String');
    cognome = get(handles.editCognome,'String');
    password = get(handles.password,'String');
    tipoUtente = handles.tipoUtente;
    % controllo che non ci siano form vuoti
    if(length(nome)~=0 & length(cognome)~=0 & length(password)~=0 & length(cf)~=0)
        if(sum(strcmp(cfU,cf))==0)
            if(length(cf)==16)
                % domanda di conferma registrazione
                choice = questdlg('Confermi la registrazione?','CONFERMA','SI','NO','NO');
                if strcmp(choice,'SI')
                    fid = fopen('utenti.txt','a');
                    fprintf(fid,'\n%s %s %s %s %d', upper(cf), nome, cognome, password, round(tipoUtente));
                    fclose(fid);
                    %creo il file da consegnare all'utente appena registrato
                    a = strcat('Benvenuto signor' , {' '} ,  cognome , {' '} , nome);
                    b = strcat('Le sue credenziali sono:');
                    c = strcat('Password:' , {' '} , password);
                    d = strcat('Codice Fiscale:',{' '},cf);
                    nomeFileUscita = 'newUtente.txt';
                    fid2=fopen(nomeFileUscita,'w');
                    fprintf(fid2,'%s \n %s \n  %s  %s',a{1},b,c{1},d{1});
                    fclose(fid2);
                    set(handles.textWelcome,'String',nomeFileUscita);
                    set(handles.send2server,'Enable','on');
                    
                    handles.message = strcat(a{1},{' '},',',b,{' '},c{1},',',{' '},d{1});
                    if(tipoUtente==1.1)
                        msgbox('Non è stato definito un tipo utente, verrà impostato di default come utente normale','WARNING','warn');
                    end
                end
            else
                msgbox('lunghezza codic fiscale errata','ERRORE','error');
            end
        else
            msgbox('Cf gia presente','ERRORE','error');
        end
    else
        msgbox('Dati mancanti','ERRORE','error');
    end
    guidata(hObject,handles);


function passGenerator_Callback(hObject, eventdata, handles)
    %% bottone genera password
    %genero la password
    simboli = ['a':'z' 'A':'Z' '0':'9'];
    lungMax = 12;
    nums = randi(length(simboli),[1 lungMax]);
    handles.st = simboli(nums);
    set(handles.password,'String',handles.st);
    % aggiorno gli handles
    guidata(hObject,handles);

function logout_Callback(hObject, eventdata, handles)
%% ritorno alla homepage
    voce('arrivederci', 'Alice');

    close(managepage);
    homepage


function dropPop_Callback(hObject, eventdata, handles)
    % recupero l'elemento selezionato nel popupmenu degli utenti
    contenuto = get(handles.dropPop,'String');
    value = get(handles.dropPop,'Value');
    handles.utenteSel = contenuto{value};
    cfSel = handles.utenteSel(1:16);
    % abilito il pulsante elimina utente
    set(handles.pushElimina,'enable','on');
    [cfUtente date time] = textread('accessi.txt','%s %s %s');
    dateTime = strcat(date,{' '},time);
    dateTime = dateTime(find(strcmp(cfUtente,cfSel)));
    % stampo in una listbox il registro accessi dell'utente selezionato
    set(handles.listaAccessi,'String',dateTime);
    guidata(hObject,handles);

function dropPop_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function pushElimina_Callback(hObject, eventdata, handles)
%% eliminazione di un utente
% elimino l'utente riscrivendo il file utenti saltando l'utente selezionato
    choice = questdlg('Confermi di eliminare l utente?','CONFERMA','SI','NO','NO');
    if strcmp(choice,'SI')
        cf = handles.utenteSel(1:16);
        fid = fopen('utenti.txt','w');
        for i=1:length(handles.cfU)
            if(strcmp(handles.cfU{i},cf)==0)
                if i==1
                    fprintf(fid,'%s %s %s %s %d', handles.cfU{i}, handles.nomeU{i}, handles.cognomeU{i}, handles.passwordU{i}, handles.tipoUtenteU(i));
                else
                    fprintf(fid,'\n%s %s %s %s %d', handles.cfU{i}, handles.nomeU{i}, handles.cognomeU{i}, handles.passwordU{i}, handles.tipoUtenteU(i));
                end
            end
        end
        fclose(fid);
        % aggiorno pagina
        managepage
    end

function listaAccessi_Callback(hObject, eventdata, handles)

function listaAccessi_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function comunicazioni_Callback(hObject, eventdata, handles)
    % link alla gui forum
    forum

    function agenda_Callback(hObject, eventdata, handles)
     % link alla gui calendario
    calendario

function send2server_Callback(hObject, eventdata, handles)
    server(handles.message, 3000, 10);
