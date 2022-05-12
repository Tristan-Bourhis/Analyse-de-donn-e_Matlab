% PRACTICE 5: CLUSTERING
% Data analysis

%% LEARNING OBJECTIVES
%  - How to carry out Hierarchical clustering (using linkage and dendrogram)
%  - How to interpret a dendrogram
%  - How to run k-means (using kmeans)
%  - How to select the number K of clusters 

%% LOAD THE DATA FROM FILE (EACH TEMPERATURE VARIABLE IS A DIFERENT COLUMN)
clear all
close all
infomat =load ('customers.mat'); %faster load
td = infomat.td;

%% BASIC EXPLORATORY ANALYSIS OF THE DATA
disp('Initial table (detail):'); disp(td(1:5,:));
summary(td)

figure; 
indAmount = [2:5];
indNumber = [6:9];
ax(1)=subplot(2,1,1);plot(td{:,indAmount}');title ('Amount');
ax(1)=subplot(2,1,2);plot(td{:,indNumber}');title ('Amount');

Xall=td{:,indAmount};
figure;
[~,ax]=plotmatrix(Xall);
ax(4,1).XLabel.String='2011';
ax(1,1).YLabel.String='2011';
ax(4,2).XLabel.String='2012';
ax(2,1).YLabel.String='2012';
ax(4,3).XLabel.String='2013';
ax(3,1).YLabel.String='2013';
ax(4,4).XLabel.String='2014';
ax(4,1).YLabel.String='2014';

disp('covariance matrix:');disp(cov(Xall));
disp('correlation matrix:');disp(corr(Xall));

%% HIERARCHICAL CLUSTERING OF VARIABLES 

% PREPARE DATA FOR HIERARCHICAL CLUSTERING 
nomInputVars = td.Properties.VariableNames(indAmount);
customers = td.customer_id>=1000 & td.customer_id<=9000;
X = td{customers, nomInputVars}; % matrix n x p
fprintf('Num customers selected: %d\n', sum(customers));
c = corr(X); fprintf('Correlation between first 2 vars: %f\n', c(1,2));

% Plot global view of the original data
figure;plot(X); legend(nomInputVars); grid on;
figure;boxplot(X, 'Labels', nomInputVars , 'notch','on', 'orientation','horizontal'); 

%create the tree
tree = linkage(X','average', 'correlation');

%plot with a threshold
figure;
hdg = dendrogram(tree, 'ColorThreshold','default', 'Labels', nomInputVars);
set(hdg,'LineWidth',2); grid minor;

figure;
hdg = dendrogram(tree, 'ColorThreshold',0.75, 'Labels', nomInputVars);
set(hdg,'LineWidth',2); grid minor;

%% KMEANS CLUSTERING OF OBSERVATIONS (2 VARIABLES)

% idx = kmeans(X,k) performs k-means clustering to partition the
% observations of the n-by-p data matrix X into k clusters, and returns an
% n-by-1 vector (idx) containing cluster indices of each observation. Rows
% of X correspond to points and columns correspond to variables. By
% default, kmeans uses the squared Euclidean distance measure and the
% k-means++ algorithm for cluster center initialization.

% PREPARE DATA FOR KMEANS 
nomInputVars = {'tran_amount_2013' 'tran_amount_2014'};
customers = td.customer_id>=1000 & td.customer_id<=9000;
X = td{customers, nomInputVars}; % matrix n x p
fprintf('Num customers selected: %d\n', sum(customers));
c = corr(X); fprintf('Correlation between first 2 vars: %f\n', c(1,2));

figure;
plot(X(:,1), X(:,2), '.', 'Markersize',10);
xlabel(nomInputVars(1));ylabel(nomInputVars(2)); 

% Run 100 replicates of kmeans and select the best
rng('default'); % For reproducibility
K=3;
[idx, ctrs,sumd] = kmeans(X,K,'replicates',100);

% plot clusters
figure;hold all;grid on; axis square;
scatter(X(:,1), X(:,2),40,idx,'filled');
scatter(ctrs(:,1),ctrs(:,2),200,'filled'); %centroids
title(sprintf('QE(K=%d)=%3.1f (100 replicates)',K,sum(sumd)));
xlabel(nomInputVars(1));ylabel(nomInputVars(2)); 

%SELECT K
Kini=1; Kfin=7;
%Quantization error
qe=[];
for K = Kini:Kfin
    [~, ~, sumd] = kmeans(X, K, 'replicates',100);
    qe(K)=sum(sumd);
end
figure; bar(qe);axis tight;
xlabel('K'); ylabel('QE'); grid on;

%% KMEANS CLUSTERING OF OBSERVATIONS (SEVERAL VARIABLES)

% PREPARE DATA FOR KMEANS 
nomInputVars = td.Properties.VariableNames(indAmount);
customers = td.customer_id>=1000 & td.customer_id<=9000;
X = td{customers, nomInputVars}; % matrix n x p
fprintf('Num customers selected: %d\n', sum(customers));
c = corr(X); fprintf('Correlation between first 2 vars: %f\n', c(1,2));

% Run 100 replicates of kmeans and select the best
rng('default'); % For reproducibility
K=3;
[idx, ctrs,sumd] = kmeans(X,K,'replicates',100);


% Patterns given by the centroids
figure; hold on;
plot(ctrs','-s','linewidth',3,'Markersize',4);
set(gca,'xtick',1:length(nomInputVars)); set(gca,'xticklabel',nomInputVars);
ylabel('Amount');grid minor;
legend(strcat('CLUSTER-', num2str([1:K]')));
title ('Cluster prototypes (centroids)');

%add days of each cluster
figure; hold on; colors = hsv(K); hp1=[];
for i=1:K
    hpaux=plot([X(idx==i,:)]', 'color', colors(i,:));
    hp1(i) = hpaux(1);
end
hp2=plot(ctrs','-s','linewidth',5,'Markersize',8);
set(gca,'xtick',1:length(nomInputVars)); set(gca,'xticklabel',nomInputVars);
ylabel('Amount');grid minor;
title ('Data and Cluster prototypes (centroids)');
legend([hp1'; hp2], [strcat('CLUSTER -', num2str([1:K]')); strcat('CENTROID-', num2str([1:K]'))]);

