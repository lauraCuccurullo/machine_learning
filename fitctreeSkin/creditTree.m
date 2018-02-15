clear
close all
clc

%% importo il dataset
filename='Skin_NonSkin.txt';
[~, DELIM, NHEADERLINES] = importdata(filename);
dataset = importdata(filename, DELIM, NHEADERLINES);

%% divido il mio dataset tra train e test
[n,d]= size(dataset);
columnOut = size(dataset, 2); % conteggio di tutte le colonne (colonna output Y)
lengthColX = columnOut - 1; % conteggio di tutte le colonne eccetto l'output (matrice X)

X = dataset(:,1:lengthColX); % matrice X degli input
Y = dataset(:,columnOut); % Array Y degli output 

n_train= floor(0.80*n); %numero tuple train
n_test= floor(0.20*n); %numero tuple test

%uso la funzione random per dividerlo ogni volta in modo casuale
[Xtr, Ytr, Xts, Yts] = randomSplitDataset(X, Y, n_train, n_test);

%% Costruzione dell'albero e calcolo entropia

decisionTree = fitctree(Xtr,Ytr);
view(decisionTree,'Mode','graph');

%% Valutazione su DecisionTree e matrice di confusione
%costruisco il decision tree con il training set
YTestPredict = predict(decisionTree, Xts);

matrix(:,1) = YTestPredict;
matrix(:,2) = Yts;

%% Accuratezza
correct = 0;

for i = 1:n_test
    if matrix(i, 1) == matrix(i, 2)
        correct = correct + 1;
    end
end

wrong = n_test - correct;
correct_percentage = correct/n_test * 100;
wrong_percentage = wrong/n_test * 100;

TrainingSet_percentage = n_train / n * 100;
TestSet_percentage = n_test / n * 100;

sprintf('Dimensione data set: %d (100 %%)\nDimensione training set: %d (%f %%)\nDimensione test set: %d (%f %%)\n\nTotale elementi classificati correttamente: %d (%f %%)\nTotale elementi classificati NON correttamente: %d (%f %%)\n', n, n_train, TrainingSet_percentage, n_test, TestSet_percentage, correct, correct_percentage, wrong, wrong_percentage)

%% Potatura

ErrTest = PruneAndAcc(decisionTree,Xtr, Ytr,Xts, Yts);
[err,locErr] = min(ErrTest);    % err = errore minimo; locErr = indice dell'errore minimo

%% Potatura dell'albero al livello ottimale e valutazione su albero potato

TreePruned = prune(decisionTree,'level',locErr - 1);
view(TreePruned,'Mode','graph');

%% Valutazione su DecisionTree e matrice di confusione
%costruisco il decision tree con il training set
YTestPrunePredict = predict(TreePruned, Xts);

matrix(:,1) = YTestPrunePredict;
matrix(:,2) = Yts;

%% Accuratezza
correct = 0;

for i = 1:n_test
    if matrix(i, 1) == matrix(i, 2)
        correct = correct + 1;
    end
end

wrong = n_test - correct;
correct_percentage = correct/n_test * 100;
wrong_percentage = wrong/n_test * 100;

TrainingSet_percentage = n_train / n * 100;
TestSet_percentage = n_test / n * 100;
