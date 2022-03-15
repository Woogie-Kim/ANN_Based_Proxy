%% Predict Production Map (2D)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set working space to initial
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set reservoir properties
Conductivity = 1;     % Hydraulic fracture conductivity
MPERM = 0.001;        % Matrix permeability
MPORO = 0.06;         % Matrix porosity
NFPERM = 0.005;       % Natural fracture permeability
NFPORO = 0.02;        % Natural fracture porosity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set resolution
ss = 80;
ssq = 80;
ss_w = 400/ss;
ssq_w = 400/ssq;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predict N-th cumuative gas production
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
    ANN(gh+1,:) = Predicted_ANN(size(Predicted_ANN,1),:);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set production map axis
min_x = 200;
step_x = ss_w;
max_x = 200+ ss_w * ss;
min_y = 100;
step_y = ss_w;
max_y = 100 + ss_w * ss;
x = min_x:step_x:max_x;
y = min_y:step_y:max_y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Production mapping
h = figure;
s = pcolor(x,y,ANN);
s.EdgeColor = [.8 .8 .8 ];
s.LineWidth = 0.0001;
c = colorbar;
c.Label.String = 'Cumulative Gas Production (MMscf)';
c.FontSize = 10;
axis square
hold on
xlabel('Hydraulic Fracture Spacing (ft)','FontSize',12)
ylabel('Hydraulic Fracture Half-Length (ft)','FontSize',12)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting base & best production scenarios
for rank = 1:1
    d_1 = reshape(ANN,[],1);
    d_rank = sort(d_1,'descend');
    
    [i, j] = find(ANN == d_rank(rank,1));
    scatter((ss_w)*(j-1)+200,(ss_w)*(i-1)+100,150 ,...
    'x',...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','r',...
    'LineWidth',3)
end
scatter(300,300,70 ,...
'o','MarkerEdgeColor','b',...
'MarkerFaceColor','b',...
'LineWidth',0.5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Smoothed Contour
resolution = 10;
xg = min_x:(step_x/resolution):max_x;
yg = min_y:(step_y/resolution):max_y;
[X,Y] = meshgrid(x,y);
[XG,YG] = meshgrid(xg,yg);   
smoothing_parameter = 0.00005;
fitted = griddata(X,Y,ANN,XG,YG,'cubic');
fitted_smoothed_x = csaps(xg,fitted,smoothing_parameter,xg);
fitted_smoothed_xy = csaps(yg,fitted_smoothed_x',smoothing_parameter,yg);
[M,wd] = contour(XG,YG,fitted_smoothed_xy',11);
wd.LineColor = [.82 0 0];
wd.LineWidth = 1.5;
wd.LineStyle = '-';
legend('', 'Best Scenario', 'Base Scenario')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save figure
% saveas(h,'optimal(Production).png')