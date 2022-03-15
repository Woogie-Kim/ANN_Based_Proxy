%%
clear all
clc
Conductivity = 1;
MPORO = 0.06;
NFPORO = 0.02;
NFPERM = 0.005;

ss = 80;
ssq = 80;
ss_w = 400/ss;
ssq_w = 400/ssq;

for ff = 1:1
    MPERM = 0.0001*ff;
    NPV_RSV1(MPERM,MPORO,NFPERM,NFPORO,Conductivity,ss,ss_w,ssq,ssq_w);
    Real_NPV = ans;
    h = figure;
    min_x = 200;
    step_x = ss_w;
    max_x = 200+ ss_w * ss;
    min_y = 100;
    step_y = ss_w;
    max_y = 100 + ss_w * ss;
    x = min_x:step_x:max_x;
    y = min_y:step_y:max_y;
    clims = [-4.3e6 7e6];
    s = pcolor(x,y,Real_NPV);
    s.EdgeColor = [.8 .8 .8 ];
    s.LineWidth = 0.0001;
    c = colorbar;
    c.Label.String = 'Net Present Value ($)';
    c.FontSize = 24;
    axis square
    hold on
    xlabel('Hydraulic Fracture Spacing (ft)','FontSize',12)
    ylabel('Hydraulic Fracture Half-Length (ft)','FontSize',12)
    hold on

    for rank = 1:56
        d_1 = reshape(Real_NPV,[],1);
        d_rank = sort(d_1,'descend');

        [i, j] = find(Real_NPV == d_rank(rank,1));
        scatter((ss_w)*(j-1)+200,(ss_w)*(i-1)+100,150 ,'x','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',3)
        hold on 
    end
    scatter(300,300,70 ,'o','MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',0.5)
        saveas(h,sprintf('optimal/MPERM/optimal%.4f.png',MPERM))
        hold on
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
    [M,wd] = contour(XG,YG,fitted_smoothed_xy',6);
%     wd.LevelList = 1e6 * [-3 -2 -1 0 1 2 3 4 5 6 ];
    wd.LineColor = [.82 0 0];
    wd.LineWidth = 1.5;
    clabel(M,wd,'LabelSpacing',3000,'FontSize',22,'FontWeight','bold','Color',[.82 0 0]);
    wd.LineStyle = '-';
%     legend('','','','','','','','','', '',...
%         '','','','','','','','','', '',...
%         '','','','','','','','','', '',...
%         '','','','','','','','','', '',...
%         '','','','','','','','','', '',...
%         '','','','','','','','','', '',...
%         '','','','','','','','','', '',...
%         '','','','','','','','','', '',...
%         '','','','','','','','','', '',...
%         '','','','','','','','','', '',...
%         'Optimal Scenarios', 'Base Scenario')
%         close all
end