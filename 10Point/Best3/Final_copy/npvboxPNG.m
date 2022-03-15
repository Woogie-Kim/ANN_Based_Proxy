%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input Data
clear all
close all
clc
MPORO = 'NPV/NPV_MATPORO.xlsx';
MPERM = 'NPV/NPV_MPERM.xlsx';
NFPORO = 'NPV/NPV_NFRACPORO.xlsx';
NFPERM = 'NPV/NPV_NFRACPERM.xlsx';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Box Plot
h = figure;
npvbox(MPORO,10);
xlabel('Matrix Porosity (%)')
ylabel('Net Present Value ($)')
% ylim([1e6 8e6])
saveas(h,'boxplot/MPORO.png')
h = figure;
npvbox(MPERM,10);
xlabel('Matrix Permeability (md)')
ylabel('Net Present Value ($)')
% ylim([1e6 8e6])
saveas(h,'boxplot/MPERM.png')
h = figure;
npvbox(NFPORO,10);
xlabel('Natural fracture Porosity (%)')
ylabel('Net Present Value ($)')
% ylim([1e6 8e6])
saveas(h,'boxplot/NFPORO.png')
h = figure;
npvbox(NFPERM,10);
xlabel('Natural fracture Peameability (md)')
ylabel('Net Present Value ($)')
% ylim([1e6 8e6])
saveas(h,'boxplot/NFPERM.png')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Scatter Plot (NPV)
h = figure;
scatter_NPV(MPORO,'o');
hold on
scatter_NPV(MPERM,'o');
hold on
scatter_NPV(NFPERM,'o');
hold on
scatter_NPV(NFPORO,'o');
xlabel('Normalized Value')
ylabel('Net Present Value ($)')
legend('Matrix Porosity','Matrix Permeability',...
       'Natural Fracture Porosity',...
       'Natural Fracture Permeability',...
       'Location','northwest');
saveas(h,'scatter/scatterplot.png')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot (NPV)
h = figure;
plot_NPV(MPORO);
hold on
plot_NPV(MPERM);
hold on
plot_NPV(NFPERM);
hold on
plot_NPV(NFPORO);
xlabel('Normalized Value')
ylabel('Net Present Value ($)')
legend('Matrix Porosity','Matrix Permeability',...
       'Natural Fracture Porosity',...
       'Natural Fracture Permeability',...
       'Location','northwest');
saveas(h,'scatter/plot.png')
close all
