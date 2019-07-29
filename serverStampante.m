function varargout = serverStampante(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @serverStampante_OpeningFcn, ...
                   'gui_OutputFcn',  @serverStampante_OutputFcn, ...
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

function serverStampante_OpeningFcn(hObject, eventdata, handles, varargin)
    % creo un axes che si estende per tutta la gui
    ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
    % importo l'immagine di background e la visualizzo sull'axes precedente
    bg = imread('img/homeground.jpg'); imagesc(bg);
    % controllo che l'immagine non si estenda oltre l'axes
    set(ah,'handlevisibility','off','visible','off');
    % porto l'immagine di background "dietro" tutti gli altri oggetti grafici
    % all'interno della gui
    uistack(ah, 'bottom');
    handles.output = hObject;
    guidata(hObject, handles);
    

function varargout = serverStampante_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;


function ricevi_Callback(hObject, eventdata, handles)
    data = client('localhost', 3000)
    set(handles.text2,'String',data);

function print_Callback(hObject, eventdata, handles)
