%估计x用的，但是用了所有的数据

clc
clear all
close all


load_left = [         0     0     0     0     8     8     8     8     8    16    16    16    16    16    24    24    24    24    24    32    32     32    32    32] * 1000;
load_right = [       8    16    24    32     0     8    16    24    32     0     8    16    24    32     0     8    16    24    32     0     8     16    24    32] * 1000;
diff_left = -[           -0.0035    0.0020    0.0015    0.0130   -0.0485   -0.0375   -0.0335   -0.0270   -0.0225   -0.0665   -0.0540   -0.0485    -0.0430   -0.0410   -0.0920   -0.0715   -0.0630   -0.0615   -0.0625   -0.1020   -0.0855   -0.0830   -0.0795   -0.0735];
diff_right=-[          -0.0405   -0.0615   -0.0685   -0.0975    0.0060   -0.0290   -0.0480   -0.0655   -0.0820    0.0120   -0.0225   -0.0460    -0.0615   -0.0785    0.0175   -0.0195   -0.0400   -0.0520   -0.0755    0.0210   -0.0160   -0.0380   -0.0435   -0.0715];
% 确保左边更重
idx = find(load_left < load_right);
for i = 1 : length(idx)
    tmp = load_left(idx(i));
    load_left(idx(i)) = load_right(idx(i));
    load_right(idx(i)) = tmp;

    tmp = diff_left(idx(i));
    diff_left(idx(i)) = diff_right(idx(i));
    diff_right(idx(i)) = tmp;
end


syms q  real %集装箱的均匀载荷N/m : Load Intensity
syms E  real %钢铁的弹性模量

%%  搞4次方程组
syms I real  % Moment of Inertia  未知
syms a real  % a总长度
syms x real  % 左侧支撑点

% 可以测得
syms c real %一个常数

delta_l = q * x^4  / (8 * E * I)

M = q * a / 2 * (x - a / 4);

delta_r = M*(a-x)^2/(2*E*I);


 
-x^4/(2*a*(a - x)^2*(a/4 - x))

eq = delta_l / delta_r;


[num, den] = numden(eq); %num分子，den分母

eq2 = simplify (eval(simplify( eq*den) - den*c)) 

%得到系数矩阵Coef
[Coef, T]=coeffs (eq2,x)

%% 开始实际代入数字

% 设置参数
a = 15
g = 9.8;
load k.mat
act_spring_value = load_right * g / K_estimated; %弹簧自身带来的影响
dl = diff_left - act_spring_value;      %重力之外，被影响的z的偏移
dr = diff_right - act_spring_value;     %箱子重之外，被影响的z的偏移
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

mean(res)
std(res)



data = res

boxplot(data, 'Symbol', 'o', 'Colors', 'k', 'orientation', 'horizontal', 'Widths', 3); % 绘制横向箱形图
hold on;  % 保持当前图形，以便添加额外的图层

% 添加数据点
scatter(data, repmat(1, size(data)), 'r', 'filled');  % 注意这里坐标参数的顺序要调换

% 隐藏 y 轴刻度和标签，因为现在 "x" 是数据轴
set(gca, 'YTick', []);  % 删除 y 轴刻度
set(gca, 'YTickLabel', []);  % 删除 y 轴标签

hold off;