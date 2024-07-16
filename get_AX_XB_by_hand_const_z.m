%% 手动计算AX=XB的数据，但是没有任何约束项。这样会有很多解。
% 这个是用matlab自带的优化器来算，【约束z】的信息
clc
clear all
close all

load simulated_AB

%save('simulated_AB', 'A_matrices', 'B_matrices','A_matrices_new', 'T_cb', 'T_cprime_b', 'diff_pitch', 'diff_z');
%似乎！有2个0解？
% 基于优化的方法
AA=T_cb;

%x_init = decompose_X(AA);
x_init=[0 0 0 0 0 0].';
z = T_cb(3,4);
res=optimize_AX_XB(A_matrices, B_matrices, x_init, z)

%res - T_cb


function X = optimize_AX_XB(A_matrices, B_matrices, x_init, z)
    %global z
    % 将初始变换矩阵转换为李代数向量
    %x_init = decompose_X(X_init);
    
    % 定义优化问题的目标函数
    objective = @(x) objective_function(x, A_matrices, B_matrices, z);
    
    % 定义优化算法的选项
    options = optimoptions('fmincon', 'Algorithm', 'interior-point', 'SpecifyObjectiveGradient', false, 'Display', 'off','StepTolerance', 1e-8);
    
    % 求解无约束优化问题
    x_opt = fmincon(objective, x_init, [], [], [], [], [], [], [], options);
    
    % 将优化结果转换为变换矩阵X
    x_opt(3) = z;
    X = compose_X(x_opt);
    final_error = objective_function(x_opt, A_matrices, B_matrices, z);
    fprintf('Final residual: %e\n', final_error);
end

function error = objective_function(x, A_matrices, B_matrices, z)
    x(3)=z;
    X = compose_X(x);
    
    error = 0;
    for i = 1:length(A_matrices)
        A = A_matrices{i};
        B = B_matrices{i};
        
        % 计算AX-XB的误差
        error = error + norm(A * X - X * B, 'fro')^2;
    end
end
function x = decompose_X(X)
    R = X(1:3, 1:3);
    t = X(1:3, 4);
    w = rotation_log(R);
    x = [t; w];
end

function X = times__(x)
X = [
    0, -x(1), x(2);
    x(1), 0, -x(3);
    -x(2), x(3), 0;
    ];
end

function X = compose_X(x)
    t = x(1:3);
    w = x(4:6);
    R = expm(times__(w));
    X = [R, t; 0, 0, 0, 1];
end

function w = rotation_log(R)
    theta = acos((trace(R) - 1) / 2);
    
    if theta < 1e-12
        w = zeros(3, 1);
    else
        A = (R - R') / (2 * sin(theta));
        w = theta * [A(3, 2); A(1, 3); A(2, 1)];
    end
end