%% 用来测试模拟出来的AX=XB的问题的
clc
clear all
close all
load simulated_AB.mat

Tx = 7.345465303849309; Ty = 0.1395879022194233; Tz = 1.495; % 平移
qx = 0.5744485910542397; qy = -0.5731322100778303; qz = 0.414850377485667; qw = -0.4116156584814286;
noise_level_translation = 0; % 平移噪声水平(米)
noise_level_rotation = 0.1; % 旋转噪声水平(弧度)

% 将四元数转换为旋转矩阵
R = quat2rotm([qw, qx, qy, qz]);

% 将旋转矩阵转换为旋转向量
so3_mat = logm(R);
rot_vec = [so3_mat(3, 2), so3_mat(1, 3), so3_mat(2, 1)] + noise_level_rotation * randn(1,3);

% 构建初始猜测向量x0
x0 = [rot_vec, Tx, Ty, Tz];

X = solve_AX_XB(A_matrices, B_matrices, x0);

gt_X = [R,[Tx, Ty, Tz].';0 0 0 1];

gt_R = R;
RR = X(1:3,1:3).';
acosd((trace(gt_R*RR.')-1)/2) %角度误差（度）

gt_X(1:3,4)-(-RR* X(1:3,4) ) % 平移误差

function cost = objective_function(x, AA, BB)
    % 提取旋转向量和平移向量
    rot_vec = x(1:3);
    trans_vec = x(4:6).';
    
    % 使用指数映射将旋转向量转换为旋转矩阵
    R = expm(skew(rot_vec));
    
    % 构建变换矩阵X
    X = [R, trans_vec; 0, 0, 0, 1];
    
    % 计算cost函数(AX-XB的Frobenius范数)
    cost = 0;
    for i = 1 : length(AA)
        A = AA{i};
        B = BB{i};
        cost = norm(A*X - X*B, 'fro') + cost;
    end
end

% 定义反对称矩阵函数
function S = skew(v)
    S = [0, -v(3), v(2); v(3), 0, -v(1); -v(2), v(1), 0];
end

% 主函数
function X = solve_AX_XB(A, B, x0)
    % 设置优化选项
    options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'interior-point');
    
    % 运行优化
    x_opt = fmincon(@(x)objective_function(x, A, B), x0, [], [], [], [], [], [], [], options);
    
    % 提取优化后的旋转向量和平移向量
    rot_vec_opt = x_opt(1:3);
    trans_vec_opt = x_opt(4:6);
    
    % 使用指数映射将旋转向量转换为旋转矩阵
    R_opt = expm(skew(rot_vec_opt));
    
    % 构建优化后的变换矩阵X
    X = [R_opt, trans_vec_opt.'; 0, 0, 0, 1];
end