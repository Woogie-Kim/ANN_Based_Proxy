%% Economic Parameter
clear all
clc
Yr = 10;
OPEX = 30*365.25;                % $/year
Gas_Price = 2.53 / 1000;           % $/scf
Royalty = 0.125;            % 12.5%
Interest_Rate = 0.1;        % 10%
Horizontal_Well = 2250000;  % $
Horizontal_Length = 3700;

run domainDisc.m