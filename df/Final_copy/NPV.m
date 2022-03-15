
%% NPV 계산

clear all, clc
%% NPV Predict
Cumulative_ANN = xlsread('VVS_ALL(ANN).xlsx');
Param = xlsread('VVS_ALL.xlsx','Parameter');
Param_HF(1,:) = Param(1,:); % Half-Length
Param_HF(2,:) = Param(3,:); % Hydraulic fracture Spacing

Cumulative_ANN = Cumulative_ANN * 1e6;
ANN = Cumulative_ANN(10,:);
GasRate_ANN = Cumulative_ANN;
for j = 2:size(Cumulative_ANN,1)
    for k = 1:size(Cumulative_ANN,2)
        
        GasRate_ANN(j,k) = Cumulative_ANN(j,k) - Cumulative_ANN(j-1,k);
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

%% NPV Simulation
Cumulative_SIM = xlsread('VVS_ALL.xlsx', 'Cumulative');
SIM = Cumulative_SIM(10,:);

Cumulative_SIM = Cumulative_SIM;
GasRate_SIM = Cumulative_SIM;
for j = 2:size(Cumulative_SIM,1)
    for k = 1:size(Cumulative_SIM,2)
        
        GasRate_SIM(j,k) = Cumulative_SIM(j,k) - Cumulative_SIM(j-1,k);
    end
end


%Calculate Revenue & OPEX
Revenue(Yr+1,size(GasRate_SIM,2)) = 0;
OPEX_M(Yr+1,size(GasRate_SIM,2)) = 0;
Revenue(1,:) = Gas_Price.* GasRate_SIM(1,:)/((1 + Interest_Rate));    
Revenue(Yr+1,:) = Revenue(1,:);
OPEX_M(1,:) = OPEX./((1 + Interest_Rate));
OPEX_M(Yr+1,:) = OPEX_M(1,:);

for ii = 2:Yr
    GasProd = GasRate_SIM(ii,:)/((1 + Interest_Rate)^(ii));
    
    Revenue(ii,:) = Gas_Price.* GasProd;
    Revenue(Yr+1,:) = Revenue(Yr+1,:) + Revenue(ii,:); % Sum of Total Production Time [ Revenue ]
    
    OPEX_M(ii,:) = OPEX./((1 + Interest_Rate)^(ii));
    OPEX_M(Yr+1,:) = OPEX_M(Yr+1,:) + OPEX_M(ii,:); % Sum of Total Production Time [ OPEX ]
end
Revenue_end = Revenue(Yr+1,:);
OPEX_end = OPEX_M(Yr+1,:);


for zz = 1 : size(GasRate_SIM,2)
    NPV_Simulation(1,zz) = (1-Royalty) * Revenue_end(1,zz) - OPEX_end(1,zz) - CAPEX(1,zz);
end


%% Save Matrix as xlsx
Param = Param(1:3,:);
Param = transpose(Param);
NPV_Simulation = transpose(NPV_Simulation);
NPV_Predict = transpose(NPV_Predict);
ANN = transpose(ANN);
SIM = transpose(SIM);
for w = 1:size(NPV_Simulation,1)
    Error(w,1) = abs((NPV_Simulation(w,1) - NPV_Predict(w,1)) / NPV_Simulation(w,1))*100;  % Absolute Percent Error
end

prop = ["HalfLength", "Conductivity", "Spacing", "Predicted_NPV","Simulation_NPV","Error","Rank_ANN", "Rank_SIM",...
    "Production_ANN","Production_SIM","Rank_PRODANN", "Rank_PRODSIM"];
writematrix(prop, 'NPV_Calculation.xlsx', 'Range','B1:M1');
writematrix(Param, 'NPV_Calculation.xlsx', 'Range','B2:D771');
writematrix(NPV_Predict, 'NPV_Calculation.xlsx', 'Range','E2:E771');
writematrix(NPV_Simulation, 'NPV_Calculation.xlsx', 'Range','F2:F771');
writematrix(Error, 'NPV_Calculation.xlsx', 'Range','G2:G771');
writematrix(ANN, 'NPV_Calculation.xlsx', 'Range','J2:J771');
writematrix(SIM, 'NPV_Calculation.xlsx', 'Range','K2:K771');