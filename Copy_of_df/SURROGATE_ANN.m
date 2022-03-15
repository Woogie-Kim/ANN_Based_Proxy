%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Korea Maritime and Ocean University
% Department of Energy and Resource Enginnering
% 2021 Capstone design 
% Jongwook Kim, Undergraudate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Network                : feedforward network
% Trainging method       : Levenberg-Marquardt backpropagation
% Activation function    : Hyperbolic tangent 
% Number of Hidden-Layer : 2 layers
% Optimize NN structure  : first = [4-40] second = [4-40]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load Data
 x_train = xlsread('EXP_7PARAM.xlsx', 'Parameter');
 t_1 = xlsread('EXP_7PARAM.xlsx', 'Cumulative');
t = t_1; % Cumulative gas production per year
 x_train=t*1e-6; % scf => MMscf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Build ANN
tic
hidlaysize1 = 2:4;
hidlaysize2 = 2:4;
trainopt = {'trainlm'}; 
% trainopt = {'trainlm' 'traingd' 'traingda' 'traingdm' 'traingdx'}; 
maxepoch = 100:100:1000;
transferfunc = {'tansig'};
bestparameters = gridSearchNN(x_train',x_train',hidlaysize1,...
                              hidlaysize2,trainopt,maxepoch,transferfunc);

time = toc;