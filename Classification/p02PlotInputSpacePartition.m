function p02PlotInputSpacePartition(model)

%data
td = model.X;
nomVar1 = model.PredictorNames{1};
nomVar2 = model.PredictorNames{2};
var1 = td.(nomVar1);
var2 = td.(nomVar2);

% Grid points
[x1,x2] = meshgrid(min(var1)-2:.1:max(var1)+2, ...
                   min(var2)-2:.1:max(var2)+2);
x1 = x1(:);
x2 = x2(:);

% predict
tgrid = table();
tgrid.(nomVar1) = x1;
tgrid.(nomVar2) = x2;
yestGrid = predict(model,tgrid);

%plot
figure; hold on;
gscatter(x1,x2,yestGrid,[],[],[20 20 20 20 20 20 20]);

plot (var1, var2,'.k');

lg = legend;
legend({lg.String{1:end-1}, 'TR data'});

xlabel(nomVar1);
ylabel(nomVar2);

return