%% Fitting Proxy

% Load Datat
Base = xlsread('VVS_ALL.xlsx','Parameter'); % Base case reservoir model, All scenarios
Simulation = xlsread('VVS_ALL.xlsx','Cumulative'); % Base case reservoir simulation results, All scenarios
tic
Predicted_ANN = Proxy_Val(Base); % Predicted ANN based proxy model, All scenarios
time  = toc
Predicted_ANN = Predicted_ANN;
Simulation = Simulation *1e-6;

for ww = 1:size(Simulation,1)
    for qq = 1:size(Simulation,2)
        MAPE_case(ww,qq) = abs((Simulation(ww,qq)-Predicted_ANN(ww,qq))/Simulation(ww,qq));
    end
end
MAPE = sum(MAPE_case)*(100 / size(MAPE_case,1));
MAPE = sum(MAPE) / size(MAPE_case,2);
        
h = figure;
plotregression(Simulation,Predicted_ANN);
xlabel('Simulation Results (MMscf)','FontSize',12,'FontWeight','bold');
ylabel('ANN Predicted (MMscf)','FontSize',12,'FontWeight','bold');
saveas(h,sprintf('VersusPlot.tif'));

% export to excel file
writematrix(Predicted_ANN,'VVS_ALL(ANN).xlsx' );