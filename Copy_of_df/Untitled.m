% Make some data
Daten = rand(100, 3);
Daten(:,3) = Daten(:,1) + Daten(:,2) + .1*randn(100, 1);  % Minimum asymptotic error is .1
[m,n] = size(Daten) ;
% Split into train and test
P = 0.7 ;
Training = Daten(1:round(P*m),:) ; 
Testing = Daten(round(P*m)+1:end,:);
XTrain = Training(:,1:n-1);
YTrain = Training(:,n);
XTest = Testing(:,1:n-1);
YTest = Testing(:,n);
% Define a train/validation split to use inside the objective function
cv = cvpartition(numel(YTrain), 'Holdout', 1/3);
% Define hyperparameters to optimize
vars = [optimizableVariable('hiddenLayerSize', [1,20], 'Type', 'integer');
	    optimizableVariable('lr', [1e-3 1], 'Transform', 'log')];
% Optimize
minfn = @(T)kfoldLoss(XTrain', YTrain', cv, T.hiddenLayerSize, T.lr);
results = bayesopt(minfn, vars,'IsObjectiveDeterministic', false,...
    'AcquisitionFunctionName', 'expected-improvement-plus');
T = bestPoint(results)
% Train final model on full training set using the best hyperparameters
net = feedforwardnet(T.hiddenLayerSize, 'traingd');
net.trainParam.lr = T.lr;
net = train(net, XTrain', YTrain');
% Evaluate on test set and compute final rmse
ypred = net(XTest');
finalrmse = sqrt(mean((ypred - YTest').^2))
function rmse = kfoldLoss(x, y, cv, numHid, lr)
% Train net.
net = feedforwardnet(numHid, 'traingd');
net.trainParam.lr = lr;
net = train(net, x(:,cv.training), y(:,cv.training));
% Evaluate on validation set and compute rmse
ypred = net(x(:, cv.test));
rmse = sqrt(mean((ypred - y(cv.test)).^2));
end