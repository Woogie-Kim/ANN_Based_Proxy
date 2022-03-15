%%
q = xlsread('sep.xlsx');
r = q(3:13,:);
h = figure;
h.Position = [1 41 2560 1.3273e+03];
boxplot(r,'Labels',{'200ft','300ft','400ft','500ft','600ft',...
    '200ft','300ft','400ft','500ft','600ft',...
    '200ft','300ft','400ft','500ft','600ft',...
    '200ft','300ft','400ft','500ft','600ft',...
    '200ft','300ft','400ft','500ft','600ft'})
df = yline(0);
df.LineWidth = 1.5;
df.Color = [.82 0 0];
ax = gca;
ax.FontSize = 20;
ylabel('Net Present Value ($)','FontSize', 24);
hold on
scp = scatter(11, 13911350.1437);
scp.SizeData = 350;
scp.LineWidth = 1.3;
scp.MarkerEdgeColor = 'r';
saveas(h,'good.tif')