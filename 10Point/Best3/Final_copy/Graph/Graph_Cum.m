%% data 불러오기
clear all
clc

Cumulative_Gas = xlsread('EXP_7PARAM.xlsx','Cumulative');
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
