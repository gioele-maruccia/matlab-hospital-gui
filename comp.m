% equazioni differenziali relative al sistema compartimentale, dove i
% parametri k sono resi globali sono resi globali perchè calcolati in
% un'altra funzione (utilizzata nella ode23 sui dati ASL)
function dq=comp(t,q)
dq=zeros(2,1);
global k;
global D;
dq(1)=-k(2)*q(1);
dq(2)=-k(1)*q(2)+k(2)*q(1);

