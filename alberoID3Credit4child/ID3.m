function [tree] = ID3(Xtr, Ytr, activeAttr)

if (isempty(Xtr))
    error('è necessario fornire un dataset');
end

% Costanti
[numberExamples, numberAttributes]= size(Xtr);

% Creo la struttura del nodo
tree = struct('value', 'null','left', 'null','leftcenter', 'null','rightcenter','null','right','null');

%conto il totale tuple e in numero di veri e falsi
c=0;numTrue=0;
for i=1:numberExamples
    if (Xtr(i))
        c=c+1;
        if(Ytr(i)==1)
            numTrue=numTrue+1;
        end
    end
end
numFalse=c-numTrue;

% Se tutte le righe hanno value 1 avrò tutto 1
lastColumnSum = sum(Ytr);
if (lastColumnSum == c)
    tree.value = 'true';
    return
end
%se sono tutte 0 avrò 0
if(lastColumnSum == 0)
    tree.value = 'false';
    return
end

% Se non ho più attributi attivi restituisco l'albero con il value più
% comune
if (sum(activeAttr) == 0)
    if (numTrue > numFalse)
        tree.value = 'true';
    else
        tree.value = 'false';
    end
    return
end

gains = gaincalc(Xtr, Ytr, c, lastColumnSum, numberAttributes, activeAttr);

% Prendo l'attributo che massimizza il gain
[~, bestAttribute] = max(gains);
% Setto tree.value all'attributo migliore appena trovato
tree.value = num2str(bestAttribute);
% Rimuovo il precedente attributo di split
activeAttr(bestAttribute) = 0;

% Inizializzo e creo le nuove matrici
Xtr_0 = zeros(c,numberAttributes); 
Ytr_0 = zeros(c,1); 
Xtr_0_index = 1;

Xtr_1 = zeros(c,numberAttributes);
Ytr_1 = zeros(c,1); 
Xtr_1_index = 1;

Xtr_2 = zeros(c,numberAttributes);
Ytr_2 = zeros(c,1); 
Xtr_2_index = 1;

Xtr_3 = zeros(c,numberAttributes);
Ytr_3 = zeros(c,1); 
Xtr_3_index = 1;

s1=0; s0=0;s2=0;s3=0;


for i=1:c
    if (Xtr(i, bestAttribute)>=0) 
        s1=sum(Xtr(i, :));
        Xtr_1(Xtr_1_index, :) = Xtr(i, :); 
        Ytr_1(Xtr_1_index)= Ytr(i);
        Xtr_1_index = Xtr_1_index + 1;
    elseif(Xtr(i, bestAttribute)>=-0.25)
        s2=sum(Xtr(i, :));        
        Xtr_2(Xtr_2_index, :) = Xtr(i, :);
        Ytr_2(Xtr_2_index)= Ytr(i);
        Xtr_2_index = Xtr_2_index + 1;
    elseif (Xtr(i,bestAttribute)>-0.5)
        s3=sum(Xtr(i, :));        
        Xtr_3(Xtr_3_index, :) = Xtr(i, :);
        Ytr_3(Xtr_3_index)= Ytr(i);
        Xtr_3_index = Xtr_3_index + 1;
    else
        s0=sum(Xtr(i, :));        
        Xtr_0(Xtr_0_index, :) = Xtr(i, :);
        Ytr_0(Xtr_0_index)= Ytr(i);
        Xtr_0_index = Xtr_0_index + 1;
    end
    
end

% Se Xtr_0 è vuoto aggiungo un nodo foglia a sinistra
if (isempty(Xtr_0) || s0==0)
    leaf = struct('value', 'null','left', 'null','leftcenter', 'null','rightcenter','null', 'right', 'null');
    if (numTrue>numFalse) % for matrix examples
        leaf.value = 'true';
    else
        leaf.value = 'false';
    end
    tree.left = leaf;
else
    % Chiamata ricorsiva
    tree.left = ID3(Xtr_0, Ytr_0, activeAttr);
end

% Se Xtr_2 è vuoto aggiungo un nodo foglia in centro
if (isempty(Xtr_2) || s2==0)
    leaf = struct('value', 'null','left', 'null','leftcenter', 'null','rightcenter','null', 'right', 'null');
    if (numTrue>numFalse) 
        leaf.value = 'true';
    else
        leaf.value = 'false';
    end
    tree.leftcenter = leaf;
else
    % Chiamata ricorsiva
    tree.leftcenter = ID3(Xtr_2, Ytr_2, activeAttr);
end

% Se Xtr_3 è vuoto aggiungo un nodo foglia in centro
if (isempty(Xtr_3) || s3==0)
    leaf = struct('value', 'null','left', 'null','leftcenter', 'null','rightcenter','null', 'right', 'null');
    if (numTrue>numFalse) 
        leaf.value = 'true';
    else
        leaf.value = 'false';
    end
    tree.rightcenter = leaf;
else
    % Chiamata ricorsiva
    tree.rightcenter = ID3(Xtr_3, Ytr_3, activeAttr);
end

% Se Xtr_1 è vuoto aggiungo un nodo foglia a destra
if (isempty(Xtr_1) || s1==0)
    leaf = struct('value', 'null','left', 'null','leftcenter', 'null','rightcenter','null', 'right', 'null');
    if (numTrue>numFalse) % for matrix examples
        leaf.value = 'true';
    else
        leaf.value = 'false';
    end
    tree.right = leaf;
else
    % Chiamata ricorsiva
    tree.right = ID3(Xtr_1, Ytr_1, activeAttr);
end

return
end