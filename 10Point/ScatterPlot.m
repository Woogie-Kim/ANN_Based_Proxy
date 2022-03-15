%% Scatter 3D plot

x = xlsread('EXP_7PARAM.xlsx', 'Parameter');
good1 = x(1,:);
good2 = x(2,:);
good3 = x(3,:);
good1 = normalize(good1,'range');
good2 = normalize(good2,'range');
good3 = normalize(good3,'range');
h = figure;
scatter3(good1, good2, good3,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','#A2142F')
xlabel('X axis','FontSize',10,'FontWeight','bold')
ylabel('Y axis','FontSize',10,'FontWeight','bold')
zlabel('Z axis','FontSize',10,'FontWeight','bold')

saveas(h,sprintf('scatterplot.tif'));