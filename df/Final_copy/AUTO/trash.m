%% Base Case NPV MAP
clear all
clc

for nooo = 1:4
h  = figure;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SelectProp = nooo; % Select Changing Property
VISRANK = 1;   % Rank of each figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Base Case Property 
Conductivity = 5.4;
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
ss = 400;
ssq = 400;
ss_w = 400/ss;
ssq_w = 400/ssq;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for Prop = 1:NUM_PROP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PROPERTY == "MPERM"
    MPERM = 0.0001*Prop; %Matrix Permeability
    PROP_INT = MPERM;
elseif PROPERTY == "NFPERM"
    NFPERM = 0.001*Prop; %Natural Fracture Permeability
    PROP_INT = NFPERM;
elseif PROPERTY == "MPORO"
    MPORO = 0.04+ 0.01*Prop; %Matrix Porosity
    if MPORO== 0.05
        MPORO = 0.054;
    end
    if MPORO == 0.13
        MPORO = 0.135;
    end
    PROP_INT = MPORO;
elseif PROPERTY == "NFPORO"
NFPORO = 0.005*Prop; %Natural Fracture Porosity
PROP_INT = NFPORO;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculating NPV
NPV_RSV1(MPERM,MPORO,NFPERM,NFPORO,Conductivity,ss,ss_w,ssq,ssq_w);
Real_NPV = ans;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optimal scenarios
for rank = 1:VISRANK
    d_1 = reshape(Real_NPV,[],1);
	d_rank = sort(d_1,'descend');
	[i, j] = find(Real_NPV == d_rank(rank,1));
	Sp = (ss_w)*(j-1)+200;
    HL = (ss_w)*(i-1)+100;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INT(Prop,nooo) = PROP_INT;
HLV(Prop,nooo) = HL;
SpV(Prop,nooo) = Sp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
left_color = [0,0,.6]; right_color = [.8,0,0];
set(h,'defaultAxesColorOrder',[left_color; right_color]);

yyaxis left
scatter(INT(1:Prop,nooo),HLV(1:Prop,nooo),30,...
    'MarkerFaceColor',left_color,'MarkerEdgeColor',left_color)
title(PROPERTY,'FontWeight','bold')
ylabel('Hydraulic fracture half-length (ft)','FontSize',12)
ylim([260 330])

yyaxis right
scatter(INT(1:Prop,nooo),SpV(1:Prop,nooo),42,'s',...
    'MarkerFaceColor',right_color,'MarkerEdgeColor',right_color)
ylabel('Hydraulic fracture spacing (ft)','FontSize',12)
ylim([200 205])
ax=gca;
ax.FontWeight = 'bold';
end