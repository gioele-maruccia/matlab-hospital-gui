% script che colora in giallo il giorno attuale
%annoHandle = get(handles.anno,'String')
giornoNow = dateNow(1:2);
switch giornoNow
    case '01'
        set(handles.pushbutton01,'background',[1 1 0.70])
    case '02'
        set(handles.pushbutton02,'background',[1 1 0.70])
    case '03'
        set(handles.pushbutton03,'background',[1 1 0.70])
    case '04'
        set(handles.pushbutton04,'background',[1 1 0.70])
    case '05'
        set(handles.pushbutton05,'background',[1 1 0.70])
    case '06'
        set(handles.pushbutton06,'background',[1 1 0.70])
    case '07'
        set(handles.pushbutton07,'background',[1 1 0.70])
    case '08'
        set(handles.pushbutton08,'background',[1 1 0.70])
    case '09'
        set(handles.pushbutton09,'background',[1 1 0.70])
     case '10'
        set(handles.pushbutton10,'background',[1 1 0.70])
    case '11'
        set(handles.pushbutton11,'background',[1 1 0.70])
    case '12'
        set(handles.pushbutton12,'background',[1 1 0.70])
     case '13'
        set(handles.pushbutton13,'background',[1 1 0.70])
    case '14'
        set(handles.pushbutton14,'background',[1 1 0.70])
    case '15'
        set(handles.pushbutton15,'background',[1 1 0.70])
    case '16'
        set(handles.pushbutton16,'background',[1 1 0.70])
    case '17'
        set(handles.pushbutton17,'background',[1 1 0.70])
    case '18'
        set(handles.pushbutton18,'background',[1 1 0.70])
    case '19'
        set(handles.pushbutton19,'background',[1 1 0.70])
    case '20'
        set(handles.pushbutton20,'background',[1 1 0.70])
    case '21'
        set(handles.pushbutton21,'background',[1 1 0.70])
     case '22'
        set(handles.pushbutton22,'background',[1 1 0.70])
    case '23'
        set(handles.pushbutton23,'background',[1 1 0.70])
    case '24'
        set(handles.pushbutton24,'background',[1 1 0.70])
     case '25'
        set(handles.pushbutton25,'background',[1 1 0.70]) 
     case '26'
        set(handles.pushbutton26,'background',[1 1 0.70])
     case '27'
        set(handles.pushbutton27,'background',[1 1 0.70])
     case '28'
        set(handles.pushbutton28,'background',[1 1 0.70])   
    case '29'
        set(handles.pushbutton29,'background',[1 1 0.70])
        case '30'
        set(handles.pushbutton30,'background',[1 1 0.70])
        case '31'
        set(handles.pushbutton31,'background',[1 1 0.70])
end