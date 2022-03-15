%%

MPERM = 0.001;
MPORO = 0.06;
NFPERM = 0.005;
NFPORO = 0.02;
ss = 4;
ssq = 4;
ss_w = 400/ss;
ssq_w = 400/ssq;
Conductivity =5.4;

    

NPV_RSV1(MPERM,MPORO,NFPERM,NFPORO,Conductivity,ss,ss_w,ssq,ssq_w);
Real_NPV = ans;
d_1 = reshape(Real_NPV,[],1);
d_rank = sort(d_1,'descend');
d_rank(1,1)