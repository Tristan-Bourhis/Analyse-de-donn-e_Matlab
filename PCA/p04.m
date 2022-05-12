% PRACTICE 4: PCA
% Data analysis

%% LEARNING OBJECTIVES
%  - How to carry out PCA (using function pca)
%  - How to carry out interpret PCA results (using scree plots and loadings)

%% LOAD THE DATA FROM FILE
clear all
close all
infomat =load ('forex.mat'); %faster load
td = infomat.td;
td.DATE = datetime(td.DATE_TIME,'InputFormat','yyyy.MM.dd HH:mm:SS');

%% BASIC EXPLORATORY ANALYSIS OF THE DATA
disp('Initial table (detail):'); disp(td(1:5,:));

%auxiliary variables for easy data management
varnames = td.Properties.VariableNames;
varnames{2}=varnames{2}(12:end);
varnames{3}=varnames{3}(12:end);
varnames{4}=varnames{4}(12:end);
varnames{5}=varnames{5}(12:end);
varnames{6}=varnames{6}(12:end);

figure; 
[~,ax]=plotmatrix(td{:,2:6});
ax(5,1).XLabel.String=varnames{2};
ax(1,1).YLabel.String=varnames{2};
ax(5,2).XLabel.String=varnames{3};
ax(2,1).YLabel.String=varnames{3};
ax(5,3).XLabel.String=varnames{4};
ax(3,1).YLabel.String=varnames{4};
ax(5,4).XLabel.String=varnames{5};
ax(4,1).YLabel.String=varnames{5};
ax(5,5).XLabel.String=varnames{6};
ax(5,1).YLabel.String=varnames{6};
linkaxes(ax,'xy');

%% PCA 
% it uses a matrix n x p, being n the number of observations and p the
% number of input variables

% Filter data to set the problem
tr = td(td.DATE.Year>=2019 & td.DATE.Year<=2020, :);
X = [tr{:, 2:6}]; % matrix n x p

% Plot global view of the original data
figure;plot(X); legend(varnames{2:6}); grid on;
figure;boxplot(X, 'Labels', {varnames{2:6}} , 'notch','on', 'orientation','horizontal'); 

%figure;plotmatrix(X);
disp('covariance matrix:');disp(cov(X));
disp('correlation matrix:');disp(corr(X));

% Run PCA
[loading, score, latent,~, explained, mu] = pca(X);

% Scree plot
p04ScreePlot(explained);

% Plot loadings (i.e. the coeffients of each principal component)
numPCShow = 2;
figure;
for i=1:numPCShow
    subplot(numPCShow,1,i);
    bar(loading(:,i));
    xlabel('Input'); ylabel('Loading'); title (sprintf('Coeff. PC %d',i));
    set(gca,'xticklabel',{varnames{2:6}})
end

%% PLOT SCORES IN LOW DIMENSIONAL PC's (first two components)
% score contains the coordinates of the original data in the new
% coordinate system defined by the principal components. The score matrix
% is the same size as the input data matrix
figure;
plot(score(:,1),score(:,2),'.', 'Markersize',15);
xlabel('1st Principal Component');
ylabel('2nd Principal Component');

%% ORIGINAL DATA -> PCA -> FIRST PC (A FEW)    PC's -> RECONSTRUCT ORIGINAL DATA
nComp = 2; % select the first 2 principal components
fprintf('Number of original variables: %d Number of observations: %d\n', size(X,2), numel(X));
fprintf('Number of selected PC: %d Number of observations: %d\n', nComp, nComp * size(X,1));

% reconstruct the original variables from the first nComp PC's
Xhat = score(:,1:nComp) * loading(:,1:nComp)';
Xhat = bsxfun(@plus, Xhat, mu); % add the mu to each variable

figure;
ax(1)=subplot(2,1,1); plot(X); title ('ORIGINAL VARIABLES');legend({varnames{2:6}});
ax(2)=subplot(2,1,2); plot(Xhat); title ('RECONSTRUCTED VARIABLES FROM 1ST & 2ND PC');legend({varnames{2:6}});
linkaxes(ax,'xy');

figure; % last year, different view
ax(1)=subplot(1,2,1); pcolor(X(end-365:end,:)'); title ('ORIGINAL VARIABLES');xlabel('LAST YEAR');shading flat; colorbar;
set(gca,'ytick',1:5)
set(gca,'yticklabel',{varnames{2:6}})
ax(2)=subplot(1,2,2); pcolor(Xhat(end-365:end,:)'); title ('RECONSTRUCTED VARIABLES FROM 1ST & 2ND PC');xlabel('LAST YEAR');shading flat; colorbar;
set(gca,'ytick',1:5)
set(gca,'yticklabel',{varnames{2:6}})

figure; %only one varible
plot(X(:,1),Xhat(:,1),'.');
xlabel(['Original ' varnames{2}])
ylabel(['Reconstructed ' varnames{2}])

% TRY with only the first PC:
% nComp = 1; 


%% BIPLOT 
%Visualize both the orthonormal principal component coefficients for each
%variable and the principal component scores for each observation in a
%single plot

figure;
numDims = 3; %max 3D (try it!)
biplot(loading(:,1:numDims),'scores',score(:,1:numDims),'varlabels', {varnames{2:6}});
axis square;

%You can identify items in the plot by selecting Tools>Data Cursor from the
%figure window. By clicking a variable (vector), you can read that
%variable's coefficients for each principal component. By clicking an
%observation (point), you can read that observation's scores for each
%principal component.



%%  SCALING VARIABLES (STANDARIZING)   --  APPENDIX --
% % %When all variables are in the same unit, it is appropriate to compute
% % %principal components for raw data. When the variables are in different
% % %units or the difference in the variance of different columns is
% % %substantial (as in this case), scaling of the data or use of weights is
% % %often preferable.
% % 
% % %Perform the principal component analysis by using the inverse variances of
% % %the ratings as weights.
% % w = 1./var(X);
% % [wcoeff,score,latent,tsquared,explained] = pca(X,...
% % 'VariableWeights',w);
% % 
% % %Or equivalently:
% % [wcoeff,score,latent,tsquared,explained] = pca(X,...
% % 'VariableWeights','variance');
