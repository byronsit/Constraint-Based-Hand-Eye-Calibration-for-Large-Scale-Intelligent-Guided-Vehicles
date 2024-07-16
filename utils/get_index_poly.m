% 假设 moneq1 已经定义并且是一个符号表达式数组
% moneq1 = [q0^3*q1, q0^3*q2, ..., q3^2, 1];

function [quadratic_indices quartic_indices ] = get_index_poly(moneq1)
% 遍历 moneq1 数组
quadratic_indices = [];
quartic_indices = [];
for i = 1:length(moneq1)
    % 获取数组中的当前表达式
    expr = moneq1(i);
    % 获取表达式的总次数，即所有变量的次数之和
    [C, T] = coeffs(expr);  % C 是系数，T 是项
    total_degree = sum(feval(symengine, 'degree', T));
    
    % 判断总次数是否为二次或四次
    if total_degree == 2
        quadratic_indices = [quadratic_indices, i];
    elseif total_degree == 4
        quartic_indices = [quartic_indices, i];
    end
end
%四次项要多一个
quartic_indices = [quartic_indices, length(moneq1) ];
end