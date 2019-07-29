% calcolo etaMin ed etaMax
function [etaMin etaMax] = etaMaxMin(eta)
    eta = eta(find(eta>0 & eta<100));
    etaMin = min(eta);
    etaMax = max(eta)+1;
end