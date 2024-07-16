% 已知量
A = 1; % 重物质量
M = 10; % 底盘质量
g = 9.8; % 重力加速度
k = 1000; % 弹簧刚度系数
x = 0.5; % 重物位置

% 小角度近似
cos_theta = 1 - theta^2/2;
sin_theta = theta;

% 几何约束
delta_R = delta_L - 2*d*theta;

% 力矩计算
tau_cargo = A*g*x*cos_theta;
tau_chassis = 0;
F_L = -k * (delta_L + M*g/(2*k));
F_R = -k * (delta_R + M*g/(2*k));
tau_L = F_L * d * cos_theta;
tau_R = -F_R * d * cos_theta;

% 平衡方程
torque_eq = tau_cargo + tau_L + tau_R == 0;
vertical_eq = A*g + M*g + F_L + F_R == 0;

% 消去 delta_L 和 delta_R
eq1 = subs(torque_eq, [delta_L, delta_R], [delta_L, delta_L - 2*d*theta]);
eq2 = subs(vertical_eq, [delta_L, delta_R], [delta_L, delta_L - 2*d*theta]);

% 求解 d
res = solve(eq1, eq2, d, 'ReturnConditions', true)
pretty(simplify(d_sol))