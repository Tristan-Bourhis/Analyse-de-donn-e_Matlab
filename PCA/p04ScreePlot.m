function p04ScreePlot(proportionExplainedVariance)

% PRACTICE 4: PCA 
% STATISTICS II  - November 2017

nPrincComp = length(proportionExplainedVariance);

acumPEV = cumsum(proportionExplainedVariance);

figure;

yyaxis left;
bar(proportionExplainedVariance);
ylabel('Variance Explained (%)');
ylim([0 100]);
yyaxis right;
plot(acumPEV, '-o', 'linewidth', 3);
ylabel('Acumulated variance Explained (%)');
ylim([0 100]);
xlim([0.5 nPrincComp+0.5]);

set(gca,'xtick', 1:nPrincComp);

title ('Scree plot'); 
xlabel('Principal Component');

grid on;


return

