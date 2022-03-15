%%
clear all
clc

HL = 100:5:500;
CD = 3.0;
SP = 200:5:600;
Param= combvec(HL,CD,SP); 
% Param(3,:) = Param(2,:);
% Param(2,:) = CD;
Param(4,:) = 0.001;
Param(5,:) = 0.06;
Param(6,:) = 0.005; 
Param(7,:) = 0.02;

Production = Proxy_Val(Param);
Production_1(11,6561) = 0 ;
Production_1 = Production;
plot(Production_1,'Color', '#bebebe')