
disp("-->> Starting process.");
addpath("app");
addpath("functions");
addpath("templates");

load flu
flu2 = stack(flu,2:10,'NewDataVarName','FluRate',...
    'IndVarName','Region');
flu2.Date = nominal(flu2.Date);
flu2 = dataset2table(flu2);
plot(flu2.WtdILI,flu2.FluRate,'ro')
xlabel('WtdILI')
ylabel('Flu Rate')
lme = fitlme(flu2,'FluRate ~ 1 + WtdILI + (1|Date)')
DF = full(designMatrix(lme,'Fixed'))
DR = full(designMatrix(lme,'Random'))