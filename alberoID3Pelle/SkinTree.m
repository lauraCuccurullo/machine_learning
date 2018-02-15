clear
close all
clc

%% importo il dataset
filename='Skin_NonSkin.txt';
[~, DELIM, NHEADERLINES] = importdata(filename);
dataset = importdata(filename, DELIM, NHEADERLINES);

%%
numberOfTrials=5;
correct = 0;
falsenegative=0;
falsepositive=0;
count=0;
wrong = 0;
correct_percentage = 0;
wrong_percentage = 0;
    
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
    [decisionTree] = ID3(Xtr, Ytr, ActivAttr);
    
    fprintf('DECISION TREE STRUCTURE:\n');
    PrintTree(decisionTree, 'root');
    
    %% Valutazione su DecisionTree e matrice di confusione
    
    YTestPredict = predicttree(decisionTree, Xts);
    matrix(:,1) = YTestPredict;
    matrix(:,2) = Yts;
    %% Accuratezza
    
    cor=0;
    for j = 1:n_test
        if matrix(j, 2)==1
            count=count+1;
        end
        if matrix(j, 1) == matrix(j, 2)
            cor = cor + 1;
        elseif (matrix(j, 1)==2 && matrix(j, 2)==1)
            falsepositive=falsepositive+1;
        elseif (matrix(j, 1)==1 && matrix(j, 2)==2)
            falsenegative=falsenegative+1;
        end
        
    end
    correct = correct+cor;
    wrong = wrong + n_test - cor;
    correct_percentage = correct_percentage + cor/n_test * 100;
    wrong_percentage = wrong_percentage + (n_test-cor)/n_test * 100;

    TrainingSet_percentage = n_train / n * 100;
    TestSet_percentage = n_test / n * 100;
    
    %% Potatura dell'albero al livello ottimale e valutazione su albero potato

    TreePruned = prunetree2(decisionTree, Xtr, Ytr);
    fprintf('DECISION TREE STRUCTURE:\n');
    PrintTree(TreePruned, 'root');

    %% Valutazione su DecisionTree e matrice di confusione
    %costruisco il decision tree con il training set
%     YTestPrunePredict = predicttree(TreePruned, Xts);
% 
%     matrix(:,1) = YTestPrunePredict;
%     matrix(:,2) = Yts;
% 
%     %% Accurate
%     correctP = 0;
%     falsenegativeP=0;
%     falsepositiveP=0;
%     count=0;
% 
%     for j = 1:n_test
%         if matrix(j, 2)==1
%             count=count+1;
%         end
%         if matrix(j, 1) == matrix(j, 2)
%             correctP = correctP + 1;
%         elseif (matrix(j, 1)==2 && matrix(j, 2)==1)
%             falsepositiveP=falsepositiveP+1;
%         elseif (matrix(j, 1)==1 && matrix(j, 2)==2)
%             falsenegativeP=falsenegativeP+1;
%         end    
%     end
% 
%     wrongP = n_test - correctP;
%     correct_percentageP = correctP/n_test * 100;
%     wrong_percentageP = wrongP/n_test * 100;
% 
%     TrainingSet_percentageP = n_train / n * 100;
%     TestSet_percentageP = n_test / n * 100;
%     
%     sprintf('Dimensione data set: %d (100 %%)\nDimensione training set: %d (%f %%)\nDimensione test set: %d (%f %%)\n\nTotale elementi classificati correttamente: %d (%f %%)\nTotale elementi classificati NON correttamente: %d (%f %%)\n', n, n_train, TrainingSet_percentageP, n_test, TestSet_percentageP, correctP, correct_percentageP, wrongP, wrong_percentageP)
%     sprintf('falsi positivi: %d, falsi negativi: %d, totale positivi %d', falsepositiveP, falsenegativeP, count)
%    
end

correct = correct/numberOfTrials;
falsenegative=falsenegative/numberOfTrials;
falsepositive=falsepositive/numberOfTrials;

wrong = wrong/numberOfTrials;
correct_percentage = correct_percentage/numberOfTrials;
wrong_percentage = 100-correct_percentage;

sprintf('Dimensione data set: %d (100 %%)\nDimensione training set: %d (%f %%)\nDimensione test set: %d (%f %%)\n\nTotale elementi classificati correttamente: %.0f (%f %%)\nTotale elementi classificati NON correttamente: %.0f (%f %%)\n', n, n_train, TrainingSet_percentage, n_test, TestSet_percentage, correct, correct_percentage, wrong, wrong_percentage)
sprintf('falsi positivi: %.0f, falsi negativi: %.0f, totale positivi %.0f', falsepositive, falsenegative, count)
    