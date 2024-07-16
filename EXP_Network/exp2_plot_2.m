%  展示1d情况下的数据
%
clc
clear all
close all

load res_2d.mat
load res_2d_left.mat
load res_2d_right.mat

% 定义数据集
dataSets = [res_2d_purelin, res_2d_tansig, res_2d_logsig
            res_2d_purelin_left, res_2d_tansig_left, res_2d_logsig_left 
            res_2d_purelin_right, res_2d_tansig_right, res_2d_logsig_right];
% 初始化变量
globalMin = min(min(dataSets)');
globalMax = max(max(dataSets)');


% 设置颜色映射范围
caxis([globalMin, globalMax]);

make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
if ~make_it_tight,  clear subplot;  end

% 创建各个子图
subplot(4, 3, 1);
imagesc(res_2d_purelin);
caxis([globalMin, globalMax]);


subplot(4, 3, 2);
imagesc(res_2d_tansig);
caxis([globalMin, globalMax]);

subplot(4, 3, 3);
imagesc(res_2d_logsig);
caxis([globalMin, globalMax]);

subplot(4, 3, 4);
imagesc(res_2d_purelin_left);
caxis([globalMin, globalMax]);



subplot(4, 3, 5);
imagesc(res_2d_tansig_left);
caxis([globalMin, globalMax]);

subplot(4, 3, 6);
imagesc(res_2d_logsig_left);
caxis([globalMin, globalMax]);

subplot(4, 3, 7);
imagesc(res_2d_purelin_right);
caxis([globalMin, globalMax]);

subplot(4, 3, 8);
imagesc(res_2d_tansig_right);
caxis([globalMin, globalMax]);

subplot(4, 3, 9);
imagesc(res_2d_logsig_right);
caxis([globalMin, globalMax]);




ticks = linspace(globalMin, globalMax, 5); % 创建 5 个等间距刻度

cb = colorbar('Position', [0.15, 0.25, 0.75, 0.025], 'Orientation', 'horizontal');

tickLabels = arrayfun(@(x) sprintf('%.1e', x), ticks, 'UniformOutput', false);
set(cb, 'TickLabels', tickLabels);
set(cb, 'Ticks', ticks);



return;
% 调整所有子图的位置，为底部的 colorbar 留出空间
for i = 1:9
    subplot(3, 3, i);
    pos = get(gca, 'Position');
    set(gca, 'Position', [pos(1), pos(2)+0.05, pos(3), pos(4)*0.9]);
end

% 添加统一的 color bar
%colorbar;

return

%%%%%%%%%%
subplot(3,3,1)
imagesc(res_2d_purelin);  % 显示数组
subplot(3,3,2)
imagesc(res_2d_tansig);  % 显示数组
subplot(3,3,3)
imagesc(res_2d_logsig);  % 显示数组


subplot(3,3,4)
imagesc(res_2d_purelin_left);  % 显示数组
subplot(3,3,5)
imagesc(res_2d_tansig_left);  % 显示数组
subplot(3,3,6)
imagesc(res_2d_logsig_left);  % 显示数组

subplot(3,3,7)
imagesc(res_2d_purelin_right);  % 显示数组
subplot(3,3,8)
imagesc(res_2d_tansig_right);  % 显示数组
subplot(3,3,9)
imagesc(res_2d_logsig_right);  % 显示数组

%colorbar;    % 显示颜色条
%xlabel('Neurons in the Single Hidden Layer');  % x轴标签
%ylabel('MRES');       % y轴标签










