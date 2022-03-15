h = figure;
x = 200:600;
y = 100:500;
imagesc(x,y,Real_NPV)
c = colorbar;
c.Label.String = 'Net Present Value ($)';
c.FontSize = 12;
axis xy
axis square
hold on
xlabel('Hydraulic Fracture Spacing (ft)','FontSize',12)
ylabel('Hydraulic Fracture Half-Length (ft)','FontSize',12)
scatter(200,500,100 ,'x','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',3)
hold on
scatter(300,300,100 ,'o','MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',0.5)
legend('Optimal Solution','Base case')

saveas(h,'optimal.png')