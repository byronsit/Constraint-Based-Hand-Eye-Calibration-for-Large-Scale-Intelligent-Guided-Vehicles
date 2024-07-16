%测inv_EI的数值
clc
clear all
close all

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
0.088

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
-0.0235
]


syms q  real %集装箱的均匀载荷N/m : Load Intensity
syms E  real %钢铁的弹性模量

%% 未知
syms I real  % Moment of Inertia  未知
syms a real  % a总长度
syms x real  % 左侧支撑点

% 可以测得
syms c real %一个常数

delta_l = q * x^4  / (8 * E * I)

M = q * a / 2 * (x - a / 4);

delta_r = M*(a-x)^2/(2*E*I);

%% %%%
[A,B]=coeffs(delta_r,q)

simplify(-(a*(a - x)^2*(a/4 - x))

%%%%

 
-x^4/(2*a*(a - x)^2*(a/4 - x))

eq = delta_l / delta_r;



[num, den] = numden(eq); %num分子，den分母

eq2 = simplify (eval(simplify( eq*den) - den*c)) 

[Coef, T]=coeffs (eq2,x)



% 设置参数
a = 15
g = 9.8;
load k.mat
act_spring_value = AA*g/K_estimated; %弹簧自身带来的影响


dl = dL_left - act_spring_value;
dr = dL_right;
c_rate = (dl./dr).'


res=[];
for i = 1 : length(c_rate)
    c = c_rate(i);
    cal_coef = eval(Coef);
    cal_coef
    solutions = roots(cal_coef)
    idx = find(solutions<5 & 0 < solutions);
    res(i) = solutions(idx);
end

x = mean(res); %均值的x

%% 开始构造1/EI要的左右数字
YY = [dl;dr];   %dl已经消过了
XX = zeros(length(YY),1);
for i = 1 : length(c_rate)
    q = AA(i)*g/(a/2);
    XX(i) = q*x^4/8;

    M = q * a / 2 * (x - a /4);

    idx = i + length(c_rate);
    XX(idx) = M*(a-x)^2/2;
end


% 输出直接拟合的结果
lm = fitlm(XX, YY);
disp(lm);
inv_EI=output_fit_result(XX, YY) 
