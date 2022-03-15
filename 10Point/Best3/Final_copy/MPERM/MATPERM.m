%% Load Datat
Base = xlsread('../VVS_ALL.xlsx','Parameter'); % Predicted_ANN case reservoir model, All scenarios

%% Predict Cumulative Gas Production with Proxy
for zz = 1:10
    MPERM= 0.0001 * zz; 
    Base(4,:) = MPERM;
    Predicted_ANN = Proxy_Val(Base); % Predicted ANN Predicted_ANNd proxy model, All scenarios
    writematrix(Predicted_ANN,'MPERM.xlsx','Sheet',zz); % export to excel file
    
%% Calculate NPV    
    Param_HF(1,:) = Base(1,:); % Half-Length
    Param_HF(2,:) = Base(3,:); % Hydraulic fracture Spacing
    Predicted_ANN= Predicted_ANN * 1e6;
    GasRate_ANN = Predicted_ANN;
        for j = 2:size(Predicted_ANN,1)
            for k = 1:size(Predicted_ANN,2)

                GasRate_ANN(j,k) = Predicted_ANN(j,k) - Predicted_ANN(j-1,k);
            end
        end
        
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
        Cost_HL(1,k) =16654*exp(0.0072*Param_HF(1,k));
                StageNum(1,k) = int16(Horizontal_Length / Param_HF(2,k)) +1;
                CAPEX(1,k) = Cost_HL(1,k) * StageNum(1,k) + Horizontal_Well;
        end
        
        for z = 1 : size(GasRate_ANN,2)
            NPV_Predict(1,z) = (1-Royalty) * Revenue_end(1,z) - OPEX_end(1,z) - CAPEX(1,z);
        end
%% Save Matrix as xlsx
Param = Base(1:3,:);
Param = transpose(Param);
NPV_Predict = transpose(NPV_Predict);
NPV_base = Param;
NPV_base(:,4) = NPV_Predict;
Prod_ANN = Predicted_ANN(size(Predicted_ANN,1),:);
Prod_ANN = transpose(Prod_ANN);
NPV_base(:,5) = Prod_ANN; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sorttool(MPERM, zz, domainMPERM,NPV_base);
clear NPV_Predict
clear Prod_ANN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end