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
syms A_L A_R
syms k
syms g          % 重力系数
syms theta      % 因为delta_L_left和delta_L_right产生的倾斜角
syms L          % 车的长度
syms d          % 弹簧距离底盘中点距离（正数）
syms delta_L    % 实际弹簧压缩距离
syms delta_R    % 实际弹簧压缩距离


% 一个铁棍长度为L
% 以中点对称，左右d的距离都有一个弹簧支撑。（理想弹簧，一开始伸缩为0）
% 现在在2个弹簧正上方，分别放质量为A_L,A_R的物体，此时弹簧必然发生倾斜（重心变了）
% 我觉得重心是 Xg=d*(A_R-A_L)/(A_L+A_R)  ，我错了吗？
% 假设铁棍两端产生的变化量为delta_L_left和delta_L_right，那么铁棍产生的倾斜角为tan_theta = (delta_L_left - delta_L_right)/L
% 小角度近似的画theta = tan_theta
% 那么根据长度，弹簧产生的变化量应该为delta_L = (Xg - d)* tan_theta; 和delta_R = (d - Xg)* tan_theta; 
% 那么弹簧产生的力为F_L = k * delta_L ; 和F_R = k * delta_R ; 
% 那么垂直方向的力必须平衡，所以(A_L+A_R)*g == (F_L+F_R)
% 
% 漏了一个约束！我觉得是几何约束，我写了geo_eq = delta_L_left + (L/2 + Xg) * sin_theta == delta_L_right + L * sin_theta;
% 这表明，新重心左侧的长度为(L/2 + Xg),发生旋转和下降（压缩弹簧）后，整个铁棍最低点所在的平面，到左侧重心的竖直方向距离为(L/2 +
% Xg)sin(theta), 整个铁棍最低点所在的平面到原始平面的距离为delta_L_left + (L/2 + Xg) *
% sin_theta.
% 类似的，右侧弹簧
% 我哪里错了？为啥算符号运算出来无解呢？


Xg=d*(A_R-A_L)/(A_L+A_R)                            % 系统新的重心
tan_theta = (delta_L_left - delta_L_right)/L;       % 如果原始状态视为"平",新的倾斜（假设是支撑物最左侧，和最右侧，和地面夹角）就是这个tan_theta
%theta = tan_theta;                                  % 小角度的线性近似
%sin_theta = theta;
delta_L = (d + Xg)* tan_theta;                      % 根据theta算出的实际的【弹簧】变化量
delta_R = (d - Xg)* tan_theta;                      % 根据theta算出的实际的【弹簧】变化量

F_L = k * delta_L ;                                 % 弹簧力
F_R = k * delta_R ;                                 % 弹簧力

vertical_eq = (A_L+A_R)*g == (F_L+F_R)              % 垂直力平衡，已经没有底盘要考虑了

%geo_eq = delta_L_left  == (L + delta_L_right/sin_theta)*sin_theta;
geo_eq = (delta_L - delta_R) / (2*d) == tan_theta

res= solve(geo_eq, vertical_eq, delta_L_left, delta_L_right, 'ReturnConditions', true)
%(A_L*L*g + A_R*L*g + 2*d*k*z)/(2*d*k)

res= solve(vertical_eq, delta_L_left, 'ReturnConditions', true)
delta_L_left = res.delta_L_left;
 simplify(eval((delta_L - delta_R) / (2*d)) - tan_theta)

%(A_L*L*g + A_R*L*g + 2*d*k*z)/(2*d*k)

%% 我自己算算看
