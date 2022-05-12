function [chi2, p] = p02Plotcrosstab(td,inputVars,y)
warning('off','all')

numInputs = length(inputVars);
figure;
for i=1:numInputs
    x = inputVars{i};
    
    [~,chi2,p] = crosstab(eval(sprintf('td.%s',x)),eval(sprintf('td.%s',y)));
    disp([x ' vs ' y ': chi2=' num2str(chi2) ' pval=' num2str(p)])
    
    tcounts = varfun(@(x) length(x), td, 'GroupingVariables',{x y},'InputVariables',{});
    tcrosstab = unstack(tcounts,'GroupCount',x);
     
    if numInputs<5
        subplot(1,numInputs,i);
    else
        subplot(2,ceil(numInputs/2),i);
    end
    bar(table2array(tcrosstab(:,2:end))')
    
    if i == numInputs
        legend(char(table2array(tcrosstab(:,1))),'Location','northeastoutside')
    end
    
    title(['pval=' num2str(p)])
    xlabel(x)
    set(gca,'xticklabel',categories(eval(sprintf('td.%s',x))))
    disp(tcrosstab)
end

end