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
 t_1 = xlsread('EXP_7PARAM.xlsx', 'Cumulative');
t = t_1; % Cumulative gas production per year
 t=t*1e-6; % scf => MMscf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Build ANN
clear perflog
clc

for kk = 1:19
    first = kk * 2 + 2;
    for jj = 1:19
        second = jj * 2 + 2;
        n = 19*(first-4)/2 + (second-4)/2 + 1; % run Automatically
        
trainFcn = 'trainlm';  
hiddenLayerSize = [first,second];
net = fitnet(hiddenLayerSize,trainFcn);


NNsize = size(hiddenLayerSize,2);
% NN Structure
for ii = 1: NNsize 
net.layers{ii}.transferFcn = 'tansig'; 
% tansig = hyperbolic tangent sigmoid / purelin = pure linear / poslin = ReLU
end

% Hyperparameter
net.trainParam.epochs = 1000;
net.trainParam.goal = 0;
net.trainParam.max_fail = 10;
net.trainParam.mu_max = 5e20;
net.trainParam.showWindow = false;	% Show GUI 

% Input and Output Pre/Post-Processing 
net.input.processFcns = {'removeconstantrows','mapminmax'}; %normalization [-1, 1]
net.output.processFcns = {'removeconstantrows','mapminmax'}; %normalization [-1, 1]

% Setup Division of Data for Training, Validation, Testing
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100; % Training
net.divideParam.valRatio = 15/100; % Validation
net.divideParam.testRatio = 15/100; % Testing

%  Performance Function
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y);


% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y);
valPerformance = perform(net,valTargets,y);
testPerformance = perform(net,testTargets,y);

train_Proxy =  y .* tr.trainMask{1};
val_Proxy =  y .* tr.valMask{1};
test_Proxy =  y .* tr.testMask{1};

        for ww = 1:size(y,1)
            for qq = 1:size(y,2)
                 AAPE_1(ww,qq) = abs((trainTargets(ww,qq)-train_Proxy(ww,qq))/trainTargets(ww,qq)); % training AAPE
            end
        end
        AAPE_train = sum(AAPE_1)*(100 / size(AAPE_1,1));
        AAPE_train = rmmissing(AAPE_train);
        AAPE_train = sum(AAPE_train) / size(AAPE_train,2);
        
        
        for ww = 1:size(y,1)
            for qq = 1:size(y,2)
                 AAPE_2(ww,qq) = abs((valTargets(ww,qq)-val_Proxy(ww,qq))/valTargets(ww,qq)); % validation AAPE
            end
        end
        AAPE_val = sum(AAPE_2)*(100 / size(AAPE_2,1));
        AAPE_val = rmmissing(AAPE_val);
        AAPE_val = sum(AAPE_val) / size(AAPE_val,2);
        
        for ww = 1:size(y,1)
            for qq = 1:size(y,2)
                 AAPE_3(ww,qq) = abs((testTargets(ww,qq)-test_Proxy(ww,qq))/testTargets(ww,qq)); % test AAPE
            end
        end
        AAPE_test = sum(AAPE_3)*(100 / size(AAPE_3,1));
        AAPE_test = rmmissing(AAPE_test);
        AAPE_test = sum(AAPE_test) / size(AAPE_test,2);
        
        
        
        for ww = 1:size(y,1)
            for qq = 1:size(y,2)
                 AAPE_case(ww,qq) = abs((t(ww,qq)-y(ww,qq))/t(ww,qq)); % total AAPE
            end
        end
        AAPE = sum(AAPE_case)*(100 / size(AAPE_case,1));
        AAPE = sum(AAPE) / size(AAPE_case,2);
        
        % performance log
        perflog(n,1) = n;                           % Iteration number  
        perflog(n,2) = first;                       % First neural
        perflog(n,3) = second;                      % Second neural
        perflog(n,4) = performance;                 % total performance
        perflog(n,5) = trainPerformance;            % train performance
        perflog(n,6) = valPerformance;              % validation performance
        perflog(n,7) = testPerformance;             % test performance
        perflog(n,8) = 0;                           % best total
        perflog(n,9) = 0;                           % best train
        perflog(n,10) = 0;                          % best validation
        perflog(n,11) = 0;                          % best test
        perflog(n,12) = AAPE;                       % total AAPE
        perflog(n,13) = AAPE_train;                 % train AAPE
        perflog(n,14) = AAPE_val;                   % validation AAPE
        perflog(n,15) = AAPE_test;                  % test AAPE
        if performance == min(perflog(:,4))
            perflog(n,8) = 1;
        end
        if trainPerformance == min(perflog(:,5))
            perflog(n,9) = 1;
        end
        if valPerformance == min(perflog(:,6))
            perflog(n,10) = 1;
        end
        if testPerformance == min(perflog(:,7))
            perflog(n,11) = 1;
        end
        
        % Visualization
        if perflog(n,6) == min(perflog(:,6))
            h = figure('doublebuffer','off','Visible','Off');
            plotperform(tr);
            saveas(h,sprintf('FIG%d_perform.tif',n));
            h = figure('doublebuffer','off','Visible','Off');
            plotregression(t,y);
            xlabel('Simulation Results (MMscf)','FontSize',12,'FontWeight','bold');
            ylabel('ANN Predicted (MMscf)','FontSize',12,'FontWeight','bold');
            saveas(h,sprintf('FIG%d_total.tif',n));
            h = figure('doublebuffer','off','Visible','Off');
            plotregression(valTargets,y);
            xlabel('Simulation Results (MMscf)','FontSize',12,'FontWeight','bold');
            ylabel('ANN Predicted (MMscf)','FontSize',12,'FontWeight','bold');
            saveas(h,sprintf('FIG%d_val.tif',n));
            h = figure('doublebuffer','off','Visible','Off');
            plotregression(trainTargets,y);
            xlabel('Simulation Results (MMscf)','FontSize',12,'FontWeight','bold');
            ylabel('ANN Predicted (MMscf)','FontSize',12,'FontWeight','bold');
            saveas(h,sprintf('FIG%d_train.tif',n));
            h = figure('doublebuffer','off','Visible','Off');
            plotregression(testTargets,y);
            xlabel('Simulation Results (MMscf)','FontSize',12,'FontWeight','bold');
            ylabel('ANN Predicted (MMscf)','FontSize',12,'FontWeight','bold');
            saveas(h,sprintf('FIG%d_test.tif',n));
            close all
        end


fprintf('%d번째 | 구조 ==> [ %d ][ %d ] | AAPE_train ==> %4g  | AAPE_val ==> %4g \n',n,first,second,AAPE_train, AAPE_val);
% Deployment
if perflog(n,6) == min(perflog(:,6))
    genFunction(net,'Proxy_Val');
end



    end
end

fprintf('\n \n 끝났어 친구! \n');
writematrix(perflog,'perflog.xlsx');