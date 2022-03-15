%% data 불러오기
clear all
clc

Cumulative_Gas = xlsread('VVS_ALL.xlsx','Cumulative');
%% Graph
Year = 0:size(Cumulative_Gas,1); % load year
CumGas(size(Cumulative_Gas, 1)+1,size(Cumulative_Gas, 2)) = 0;
% CumGas
CumGas(2:size(CumGas,1),:) = Cumulative_Gas; % load Cumulative Gas Production History
CumGas = CumGas * 1e-6;
h = figure;
plot(Year,CumGas,'Color','#bebebe')
hold on

plot(Year,CumGas(:,size(CumGas,2)),'LineWidth',1.8,'Color','#FF0000')
xlabel('Time (Year)','FontWeight','bold')
ylabel('Cumulative Gas Production (MMscf)','FontWeight','bold')
saveas(h,sprintf('Cumulative Gas Production(Exp).png'));
close all

% Predict
Cumulative_Gas_ANN = xlsread('VVS_ALL(ANN)');
CumGas_ANN(size(Cumulative_Gas_ANN, 1)+1,size(Cumulative_Gas_ANN, 2)) = 0;
% CumGas
CumGas_ANN(2:size(CumGas_ANN,1),:) = Cumulative_Gas_ANN; % load Cumulative Gas Production History

h = figure;
plot(Year,CumGas_ANN,'Color','#bebebe')
hold on

plot(Year,CumGas_ANN(:,size(CumGas_ANN,2)),'LineWidth',1.8,'Color','#FF0000')
xlabel('Time (Year)','FontWeight','bold')
ylabel('Cumulative Gas Production (MMscf)','FontWeight','bold')
saveas(h,sprintf('Cumulative Gas Production(ANN).png'));
close all

%% Versus

h = figure;
plot(Year,CumGas,'Color','#FF0000')
% plot(Year,CumGas_ANN,'Color','#0000FF')
hold on