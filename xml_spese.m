report = com.mathworks.xml.XMLUtils.createDocument('report')
radice = report.getDocumentElement
nostroAsl = '70001';

spese_tot=[134];
tot_prest=[12];

ricetta=[11 23 34];

importo_branca=[12.43 6777 89];

asl=report.createElement('asl')
radice.appendChild(asl)
asl.setAttribute('codice_asl',nostroAsl)
spesa=report.createElement('spesa')
asl.appendChild(spesa)
newtext1=report.createTextNode(num2str(spese_tot))
spesa.appendChild(newtext1)
numero_prestazioni=report.createElement('numero_prestazioni')
asl.appendChild(numero_prestazioni)
newtext2=report.createTextNode(num2str(tot_prest))
numero_prestazioni.appendChild(newtext2)
for j=1:length(ricetta)
    ric=ricetta;
    imp=importo_branca;
    branca_ricetta(j)=report.createElement('branca_ricetta')
    branca_ricetta(j).setAttribute('codice_branca',num2str(ric(j)))
    asl.appendChild(branca_ricetta(j))
    importo=report.createElement('importo')
    branca_ricetta(j).appendChild(importo)
    newtext3=report.createTextNode(num2str(imp(j)))
    importo.appendChild(newtext3)
end

xmlwrite(report)