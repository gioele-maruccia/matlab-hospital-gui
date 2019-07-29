function varargout = ospGui(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @ospGui_OpeningFcn, ...
                       'gui_OutputFcn',  @ospGui_OutputFcn, ...
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

function ospGui_OpeningFcn(hObject, eventdata, handles, varargin)
%% apertura gui

    % sfondo per pulsante info
    bg_image = imread('img/infoFoto.png');
    set(handles.pushInfo,'CData',bg_image);
    % creo un axes che si estende per tutta la gui
    ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
    % importo l'immagine di background e la visualizzo sull'axes precedente
    bg = imread('img/homeground.jpg'); imagesc(bg);
    % controllo che l'immagine non si estenda oltre l'axes
    set(ah,'handlevisibility','off','visible','off');
    % porto l'immagine di background "dietro" tutti gli altri oggetti grafici
    % all'interno della gui
    uistack(ah, 'bottom');
    % disabilito il menu a tendina ospedali
    set(handles.popupOsp,'Enable','off');
    handles.i = 1;
    handles.vettOsp = [];
    handles.output = hObject;
    % aggiorno gli handles
    guidata(hObject, handles);

function varargout = ospGui_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

function popupOsp_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function browse_Callback(hObject, eventdata, handles)
%% scelta del file da caricare
    filepath = ' ';
    [file path] = uigetfile('*.xml');
    filepath = strcat(path, file);
    set(handles.editFile, 'String', filepath);
    % controllo che non ci siano errori nel caricamento del file e procedo
    % con calcoli e mostrando il grafico compartimentale
    global media_k;
    if length(filepath) ~= 0
        try
            handles.vettOsp = [handles.vettOsp handles.i];
            handles.nomeXML{handles.i} = filepath;
            set(handles.popupOsp,'String',handles.vettOsp);
            handles.i = handles.i + 1;
            set(handles.popupOsp,'Enable','on');
            somma=zeros(1,3);
            % per ogni ospedale calcolo la media e la DS(dev standard)
            for j=1:length(handles.nomeXML)
                [codice_paziente,A,a,b,codice_ospedale]=leggo_osp_diabete(handles.nomeXML{j});
                [media_parametri_cinetici,deviazione_standard]=calcolo_osp_dati(A,a,b);
                % salvo la somma della media_parametri_cinetii perchè
                % voglio calcolare la media complessiva su tutti i
                % parametri di tutti gli ospedali
                somma = somma+media_parametri_cinetici;
            end
            % media complessiva
            media_tot = somma./length(handles.nomeXML);
            media_k(1)=media_tot(2);
            media_k(2)=media_tot(3);
            % grafico andamento compartimentale
            [t, q]=ode23(@comp2,[0:0.1:4],[10000 0]);
            subplot(2,1,2)
            % plotto grafico specificando lo spessore della linea
            plot(t,q(:,1),'g',t,q(:,2),'r','LineWidth',3)
            % setto posizione grafico
                xlabel('TEMPO(hh)');
                ylabel('CONCENTRAZIONE [mg/dl]');
            set(gca, 'Position', [0.1 0.06 0.8 0.34]);
            % visualizzo legenda
            legend('Compartimento 1','Compartimento 2');
            % caricamento riuscito, invito a caricare un altro file
            msgbox('file caricato!, caricane un altro se vuoi','caricamento file','warning');
        catch
            % messaggio di errore in caso di fallito caricamento del file o di
            % errore nelle operazioni di lettura
            msgbox('File non presente o file errato!');
            %ritorno alla gui precedente
        end
    end
    % aggiorno gli handles
    guidata(hObject, handles);

function popupOsp_Callback(hObject, eventdata, handles)
%% popup scelta ospedali
    % leggo il contenuto del menù a tendina
    contenuto = get(handles.popupOsp,'String');
    value = get(handles.popupOsp,'Value'); % indice dell'elemento selezionato
    ospSel = str2double(contenuto(value));
    pathOspSel = handles.nomeXML(ospSel);
    [codice_paziente,A,a,b,codice_ospedale]=leggo_osp_diabete(pathOspSel{1});
    for i=1:length(A)
        k(i,1) = str2num(a{i});
        k(i,2) =  str2num(b{i});
    end
    % nascondo invito a selezionare un oggetto dal menù
    set(handles.text4,'Visible','off');
    subplot(2,1,1)
    mybar = bar(k);
    % settaggio colori
    hp = findobj(mybar, 'Type', 'patch');
    set(hp(1),'EdgeColor',[1 1 1]);
    set(hp(2),'EdgeColor',[1 1 1]);
    legend({'k1','k2'},'location','northwest');
    % nomi assi
    xlabel('CODICE PAZIENTI');
    ylabel('PARAMETRI [mg/dl]');
    % setto posizione
    set(gca, 'Position', [0.1 0.50 0.8 0.34]);
    axis tight;

function indietro_Callback(hObject, eventdata, handles)
%% link a Gui precedente
    myFigure
    close(ospGui);

function pushInfo_Callback(hObject, eventdata, handles)
%% area informazioni
helpdlg('Sei nell area ospedali, selezionando uno o più file diabete potrai visualizzare la simulazione del modello compartimentale (in basso) relativo a tutti gli ospedali caricati, selezionando invece uno specifico ospedale dal menù a tendina apparirà il grafico relativo ai coefficienti k di ogni singolo paziente ',...
        'Area informazioni');

function screen_Callback(hObject, eventdata, handles)
    % salvo l immagine
    set(gcf, 'PaperPositionMode','auto')
    print -dtiff -r0 ospGui.tiff
