function J = J_func_hand_PCR(RR, scale, tt, A, B)
J = vpa(0);
len = size(A, 2);
for i = 1 : len
    res = scale*RR*A(:,i) + tt - B(:,i);
    J = J + 1 / len * res'*res;
end
end