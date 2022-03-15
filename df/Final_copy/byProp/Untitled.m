%% Max Scenario
clear all
clc
Conductivity = 5.4;
MPERM = 0.001;          %  [0.0001 0.001] 
MPORO = 0.06;           % [0.05 0.135]
NFPERM = 0.005;         % [0.001 0.01]
NFPORO = 0.02;          % [0.01 0.04]
ss = 80;
ssq = 80;
ss_w = 400/ss;
ssq_w = 400/ssq;

run ../NPV_RSV1(MPERM,MPORO,NFPERM,NFPORO,Conductivity,ss,ss_w,ssq,ssq_w);
Real_NPV = ans;

for rank = 1:1
    d_1 = reshape(Real_NPV,[],1);
    d_rank = sort(d_1,'descend');
    
    [i, j] = find(Real_NPV == d_rank(rank,1));
end
H_SP = (ss_w)*(j-1)+200;
H_HL = (ss_w)*(i-1)+100;
NPV_MAX = d_rank(1,1);