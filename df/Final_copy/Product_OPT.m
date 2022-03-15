%% Base Case Production optimization
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
base(7,3600) = 0;
%Base Case Property 
for ii = 1:81
for kk = 1:81
Half_Length = 95 + ii*5;
Conductivity = 5.4;
Spacing = 195 + kk*5;
MPERM = 0.0001:0.0001:0.001;
MPORO = 0.05:0.01:0.13;
NFPERM = 0.001:0.001:0.01;
NFPORO = 0.01:0.01:0.04;
base_1 = combvec(MPERM,MPORO,NFPORO,NFPERM);
base(1,:) = Half_Length;
base(2,:) = Conductivity;
base(3,:) = Spacing;
base(4:end,:) = base_1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate NPV    
    Predicted_ANN = Proxy_Val(base);
    Predicted_ANN= Predicted_ANN * 1e6;
    GasRate_ANN = Predicted_ANN;
    for j = 2:size(Predicted_ANN,1)
        for k = 1:size(Predicted_ANN,2)
           GasRate_ANN(j,k) = Predicted_ANN(j,k) - Predicted_ANN(j-1,k);
        end
    end
    Yr = 10;
    OPEX = 30*365.25;                % $/year
    Gas_Price = 2.53 / 1000;           % $/scf
    Royalty = 0.125;            % 12.5%
    Interest_Rate = 0.1;        % 10%
    Horizontal_Well = 2250000;  % $
    Horizontal_Length = 3700;

    %Calculate Revenue & OPEX
    Revenue(Yr+1,size(GasRate_ANN,2)) = 0;
    OPEX_M(Yr+1,size(GasRate_ANN,2)) = 0;
    Revenue(1,:) = Gas_Price.* GasRate_ANN(1,:)/((1 + Interest_Rate));    
    Revenue(Yr+1,:) = Revenue(1,:);
    OPEX_M(1,:) = OPEX./((1 + Interest_Rate));
    OPEX_M(Yr+1,:) = OPEX_M(1,:);

    for i = 2:Yr
        GasProd = GasRate_ANN(i,:)/((1 + Interest_Rate)^(i));
        Revenue(i,:) = Gas_Price.* GasProd;
        Revenue(Yr+1,:) = Revenue(Yr+1,:) + Revenue(i,:); % Sum of Total Production Time [ Revenue ]
        OPEX_M(i,:) = OPEX./((1 + Interest_Rate)^(i));
        OPEX_M(Yr+1,:) = OPEX_M(Yr+1,:) + OPEX_M(i,:); % Sum of Total Production Time [ OPEX ]
    end

    Revenue_end = Revenue(Yr+1,:);
    OPEX_end = OPEX_M(Yr+1,:);

    %Calculate CAPEX
    Cost_HL(1,size(base,2)) = 0;
    StageNum(1,size(base,2)) = 0;
    CAPEX(1,size(base,2)) = 0;
    
    for k = 1:size(base,2)
%         Cost_HL(1,k) = 100*(base(1,k) - 100) + 85000;
        Cost_HL(1,k) =16654*exp(0.0072*base(1,k));
        StageNum(1,k) = int16(Horizontal_Length / base(3,k)) +1;
        CAPEX(1,k) = Cost_HL(1,k) * StageNum(1,k) + Horizontal_Well;
    end
    for z = 1 : size(GasRate_ANN,2)
        NPV_Predict(1,z) = (1-Royalty) * Revenue_end(1,z) - OPEX_end(1,z) - CAPEX(1,z);
    end
    Real_NPV(ii,kk,:) = NPV_Predict;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find OPTIMAL SOLUTION
for ww = 1:3600
d_1 = reshape(Real_NPV(:,:,ww),[],1);
d_rank = sort(d_1,'descend');
[HL SP] = find(Real_NPV(:,:,ww) == d_rank(1,1)); 
OPT_HL(ww,1) = 95 + HL*5;
OPT_SP(ww,1) = 195 + SP*5;
end
