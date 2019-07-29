function varargout = guiReport(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @guiReport_OpeningFcn, ...
    'gui_OutputFcn',  @guiReport_OutputFcn, ...
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

function guiReport_OpeningFcn(hObject, eventdata, handles, varargin)
%% apertura GUI
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
    handles.i = 1;
    set(handles.pushReportAsl,'Enable','off');
    set(handles.pushReportOsp,'Enable','off');
    % flag di file caricato settati di default a 0
    handles.flagOsp = 0;
    handles.flagAsl = 0;
    handles.output = hObject;
    % aggiorno gli handles
    guidata(hObject, handles);

function varargout = guiReport_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;

function browse_Callback(hObject, eventdata, handles)
%% caricamento del report Osp
    filepath = ' ';
    [file path] = uigetfile('*.xml');
    filepath = strcat(path, file);
    % caricamento della pathname del file con possibilità di caricarne più
    % di una
    if length(filepath) ~= 0
        try
            set(handles.editFile, 'String', filepath);
            handles.nomeXML{handles.i} = filepath;
            handles.i = handles.i + 1;
            msgbox('file caricato!, caricane un altro se vuoi','caricamento file','warning');
            set(handles.pushReportOsp,'Enable','on');
            % caricamento effettuato ---> flag = 1 (utile per abilitare il
            % report regionale)
            handles.flagOsp = 1;
        catch
            % messaggio di errore in caso di fallito caricamento del file o di
            % errore nelle operazioni di lettura
            msgbox('File non presente o file errato!');
            %ritorno alla gui precedente
            close(gca);
            myFigure
        end
    end
    % aggiorno gli handles
    guidata(hObject, handles);

function pushReportOsp_Callback(hObject, eventdata, handles)
%% lettura del report Osp
    for i=1:length(handles.nomeXML)
        [codice_ospedale,rimborso_totale_previsto,giornate_degenza_d,num_prestazioni,codice_drg_d, modalita_di_dimissione_s]=leggo_spese_ospedale(handles.nomeXML{i});
        for j=1:length(giornate_degenza_d)
            % trasformo in int alcune stringhe per agevolare i calcoli
            A(j)=str2num(giornate_degenza_d{j});
            dimessi(j)=str2num(modalita_di_dimissione_s{j});
        end
        giornate_degenza{i}=num2str(sum(A));
        codici_ospedali{i}=codice_ospedale;
        rimborsi_totali{i}=rimborso_totale_previsto;
        numeri_dimessi{i}=num2str(length(find(dimessi>2)));
        codici_drg{i}=num2str(num_prestazioni);
    end
    report_scrittura(codici_ospedali,rimborsi_totali,giornate_degenza,numeri_dimessi,codici_drg);
    perText = strcat('file creato:',{' '},'reportSpeseOsp.xml');
    % visualizzo a video il nome del file creato, ma stranamente non
    % funziona!!!
    set(handles.fileCreatoText,'String',perText);
    guidata(hObject, handles);


function browse2_Callback(hObject, eventdata, handles)
%% caricamento del file ASL
filepath = ' ';
[file path] = uigetfile('*.txt');
filepath = strcat(path, file);
    if length(filepath) ~= 0
        set(handles.editFile2, 'String', filepath);
        set(handles.pushReportAsl,'Enable','on');
        handles.flagAsl = 1;
        guidata(hObject, handles);
    end

function pushReportAsl_Callback(hObject, eventdata, handles)
%% creazione report totale ASL
% creo radice e il suo tag
    asl=com.mathworks.xml.XMLUtils.createDocument('asl');
    radice=asl.getDocumentElement;
    % codice nostra asl
    nostroAsl = '70001';
    filename = get(handles.editFile2, 'String');
    % leggo file txt
    [codNosologico anno mese azErogante aslAssistito comAssistito sesso eta ricetta disciplinaErogatore prestazione numPrestazioni importo] = textread(filename,'%s %s %d %s %s %s %s %d %d %d %s %d %f','delimiter','\t');
    spese_tot = sum(importo(find(strcmp(nostroAsl,aslAssistito))));
    tot_prest = sum(numPrestazioni( find( strcmp( nostroAsl, aslAssistito))));
    ricettaUnico = unique(ricetta( find( strcmp( nostroAsl, aslAssistito))));
    % calcolo importo per branca
    for i=1:length(ricettaUnico)
        importo_branca(i) = sum(importo(find( ricetta==ricettaUnico(i) & strcmp(nostroAsl,aslAssistito ) )));
    end
    radice.setAttribute('codice_asl',nostroAsl);
    % creo un nuovo elemento "spesa", figlio di asl
    spesa=asl.createElement('spesa');
    radice.appendChild(spesa);
    newtext1 = asl.createTextNode(num2str(spese_tot));
    spesa.appendChild(newtext1);
    % creo un altro figlio 
    numero_prestazioni=asl.createElement('numero_prestazioni');
    radice.appendChild(numero_prestazioni);
    newtext2=asl.createTextNode(num2str(tot_prest));
    numero_prestazioni.appendChild(newtext2);
    % creo tanti figli quanti sono il numero di branca ricette ed in ognuno
    % dei quali inserisco un testo "PCData"
    for j=1:length(ricettaUnico)
        ric=ricettaUnico;
        imp=importo_branca;
        branca_ricetta(j)=asl.createElement('branca_ricetta');
        branca_ricetta(j).setAttribute('codice_branca',num2str(ric(j)));
        radice.appendChild(branca_ricetta(j));
        importo=asl.createElement('importo');
        branca_ricetta(j).appendChild(importo);
        newtext3=asl.createTextNode(num2str(imp(j)));
        importo.appendChild(newtext3);
    end
    % stampo in un file il risultato del report
    a = xmlwrite(asl) ;
    fid = fopen('reportSpeseAsl1.xml','w');
    fprintf(fid,'\n%s', a);
    fclose(fid);
    % visualizzo il nome del file appena creato
    perText = strcat('file creato:',{' '},'reportSpeseAsl1.xml');
    set(handles.fileCreatoText,'String',perText);
    guidata(hObject, handles);

function reportReg_Callback(hObject, eventdata, handles)
%% creazione report REGIONALE
    % controllo che entrambi i file siano stati caricati, in caso contrario
    % visualizzo msgbox di errore
    if handles.flagOsp == 1 && handles.flagAsl == 1
        media=zeros(1,3);
        for j=1:length(handles.nomeXML)
            try
                [codice_paziente,A,a,b,codice_ospedale{j}]=leggo_osp_diabete(handles.nomeXML{j});
                [media_parametri_cinetici,deviazione_standard]=calcolo_osp_dati(A,a,b);
            catch
                close(guiReport);
                msgbox('formato file errato','ERRORE','Error');
                myFigure
            end
            media=media+media_parametri_cinetici;
            MEDIA{j}=[num2str(media_parametri_cinetici(1)),',',num2str(media_parametri_cinetici(2)),',',num2str(media_parametri_cinetici(3))];
            STD{j}=[num2str(deviazione_standard(1)),',',num2str(deviazione_standard(2)),',',num2str(deviazione_standard(3))];
        end
        media_tot=media./length(handles.nomeXML);
        media_k(1)=media_tot(2);
        media_k(2)=media_tot(3);
        pathAsl = get(handles.editFile2,'String');
        % leggo il file asl specificato
        [paziente tempo glucosio]=textread(pathAsl,'%s %.1f %.1f','headerlines',1,'delimiter',' ');
        lista_pazienti=unique(paziente);
        %ricavo i parametri dei miei pazienti
         for j=1:length(lista_pazienti)
            posizione_paz_iesimo=find(strcmp(lista_pazienti{j},paziente));
            tempo_paziente=tempo(posizione_paz_iesimo);
            glucosio_paziente=glucosio(posizione_paz_iesimo);
            [w ,res]=lsqcurvefit(@bgp,[20 1.7 3.4],tempo_paziente,glucosio_paziente-glucosio_paziente(1));
            parametriW{j}=w;
            prametriK{j}=[w(2) w(3)];
            % k(1)=w(2);
            % k(2)=w(3);
        end
        % creo report con funzione scrivo_diabete
        scrivo_diabete(codice_ospedale,MEDIA,STD,lista_pazienti,parametriW);
        global fileDaScrivere;
        
        fid = fopen('reportDiabete.xml','w');
        fprintf(fid,'\n%s', fileDaScrivere);
        fclose(fid);
        % visualizzo il nome del file appena creato
        perText = strcat('file creato:',{' '},'reportDiabete.xml');
        set(handles.fileCreatoText,'String',perText);
    else
        % messaggio di errore nel caso in cui non siano stati caricati
        % entrambi i file (ASL e OSP)
        msgbox('bisogna prima caricare entrambi i file ','ERRORE','Error');
    end

function indietro_Callback(hObject, eventdata, handles)
    % link a gui precedente
    close(guiReport);
    myFigure;

function info_Callback(hObject, eventdata, handles)
    %% area informazioni
    helpdlg('Sei nell area dedicata alla creazione dei report relativi alla asl e agli ospedali della asl da inviare alla regione. Per creare il report riguardante le statistiche degli ospedali occorre:   1-caricare, cliccando sul tasto browse in alto, il file relativo alle statistiche di un ospedale ripetendo l operazione per ciascun ospedale;   2-cliccare su crea report spese ospedale in alto a destra. Per creare il report riguardante le statiche dell asl occorre:    1-caricare, cliccando sul tasto browse in basso, il file relativo alle statistiche dell asl;  2-cliccare su crea report spese asl in alto a destra. Per creare il report riguardante lo studio del diabete occorre:    1-Aggiornare la  pagina dei report;    2-caricare, cliccando sul tasto browse in alto, il file relativo al diabete di un ospedale e ripetere l operazione per ciascun ospedale;   3-caricare, cliccando sul tasto browse in basso, il file relativo al diabete della nostra asl;    4-cliccare sul tasto crea report regione diabete, in basso.',...
        'Area informazioni');


function refresh_Callback(hObject, eventdata, handles)
close(guiReport);
guiReport


function browse3_Callback(hObject, eventdata, handles)
    filepath = ' ';
    [file path] = uigetfile('*.xml');
    filepath = strcat(path, file);
    % caricamento della pathname del file con possibilità di caricarne più
    % di una
    set(handles.editFile3,'String',filepath);
        
function leggiPush_Callback(hObject, eventdata, handles)
    filePath = get(handles.editFile3,'String');
    if length(filePath) ~= 0
        leggo_regione(filePath);
    msgbox('File letto!');
    end