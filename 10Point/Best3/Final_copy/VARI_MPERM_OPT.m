%%
clear all
clc
Conductivity = 1;
MPORO = 0.06;
NFPORO = 0.02;
% MPERM = 0.001;
NFPERM = 0.005;

NUM_MPORO = 9;
NUM_MPERM = 10;
NUM_NFPORO = 4;
NUM_NFPERM = 10;
NUM_PROP = NUM_MPERM;
RANKBOUND = 100;

ss = 80;
ssq = 80;
ss_w = 400/ss;
ssq_w = 400/ssq;
% Contour Map
h = figure;
for ff = 1:NUM_PROP
    MPERM = 0.0001*ff;
    
    Property(1,ff) = MPERM;
    NPV_RSV1(MPERM,MPORO,NFPERM,NFPORO,Conductivity,ss,ss_w,ssq,ssq_w);
    Result_Cond(:,:,ff) = ans;
    
    min_x = 200;
    step_x = ss_w;
    max_x = 200+ ss_w * ss;
    min_y = 100;
    step_y = ss_w;
    max_y = 100 + ss_w * ss;
    x = min_x:step_x:max_x;
    y = min_y:step_y:max_y;
      
    clims = [-5.3e6 8.5e6];
%     imagesc(x,y,Result_Cond(:,:,ff),clims)
    c = colorbar;
    colorbar('off')
%     c.Limits = clims;
%     c.Label.String = 'Net Present Value ($)';
%     c.FontSize = 12;
    axis xy
    axis square
    hold on
    
    hold on
    
    s = rng;
    rng(s);
    r1 = rand(1,3);
    
    
    % smoothing
    resolution = 10;
    xg = min_x:(step_x/resolution):max_x;
    yg = min_y:(step_y/resolution):max_y;
    [X,Y] = meshgrid(x,y);
    [XG,YG] = meshgrid(xg,yg);   
    smoothing_parameter = 0.00005;
    fitted = griddata(X,Y,Result_Cond(:,:,ff),XG,YG,'cubic');
    fitted_smoothed_x = csaps(xg,fitted,smoothing_parameter,xg);
    fitted_smoothed_xy = csaps(yg,fitted_smoothed_x',smoothing_parameter,yg);
    [M,wd] = contour(XG,YG,fitted_smoothed_xy',1);
    wd.LevelList = [0];
    wd.LineColor = r1;
    wd.LineWidth = 1.5;
%     clabel(M,wd,'LabelSpacing',3000,'FontSize',22,'FontWeight','bold','Color',r1);
    wd.LineStyle = '-';
    
    hold on
    
    for rank = 1:RANKBOUND
        d_1 = reshape(Result_Cond(:,:,ff),[],1);
        d_rank = sort(d_1,'descend');

        [i, j] = find(Result_Cond(:,:,ff) == d_rank(rank,1));
%         scatter((ss_w)*(j-1)+200,(ss_w)*(i-1)+100,150 ,'x','MarkerEdgeColor',r1,'MarkerFaceColor',r1,'LineWidth',3)
        hold on 
    end
    hold on
    max = mean(d_rank(1:RANKBOUND,1) /1e6);
    max = floor(max);
    [M,wd] = contour(XG,YG,fitted_smoothed_xy',1);
    wd.LevelList = 1e6*[max];
    wd.LineColor = r1;
    wd.LineWidth = 1.5;
    hold on
end
xlabel('Hydraulic Fracture Spacing (ft)','FontSize',12)
ylabel('Hydraulic Fracture Half-Length (ft)','FontSize',12)
% saveas(h,sprintf('OPT/optimalNPV_MPERM.png'))
% close all

%% boxplot


for ee = 1: NUM_PROP
    for rank = 1:RANKBOUND
    d_1(:,ee) = reshape(Result_Cond(:,:,ee),[],1);
    d_rank = sort(d_1,'descend');
    end
end
d_2 = reshape(d_1,[],1);
Property = string(Property);
Property(1,NUM_PROP+1) = 'Total';
h = figure;
d =  NaN(size(d_2,1),NUM_PROP+1);
d(:,NUM_PROP+1) = d_2;
d(1:rank,1:NUM_PROP) = d_rank(1:rank,:);
boxplot(d,'Labels',Property);
ax = gca;
ax.FontSize = 12;
xlabel('Matrix Permeability (md)','FontSize',15)
ylabel('Net Present Value ($)','FontSize',15)
r = yline(0);
r.Color = [.8 0 0];
r.LineWidth = 1;

% axis square
% saveas(h,'optimal_box.tif')
