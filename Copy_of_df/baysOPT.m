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
 x = xlsread('EXP_7PARAM.xlsx', 'Parameter');
 x_2  = transpose(x);
 t_1 = xlsread('EXP_7PARAM.xlsx', 'Cumulative');
t = t_1; % Cumulative gas production per year
 t=t*1e-6; % scf => MMscf
 t_2  = transpose(t);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Split into train and test
m = size(x_2,1);
P = 0.7 ;
XTrain = x_2(1:round(P*m),:) ; 
YTrain = t_2(1:round(P*m),:) ; 
XTest = x_2(round(P*m)+1:end,:);
YTest = t_2(round(P*m)+1:end,:);
% Define a train/validation split to use inside the objective function
cv = cvpartition(numel(YTrain), 'Holdout', 1/3);
% Define hyperparameters to optimize
vars = [optimizableVariable('hiddenLayerSize', [1,20], 'Type', 'integer');
	    optimizableVariable('lr', [1e-3 1], 'Transform', 'log')];
% Optimize
minfn = @(T)kfoldLoss(XTrain', YTrain', cv, T.hiddenLayerSize, T.lr);
results = bayesopt(minfn, vars,'IsObjectiveDeterministic', false,...
    'AcquisitionFunctionName', 'expected-improvement-plus');
T = bestPoint(results);
function rmse = kfoldLoss(x, y, cv, numHid, lr)
% Train net.
net = feedforwardnet(numHid, 'traingd');
net.trainParam.lr = lr;
net = train(net, x(:,cv.training), y(:,cv.training));
% Evaluate on validation set and compute rmse
ypred = net(x(:, cv.test));
n = size(ypred);
pw = 2*ones(n);
pw = num2cell(pw);
cMinus = cellfun(@minus, ypred, y(cv.test), 'UniformOutput', false);
cSquare = cellfun(@power, cMinus, pw, 'UniformOutput', false);
cSquareVect = cell2mat(cSquare);
cMean = mean(cSquareVect);
rmse = sqrt(cMean);
%rmse = sqrt(mean((ypred - y(cv.test)).^2));
end
