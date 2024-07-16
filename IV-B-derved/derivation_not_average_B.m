% 推导非均匀放置下的公式
clc
clear all 
close all

%% 重心的公式
syms Xg M A1 A2 theta cos_theta a real

% 计算铁棍的新的重心(倾斜后)
P_M = Xg + (a/2 - Xg) * cos(theta);   %  铁棍自重乘以其原始重心位置

% 计算力A1作用点的重心(倾斜后)
P_A1 =  Xg + (a/4 - Xg) * cos(theta);  % A1作用在左侧部分，考虑倾斜影响
%forceA1Contribution = subs(forceA1Contribution, cos(theta), 1-theta*theta/2 )


% 计算力A2作用点的重心(倾斜后)
P_A2 =  Xg + (3 * a / 4 - Xg) * cos(theta);  % A2作用在右侧部分，同样考虑倾斜影响
%forceA2Contribution = subs(forceA2Contribution, cos(theta), 1-theta*theta/2 )

% 计算总质量
totalMass = M + A1 + A2;  % 系统的总质量，包括铁棍自重和两个作用力的等效质量

% 构建重心位置的方程
eq0 = Xg == (M * P_M + A1 * P_A1 + A2 * P_A2) / totalMass;  % 重心方程

%直接得到全新重心的表达式
Xg = solve(eq0, Xg); %发现重心的位置是始终不变的

%% 弹簧约束
syms k sigma_l sigma_r g u real
L0 = M * g / (2*k);                                      % 弹簧本身因为M被压缩的长度
F_l = k * (sigma_l + L0);                                % 弹簧力，额外被压缩
F_r = k * (sigma_r + L0);                                % 弹簧右测力

eq1 = F_l + F_r == (A1 + A2 + M)*g                   %弹簧力提供向上的力，等于重力之和
%eq2 = sigma_l - sigma_r == (a-2*u)*tan(theta)       %弹簧长度，存在几何约束，所以有一个theta
tan_theta = ((sigma_l - sigma_r)/(a-2*u));
cos_theta = sqrt(1/(tan_theta^2+1));
%% 力矩约束

%重新根据tan_theta换算写cos_theta
approx_P_M  = Xg + (a / 2     - Xg) * cos_theta;
approx_P_A1 = Xg + (a / 4     - Xg) * cos_theta;
approx_P_A2 = Xg + (3 * a / 4 - Xg) * cos_theta;


F_s = F_l * (Xg-u) + F_r * (Xg - (a-u))                                            % 弹簧的力矩
F_w = A1 * (Xg - approx_P_A1) + A2 * (Xg - approx_P_A2) + M * (Xg - approx_P_M)    %                        重力的力矩

%
eq2 = F_s == F_w


eq1 = eval(eq1);
eq2 = eval(eq2);

%% 假设，去掉非法无用解
assume(a, 'real')
assumeAlso(a > 0)
assumeAlso(k > 0)
assumeAlso(M > 0)
assumeAlso(g > 9)
assumeAlso(A1 > 0)
assumeAlso(A2 >= 0)
assumeAlso(theta >= 0)
assumeAlso(theta < 30/180*pi)
assumeAlso(A1 > A2)
assumeAlso(u > 0)
assumeAlso(u < a/2)
assumeAlso(sigma_l>=0)
assumeAlso(sigma_r>=0)



%% 直接根据几何约束求解,得到弹簧压缩量res.sigma_l(1)和res.sigma_r(1)
res = solve(eq1, eq2 , sigma_l, sigma_r,'ReturnConditions', true)
[aa_l,bb_l] = coeffs(simplify(res.sigma_l(1)),[A1;A2])  %paper上的公式

%simplify(res.sigma_r(1))
[aa_r,bb_r] = coeffs(simplify(res.sigma_r(1)),[A1;A2])  %paper上的公式


%% 替换tan_theta，得到theta表达式,
sigma_l = res.sigma_l(1);   
sigma_r = res.sigma_r(1);   
tan_theta = eval(tan_theta)
cos_theta = eval(cos_theta)
[aa_theta, bb_theta] = coeffs(simplify(cos_theta),[A1;A2]) %实际上也用不着
[aa_theta, bb_theta] = coeffs(simplify(tan_theta),[A1;A2]) %实际上也用不着
[aa_theta, bb_theta] = coeffs(simplify(sin_theta),[A1;A2]) %实际上也用不着


%% 推导在0和a的高度公式，因为要考虑theta。要替换到最左和最右边
sin_theta = tan_theta * cos_theta;
LL = sigma_l + u * sin_theta;
LL = simplify(LL);
RR = sigma_r - u * sin_theta;
RR = simplify(RR);

[aa_l,bb] = coeffs(LL,[A1;A2])
simplify(aa_l)  %paper上的公式


[aa_r,bb] = coeffs(RR,[A1;A2])
simplify(aa_r) %paper上的公式
