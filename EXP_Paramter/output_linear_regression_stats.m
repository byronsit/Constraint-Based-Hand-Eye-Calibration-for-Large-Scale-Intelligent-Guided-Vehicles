function output_linear_regression_stats_without_intercept(x1, x2, y)
    % 检查输入数据
    if isempty(x1) || isempty(x2) || isempty(y)
        error('输入数据不能为空');
    elseif length(x1) ~= length(x2) || length(x1) ~= length(y)
        error('所有输入向量的长度必须相同');
    end

    % 组合 x1 和 x2 到一个矩阵中
    X = [x1, x2];

    % 拟合不包含截距的线性模型
    robustOptions = struct('RobustWgtFun', 'huber', 'Tuning', 1.345);

lm = fitlm(X, y, 'Intercept', false, 'RobustOpts', robustOptions);

    % 显示完整的线性模型结果
    disp(lm);

    % 提取和计算重要的统计量
    coefficients = lm.Coefficients.Estimate;
    ci = coefCI(lm);
    R2 = lm.Rsquared.Ordinary;
    R2_adj = lm.Rsquared.Adjusted;
    F = lm.anova.F(1);  % F统计量
    p_value = lm.anova.pValue(1);  % p值
    RMSE = lm.RMSE;

    % 输出统计结果
    fprintf('Coefficients:\n');
    fprintf('a1 = %.4f (95%% CI: [%.4f, %.4f])\n', coefficients(1), ci(1,1), ci(1,2));
    fprintf('a2 = %.4f (95%% CI: [%.4f, %.4f])\n', coefficients(2), ci(2,1), ci(2,2));
    fprintf('R² = %.4f\n', R2);
    fprintf('Adjusted R² = %.4f\n', R2_adj);
    fprintf('F-statistic = %.4f\n', F);
    fprintf('p-value = %.4e\n', p_value);
    fprintf('RMSE = %.4f\n', RMSE);
end