function [Real_NPV] = NPV_RSV1(MPERM,MPORO,NFPERM,NFPORO,Conductivity,ss,ss_w,ssq,ssq_w)
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
end