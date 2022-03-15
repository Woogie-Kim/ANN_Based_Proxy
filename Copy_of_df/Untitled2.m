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
gasopt = xlsread('now.xlsx');
[m,n] = size(gasopt) ;
% Split into train and test
P = 0.7 ;
s = RandStream('mlfg6331_64'); 
datasample(s,gasopt,round(P*m),'Replace',false)
Training = datasample(s,gasopt,round(P*m),'Replace',false); 

XTrain = Training(:,1:7);
YTrain = Training(:,8);
XTest = Testing(:,1:7);
YTest = Testing(:,8);
%%
% Define a train/validation split to use inside the objective function
cv = cvpartition(numel(YTrain), 'Holdout', 0.25);
% Define hyperparameters to optimize
vars = [optimizableVariable('FirstHiddenLayerSize', [2,40], 'Type', 'integer');
	    optimizableVariable('SecondHiddenLayerSize', [2,40], 'Type', 'integer')];
% Optimize
minfn = @(T)kfoldLoss(XTrain', YTrain', cv, [T.FirstHiddenLayerSize T.SecondHiddenLayerSize]);
results = bayesopt(minfn, vars,'IsObjectiveDeterministic', false,...
    'AcquisitionFunctionName', 'expected-improvement-plus');
results.NumObjectiveEvaluations = 100;
T = bestPoint(results)
% Train final model on full training set using the best hyperparameters
net = feedforwardnet([T.FirstHiddenLayerSize T.SecondHiddenLayerSize], 'trainlm');
net = train(net, XTrain', YTrain');
% NN Activation function
for ii = 1: 2
net.layers{ii}.transferFcn = T.ActFcn; 
end
% Evaluate on test set and compute final rmse
ypred = net(XTest');
finalrmse = sqrt(mean((ypred - YTest').^2))
function rmse = kfoldLoss(x, y, cv, numHid)
% Train net.
net = feedforwardnet(numHid, 'trainlm');
net = train(net, x(:,cv.training), y(:,cv.training));
for ii = 1: 2
net.layers{ii}.transferFcn = 'poslin'; 
end
% Evaluate on validation set and compute rmse
ypred = net(x(:, cv.test));
rmse = sqrt(mean((ypred - y(cv.test)).^2));
end