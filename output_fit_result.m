%就是XX,YY.不带截距的！
function ret=output_fit_result(Ag, delta_L) 
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
p_value
fprintf('RMSE = %.10f\n', RMSE);


ret = lm.Coefficients.Estimate(1);



return