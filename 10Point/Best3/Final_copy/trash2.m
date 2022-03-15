%%

Base = xlsread('NPV_Calculation.xlsx');
NPV = Base(:,4);
Cum = Base(:,9);
Rank = Base(:,7);
Cum = Cum * 1e-6;
%%

h = figure;
yyaxis left
aNPV = area(Rank, NPV);
xlim([1 275])

xlabel('Rank of Scenarios')
ylabel('Net Present Value ($)')
hold on
yyaxis right
pRank = plot(Rank, Cum);
pRank.LineWidth = 0.8;
ylim([-1e4 1.5e4])
ylabel('Cumulative Gas Production (MMscf)')

hold on
s = scatter(114,14144.2);
s.SizeData = 55;
s.LineWidth = 1.5;
s.MarkerEdgeColor = 'b';