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
syms delta_L_left real
syms delta_L_right real
syms A real
syms k real
syms g real     % 重力系数
syms theta real % 因为delta_L_left和delta_L_right产生的倾斜角
syms L real     % 车的长度
syms tan_theta real

%未知量
syms x real % 重物距离底盘中点距离。x为标量，正数
syms M real % 底盘重量
syms d real % 弹簧距离底盘中点距离（正数）
syms delta_L real   % 实际弹簧压缩距离
syms delta_R real   % 实际弹簧压缩距离


L0 = M*g/(2*k); %底盘给弹簧带来的压缩量
x=d;
Xg= (A*(-x))/(A+M)                                      % 系统新的重心

%Xg=0;   %强制重心为0位置


tan_theta = (delta_L_left - delta_L_right)/L;       % 如果原始状态视为"平",新的倾斜（假设是左侧，和地面夹角）就是这个tan_theta

%theta = tan_theta;                                  % 小角度的线性近似
theta = atan(tan_theta)
%sin_theta = theta;
sin_theta = sin(theta);
%cos_theta = 1 - theta * theta / 2;                  % 线性近似
cos_theta = cos(theta)
%geo_eq = delta_L - (2*d*tan_theta) == delta_R;      % 几何约束
delta_R = delta_L - (2*d*tan_theta)


tau_cargo =  A*g*(Xg - (-x))*cos_theta;                  % 重物产生的力矩 
tau_chassis = M*g*(Xg - 0)*cos_theta;                 % 底盘产生的力矩 
F_L =  -k * (delta_L + L0);                         % 弹簧产生的力（绝对值）
F_R =  -k * (delta_R + L0);                         % 弹簧产生的力（绝对值）
tau_L =  F_L * (Xg - (-d))*cos_theta;
tau_R =  F_R * (Xg - d)*cos_theta;


%垂直力约束
vertical_eq =simplify( A * g + M * g + F_L + F_R == 0)
%结果： A*g + 2*d*k*tan_theta == 2*delta_L*k

%力矩约束
torque_eq = simplify( tau_cargo + tau_chassis + tau_L + tau_R ==0) %这里似乎丢了什么东西不对
% 结果：



dd=solve(vertical_eq, d, 'ReturnConditions',true)   % 可以得到d的表达式
% d = -(A*g - 2*delta_L*k)/(2*k*tan_theta);
% d=dd.d;
% eval(torque_eq)

%M^2*g + 4*A*M*g + 4*A*delta_L*k + 2*M*delta_L*k == M*(4*A*g + M*g - 2*delta_L*k)
%-(A*g - 2*delta_L*k)/(2*k*tan_theta) == 0
%g= M^2*g + 4*A*M*g + 4*A*delta_L*k + 2*M*delta_L*k == M*(4*A*g + M*g - 2*delta_L*k) 

dd=solve(torque_eq, d, 'ReturnConditions',true)   %可以得到d的表达式

dd=solve(torque_eq, vertical_eq, d, 'ReturnConditions',true)   %无解