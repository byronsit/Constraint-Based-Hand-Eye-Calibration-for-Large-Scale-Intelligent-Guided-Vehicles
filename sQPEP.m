% 
% LibQPEP: A Library for Globally Optimal Solving Quadratic Pose Estimation Problems (QPEPs),
%          It also gives highly accurate uncertainty description of the solutions.
%
%
% Article: 
%      Wu, J., Zheng, Y., Gao, Z., Jiang, Y., Hu, X., Zhu, Y., Jiao, J., Liu, M. (2020)
%           Quadratic Pose Estimation Problems: Globally Optimal Solutions, 
%           Solvability/Observability Analysis and Uncertainty Description.
%           IEEE Transactions on Robotics.
%           https://doi.org/10.1109/TRO.2022.3155880
%
%
% Authors:      Jin Wu and Ming Liu
% Affiliation:  Hong Kong University of Science and Technology (HKUST)
% Emails:       jin_wu_uestc@hotmail.com; eelium@ust.hk
% Websites:     https://zarathustr.github.io
%               https://ram-lab.com
%          
%
% syms_hand_eye.m: Generating symbolic expressions for solving hand-eye 
%                  calibration problem

%点云缩放，point cloud point 2 plane.   scale在R上

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
tt = [t1; t2; t3]; 
tts=[t1;t2;t3;scale];
RR = q2R(q);
XX = [
    RR, tt;
    zeros(1, 3), 1];
J_pure = J_func_hand_eye(XX, A, B);
[coef_J_pure, mon_J_pure] = coeffs(J_pure, [q; tt; scale]);
generateFuncFile(coef_J_pure, fullfile('func_files', 'coef_J_pure_hand_eye_func_sQPEP.m'), {var_A(1 : 3, :), B(1 : 3, :)});
generateFuncFile(mon_J_pure, fullfile('func_files', 'mon_J_pure_hand_eye_func_sQPEP.m'), {q, tt, scale});
J = J_pure - 0.5 * lambda * (q.' * q - 1);
x = [q; tt; lambda; scale];
Jacob = jacobian(J, x);
Jacob = expand(Jacob.');

%%

%%


coef_len = length(coef_J_pure);
str = sprintf('coef_J = sym(''coef_J'', [1, %d]);', coef_len);
eval(str);
showSyms(symvar(coef_J));
J = coef_J * mon_J_pure.' - 0.5 * lambda * (q.' * q - 1);
x = [q; tt; lambda; scale];
Jacob = jacobian(J, x);
Jacob = expand(Jacob.');


[coeft1, mont1] = coeffs(Jacob(5), [tt;scale]);
g1 = coeft1(1 : 4).';
[coeftq1, montq1] = coeffs(expand(Jacob(5) - g1.' * [tt;scale] ), q);
generateFuncFile(coeftq1, fullfile('func_files', 'coeftq1_hand_eye_func_sQPEP.m'), {coef_J});
[coeft2, mont2] = coeffs(Jacob(6), [tt;scale]);
g2 = coeft2(1 : 4).';
[coeftq2, montq2] = coeffs(expand(Jacob(6) - g2.' * [tt;scale] ), q);
generateFuncFile(coeftq2, fullfile('func_files', 'coeftq2_hand_eye_func_sQPEP.m'), {coef_J});
[coeft3, mont3] = coeffs(Jacob(7), [tt;scale]);
g3 = coeft3(1 : 4).';
[coeftq3, montq3] = coeffs(expand(Jacob(7) - g3.' * [tt;scale] ), q);
generateFuncFile(coeftq3, fullfile('func_files', 'coeftq3_hand_eye_func_sQPEP.m'), {coef_J});


[coeft4, mont4] = coeffs(Jacob(9), [tt;scale]);
g4 = coeft4(1 : 4).';
[coeftq4, montq4] = coeffs(expand(Jacob(9) - g4.' * [tt;scale] ), q);
generateFuncFile(coeftq4, fullfile('func_files', 'coeftq4_hand_eye_func_sQPEP.m'), {coef_J});


G = - [g1.'; g2.'; g3.';g4.'];
generateFuncFile(G, fullfile('func_files', 'G_hand_eye_func_sQPEP.m'), {coef_J});

pinvG = sym('pinvG', [4, 4]);
showSyms(symvar(pinvG));
coefs_tq = sym('coefs_tq', [4, 10]); %raw->[4, 11]
showSyms(symvar(coefs_tq));
ts = pinvG * coefs_tq * montq1.';
t1 = ts(1);
t2 = ts(2);
t3 = ts(3);
scale = ts(4);

%%测试点东西
% [co, mon] = coeffs(scale, q);
% 
% 
% [a,b]=coeffs( eval(jacob(1)) + lambda * q0, q)
%     %= coeffs(Jacob(1) + lambda * q0, [q; tts]);
% 
% [a,b]=coeffs(jacob1, q)
% 
% [a1,b1] = coeffs(coef_J24*scale + coef_J21*t1 + coef_J22*t2 + coef_J23*t3,q)
%assume(t1==)






generateFuncFile(t1, fullfile('func_files', 't1_hand_eye_func_sQPEP.m'), {pinvG, coefs_tq, q});
generateFuncFile(t2, fullfile('func_files', 't2_hand_eye_func_sQPEP.m'), {pinvG, coefs_tq, q});
generateFuncFile(t3, fullfile('func_files', 't3_hand_eye_func_sQPEP.m'), {pinvG, coefs_tq, q});
generateFuncFile(scale, fullfile('func_files', 'ss_hand_eye_func_sQPEP.m'), {pinvG, coefs_tq, q});

%% 四元数
% jj = subs(Jacob(1), t1, eval(t1))
% jj = subs(jj, t2, eval(t2))
% jj = subs(jj, t3, eval(t3))
% [a, b] = coeffs(expand( eval(jj)) + lambda * q0, [q]);    %%测试
% a*b.' - coef_Jacob1_qt*mon_Jacob1_qt.'
% generateFuncFile(a, fullfile('func_files', 'tttt.m'), {pinvG,coefs_tq,coef_J, q})
% %上面是debug用的

[coef_Jacob1_qt, mon_Jacob1_qt] = coeffs(Jacob(1) + lambda * q0, [q; tts]);
generateFuncFile(coef_Jacob1_qt, fullfile('func_files', 'coef_Jacob1_qt_hand_eye_func_sQPEP.m'), {coef_J});
[coef_Jacob2_qt, mon_Jacob2_qt] = coeffs(Jacob(2) + lambda * q1, [q; tts]);
generateFuncFile(coef_Jacob2_qt, fullfile('func_files', 'coef_Jacob2_qt_hand_eye_func_sQPEP.m'), {coef_J});
[coef_Jacob3_qt, mon_Jacob3_qt] = coeffs(Jacob(3) + lambda * q2, [q; tts]);
generateFuncFile(coef_Jacob3_qt, fullfile('func_files', 'coef_Jacob3_qt_hand_eye_func_sQPEP.m'), {coef_J});
[coef_Jacob4_qt, mon_Jacob4_qt] = coeffs(Jacob(4) + lambda * q3, [q; tts]);
generateFuncFile(coef_Jacob4_qt, fullfile('func_files', 'coef_Jacob4_qt_hand_eye_func_sQPEP.m'), {coef_J});


coef_Jacob1_qt_syms = sym('coef_Jacob1_qt_syms', [1, 36]);
coef_Jacob2_qt_syms = sym('coef_Jacob2_qt_syms', [1, 36]);
coef_Jacob3_qt_syms = sym('coef_Jacob3_qt_syms', [1, 36]);
coef_Jacob4_qt_syms = sym('coef_Jacob4_qt_syms', [1, 36]);
showSyms(symvar(coef_Jacob1_qt_syms));
showSyms(symvar(coef_Jacob2_qt_syms));
showSyms(symvar(coef_Jacob3_qt_syms));
showSyms(symvar(coef_Jacob4_qt_syms));
coef_Jacob_qt_syms = [
    coef_Jacob1_qt_syms;
    coef_Jacob2_qt_syms;
    coef_Jacob3_qt_syms;
    coef_Jacob4_qt_syms;
    ];
Jacob_ = coef_Jacob_qt_syms * mon_Jacob1_qt.';
    
eqs = expand(eval([Jacob_; Jacob(8)]));

f0 = eqs(1);
f1 = eqs(2);
f2 = eqs(3);
f3 = eqs(4);
[coef_f0_q, mon_f0_q] = coeffs(f0, q);
[coef_f1_q, mon_f1_q] = coeffs(f1, q);
[coef_f2_q, mon_f2_q] = coeffs(f2, q);
[coef_f3_q, mon_f3_q] = coeffs(f3, q);
coef_f0_q_sym = sym('coef_f0_q_sym', [1, 20]);
coef_f1_q_sym = sym('coef_f1_q_sym', [1, 20]);
coef_f2_q_sym = sym('coef_f2_q_sym', [1, 20]);
coef_f3_q_sym = sym('coef_f3_q_sym', [1, 20]);
showSyms(symvar(coef_f0_q_sym));
showSyms(symvar(coef_f1_q_sym));
showSyms(symvar(coef_f2_q_sym));
showSyms(symvar(coef_f3_q_sym));

coef_f_q_sym = [
    coef_f0_q;
    coef_f1_q;
    coef_f2_q;
    coef_f3_q;
    ];
generateFuncFile(coef_f_q_sym, fullfile('func_files', 'coef_f_q_sym_hand_eye_func_sQPEP.m'), {pinvG, coefs_tq, coef_Jacob_qt_syms});

f0 = coef_f0_q_sym * mon_f0_q.';
f1 = coef_f1_q_sym * mon_f1_q.';
f2 = coef_f2_q_sym * mon_f2_q.';
f3 = coef_f3_q_sym * mon_f3_q.';
eq = expand([
     f0 * q1 - f1 * q0;
     f0 * q2 - f2 * q0;
     f0 * q3 - f3 * q0;
     q0 * q0 + q1 * q1 + q2 * q2 + q3 * q3 - 1;
     ]);
generateFuncFile(eq, fullfile('func_files', 'eq_hand_eye_func_sQPEP.m'), {coef_f0_q_sym, coef_f1_q_sym, coef_f2_q_sym, coef_f3_q_sym, q});

eq_ = eq;
eq_ = expand(eval(subs(eq_, q0^2, (1 - q1^2 - q2^2 - q3^2))));
[coefeq1, moneq1] = coeffs(eq_(1), q); 
[quadratic_indices quartic_indices]=get_index_poly(moneq1);
mon2th1 = moneq1(quadratic_indices);
mon4th1 =  moneq1(quartic_indices);

[coefeq2, moneq2] = coeffs(eq_(2), q); 
[quadratic_indices quartic_indices]=get_index_poly(moneq2);
mon2th2 = moneq1(quadratic_indices);
mon4th2 =  moneq1(quartic_indices);

[coefeq3, moneq3] = coeffs(eq_(3), q); 
[quadratic_indices quartic_indices]=get_index_poly(moneq3);
mon2th3 = moneq1(quadratic_indices);
mon4th3 =  moneq1(quartic_indices);


coef2th1 = coefeq1(quadratic_indices);
coef4th1 = coefeq1(quartic_indices);

coef2th2 = coefeq2(quadratic_indices);
coef4th2 = coefeq2(quartic_indices);

coef2th3 = coefeq3(quadratic_indices);
coef4th3 = coefeq3(quartic_indices);


% coef2th2 = [ coefeq2(10), coefeq2(14), coefeq2(16), coefeq2(23), coefeq2(27), coefeq2(29), coefeq2(33), coefeq2(35), coefeq2(37)];
% coef4th2 = [ coefeq2(1 : 9), coefeq2(11 : 13), coefeq2(15), coefeq2(17 : 22), coefeq2(24 : 26), coefeq2(28), coefeq2(30 : 32), coefeq2(34), coefeq2(36), coefeq2(38)];
% 
% coef2th3 = [ coefeq3(10), coefeq3(14), coefeq3(16), coefeq3(23), coefeq3(27), coefeq3(29), coefeq3(33), coefeq3(35), coefeq3(37)];
% coef4th3 = [ coefeq3(1 : 9), coefeq3(11 : 13), coefeq3(15), coefeq3(17 : 22), coefeq3(24 : 26), coefeq3(28), coefeq3(30 : 32), coefeq3(34), coefeq3(36), coefeq3(38)];

y = mon2th1.';
generateFuncFile(y, fullfile('func_files', 'y_func_hand_eye_sQPEP.m'), {q});
v = mon4th1(1 : end - 1).';
generateFuncFile(v, fullfile('func_files', 'v_func_hand_eye_sQPEP.m'), {q});

D = [
    coef4th1(1 : end - 1);
    coef4th2(1 : end - 1);
    coef4th3(1 : end - 1);
    ];

G = [
    coef2th1;
    coef2th2;
    coef2th3;
    ];

c = [
    coef4th1(end);
    coef4th2(end);
    coef4th3(end);
    ];

generateFuncFile(D, fullfile('func_files', 'D_func_hand_eye_sQPEP.m'), {coef_f0_q_sym, coef_f1_q_sym, coef_f2_q_sym, coef_f3_q_sym});
generateFuncFile(G, fullfile('func_files', 'G_func_hand_eye_sQPEP.m'), {coef_f0_q_sym, coef_f1_q_sym, coef_f2_q_sym, coef_f3_q_sym});
generateFuncFile(c, fullfile('func_files', 'c_func_hand_eye_sQPEP.m'), {coef_f0_q_sym, coef_f1_q_sym, coef_f2_q_sym, coef_f3_q_sym});


%提取项用的
HH = jacobian(eq, q);
generateFuncFile(HH, fullfile('func_files', 'Jacob_hand_eye_func_sQPEP.m'), {coef_f0_q_sym, coef_f1_q_sym, coef_f2_q_sym, coef_f3_q_sym, q});
gradient = expand(HH.' * eq);
%HH似乎没用到
[coef1, mon1] = coeffs(eqs(1), x);
[coef2, mon2] = coeffs(eqs(2), x);
[coef3, mon3] = coeffs(eqs(3), x);
[coef4, mon4] = coeffs(eqs(4), x);

% Q_sym = [
%     coef1(11), coef1(18), coef1(22), coef1(24);
%     coef2(11), coef2(18), coef2(22), coef2(24);
%     coef3(11), coef3(18), coef3(22), coef3(24);
%     coef4(11), coef4(18), coef4(22), coef4(24);
%     ];
% generateFuncFile(Q_sym, fullfile('func_files', 'Q_hand_eye_func_sQPEP.m'), {pinvG, coefs_tq, coef_Jacob_qt_syms});

%res = expand(eqs(1 : 4) - Q_sym * q);
res = expand(eqs(1 : 4));
H = jacobian(res, q);
h1 = H(:, 1);
h2 = H(:, 2);
h3 = H(:, 3);
h4 = H(:, 4);
P1 = jacobian(h1, q);
P2 = jacobian(h2, q);
P3 = jacobian(h3, q);
P4 = jacobian(h4, q);
%mon_f0_q
%%
s = sum(mon_f0_q);
f=jacobian(s, q)

%%

for i = 1 : 4
    for j = 1 : 4
        str = sprintf('W%d%d = [jacobian(P%d(1, :), q%d).''; jacobian(P%d(2, :), q%d).''; jacobian(P%d(3, :), q%d).''; jacobian(P%d(4, :), q%d).''];', ...
                        i, j, i, j - 1, i, j - 1, i, j - 1, i, j - 1);
        eval(str);
    end
end


W1 = [W11, W12, W13, W14];
W2 = [W21, W22, W23, W24];
W3 = [W31, W32, W33, W34];
W4 = [W41, W42, W43, W44];
v = kron(q, q);
u = kron(v, q);
W = [W1, W2, W3, W4] / 6;
generateFuncFile(W, fullfile('func_files', 'W_hand_eye_func_sQPEP.m'), {pinvG, coefs_tq, coef_Jacob_qt_syms});
%4x4 4x10 4x36

%% 推导公式(8)试试看
% 既然有了-W,
%syms_lambda = 

sym_lambda = coef_f0_q_sym * mon_f3_q.'/q0;
%[coef_f3_q, mon_f3_q] = coeffs(f3, q);
%coef_f0_q_sym = sym('coef_f0_q_sym', [1, 20]);

W_sym = sym('W_sym', [4, 64]);
showSyms(symvar(W_sym));
eq8 = W_sym*u*q0- q* coef_f0_q_sym * mon_f3_q.'    
eq8 = simplify(eq8);
eq8 = expand(eq8);
%% 推导公式(9)看看


new_eq8 = subs(eq8, q0^2, 1-q1^2-q2^2-q3^2)
new_eq8 = subs(new_eq8, q0^3, q0*q0^2)
new_eq8 = subs(new_eq8, q0^2, 1-q1^2-q2^2-q3^2)

[eq9_a1 eq9_b1]=coeffs(new_eq8(2),[q0 q1 q2 q3])
[eq9_a2 eq9_b2]=coeffs(new_eq8(3),[q0 q1 q2 q3])
[eq9_a3 eq9_b3]=coeffs(new_eq8(4),[q0 q1 q2 q3])

%通过W的数值，结合coef_f0_q_sym就可以得到M矩阵啦
M = [eq9_a1; eq9_a2; eq9_a3];
generateFuncFile(M, fullfile('func_files', 'M_hand_eye_func_sQPEP.m'), {W_sym,coef_f0_q_sym});

%% plane B!


return

tot=zeros(1,10);
for i = 1 : length(eq9_b1)
 c(i)=calculatePolynomialDegree(eq9_b1(i));
 tot(c(i)+1)=tot(c(i)+1)+1; 
end