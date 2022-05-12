% PRACTICE 2: CLASSIFICATION
% Telco churn

%% LEARNING OBJECTIVES
%  - How to build the training and test sets
%  - How to fit a classification tree
%  - How to fit a linear discriminant analysis model
%  - How to review the models in terms of errors
%  - How to select a good compromise between complexity and test error rate

% https://www.kaggle.com/blastchar/telco-customer-churn

clear all
close all

%% LOAD THE DATA FROM EXCEL FILE AND PREPARE FOR ANALYSIS
infomat =load ('telcoChurn.mat'); %faster load
td = infomat.td;

%% SEPARATE IN TRAINING AND TEST

% Cross validation (train: 70%, test: 30%)
rng('default'); % for reproductivity
cv = cvpartition(size(td,1),'HoldOut',0.3);
idx = cv.test;

% Separate to training and test data
tdTrain = td(~idx,:);
tdTest = td(idx,:);

%% BASIC EXPLORATORY ANALYSIS OF THE DATA
summary(td)

p02Plotcrosstab(tdTrain, {'gender', 'SeniorCitizen', 'Partner', 'Dependents', 'PhoneService', ...
                          'MultipleLines', 'InternetService', 'OnlineSecurity', 'OnlineBackup'}, 'Churn');

p02Plotcrosstab(tdTrain, {'DeviceProtection', 'TechSupport', 'StreamingTV', 'StreamingMovies', ...
                          'Contract','PaperlessBilling','PaymentMethod','MultipleLines', 'OnlineBackup'}, 'Churn');

%distribution with month and season
figure;
subplot(3,1,1);
boxplot(tdTrain.tenure,tdTrain.Churn);
xlabel('Churn');ylabel('Tenure');
subplot(3,1,2);
boxplot(tdTrain.TotalCharges,tdTrain.Churn);
xlabel('Churn');ylabel('Total charges');
subplot(3,1,3);
boxplot(tdTrain.MonthlyCharges,tdTrain.Churn);
xlabel('Churn');ylabel('Monthly charges');

figure
idx = tdTrain.Churn=='Yes';
plot(tdTrain.tenure(idx), tdTrain.MonthlyCharges(idx), 'rx', ...
     tdTrain.tenure(~idx), tdTrain.MonthlyCharges(~idx), 'b.');
xlabel('Tenure')
ylabel('Montly charges')

%% CLASSIFICATION TREE

% FIRST: Fit a very large model (a full expanded tree) an its prunning sequence
modelSpecif = 'Churn~SeniorCitizen+Partner+Dependents+InternetService+OnlineSecurity+OnlineBackup+DeviceProtection+TechSupport+StreamingTV+StreamingMovies+Contract+PaperlessBilling+PaymentMethod';
treeIni = fitctree(tdTrain, modelSpecif, 'SplitCriterion','deviance', 'MinParentSize', 10); %deviance: "decrease entropy"

% show the tree
view(treeIni,'mode','graph');

% Plot confussion matrix training and test
p02PlotConfusionMatrix(treeIni, tdTrain, {'No' 'Yes'}, 'Training full tree:');
p02PlotConfusionMatrix(treeIni, tdTest, {'No' 'Yes'}, 'Test full tree:');

% Explore subtrees
[lTR,seTR,nLeafTR] = loss(treeIni,tdTrain, 'Churn', 'Subtrees', 'all', 'LossFun','classiferror');
[lTS,seTS,nLeafTS] = loss(treeIni,tdTest, 'Churn', 'Subtrees', 'all', 'LossFun','classiferror');

figure;hold on;
plot(0:max(treeIni.PruneList), lTR,'.-');
plot(0:max(treeIni.PruneList), lTS,'.-');
set(gca,'Xdir','reverse');
xlabel('Pruning level (0 node = full tree)'); grid on;
legend('Training', 'Test'); ylabel('Error rate');
disp(['Constant classifier error rate=' num2str(sum(tdTrain.Churn=='Yes')/length(tdTrain.Churn))])

%% Tree pruning
optPrunLevel = 29;

treeOpt = prune(treeIni,'Level', optPrunLevel);
view(treeOpt,'mode','graph');

p02PlotConfusionMatrix(treeOpt, tdTrain, {'No' 'Yes'}, 'Training simple tree:');
p02PlotConfusionMatrix(treeOpt, tdTest, {'No' 'Yes'}, 'Test simple tree:');

%% LINEAR AND QUADRATIC DISCRIMINANT ANALYSIS

%fit the LDA model and plot confussion matrix TR and TS
lda = fitcdiscr(tdTrain, 'Churn~tenure+MonthlyCharges');

p02PlotInputSpacePartition(lda);
p02PlotConfusionMatrix(lda, tdTrain, {'No' 'Yes'}, 'Training LDA:');
p02PlotConfusionMatrix(lda, tdTest, {'No' 'Yes'}, 'Test LDA:');

%see the coefs
disp(lda)
disp(lda.Mu);
disp(lda.Sigma);

%fit the QDA model (use DiscrimType property)
qda = fitcdiscr(tdTrain, 'Churn~tenure+MonthlyCharges', 'DiscrimType','quadratic');

p02PlotInputSpacePartition(qda);
p02PlotConfusionMatrix(qda, tdTrain, {'No' 'Yes'}, 'Training QDA:');
p02PlotConfusionMatrix(qda, tdTest, {'No' 'Yes'}, 'Test QDA:');

%see the coefs
disp(qda.Mu)
disp(qda.Sigma)
