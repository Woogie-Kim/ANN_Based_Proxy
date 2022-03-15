%%
clear all
clc

gas = xlsread('CumRate.xlsx');
time1 = gas(:,1);
time2 = gas(2:130,1);
cum = gas(:,2);
rate = gas(2:130, 3);
cum = cum * 1e-3;
rate = rate * 1e-3;
h = figure;    
left_color = [0,0,.6]; right_color = [.8,0,0];
set(h,'defaultAxesColorOrder',[left_color; right_color]);

yyaxis right
plot(time1, cum,'Color',[.8,0,0],'LineWidth',2);
xlabel('Time (year)');
ylabel('Cumulative Production Rate (Mscf)');
hold on
yyaxis left
plot(time2, rate,'Color',[0,0,.6], 'LineWidth',2);
xlabel('Time (year)');
ylabel('Gas Rate (Mscf/d)');
ylim([0 8000])
saveas(h,'cumrate.tif')