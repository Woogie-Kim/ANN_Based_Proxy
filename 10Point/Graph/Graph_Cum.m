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

% plot(Year,CumGas(:,size(CumGas,2)),'LineWidth',1.8,'Color','#FF0000')
scatter(Year,CumGas(:,size(CumGas,2)),25,'LineWidth',1.5,'MarkerEdgeColor','#FF0000');
xlabel('Time (Year)','FontWeight','bold')
ylabel('Cumulative Gas Production (MMscf)','FontWeight','bold')
legend('Generated Scenarios',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','','','','','','','','','',...
    '','Base case Scenario','Location','Southoutside','NumColumns', 2,'FontWeight','bold')
saveas(h,sprintf('Cumulative Gas Production(Exp).png'));
close all

%% Error
Param= xlsread('EXP_7PARAM.xlsx','Parameter');
Cum_Proxy = Proxy_Val(Param);

%%
real = CumGas(2:11,:);
Num_Yr = size(real,1); % Number of years
Num_SCEN = size(real,2); % Number of Scenarios
Error_1 = real - Cum_Proxy;
for ii = 1: size(real,1)
    for kk = 1: size(real,2)
        Error_2(ii,kk) = 100*(abs(Error_1(ii,kk))/real(ii,kk)) ;    % percent
    end
end
Error_3 = sum(Error_2) / Num_Yr;         % by scenarios
Error_4 = sum(Error_2,2) / Num_SCEN;     % by year

[i, j] = find(Param(2,:) <= 1.5);
[ww, qq] = find(Param(2,:) > 1.5);
good = NaN(3,size(Error_3,2));
good(1,qq) = Error_3(1,qq);
good(2,j) = Error_3(1,j);
good(3,:) = Error_3;
nice = transpose(good);
h = figure;
boxplot(nice)
%%
h = figure;
scatter(1:Num_SCEN,Error_3,25,'Filled','MarkerEdgeColor',[0 0 .65],'MarkerFaceColor',[0 0 .65]);
xlabel('Scenario Number','FontWeight','bold')
xlim([0 Num_SCEN + 1])
ylabel('Error (%)','FontWeight','bold')
hold on
scatter(j,Error_3(1,j),25,'Filled','MarkerFaceColor',[.82 0 0 ],'MarkerEdgeColor',[.82 0 0])

legend('Conductivity > 1.0md-ft','Conductivity <= 1.0md-ft','Location','Southoutside','NumColumns', 2)
saveas(h,'Error_2.png')
h = figure;
scatter(1:Num_Yr,Error_4);