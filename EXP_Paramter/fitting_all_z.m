% 只用A2=0的数据,来估参数
clc
clear all
close all

%% 导入数据
load_data_diff;

%% 对z的数据，进行求解。
% diff_left  = load_left * phi 
% diff_right = load_left * psi 
%idx = find(  load_right~=24 )
% % idx = find(load_right==0 )
% % idx = [idx, 12,15,25] %12 13 14 15 17 18 19 20 22 23 24
% % 
% % load_left=load_left(idx)
% % load_right=load_right(idx)
% % 
% % diff_left=diff_left(idx)
% % diff_right=diff_right(idx)
% % 
% % diff_degree_left=diff_degree_left(idx)
% % diff_degree_right = diff_degree_right(idx);

X=[load_left.', load_right.']


lm = fitlm(X, [diff_left],'Intercept', false);  %
disp(lm);


output_linear_regression_stats(load_left.', load_right.',diff_left )



X=[[load_left.';load_right(2:end).'], [load_right.'; load_left(2:end).']]


% lm = fitlm(X, [diff_left,diff_right(2:end)],'Intercept', false);  %
% disp(lm);

% 回归拟合Z
output_linear_regression_stats(X(:,1), X(:,2),[diff_left,diff_right(2:end)] )


% 回归角度

% 
% Y=[diff_degree_left,diff_degree_right(2:end)];
% output_linear_regression_stats(X(:,1), X(:,2),Y)


   
   