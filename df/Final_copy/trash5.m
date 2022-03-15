%%
clear all
clc
Conductivity = 5.4;
MPERM = 0.001;
MPORO = 0.06;
NFPERM = 0.005;
NFPORO = 0.02;
ss = 80;
ssq = 80;
ss_w = 400/ss;
ssq_w = 400/ssq;

NPV_RSV1(MPERM,MPORO,NFPERM,NFPORO,Conductivity,ss,ss_w,ssq,ssq_w);
Real_NPV = ans;
    d_1 = reshape(Real_NPV,[],1);
    d_rank = sort(d_1,'descend');
[i, j] = find(Real_NPV == d_rank(1,1));
Sp = (ss_w)*(j-1)+200
HL = (ss_w)*(i-1)+100