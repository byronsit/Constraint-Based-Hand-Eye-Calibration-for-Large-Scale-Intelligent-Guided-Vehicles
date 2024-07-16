clc;
clear all;

AA=[
    8 
    16 
    24 
    32
    8
    16
    24
    32
    32
    32];%单位吨
AA = AA * 1000; %换算成千克


dL_left=[
0.0405
0.0615
0.0685
0.0975
%交换了，左右映射了下
0.0485
0.0665
0.092
0.102
%4车数据
0.0945
0.0945
]

dL_right=[
0.0035
-0.002
-0.0015
-0.013
%交换了，左右映射了下
-0.006
-0.012
-0.0175
-0.021
%4车的数据
-0.027
-0.027
]





%已知量
syms delta_L_left
syms delta_L_right
syms A
syms k
syms g      % 重力系数
syms theta  % 因为delta_L_left和delta_L_right产生的倾斜角
syms L      % 车的长度

%未知量
syms x  % 重物距离底盘中点距离。（中点左侧为负数，右测为正数。） 我们这个案例里，x应该是负数，在左侧
syms M  % 底盘质量
syms d  % 弹簧距离底盘中点距离（正数）
syms delta_L    % 实际弹簧压缩距离
syms delta_R    % 实际弹簧压缩距离

L0 = M*g/(2*k);                                 %底盘给弹簧带来的压缩量
Xg=(A*x)/(A+M)                                      % 系统新的重心

tan_theta = (delta_L_left - delta_L_right)/L;       % 如果原始状态视为"平",新的倾斜（假设是左侧，和地面夹角）就是这个tan_theta
theta = tan_theta;                                  % 小角度的线性近似
%cos_theta = cos(theta)
cos_theta = 1 - theta * theta / 2;                  % 线性近似
delta_L = (d + Xg)* tan_theta;                      % 根据theta算出的实际的变化量
delta_R = (d - Xg)* tan_theta;                      % 根据theta算出的实际的变化量

tau_cargo =  A*g*(Xg-x)*cos_theta;                  % 重物产生的力矩
tau_chassis = M*g*(0-Xg)*cos_theta;                 % 底盘产生的力矩
F_L = k * (delta_L + L0);
F_R = k * (delta_R + L0);
tau_L = F_L * (d - Xg);
tau_R = F_R * (d + Xg);

torque_eq = tau_cargo + tau_chassis + tau_L + tau_R == 0 

vertical_eq = (A+M)*g == (F_L+F_R)  

dd=solve(vertical_eq, d, 'ReturnConditions',true)   %可以得到d的表达式
dd=simplify(solve(vertical_eq, d))   %可以得到d的表达式


%% 计算d用截距
% dd=(A*L*g)/(2*k*(delta_L_left - delta_L_right))
%  (A*L*g) = dd * (2*k*(delta_L_left - delta_L_right))
delta_L_left = dL_left;     %input的数据
delta_L_right = dL_right;   %input的数据
load 'k.mat'
g = 9.8;
L = 15;
YY = AA * L * g;
XX = (2*K_estimated*(delta_L_left - delta_L_right));
lm = fitlm(XX, YY);
disp(lm);

% 计算d不用截距
dd = output_fit_result(XX, YY)
D_estimated = dd;

save('d.mat','D_estimated');