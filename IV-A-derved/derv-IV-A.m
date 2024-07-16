%% 对应paper里的公式(7)(8)

clc;
clear;
syms y(x) x EI q u


% 微分方程
eq1 = EI*diff(y, x, 4) == q;

% 边界条件
% x = 0 是自由端
eq2 = subs(diff(y, x, 2), x, 0) == 0; % M = 0 at x = 0
eq3 = subs(diff(y, x, 3), x, 0) == 0; % V = 0 at x = 0
% x = u 是支撑点，假设它是一个允许旋转的简支
eq4 = subs(y, x, u) == 0; % y(u) = 0
eq5 = subs(diff(y,x,1),x,u) == 0

% 求解微分方程
ySol = dsolve([eq1, eq2, eq3, eq4, eq5]); % paper公式6

% 显示解
disp(ySol);


% 一阶导，在0处的取值
deg = subs(diff(ySol,x,1),x, 0)

dy = subs(ySol, x, 0)