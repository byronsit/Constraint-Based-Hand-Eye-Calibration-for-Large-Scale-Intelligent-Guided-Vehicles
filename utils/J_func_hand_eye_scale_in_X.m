function J = J_func_hand_eye_scale_in_X(X, A, B, scale)
J = vpa(0);
len = size(A, 3);
X(1:3,1:3) = X(1:3,1:3)*scale;
for i = 1 : len
    res = A(:, :, i) * X - X * B(:, :, i);
    J = J + 1 / len * trace(res.' * res);
end
end