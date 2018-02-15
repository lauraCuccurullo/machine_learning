function treePruned = prunetree2 (decisionTree, Xtr, Ytr)   
    
    % Creo la struttura del nodo
    treePruned = struct('value', 'null', 'left', 'null', 'right', 'null');
    treePruned.value = decisionTree.value;

    % Costanti
    [c, ~]= size(Xtr);
    
    left = decisionTree.left; 
    right = decisionTree.right;
        
    if (isequal(left.value,'false')||isequal(left.value,'true'))
        treePruned.left = left;
    end
    if (isequal(right.value,'false')||isequal(right.value,'true'))
        treePruned.right=right;         
    end 
    
    if ~(isequal(left.value,'false')||isequal(left.value,'true'))
        treePruned.left = left;
        treePruned.left =prunetree2(decisionTree.left, Xtr, Ytr); 
    end
    if ~(isequal(right.value,'false')||isequal(right.value,'true'))
        treePruned.right=right;
        treePruned.right =prunetree2(decisionTree.right, Xtr, Ytr);           
    end
    
    if ((isequal(treePruned.left.value,'false')||isequal(treePruned.left.value,'true')) && (isequal(treePruned.right.value,'false')||isequal(treePruned.right.value,'true')))
    %qui dovrò controllare il gain
        if isequal(treePruned.left.value, treePruned.right.value)
            treePruned.value= treePruned.left.value;
        else
            [gains, tf] = gaincalc1(Xtr, Ytr, c, decisionTree.value);
                    g=1*(real(gains));
            if g< 0.0001
                %vero o falso?
                treePruned.value = tf;
            end
        end
    end
    
end