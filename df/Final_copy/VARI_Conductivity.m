%%
clear all
clc
Conductivity = 4.8;
MPERM = 0.001;
MPORO = 0.06;
NFPERM = 0.005;
NFPORO = 0.02;
ss = 80;
ssq = 80;
ss_w = 400/ss;
ssq_w = 400/ssq;
% for ff = 1:11
% Conductivity = 0.5*ff;
% if Conductivity == 5.5
%     Conductivity =5.4;
% end
    

NPV_RSV1(MPERM,MPORO,NFPERM,NFPORO,Conductivity,ss,ss_w,ssq,ssq_w);
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
h.Position = [1.6667 41.6667 1.2787e+03 1.3193e+03];
clims = 1e6 * [-7 14];
s = pcolor(x,y,Real_NPV);
caxis(clims)
s.EdgeColor = [.8 .8 .8 ];
s.LineWidth = 0.0001;
ax = gca;
ax.FontSize = 24;

c = colorbar;
c.Label.String = 'Net Present Value ($)';
c.FontSize = 22;
c.Limits = clims;
% colorbar('off')
axis square
hold on
xlabel('Hydraulic Fracture Spacing (ft)','FontSize',24)
ylabel('Hydraulic Fracture Half-Length (ft)','FontSize',24)
for rank = 1:1
    d_1 = reshape(Real_NPV,[],1);
    d_rank = sort(d_1,'descend');
    
    [i, j] = find(Real_NPV == d_rank(rank,1));
    scatter((ss_w)*(j-1)+200,(ss_w)*(i-1)+100,350 ,'x','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',5)
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
if ff ==1
Cond = [-6 -5 -4 -3 -2 -1 0 1 2 3 4]; %0.5
elseif ff==2
Cond = [-3 -2 -1 0 1 2 3 4 5 6 ]; %1
elseif ff==3
Cond = [-1 0 1 2 3 4 5 6 7 8]; %1.5
elseif ff==4
Cond = [1 2 3 4 5 6 7 8 9]; %2
elseif ff==5
Cond = [ 3 4 5 6 7 8 9 10]; %2.5
elseif ff==6
Cond = [4 5 6 7 8 9 10 11 ]; %3
elseif ff==7
Cond = [5 6 7 8 9 10 11 ]; %3.5
elseif ff==8
Cond = [5 6 7 8 9 10 11 12 ]; %4
elseif ff==9
Cond = [6 7 8 9 10 11 12 13 ]; %4.5
elseif ff==10
Cond = [7 8 9 10 11 12 13]; %5
elseif ff==11
Cond = [7 8 9 10 11 12 13 ]; %5.4
end
    
[M,wd] = contour(XG,YG,fitted_smoothed_xy',size(Cond,2));
clabel(M,wd,'LabelSpacing',3000,'FontSize',20,'FontWeight','bold','Color',[.82 0 0]);

wd.LevelList = 1e6 * Cond; 
wd.LineColor = [.82 0 0];
wd.LineWidth = 1.5;
wd.LineStyle = '-';
legend('','Optimal Scenario')
saveas(h,sprintf('COND/Conductivity%.1f.tif',Conductivity))
if ff ==1
    first_i = (ss_w)*(j-1)+200;
    first_j = (ss_w)*(i-1)+100;
elseif ff==6
    second_i = (ss_w)*(j-1)+200;
    second_j = (ss_w)*(i-1)+100;
end
close all
% end