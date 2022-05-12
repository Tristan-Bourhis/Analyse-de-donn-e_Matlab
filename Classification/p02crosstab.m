function [chi2, p] = p02crosstab(td,x,y,n)
    warning('off','all')
    [~,chi2,p] = crosstab(eval(sprintf('td.%s',x)),eval(sprintf('td.%s',y)));
    disp([x ' vs ' y ': chi2=' num2str(chi2) ' pval=' num2str(p)])

    tcounts = varfun(@(x) length(x), td, 'GroupingVariables',{x y},'InputVariables',{});
    tcrosstab = unstack(tcounts,'GroupCount',x);
    subplot(3,3,n);
    bar(table2array(tcrosstab(:,2:end))')
    legend(table2array(tcrosstab(:,1)))
    title([x ' pval=' num2str(p)])
    set(gca,'xticklabel',categories(eval(sprintf('td.%s',x))))
    disp(tcrosstab)
end