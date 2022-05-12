% PRACTICE 3: ANOVA
% Data analysis

%% LEARNING OBJECTIVES
%  - How to carry out an one-way ANOVA (using function anova1)
%  - How to carry out an two-way ANOVA without interaction (using function anovan)
%  - How to carry out an two-way ANOVA with interaction (using function anovan)


%% LOAD THE DATA FROM FILE (DIFERENT FORMAT !!)
close all
clear all
infomat =load ('autos.mat'); %faster load
td = infomat.td;

%% BASIC EXPLORATORY ANALYSIS OF THE DATA

summary(td)

%% Plot of the continuous variables
figure;
X = [td.price td.yearOfRegistration td.powerPS td.kilometer td.monthOfRegistration];
[~,ax]=plotmatrix(X);
ax(5,1).XLabel.String='Price';
ax(1,1).YLabel.String='Price';
ax(5,2).XLabel.String='Year';
ax(2,1).YLabel.String='Year';
ax(5,3).XLabel.String='Power';
ax(3,1).YLabel.String='Power';
ax(5,4).XLabel.String='Kms';
ax(4,1).YLabel.String='Kms';
ax(5,5).XLabel.String='Month';
ax(5,1).YLabel.String='Month';

%% Removal of outliers
idx = isoutlier(td.price,'percentiles',[2.5 97.5]) | ...
      isoutlier(td.yearOfRegistration,'percentiles',[5 100]) | ...
      isoutlier(td.powerPS,'percentiles',[2.5 97.5]) | ...
      isoutlier(td.kilometer,'percentiles',[5 100]) | ...
      td.monthOfRegistration == 0;
td=td(~idx,:);

%% Plot of the continuous variables
figure;
X = [td.price td.yearOfRegistration td.powerPS td.kilometer td.monthOfRegistration];
[~,ax]=plotmatrix(X);
ax(5,1).XLabel.String='Price';
ax(1,1).YLabel.String='Price';
ax(5,2).XLabel.String='Year';
ax(2,1).YLabel.String='Year';
ax(5,3).XLabel.String='Power';
ax(3,1).YLabel.String='Power';
ax(5,4).XLabel.String='Kms';
ax(4,1).YLabel.String='Kms';
ax(5,5).XLabel.String='Month';
ax(5,1).YLabel.String='Month';

%% Plot with respect to categorical
figure
subplot(221)
boxplot(td.price,td.vehicleType);

subplot(222)
boxplot(td.price,td.gearbox)

subplot(223)
boxplot(td.price,td.fuelType)

subplot(224)
boxplot(td.price,td.notRepairedDamage)

figure
boxplot(td.price,td.brand, 'orientation', 'horizontal');

%% ONE-WAY ANOVA

% Filter data to set the problem
years = td.yearOfRegistration>=1997 & td.yearOfRegistration<=2010;
brand = ismember(td.brand, {'ford', 'bmw', 'opel', 'volkswagen'}); 
tr = td(years & brand, :);

% Run ANOVA 'price ~ vehicleType'
output = tr.price; % the continuous variable
input  = removecats(tr.vehicleType); % the factor
[p,tbl,stats] = anova1(output, input); 

% Show coefs of the underlying mean model
p03showMeansModel(stats, 'price ~ vehicleType');

% Test differences
figure;multcompare(stats);
%Each group mean is represented by a symbol, and the interval is
%represented by a line extending out from the symbol.
%Two group means are significantly different if their intervals are
%disjoint; they are not significantly different if their intervals overlap.
%If you use your mouse to select any group, then the graph will highlight
%all other groups that are significantly different, if any.

% Run ANOVA 'price ~ month'
output = tr.price; % the continuous variable
input  = tr.monthOfRegistration; % the factor
[p,tbl,stats] = anova1(output, input); 
p03showMeansModel(stats, 'price ~ monthOfRegistration');
figure;multcompare(stats);

%% TWO-WAY ANOVA

% Filter data to set the problem
years = td.yearOfRegistration>=1997 & td.yearOfRegistration<=2010;
brand = ismember(td.brand, {'ford', 'bmw', 'opel', 'volkswagen'}); 
tr = td(years & brand, :);

% Run ANOVA 'price ~ vehicleType + monthOfRegistration' (without interaction)
output = tr.price; % the continuous variable
inputNames  = {'vehicleType', 'monthOfRegistration'}; 
inputs  = {removecats(tr.vehicleType) tr.monthOfRegistration}; % the factors
[p,tbl,stats] = anovan(output, inputs, 'model', 'linear', 'varnames', inputNames); 


% Show coefs of the underlying mean model
p03showMeansModel(stats, 'price ~ vehicleType + monthOfRegistration');

% Test differences
figure;multcompare(stats, 'Dimension', 1);
figure;multcompare(stats, 'Dimension', 2);
figure;multcompare(stats, 'Dimension', [1,2]);

% Run ANOVA 'price ~ vehicleType + monthOfRegistration + vehicleType*monthOfRegistration' (with interaction)
output = tr.price; % the continuous variable
inputNames  = {'vehicleType', 'monthOfRegistration'}; %(without the interaction in the list !!)
inputs  = {removecats(tr.vehicleType) tr.monthOfRegistration}; % the factors (without the interaction !!)
[p,tbl,stats] = anovan(output, inputs, 'model', 'interaction', 'varnames', inputNames); 

% Show coefs of the underlying mean model
p03showMeansModel(stats, 'price ~ vehicleType + monthOfRegistration + vehicleType*monthOfRegistration');

% Test differences
figure;multcompare(stats, 'Dimension', 1);
figure;multcompare(stats, 'Dimension', 2);
figure;multcompare(stats, 'Dimension', [1,2]);

%% N-WAY (THREE-WAY)

% Filter data to set the problem
years = td.yearOfRegistration>=1997 & td.yearOfRegistration<=2010;
brand = ismember(td.brand, {'mercedes_benz', 'audi', 'opel', 'volkswagen'}); 
tr = td(years & brand, :);

% Run ANOVA 'price ~ vehicleType + monthOfRegistration + gearbox' (with interaction)
output = tr.price; % the continuous variable
inputNames  = {'vehicleType', 'monthOfRegistration', 'gearbox'}; %(without the interaction in the list !!)
inputs  = {removecats(tr.vehicleType) tr.monthOfRegistration removecats(tr.gearbox)}; % the factors (without the interaction !!)
[p,tbl,stats] = anovan(output, inputs, 'model', 'full', 'varnames', inputNames); 

% Show coefs of the underlying mean model
p03showMeansModel(stats, 'price ~vehicleType + monthOfRegistration + gearbox + FULL INTER');

% Test differences
figure;multcompare(stats, 'Dimension', 1);
figure;multcompare(stats, 'Dimension', 2);
figure;multcompare(stats, 'Dimension', [1,2]);
figure;multcompare(stats, 'Dimension', [1,2,3]);

%% REMOVING OTHER EXPLANATORY VARIABLES
y=tr.price;
X=[tr.yearOfRegistration tr.powerPS tr.kilometer];
model = fitlm(X,y)

%% Modelling the residuals
ypredicted = predict(model,X);
output = y-ypredicted; % the continuous variable
inputNames  = {'vehicleType', 'monthOfRegistration', 'gearbox'}; %(without the interaction in the list !!)
inputs  = {removecats(tr.vehicleType) tr.monthOfRegistration removecats(tr.gearbox)}; % the factors (without the interaction !!)
[p,tbl,stats] = anovan(output, inputs, 'model', 'full', 'varnames', inputNames); 

%% Generalized Linear Models
model = fitlm(tr,'price ~ yearOfRegistration + powerPS + kilometer + vehicleType + monthOfRegistration + gearbox')
model = fitlm(tr,'price ~ yearOfRegistration + powerPS + kilometer + vehicleType + monthOfRegistration + gearbox + vehicleType*monthOfRegistration')
model = fitlm(tr,'price ~ vehicleType + monthOfRegistration + gearbox + vehicleType*monthOfRegistration + vehicleType*gearbox + monthOfRegistration*gearbox + vehicleType*monthOfRegistration*gearbox')
