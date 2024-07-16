%% 感知机的属性
function [mres]=donet(my_laryers,inputs,targets, transferFcn)

net = feedforwardnet(my_laryers);  % 10 个隐藏单元

% 配置训练参数
net.divideParam.trainRatio = 20/25;
net.divideParam.valRatio = 3/25;
net.divideParam.testRatio = 2/25;
net.trainParam.showWindow = false;  % 关闭训练窗口

%% 训练网络
[net,tr] = train(net,inputs,targets);

% 测试网络
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs); 
mres = performance;
end
