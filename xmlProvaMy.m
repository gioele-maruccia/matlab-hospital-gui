matriceRand = randn(3,4);
matrice = com.mathworks.xml.XMLUtils.createDocument('matrice');
radice = matrice.getDocumentElement
% creo elemento radice 
for i=1:3 % riga
        %creo elemento figlio, riga
        rigaFiglio(i) = matrice.createElement('rigaFiglio');
        radice.appendChild(rigaFiglio(i));
    for j = 1:4 
        colonnaFiglio(j) = matrice.createElement('colonnaFiglio');
        rigaFiglio(i).appendChild(colonnaFiglio(j));
        newtext = matrice.createTextNode(num2str(matriceRand(i,j)));
        colonnaFiglio(j).appendChild(newtext);
    end
end
xmlwrite(matrice)