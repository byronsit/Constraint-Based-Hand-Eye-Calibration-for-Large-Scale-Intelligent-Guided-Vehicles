%测试AX=XB
function [err_translation,err_rotation] = test_AX_XB(A_matrices, B_matrices, X)
err_translation = []; % 存储平移误差
err_rotation = []; % 存储旋转误差

for i = 1:length(A_matrices)
    A = A_matrices{i};
    B = B_matrices{i};    
    % 计算AX和XB
    AX = A * X;
    XB = X * B;
    
    % 计算平移误差
    err_translation(i) = norm(AX(1:3,4) - XB(1:3,4));
    
    % 计算旋转误差
    R_AX = AX(1:3,1:3);
    R_XB = XB(1:3,1:3);
    err_rotation(i) = norm(R_AX - R_XB, 'fro'); % 使用矩阵的Frobenius范数计算旋转误差
end