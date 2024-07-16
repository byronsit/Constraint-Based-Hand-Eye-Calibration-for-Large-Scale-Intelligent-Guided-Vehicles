% 定义符号变量，推导重心公式
syms Xg M A1 A2 theta a real

% 计算铁棍原本重心对系统重心的贡献
weightContribution = M * (a / 2);  % 铁棍自重乘以其原始重心位置

% 计算力A1作用点相对于倾斜后的新重心位置的贡献
forceA1Contribution = A1 * (Xg + (a/4 - Xg) * cos(theta));  % A1作用在左侧部分，考虑倾斜影响

% 计算力A2作用点相对于倾斜后的新重心位置的贡献
forceA2Contribution = A2 * (Xg + (3 * a / 4 - Xg) * cos(theta));  % A2作用在右侧部分，同样考虑倾斜影响

% 计算总质量
totalMass = M + A1 + A2;  % 系统的总质量，包括铁棍自重和两个作用力的等效质量

% 构建重心位置的方程
centerOfMassEquation = Xg == (weightContribution + forceA1Contribution + forceA2Contribution) / totalMass;  % 重心方程

% 近似替换
approximate_centerOfMassEquation = subs(centerOfMassEquation, cos(theta), 1-theta*theta/2 )


% 求解Xg的表达
solve(approximate_centerOfMassEquation, Xg)