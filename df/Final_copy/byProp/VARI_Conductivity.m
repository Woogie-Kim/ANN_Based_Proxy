%% Max Scenario
clear all
clc
Conductivity = 5.4;
MPERM = 0.001;          %  [0.0001 0.001] 
MPORO = 0.135;           % [0.05 0.135]
NFPERM = 0.005;         % [0.001 0.01]
NFPORO = 0.02;          % [0.01 0.04]
ss = 80;
ssq = 80;
ss_w = 400/ss;
ssq_w = 400/ssq;

run ../NPV_RSV1(MPERM,MPORO,NFPERM,NFPORO,Conductivity,ss,ss_w,ssq,ssq_w);
Real_NPV = ans;

min_x = 200;
step_x = ss_w;
max_x = 200+ ss_w * ss;
min_y = 100;
step_y = ss_w;
max_y = 100 + ss_w * ss;
x = min_x:step_x:max_x;
y = min_y:step_y:max_y;

h = figure;
h.Position = [1.6667 41.6667 1.4653e+03 1.3193e+03];
clims = 1e6 * [-8 20];
s = pcolor(x,y,Real_NPV);
caxis(clims)
s.EdgeColor = [.8 .8 .8 ];
s.LineWidth = 0.0001;
ax = gca;
ax.FontSize = 24;

c = colorbar;
c.Label.String = 'Net Present Value ($)';
c.FontSize = 25;
c.Limits = clims;
colorbar('off')
axis square
hold on
xlabel('Hydraulic Fracture Spacing (ft)','FontSize',27)
ylabel('Hydraulic Fracture Half-Length (ft)','FontSize',27)
for rank = 1:1
    d_1 = reshape(Real_NPV,[],1);
    d_rank = sort(d_1,'descend');
    
    [i, j] = find(Real_NPV == d_rank(rank,1));
    scatter((ss_w)*(j-1)+200,(ss_w)*(i-1)+100,500 ,'x','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',5)
end
% scatter(300,300,70 ,'o','MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',0.5)
% smoothing
resolution = 10;
xg = min_x:(step_x/resolution):max_x;
yg = min_y:(step_y/resolution):max_y;
[X,Y] = meshgrid(x,y);
[XG,YG] = meshgrid(xg,yg);   
smoothing_parameter = 0.00005;
fitted = griddata(X,Y,Real_NPV,XG,YG,'cubic');
fitted_smoothed_x = csaps(xg,fitted,smoothing_parameter,xg);
fitted_smoothed_xy = csaps(yg,fitted_smoothed_x',smoothing_parameter,yg);

Cond =-10:20;
% MPERM [0.0001 0.001] > [-8e6 14e6] <-7:3> <7:13>
% MPORO [0.05 0.135] > [-7e6 20e6]   <-6:4> <11:18>
% NFPERM [0.001 0.01] > [-8e6 18e6]  <-7:2> <9:17>
% NFPORO [0.01 0.04] > [-7e6 18e6]   <-6:4> <8:17>

[M,wd] = contour(XG,YG,fitted_smoothed_xy',size(Cond,2));
clabel(M,wd,'LabelSpacing',3000,'FontSize',25,'FontWeight','bold','Color',[.82 0 0]);
wd.LevelList = 1e6 * Cond; 
wd.LineColor = [.82 0 0];
wd.LineWidth = 1.5;
wd.LineStyle = '-';
legend('','Optimal Scenario')
saveas(h,'MPORO/MPORO_MAX.tif')
H_SP = (ss_w)*(j-1)+200;
H_HL = (ss_w)*(i-1)+100;
NPV_MAX = d_rank(1,1);
% close all