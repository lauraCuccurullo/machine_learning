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
    if (Ytr(i))
        c=c+1;
        if(Ytr(i)==2)
            numTrue=numTrue+1;
        end
    end
end
numFalse=c-numTrue;

% Se tutte le righe hanno value 2 son tutte pelle
lastColumnSum = sum(Ytr);
if (lastColumnSum == (c*2))
    tree.value = 'true';
    return
end
%se sono tutte 1 avrò che nessuna è pelle
if(lastColumnSum == c)
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

% Calcolo l'entropia attuale
p1 = numTrue / c;
if (p1 == 0)
    p1_eq = 0;
else
    p1_eq = -1*p1*log2(p1);
end
p0 = numFalse / c;
if (p0 == 0)
    p0_eq = 0;
else
    p0_eq = -1*p0*log2(p0);
end
currentEntropy = p1_eq + p0_eq;
% Trovo l'attributo che massimizza l'information gain
gains = zeros(1,numberAttributes); 
%Ciclo in cui aggiorno l'info gain
for i=1:numberAttributes
    if (activeAttr(i)) % per ogni attributo attivo aggiorno il gain
        s0 = 0; s0_and_true = 0;
        s1 = 0; s1_and_true = 0;
        s2 = 0; s2_and_true = 0;
        s3 = 0; s3_and_true = 0;
        
        for j=1:c
            %qua divido il mio attributo
            if (Xtr(j,i)>191)
                s1 = s1 + 1;
                if (Ytr(j)==2)
                    s1_and_true = s1_and_true + 1;
                end
            elseif (Xtr(j,i)>128)
                s2 = s2 + 1;
                if (Ytr(j)==2)
                    s2_and_true = s2_and_true + 1;
                end
            elseif (Xtr(j,i)>65)
                s3 = s3 + 1;
                if (Ytr(j)==2)
                    s3_and_true = s3_and_true + 1;
                end
            else
                s0 = s0 + 1;
                if (Ytr(j)==2)
                    s0_and_true = s0_and_true + 1;
                end
            end
        end
        
        % Ricalcolo l'entropia per S(v>170)
        if (~s1)
            p1 = 0;
        else
            p1 = (s1_and_true / s1); 
        end
        if (p1 == 0)
            p1_eq = 0;
        else
            p1_eq = -1*(p1)*log2(p1);
        end
        if (~s1)
            p0 = 0;
        else
            p0 = ((s1 - s1_and_true) / s1);
        end
        if (p0 == 0)
            p0_eq = 0;
        else
            p0_eq = -1*(p0)*log2(p0);
        end
        entropy_s1 = p1_eq + p0_eq;
        
        %ricalcolo per v tra 85 e 170
        if (~s2)
            p1 = 0;
        else
            p1 = (s2_and_true / s2); 
        end
        if (p1 == 0)
            p1_eq = 0;
        else
            p1_eq = -1*(p1)*log2(p1);
        end
        if (~s2)
            p0 = 0;
        else
            p0 = ((s2 - s2_and_true) / s2);
        end
        if (p0 == 0)
            p0_eq = 0;
        else
            p0_eq = -1*(p0)*log2(p0);
        end
        entropy_s2 = p1_eq + p0_eq;
        
        %ricalcolo per v tra 
        if (~s3)
            p1 = 0;
        else
            p1 = (s3_and_true / s3); 
        end
        if (p1 == 0)
            p1_eq = 0;
        else
            p1_eq = -1*(p1)*log2(p1);
        end
        if (~s3)
            p0 = 0;
        else
            p0 = ((s3 - s3_and_true) / s3);
        end
        if (p0 == 0)
            p0_eq = 0;
        else
            p0_eq = -1*(p0)*log2(p0);
        end
        entropy_s3 = p1_eq + p0_eq;
        
        % Ricalcolo l'entropia per S(v<100)
        if (~s0)
            p1 = 0;
        else
            p1 = (s0_and_true / s0); 
        end
        if (p1 == 0)
            p1_eq = 0;
        else
            p1_eq = -1*(p1)*log2(p1);
        end
        if (~s0)
            p0 = 0;
        else
            p0 = ((s0 - s0_and_true) / s0);
        end
        if (p0 == 0)
            p0_eq = 0;
        else
            p0_eq = -1*(p0)*log2(p0);
        end
        entropy_s0 = p1_eq + p0_eq;
        
        gains(i) = currentEntropy - ((s1/c)*entropy_s1) - ((s3/c)*entropy_s3) - ((s0/c)*entropy_s0) -((s2/c)*entropy_s2);
    end
end

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

s1=0; s0=0;s2=0; s3=0;

for i=1:c
    if (Xtr(i, bestAttribute)>191)
        s1=sum(Xtr(i, :));
        Xtr_1(Xtr_1_index, :) = Xtr(i, :); 
        Ytr_1(Xtr_1_index)= Ytr(i);
        Xtr_1_index = Xtr_1_index + 1;
    elseif (Xtr(i,bestAttribute)>128 && Xtr(i,bestAttribute)<191)
        s2=sum(Xtr(i, :));        
        Xtr_2(Xtr_2_index, :) = Xtr(i, :);
        Ytr_2(Xtr_2_index)= Ytr(i);
        Xtr_2_index = Xtr_2_index + 1;
    elseif (Xtr(i,bestAttribute)>65 && Xtr(i,bestAttribute)<128)
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
    leaf = struct('value', 'null', 'left', 'null','leftcenter', 'null','rightcenter','null', 'right', 'null');
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
    leaf = struct('value', 'null', 'left', 'null','leftcenter', 'null','rightcenter','null', 'right', 'null');
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
    if (numTrue>numFalse) 
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