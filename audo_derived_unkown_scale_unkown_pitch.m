% 

clear all
close all
clc

addpath('func_files');
addpath('utils');

syms A11 A12 A13 A14 real
syms A21 A22 A23 A24 real
syms A31 A32 A33 A34 real
syms scale real

var_A=[
        A11, A12, A13, A14;
    A21, A22, A23, A24;
    A31, A32, A33, A34;
      0,   0,   0,   1;
    ];

A = [
    A11, A12, A13, scale*A14;
    A21, A22, A23, scale*A24;
    A31, A32, A33, scale*A34;
      0,   0,   0,   1;
      ];

syms B11 B12 B13 B14 real
syms B21 B22 B23 B24 real
syms B31 B32 B33 B34 real

B = [
    B11, B12, B13, B14;
    B21, B22, B23, B24;
    B31, B32, B33, B34;
      0,   0,   0,   1;
      ];
  
  
syms q0 q1 q2 q3 real
syms t1 t2 t3 lambda real
q = [q0; q1; q2; q3];
tt = [t1; t2]; 
RR = q2R(q);
XX = [
    RR, [t1;t2;t3];
    zeros(1, 3), 1];
old_J_pure = J_func_hand_eye(XX, var_A, B);
J_pure     = J_func_hand_eye(XX, A, B);

%sQPEP的AX=XB的残差(不考虑t3)
[coef_J_pure, mon_J_pure] = coeffs(J_pure, [q; [t1; t2]; scale]);

%QPEP的AX=XB的残差
[old_coef_J_pure, old_mon_J_pure] = coeffs(old_J_pure, [q; [t1;t2;t3]; scale]);

%sQPEP的AX=XB的残差(scale变量用t3代替)
new_mon_J_pure = subs(mon_J_pure, scale, t3); 

new_mon_J_pure - old_mon_J_pure

%惊人的相等，很棒！
sum(new_mon_J_pure - old_mon_J_pure)
