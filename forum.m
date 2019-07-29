function varargout = forum(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @forum_OpeningFcn, ...
                   'gui_OutputFcn',  @forum_OutputFcn, ...
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

function forum_OpeningFcn(hObject, eventdata, handles, varargin)
%% apertura gui, imposto sfondo,controllo il tipo di utente
    ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
    bg = imread('img/homeground.jpg'); imagesc(bg);
    set(ah,'handlevisibility','off','visible','off')
    uistack(ah, 'bottom');
    tipoUtente = getappdata(0,'passoTipo')
    if(tipoUtente == 1)
        set(handles.edit1,'Visible','off');
        set(handles.pushbutton1,'visible','off');
    end
    % leggo il file per controllare i testi registrati nel forum
    [utenteTesto dateTime] = textread('forum.txt','%s %s','delimiter','_');
    testoPiuTime = strcat(dateTime,':',{'     '},utenteTesto);
    set(handles.listbox1,'String',testoPiuTime);
    %porto la scrollbar all'ultimo elemento
    numRighe = length(testoPiuTime)
    set(handles.listbox1,'Value',numRighe);
    handles.output = hObject;
    guidata(hObject, handles);

function varargout = forum_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;

function listbox1_Callback(hObject, eventdata, handles)
    indiceEvento = get(handles.listbox1,'Value');

function listbox1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function pushbutton1_Callback(hObject, eventdata, handles)
    cf = getappdata(0,'passoCf')
    testo = get(handles.edit1,'String')
    userTestoClock = strcat(upper(cf),{': '},testo,'_',datestr(clock,0))
    if(length(testo)==0)
        msgbox('Nessun messaggio','ERRORE','Error');
    else
        fid = fopen('forum.txt','a')
        fprintf(fid,'\n%s',userTestoClock{1});
        fclose(fid)
        forum
    end
