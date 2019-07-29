% questa funzione calcola la media e la DS dei parametri A a b dati in
% entrata, per ogni ospedale
function [media_parametri_cinetici,deviazione_standard]=calcolo_osp_dati(A,a,b)
%creo il vettore A1 che conterra i valori di A traformati in interi per
%poterci fare le varie statistiche, e verifico che le lunghezze dei vettori
%siano tutte uguali
if length(A)~=length(a) && length(a)~=length(b) && length(b)~=length(A)
    msgbox('Errore formato dati, i vettori A,a,b devono avere le stesse dimensioni','ERRORE','Error');
else
    for i=1:length(A)
        A1(i)=str2num(A{i});
        a1(i)=str2num(a{i});
        b1(i)=str2num(b{i});
    end
    media_parametri_cinetici(1)=mean(A1);
    media_parametri_cinetici(2)=mean(a1);
    media_parametri_cinetici(3)=mean(b1);
    deviazione_standard(1)=std(A1);
    deviazione_standard(2)=std(a1);
    deviazione_standard(3)=std(b1);
end






    
    