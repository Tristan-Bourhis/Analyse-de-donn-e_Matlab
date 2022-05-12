function p03showMeansModel(stats, tit)

% PRACTICE 3: ANOVA
% STATISTICS II  - November 2017

if strcmp(stats.source, 'anovan')
    fprintf('-- MEANS MODEL %s --\n', tit);
    fprintf('\tGROUP \t\t\t MEANS\n');
    nGroups = length(stats.coeffs);
    for g=1:nGroups
        fprintf('\t%s \t\t\t %f\n', stats.coeffnames{g}, stats.coeffs(g));
    end
else
    fprintf('-- MEANS MODEL %s --\n', tit);
    fprintf('\tGROUP \t MEANS\n');
    nGroups = length(stats.means);
    for g=1:nGroups
        fprintf('\t%s \t %f\n', stats.gnames{g}, stats.means(g));
    end
    
end



return