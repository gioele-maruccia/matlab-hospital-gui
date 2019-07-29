% funzione che descrive la cinetica della variazione di glucosio nel
% sistema compartimentale
function y=bgp(w,t)
y=w(1)*(exp(-w(2)*t)-exp(-w(3)*t));



