resolution = 10;%%
clear all
clc
Conductivity = 1;
MPERM = 0.001;
MPORO = 0.06;
NFPERM = 0.005;
NFPORO = 0.02;
ss = 40;
ssq = 40;
ss_w = 400/ss;
ssq_w = 400/ssq;

for gh = 0:ss
    for va =0:ssq
        HalfLength = 100 + ss_w * gh;
        Spacing = 200 + ssq_w * va;
        Base(3,va+1) = Spacing;
        Base(2,:) = Conductivity;
        Base(1,:) = HalfLength;
        Base(4,:) = MPERM;
        Base(5,:) = MPORO;
        Base(6,:) = NFPERM;
        Base(7,:) = NFPORO;
    end
    Predicted_ANN = Proxy_Val(Base);
%% Calculate NPV    
    Param_HF(1,:) = Base(1,:); % Half-Length
    Param_HF(2,:) = Base(3,:); % Hydraulic fracture Spacingclc
    Predicted_ANN= Predicted_ANN * 1e6;
    GasRate_ANN = Predicted_ANN;
    for j = 2:size(Predicted_ANN,1)
        for k = 1:size(Predicted_ANN,2)
           GasRate_ANN(j,k) = Predicted_ANN(j,k) - Predicted_ANN(j-1,k);
        end
    end
    Yr = 10;
    OPEX = 0.75 / 1000;                % $/scf
    Gas_Price = 4.25 / 1000;           % $/scf
    Royalty = 0.125;            % 12.5%
    Interest_Rate = 0.1;        % 10%
    Horizontal_Well = 2250000;  % $
    Horizontal_Length = 3700;

    %Calculate Revenue & OPEX
    Revenue(Yr+1,size(GasRate_ANN,2)) = 0;
    OPEX_M(Yr+1,size(GasRate_ANN,2)) = 0;
    Revenue(1,:) = Gas_Price.* GasRate_ANN(1,:)/((1 + Interest_Rate));    
    Revenue(Yr+1,:) = Revenue(1,:);
    OPEX_M(1,:) = OPEX.* GasRate_ANN(1,:)/((1 + Interest_Rate));
    OPEX_M(Yr+1,:) = OPEX_M(1,:);

    for i = 2:Yr
        GasProd = GasRate_ANN(i,:)/((1 + Interest_Rate)^(i));
        Revenue(i,:) = Gas_Price.* GasProd;
        Revenue(Yr+1,:) = Revenue(Yr+1,:) + Revenue(i,:); % Sum of Total Production Time [ Revenue ]
        OPEX_M(i,:) = OPEX.* GasProd;
        OPEX_M(Yr+1,:) = OPEX_M(Yr+1,:) + OPEX_M(i,:); % Sum of Total Production Time [ OPEX ]
    end

    Revenue_end = Revenue(Yr+1,:);
    OPEX_end = OPEX_M(Yr+1,:);

    %Calculate CAPEX
    Cost_HL(1,size(Param_HF,2)) = 0;
    StageNum(1,size(Param_HF,2)) = 0;
    CAPEX(1,size(Param_HF,2)) = 0;
    
    for k = 1:size(Param_HF,2)
%         Cost_HL(1,k) = 100*(Param_HF(1,k) - 100) + 85000;
        Cost_HL(1,k) =16654*exp(0.0072*Param_HF(1,k));
        StageNum(1,k) = int16(Horizontal_Length / Param_HF(2,k)) +1;
        CAPEX(1,k) = Cost_HL(1,k) * StageNum(1,k) + Horizontal_Well;
    end
    for z = 1 : size(GasRate_ANN,2)
        NPV_Predict(1,z) = (1-Royalty) * Revenue_end(1,z) - OPEX_end(1,z) - CAPEX(1,z);
    end
    Real_NPV(gh+1,:) = NPV_Predict;
end

min_x = 200;
step_x = ss_w;
max_x = 200+ ss_w * ss;
min_y = 100;
step_y = ss_w;
max_y = 100 + ss_w * ss;
x = min_x:step_x:max_x;
y = min_y:step_y:max_y;

[i, j] = find(Real_NPV == max(max(Real_NPV)));

h = figure;
    s = pcolor(x,y,Real_NPV);
    s.EdgeColor = [.8 .8 .8 ];
    s.LineWidth = 0.0001;
    c = colorbar;
    c.Label.String = 'Net Present Value ($)';
    c.FontSize = 12;
    axis square
    hold on
    
xlabel('Hydraulic Fracture Spacing (ft)','FontSize',12)
ylabel('Hydraulic Fracture Half-Length (ft)','FontSize',12)

hold on
scatter((ss_w)*(j-1)+200,(ss_w)*(i-1)+100,100 ,'x','MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',3)

hold on
scatter(300,300,100 ,'o','MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',0.5)

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
[M,wd] = contour(XG,YG,fitted_smoothed_xy',11);
wd.LineColor = [.82 0 0];
wd.LineWidth = 1.5;
wd.LineStyle = '-';
legend('', 'Optimal solution', 'Base case')
saveas(h,'optimal.png')



% legend('Optimal Solution','Base case')
% 
% hold on
% [M,wd] = contourspline(x,y,Real_NPV,15);
% wd.LineColor= [.2 .2 0];
% % [M,wd] = contour(x,y,Real_NPV,15);
% % wd.LineColor = [.2 .2 0];
% % wd.LineWidth = 1.5;
% % wd.LineStyle = '-';
% saveas(h,'optimal.png')