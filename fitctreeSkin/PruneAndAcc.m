function ErrTest = PruneAndAcc(decisionTree,Xtr,Ytr,Xts,Yts)

    [n_test,~]=size(Xts);
    [n_train,~]=size(Xtr);
    pruneMax=max(decisionTree.PruneList);
    AccTest=zeros(pruneMax,1);
    ErrTest=zeros(pruneMax,1);
    AccTrain=zeros(pruneMax,1);
    ErrTrain=zeros(pruneMax,1);
    
    for i=0 : pruneMax
        
        TreePruned = prune(decisionTree,'level',i);
        YTestPredict = predict(TreePruned, Xts);
        YTrainPredict = predict(TreePruned, Xtr);
        
        matrixTs(:,1) = YTestPredict;
        matrixTs(:,2) = Yts;
        correctTs = 0;

        for j = 1:n_test
            if matrixTs(j, 1) == matrixTs(j, 2)
                correctTs = correctTs + 1;
            end
        end
        
        matrixTr(:,1) = YTrainPredict;
        matrixTr(:,2) = Ytr;
        correctTr = 0;

        for j = 1:n_train
            if matrixTr(j, 1) == matrixTr(j, 2)
                correctTr = correctTr + 1;
            end
        end
        
        ErrTest(i+1) = (n_test - correctTs)/n_test * 100;
        AccTest(i+1) = correctTs/n_test * 100;
        
        ErrTrain(i+1) = (n_train - correctTr)/n_train * 100;
        AccTrain(i+1) = correctTr/n_train * 100;
    end

    %% Grafico accuratezza
        
    Prunelevels=(0:pruneMax);
    figure, hold on, box on, grid on
    plot(Prunelevels, AccTrain, '-o','MarkerEdgeColor','b','MarkerSize',6)
    plot(Prunelevels, AccTest, '-o','MarkerEdgeColor','r','MarkerSize',6)    
    legend('Training Set','Test Set', 'Location','southoutside','Orientation','horizontal')
    title('Accuratezza dell''algoritmo al variare del livello di pruning')

    %% Grafico errore

    Prunelevels=(0:pruneMax);
    figure, hold on, box on, grid on
    plot(Prunelevels, ErrTrain, '-o','MarkerEdgeColor','b','MarkerSize',6)
    plot(Prunelevels, ErrTest, '-o','MarkerEdgeColor','r','MarkerSize',6)        
    legend('Training Set','Test Set', 'Location','southoutside','Orientation','horizontal')
    title('Errore dell''algoritmo al variare del livello di pruning')
end