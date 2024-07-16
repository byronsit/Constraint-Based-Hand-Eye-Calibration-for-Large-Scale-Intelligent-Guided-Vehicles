% 只用A2=0的数据,来估参数
clc
clear all
close all

%% 导入数据
theta=[0	0	0	0
4.096	7.2787	-0.252	2.8337
7.4071	11.4024	3.0822	8.5872
12.3752	14.5869	15.8852	12.8446
-5.7464	-2.92	-4.619	-0.7333
-1.9229	2.3867	-5.8972	-4.4879
3.1214	4.918	-3.2394	0.3526
5.8581	5.6802	7.2822	11.2039
-13.1026	-11.5773	-18.7876	-14.7626
-5.8819	-2.6537	-13.7194	-9.8433
-1.7733	-1.5506	1.8248	2.7304
-4.9793	-2.012	2.222	4.6401
-17.4152	-17.5805	-21.9288	-16.0732
-13.3244	-13.1541	-13.6644	-10.1811
-9.6451	-8.833	-11.7659	-11.7808
2.08	3.5151	-4.9893	-2.2058]/180*pi; %原始数据这里出了点问题，多换算了一次

left_load = [     8     8     8     8    16    16    16    16    24    24    24    24    32    32    32    32]-8;
right_load = [     8    16    24    32     8    16    24    32     8    16    24    32     8    16    24    32]-8;
idx = find(left_load >= right_load)

left_load = left_load(idx);
right_load = right_load(idx);
theta = theta(idx,:)

% for i = 1 : length(idx)
%     % 交换degree的变化量
%     tmp = diff_degree_left(idx(i));
%     diff_degree_left(idx(i)) = diff_degree_right(idx(i));
%     diff_degree_right(idx(i)) = tmp;
% end

left_theta = theta(:,2)
right_theta = -theta(:,3)

X1=[left_load];
X2=[right_load];
y=[left_theta]
output_linear_regression_stats(X1', X2', y )

   
X1=[left_load,right_load];
X2=[right_load,left_load];
y=[left_theta;right_theta]

output_linear_regression_stats(X1', X2', y )

   




