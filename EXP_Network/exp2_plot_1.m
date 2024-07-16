%  展示1d情况下的数据
%
clc
clear all
close all
load res_1d.mat
load res_1d_left.mat
load res_1d_right.mat



plot(res_1d_purelin, 'x-', 'Color', 'b');
hold on;
plot(res_1d_tansig, 'o-', 'Color', 'g');
hold on;
plot(res_1d_logsig, 'd-', 'Color', 'r');
hold on;


plot(res_1d_purelin_left, 's-', 'Color', 'm');
hold on;
plot(res_1d_tansig_left, '^-', 'Color', 'c');
hold on;
plot(res_1d_logsig_left, 'v-', 'Color', 'y');
hold on;


plot(res_1d_purelin_right, 'p-', 'Color', 'k');
hold on;
plot(res_1d_tansig_right, '<-', 'Color',  [0.5, 0.5, 0.75]);
hold on;
plot(res_1d_logsig_right, '>-', 'Color', [1, 0.75, 0]);
hold on;

grid on;  
% 添加图例
legend({'Combined Output Model:Purelin ', 'Combined Output Model:Tansig ', 'Combined Output Model:Logsig ', ...
    'Single Output Model ($\delta_l$):Purelin','Single Output Model ($\delta_l$):Tansig','Single Output Model ($\delta_l$):Logsig', ...
    'Single Output Model ($\delta_r$):Purelin','Single Output Model ($\delta_r$):Tansig','Single Output Model ($\delta_r$):Logsig'},'Interpreter', 'latex');


xlabel('Neurons in the Single Hidden Layer');  % x轴标签
ylabel('MRES');       % y轴标签
