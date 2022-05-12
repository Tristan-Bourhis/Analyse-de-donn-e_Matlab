function p02PlotConfussionMatrix(model, td, possibleoutputs, figTitle)

%determine the true output
trueVal = td.(model.ResponseName);

%estimate the output
yest = predict(model,td);

figure;
trueClasses = [dummyvar(categorical(trueVal, possibleoutputs))]';
estClasses = [dummyvar(categorical(yest, possibleoutputs))]';
plotconfusion(trueClasses,estClasses, figTitle); 
set(gca,'xticklabel',{possibleoutputs{:} 'ALL'});
set(gca,'yticklabel',{possibleoutputs{:} 'ALL'});


return