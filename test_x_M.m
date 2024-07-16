clc;
clear all;
addpath("utils")
addpath("func_files")
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
syms d  % 弹簧距离底盘中点距离（正数）

%未知量
syms x  % 重物距离底盘中点距离。（中点左侧为负数，右测为正数。） 我们这个案例里，x应该是负数，在左侧
syms M  % 底盘重量
syms delta_L    % 实际弹簧压缩距离
syms delta_R    % 实际弹簧压缩距离



L0 = M*g/(2*k); %底盘给弹簧带来的压缩量
%M=0;
Xg=(A*x)/(A+M)                                      % 系统新的重心
%Xg = 0;

tan_theta = (delta_L_left - delta_L_right)/L;       % 如果原始状态视为"平",新的倾斜（假设是左侧，和地面夹角）就是这个tan_theta
theta = tan_theta;                                  % 小角度的线性近似
sin_theta = theta;                                  % 小角度的线性近似
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

torque_eq = tau_cargo + tau_chassis + tau_L + tau_R == 0 %考虑了底盘
res = solve(torque_eq, [M, x], 'ReturnConditions', true)
torque = tau_cargo + tau_chassis + tau_L + tau_R
f = simplify(expand(torque)) * (L^2*(A + M)^2)

%% 给定数值
delta_L_left = dL_left;     %input的数据
delta_L_right = dL_right;   %input的数据
load 'k.mat'
load 'd.mat'
g = 9.8;
L = 15;
k = K_estimated;
d = D_estimated;
A = AA;
ff = simplify(eval(torque));
f = simplify(ff.'*ff);


fun =@(v) double(subs(f, [M, x], {v(1), v(2)}));


% 初始猜测
initialGuess = [5e3, 0];  % M0 and x0 are initial guesses for M and x

% 创建优化选项（可选）
options = optimoptions('fminunc', ...
    'Algorithm', 'quasi-newton', ...
    'Display', 'iter', ...
    'MaxIterations', 1000, ...  % 设置较大的迭代次数
    'FunctionTolerance', 1e-18, ...  % 设置较小的函数容差
    'StepTolerance', 1e-18);  % 设置较小的步长容差
% 调用 fminunc 函数
[v_min, fval] = fminunc(fun, initialGuess, options);

% 输出结果
disp('Optimal values:');
disp(['M = ', num2str(v_min(1))]);
disp(['x = ', num2str(v_min(2))]);
disp(['Minimum value of function: ', num2str(fval)]);


