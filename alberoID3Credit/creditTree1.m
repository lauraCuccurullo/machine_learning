clear
close all
clc

%% importo il dataset
filename='creditcard1.txt';
[~, DELIM, NHEADERLINES] = importdata(filename);
dataset = importdata(filename, DELIM, NHEADERLINES);

%%
numberOfTrials=1;
for i=1:numberOfTrials
    %% divido il mio dataset tra train e test
    [n,d]= size(dataset);
    columnOut = size(dataset, 2); % conteggio di tutte le colonne (colonna output Y)
    lengthColX = columnOut - 1; % conteggio di tutte le colonne eccetto l'output (matrice X)

    X = dataset(:,1:lengthColX); % matrice X degli input
    Y = dataset(:,columnOut); % Array Y degli output 

    n_train= floor(0.7*n); %numero tuple train
    n_test= floor(0.3*n); %numero tuple test

    %uso la funzione random per dividerlo ogni volta in modo casuale
    [Xtr, Ytr, Xts, Yts] = randomSplitDataset(X, Y, n_train, n_test);
    
    %% Costruzione dell'albero
    
    ActivAttr = ones(1, d-1);
    [tree] = ID3(Xtr, Ytr, ActivAttr);
    
    fprintf('DECISION TREE STRUCTURE:\n');
    PrintTree(tree, 'root');
    
    %% Valutazione su DecisionTree e matrice di confusione
    
    YTestPredict = predicttree(tree, Xts);
    matrix(:,1) = YTestPredict;
    matrix(:,2) = Yts;
    
    %% Accuratezza
    correct = 0;
    falsenegative=0;
    falsepositive=0;
    count=0;

    for j = 1:n_test
        if matrix(j, 2)==1
            count=count+1;
        end
        if matrix(j, 1) == matrix(j, 2)
            correct = correct + 1;
        elseif (matrix(j, 1)==1 && matrix(j, 2)==0)
            falsepositive=falsepositive+1;
        elseif (matrix(j, 1)==0 && matrix(j, 2)==1)
            falsenegative=falsenegative+1;
        end
        
    end

    wrong = n_test - correct;
    correct_percentage = correct/n_test * 100;
    wrong_percentage = wrong/n_test * 100;

    TrainingSet_percentage = n_train / n * 100;
    TestSet_percentage = n_test / n * 100;
    
    sprintf('Dimensione data set: %d (100 %%)\nDimensione training set: %d (%f %%)\nDimensione test set: %d (%f %%)\n\nTotale elementi classificati correttamente: %d (%f %%)\nTotale elementi classificati NON correttamente: %d (%f %%)\n', n, n_train, TrainingSet_percentage, n_test, TestSet_percentage, correct, correct_percentage, wrong, wrong_percentage)
    sprintf('falsi positivi: %d, falsi negativi: %d, totale positivi %d', falsepositive, falsenegative, count)
    
    %% Potatura dell'albero al livello ottimale e valutazione su albero potato

    TreePruned = prunetree2(tree, Xtr, Ytr);
    fprintf('DECISION TREE STRUCTURE:\n');
    PrintTree(TreePruned, 'root');

    %% Valutazione su DecisionTree e matrice di confusione
    %costruisco il decision tree con il test set
    YTestPrunePredict = predicttree(TreePruned, Xts);

    matrix(:,1) = YTestPrunePredict;
    matrix(:,2) = Yts;

    %% Accuratezza
    correct = 0;

    for j = 1:n_test
        if matrix(j, 1) == matrix(j, 2)
            correct = correct + 1;
        end
    end

    wrong = n_test - correct;
    correct_percentage = correct/n_test * 100;
    wrong_percentage = wrong/n_test * 100;

    TrainingSet_percentage = n_train / n * 100;
    TestSet_percentage = n_test / n * 100;
    
    sprintf('Dimensione data set: %d (100 %%)\nDimensione training set: %d (%f %%)\nDimensione test set: %d (%f %%)\n\nTotale elementi classificati correttamente: %d (%f %%)\nTotale elementi classificati NON correttamente: %d (%f %%)\n', n, n_train, TrainingSet_percentage, n_test, TestSet_percentage, correct, correct_percentage, wrong, wrong_percentage)
    sprintf('falsi positivi: %d, falsi negativi: %d, totale positivi %d', falsepositive, falsenegative, count)
    
end


