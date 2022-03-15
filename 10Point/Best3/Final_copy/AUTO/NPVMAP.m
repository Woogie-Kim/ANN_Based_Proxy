%% Base Case NPV MAP
clear all
clc
for nooo = 1:4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SelectProp = nooo; % Select Changing Property
VISRANK = 1;   % Rank of each figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Base Case Property 
Conductivity = 1;
CHAGE_PROPERTY = ["MPERM","NFPERM","MPORO","NFPORO"];
PROPERTY = CHAGE_PROPERTY(1,SelectProp);
MPERM = 0.001;   % First
NFPERM = 0.005;  % Second
MPORO = 0.06;    % Third
NFPORO = 0.02;   % Fourth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trigger
Trigger(PROPERTY);
NUM_PROP = ans;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Scale of Hydraulic Fracture
ss = 80;
ssq = 80;
ss_w = 400/ss;
ssq_w = 400/ssq;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for Prop = 1:NUM_PROP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PROPERTY == "MPERM"
    MPERM = 0.0001*Prop; %Matrix Permeability
elseif PROPERTY == "NFPERM"
    NFPERM = 0.001*Prop; %Natural Fracture Permeability
elseif PROPERTY == "MPORO"
    MPORO = 0.04+ 0.01*Prop; %Matrix Porosity
    if MPORO== 0.05
        MPORO = 0.054;
    end
    if MPORO == 0.13
        MPORO = 0.135;
    end
elseif PROPERTY == "NFPORO"
NFPORO = 0.01*Prop; %Natural Fracture Porosity
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculating NPV
NPV_RSV1(MPERM,MPORO,NFPERM,NFPORO,Conductivity,ss,ss_w,ssq,ssq_w);
Real_NPV = ans;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NPV Map Setting
min_x = 200;
step_x = ss_w;
max_x = 200+ ss_w * ss;
min_y = 100;
step_y = ss_w;
max_y = 100 + ss_w * ss;
x = min_x:step_x:max_x;
y = min_y:step_y:max_y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open figure & NPV Mapping
h = figure;
h.Position = [1.6667 41.6667 1.2787e+03 1.3193e+03];
s = pcolor(x,y,Real_NPV);
s.EdgeColor = [.8 .8 .8 ];
s.LineWidth = 0.0001;
ax = gca;
ax.FontSize = 24;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Colorbar setting
c = colorbar;
c.Label.String = 'Net Present Value ($)';
c.FontSize = 24;
axis square
xlabel('Hydraulic Fracture Spacing (ft)','FontSize',24)
ylabel('Hydraulic Fracture Half-Length (ft)','FontSize',24)
hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting optimal scenarios
for rank = 1:VISRANK
    d_1 = reshape(Real_NPV,[],1);
	d_rank = sort(d_1,'descend');
	[i, j] = find(Real_NPV == d_rank(rank,1));
	scatter((ss_w)*(j-1)+200,(ss_w)*(i-1)+100,150 ,...
        'x','MarkerEdgeColor','r',...
        'MarkerFaceColor','r',...
        'LineWidth',3)
end
% scatter(300,300,70 ,'o',...
%     'MarkerEdgeColor','b',...
%     'MarkerFaceColor','b',...
%     'LineWidth',0.5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Contourmap Smooting
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
% wd.LevelList = 1e6 * [-3 -2 -1 0 1 2 3 4 5 6 ];
wd.LineColor = [.82 0 0];
wd.LineWidth = 1.5;
clabel(M,wd,'LabelSpacing',...
    3000,...
    'FontSize',22,...
    'FontWeight','bold',...
    'Color',[.82 0 0]);
wd.LineStyle = '-';
% legend('','','','','','','','','', '',...
% 	'','','','','','','','','', '',...
% 	'','','','','','','','','', '',...
% 	'','','','','','','','','', '',...
% 	'','','','','','','','','', '',...
% 	'','','','','','',...
% 	'Optimal Scenarios', 'Base Scenario')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save figure Automatically
AutoSave(h,MPERM,NFPERM,MPORO,NFPORO,PROPERTY)
end
end