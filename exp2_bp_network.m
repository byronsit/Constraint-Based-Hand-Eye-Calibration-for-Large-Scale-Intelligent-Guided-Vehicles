%估计x用的，但是用了所有的数据

clc
clear all
close all
rng(0);

load_left =  [   0      0     0     0     0     8     8     8     8     8    16    16    16    16    16    24    24    24    24    24    32    32     32    32    32] ;
load_right = [  0     8    16    24    32     0     8    16    24    32     0     8    16    24    32     0     8    16    24    32     0     8     16    24    32] ;
diff_left = -[  0         -0.0035    0.0020    0.0015    0.0130   -0.0485   -0.0375   -0.0335   -0.0270   -0.0225   -0.0665   -0.0540   -0.0485    -0.0430   -0.0410   -0.0920   -0.0715   -0.0630   -0.0615   -0.0625   -0.1020   -0.0855   -0.0830   -0.0795   -0.0735];
diff_right= -[   0       -0.0405   -0.0615   -0.0685   -0.0975    0.0060   -0.0290   -0.0480   -0.0655   -0.0820    0.0120   -0.0225   -0.0460    -0.0615   -0.0785    0.0175   -0.0195   -0.0400   -0.0520   -0.0755    0.0210   -0.0160   -0.0380   -0.0435   -0.0715];
% 确保左边更重
idx = find(load_left < load_right);
for i = 1 : length(idx)
    tmp = load_left(idx(i));
    load_left(idx(i)) = load_right(idx(i));
    load_right(idx(i)) = tmp;

    tmp = diff_left(idx(i));
    diff_left(idx(i)) = diff_right(idx(i));
    diff_right(idx(i)) = tmp;
end

inputs = [load_left; load_right];  %单位吨
targets = [diff_left; diff_right]; %单位cm
targets_left =diff_left;
targets_right =diff_right;

%% 只有1个隐含层，算2个数值
need_1d = true;
if need_1d == true
    res_1d_purelin = zeros(1,30);
    res_1d_tansig = zeros(1,30);
    res_1d_logsig = zeros(1,30);
    parfor i = 1 : 30
        res_1d_purelin(i) = donet([i],inputs,targets, 'purelin');
    end
    parfor i = 1 : 30
        res_1d_tansig(i) = donet([i],inputs,targets, 'purelin');
    end
    parfor i = 1 : 30
        res_1d_logsig(i) = donet([i],inputs,targets, 'purelin');
    end
    save('res_1d', 'res_1d_purelin', 'res_1d_tansig', 'res_1d_logsig');
end




%%
load net_purelin.mat;
need_2d = false;
if need_2d == true
    res_2d = zeros(10,10);
    parfor i = 1 : 10 
        for j = 1 : 10
            sprintf('%f %f\n',i,j);
            tmp = 0;
            for k = 1 : 100
                tmp = tmp + donet([i,j],inputs,targets, 'purelin');
            end
            res_2d(i,j) = tmp / 100;
        end
    end
    save('net_purelin_2d', 'res_2d');
    imagesc(res_2d);  % 显示数组  5 4
    colorbar;    % 显示颜色条
end




return;


% 创建一个简单的前馈神经网络
net = feedforwardnet([1]);  % 10 个隐藏单元

for i = 1 : length(net.layers)
    net.layers{i}.transferFcn = 'purelin';
end




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
