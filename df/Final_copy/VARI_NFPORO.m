%%
clear all
clc
Conductivity = 1;
MPORO = 0.06;
NFPERM = 0.005;
NFPORO = 0.02;
MPERM = 0.001;
for ff = 1:4
    NFPORO = 0.01*ff;
    NPV_RSV1(MPERM,MPORO,NFPERM,NFPORO,Conductivity);
    Result_Cond(:,:,ff) = ans;
h = figure;
    x = 200:600;
    y = 100:500;
    clims = [-4e6 7e6];
    imagesc(x,y,Result_Cond(:,:,ff),clims)
    c = colorbar;
    c.Label.String = 'Net Present Value ($)';
    c.FontSize = 12;
    axis xy
    axis square
    hold on
    [M,wd] = contour(x,y,Result_Cond(:,:,ff),1);
    wd.LevelList = 0;
    wd.LineColor = 'r';
    wd.LineWidth = 1.5;
    wd.LineStyle = '-';
    xlabel('Hydraulic Fracture Spacing (ft)','FontSize',12)
    ylabel('Hydraulic Fracture Half-Length (ft)','FontSize',12)
    saveas(h,sprintf('optimal/NFPORO/optimal%.2f.png',NFPORO))
    close all
end

