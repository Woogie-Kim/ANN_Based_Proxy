%%
clear all
clc
Conductivity = 1;
% MPORO = 0.06;
NFPORO = 0.02;
MPERM = 0.001;
NFPERM = 0.005;
ss = 100;
ssq = 100;
ss_w = 400/ss;
ssq_w = 400/ssq;

h = figure;
for ff = 1:9
    MPORO = 0.04+ 0.01*ff;
    if MPORO == 0.05
        MPORO = 0.054;
    end
    if MPORO == 0.13
        MPORO = 0.135;
    end
    NPV_RSV1(MPERM,MPORO,NFPERM,NFPORO,Conductivity,ss,ss_w,ssq,ssq_w);
    Result_Cond(:,:,ff) = ans;
    
    x = 200:ss_w:200+ ss_w * (size(Result_Cond,1)-1);
    y = 100:ss_w:100 + ss_w * (size(Result_Cond,1)-1);
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
    
    r1 = rand(ff,3);
    
    [M,wd] = contour(x,y,Result_Cond(:,:,ff),1);
    wd.LevelList = 0;
    wd.LineColor = r1(ff,:);
    wd.LineWidth = 1.5;
    wd.LineStyle = '-';
    
    hold on
    [xa, ya] = find(Result_Cond(:,:,ff) == max(max(Result_Cond(:,:,ff))));
    scatter(ya+199,xa+99,100 ,'x','MarkerEdgeColor',r1(ff,:),'MarkerFaceColor',r1(ff,:),'LineWidth',3)
    hold on

    
    
    xlabel('Hydraulic Fracture Spacing (ft)','FontSize',12)
    ylabel('Hydraulic Fracture Half-Length (ft)','FontSize',12)

end
saveas(h,sprintf('OPT/optimalNPV_MPORO.png'))
close all
