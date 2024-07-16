% 只用A2=0的数据,来估参数
clc
clear all
close all

%% 导入数据
load_data_diff;

%% 筛选数据为0的
idx = find(load_right==0)

load_left=load_left(idx)
load_right=load_right(idx)

diff_left=diff_left(idx)
diff_right=diff_right(idx)

diff_degree_left=diff_degree_left(idx)
diff_degree_right = diff_degree_right(idx);


%% 对z的数据，进行求解。
% diff_left  = load_left * phi 
% diff_right = load_left * psi 



output_fit_result(load_left.', diff_left.') %phi


output_fit_result(load_left.', diff_right.') % psi


%% 这里可能不再用来拟合theta,换一组数据

output_fit_result(load_left.', diff_degree_left.') % u

output_fit_result(load_left.', diff_degree_right.') % v
