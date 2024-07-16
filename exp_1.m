
clc
clear all
close all
delta_L = [0.0265; 0.0505; 0.0625; 0.011; 0.034; 0.0535; 0.069; 0.0655];

% 增加的质量（吨）
A = [8; 24; 32; 8; 24; 32; 32; 32];

% 重力加速度（m/s^2）
g = 9.8;

% 将质量转换为公斤并计算重力作用力
Ag = 1000 * A * g; % 单位：牛顿

% 线性模型拟合
lm = fitlm(Ag, delta_L); %XX YY

% 显示模型的统计摘要
disp(lm);


%% 算不带截距的

lm = fitlm(Ag, delta_L,'Intercept', false); %XX YY
disp(lm);
% 计算预测值和残差
y_pred = predict(lm, Ag);
residuals = delta_L - y_pred;

% 计算 RSS 和 TSS
RSS = sum(residuals.^2);
TSS = sum(delta_L.^2); % 无截距模型的 TSS

% 计算 R² 和调整 R²
n = length(delta_L);
p = lm.NumPredictors;
R2 = 1 - RSS / TSS;
R2_adj = 1 - ((1 - R2) * (n - 1)) / (n - p - 1);

% 计算 F 统计量和 p 值
F = (TSS - RSS) / p / (RSS / (n - p));
p_value = 1 - fcdf(F, p, n - p);

% 计算 RMSE
RMSE = sqrt(mean(residuals.^2));

% 显示结果
fprintf('R² = %.10f\n', R2);
fprintf('Adjusted R² = %.10f\n', R2_adj);
fprintf('F-statistic = %.10f\n', F);
fprintf('p-value = %.10f\n', p_value);
fprintf('RMSE = %.10f\n', RMSE);


K_estimated = 1 / lm.Coefficients.Estimate(1);
save('k','K_estimated')


return