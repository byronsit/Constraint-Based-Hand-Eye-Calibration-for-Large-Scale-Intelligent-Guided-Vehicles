%还没写完

clc
clear all
close all

syms q  real %集装箱的均匀载荷N/m : Load Intensity
syms E  real %钢铁的弹性模量

%% 未知
syms I real  % Moment of Inertia  未知
syms a real  % a总长度
syms x real  % 左侧支撑点
syms EI real % E* I;
% 可以测得
syms c real %一个常数
syms delta_r real

delta_l = q * x^4  / (8 * EI)

M = q * a / 2 * (x - a / 4);

delta_r = simplify(M*(a-x)^2/(2*EI));
[C, T] = coeffs(delta_r, [q])
[C, T] = coeffs(delta_r, [a])
