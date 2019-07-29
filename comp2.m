% equanzioni differenziali relative al sitema compartimentale, dove i
% parametri media_k sono resi globali perchè calcolati in un'altra
% funzione (funzione relativa alla simulazione del modello con i dati OSP)
function dq=comp2(t,q)
dq=zeros(2,1);
global media_k
dq(1)=-media_k(2)*q(1);
dq(2)=-media_k(1)*q(2)+media_k(2)*q(1);