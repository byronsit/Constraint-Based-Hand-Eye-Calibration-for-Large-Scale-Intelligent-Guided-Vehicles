
% 普通scale的AX=XB，但是有const的z,并且不需要求解pitch
% 推导 有 scale，且有pitch的

clear all
close all
clc

addpath('func_files');
addpath('utils');

%syms scale real

syms q0 q1 q2 q3 real
syms t1 t2 t3 lambda mu real
syms pc ps ac as gc gs real

% syms pa_1 pa_2 pa_3 real
% syms pb_1 pb_2 pb_3 real
% syms nv_1 nv_2 nv_3 real
problem_name = ['const_pitch_kown_scale'];
q_exp4 = [q0^4, q0^3*q1, q0^3*q2, q0^3*q3, q0^2*q1^2, q0^2*q1*q2, q0^2*q1*q3, q0^2*q2^2, q0^2*q2*q3, q0^2*q3^2, q0*q1^3, q0*q1^2*q2, q0*q1^2*q3, q0*q1*q2^2, q0*q1*q2*q3, q0*q1*q3^2, q0*q2^3, q0*q2^2*q3, q0*q2*q3^2, q0*q3^3, q1^4, q1^3*q2, q1^3*q3, q1^2*q2^2, q1^2*q2*q3, q1^2*q3^2, q1*q2^3, q1*q2^2*q3, q1*q2*q3^2, q1*q3^3, q2^4, q2^3*q3, q2^2*q3^2, q2*q3^3, q3^4];
q_exp3 = [q0^3, q0^2*q1, q0^2*q2, q0^2*q3, q0*q1^2, q0*q1*q2, q0*q1*q3, q0*q2^2, q0*q2*q3, q0*q3^2, q1^3, q1^2*q2, q1^2*q3, q1*q2^2, q1*q2*q3, q1*q3^2, q2^3, q2^2*q3, q2*q3^2, q3^3];
q_exp2 = [q0^2, q0*q1, q0*q2, q0*q3, q1^2, q1*q2, q1*q3, q2^2, q2*q3, q3^2];
a2g2 = [ac^2*gc^2, ac^2*gc*gs, ac^2*gs^2, ac*as*gc^2, ac*as*gc*gs, ac*as*gs^2, as^2*gc^2, as^2*gc*gs, as^2*gs^2];

syms A11 A12 A13 A14 real
syms A21 A22 A23 A24 real
syms A31 A32 A33 A34 real
%syms scale real

A = [
    A11, A12, A13, A14;
    A21, A22, A23, A24;
    A31, A32, A33, A34;
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

syms C11 C12 C13 C14 real
syms C21 C22 C23 C24 real
syms C31 C32 C33 C34 real

%T_cb一般是已知的
T_cb = [
    C11, C12, C13, C14;
    C21, C22, C23, C24;
    C31, C32, C33, C34;
      0,   0,   0,   1;]
R_cb = T_cb(1:3,1:3);
  

syms t1 t2 t3 lambda real


syms delta_p alpha gama real


quat2axang([1 0 0 0 ])
axang_qy = [0 1 0 delta_p];
axang_qz = [0 0 1 alpha];
axang_qx = [1 0 0 gama];

qy = [cos(delta_p/2), 0, sin(delta_p/2), 0];
qz = [cos(alpha/2), 0, 0, sin(alpha/2)];
qx = [cos(gama/2),sin(gama/2),0,0];

%syms delta_p_2 alpha_2 gama_2
% qy = [cos(delta_p_2), 0, sin(delta_p_2), 0];
% qz = [cos(alpha_2), 0, 0, sin(alpha_2)];
% qx = [cos(gama_2),sin(gama_2),0,0];

qqq=quaternion_multiply(quaternion_multiply(qy,qz),qx)


RRR = q2R(qqq)';

%RR = q2R(qy).'*q2R(qz).'*q2R(qx).'; %和quat2rotm对应，老吴写的q2R是逆似乎。可能遵循某些规则我不懂?
b_R_cprime_c = simplify(q2R(qy)).'* simplify(q2R(qz)).'* simplify(q2R(qx)).'; %和quat2rotm对应，老吴写的q2R是逆似乎。可能遵循某些规则我不懂?
R_cprime_c = R_cb * b_R_cprime_c.' * R_cb.';
RR = R_cprime_c;

rot_sym = [alpha, gama]
%尝试化简RR的形式

x = [ac; as; gc; gs; t1; t2]; %要求的变量
x_origin = [alpha, gama, t1 ,t2]

tt = [t1; t2]; 

%真要估计的是est_t的数值，其中t3可能已知
b_t_c_c_prime = [t1;t2;t3];

R_cprime_b = R_cprime_c * R_cb;
t_cprime_c = R_cprime_b * (-b_t_c_c_prime);



XX = [
    R_cprime_c, t_cprime_c;
    zeros(1, 3), 1];

J = J_func_hand_eye(XX, A, B);
J = simplify(J);
J = simplify(subs(J, sin(gama), gs));
J = simplify(subs(J, cos(gama), gc));
J = simplify(subs(J, sin(alpha), as));
J = simplify(subs(J, cos(alpha), ac));
J = simplify(subs(J, cos(delta_p), pc));
J = simplify(subs(J, sin(delta_p), ps));
[coef_J_pure, mon_J_pure] = coeffs(J, x);

%构建原始的57个元素
generateFuncFile(coef_J_pure, fullfile('func_files', ['coef_J_',problem_name,'.m']), {A(1 : 3, :), B(1 : 3, :),R_cb, ps, t3});

J_coef = sym('J_coef', [1, length(coef_J_pure)]);
showSyms(symvar(J_coef));
J = J_coef*mon_J_pure.';

Jacob = jacobian(J, x).'; %对原始的关于三角函数的进行求导


for i = 1 : length(x)
    % Jacob(i) = simplify(subs(Jacob(i), sin(gama), gs));
    % Jacob(i) = simplify(subs(Jacob(i), cos(gama), gc));
    % Jacob(i) = simplify(subs(Jacob(i), sin(alpha), as));
    % Jacob(i) = simplify(subs(Jacob(i), cos(alpha), ac));

    [coef_J_pure, mon_J_pure] = coeffs(Jacob(i), x);
    generateFuncFile(coef_J_pure, fullfile('func_files', ['coef_J_pure_',num2str(i),'_',problem_name,'.m']), J_coef);
    mons{i} = mon_J_pure;
    length(mon_J_pure)
end


[ac*gc^2, ac*gc*gs, ac*gc, ac*gs^2, ac*gs, ac, as*gc^2, as*gc*gs, as*gc, as*gs^2, as*gs, as, gc^2, gc*gs, gc*t1, gc*t2, gc, gs^2, gs*t1, gs*t2, gs, t1, t2, 1]
[ac*gc^2, ac*gc*gs, ac*gc, ac*gs^2, ac*gs, ac, as*gc^2, as*gc*gs, as*gc, as*gs^2, as*gs, as, gc^2, gc*gs, gc*t1, gc*t2, gc, gs^2, gs*t1, gs*t2, gs, t1, t2, 1]
[ac^2*gc, ac^2*gs, ac^2, ac*as*gc, ac*as*gs, ac*as, ac*gc, ac*gs, ac*t1, ac*t2, ac, as^2*gc, as^2*gs, as^2, as*gc, as*gs, as*t1, as*t2, as, gc, gs, t1, t2, 1]
[ac^2*gc, ac^2*gs, ac^2, ac*as*gc, ac*as*gs, ac*as, ac*gc, ac*gs, ac*t1, ac*t2, ac, as^2*gc, as^2*gs, as^2, as*gc, as*gs, as*t1, as*t2, as, gc, gs, t1, t2, 1]
[ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs, t1, t2, 1]
[ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs, t1, t2, 1]




return
%% 下面是旧代码，没参考价值了
J_pure_back = J_pure;




J_pure_back = simplify(subs(J_pure_back, sin(gama), gs));
J_pure_back = simplify(subs(J_pure_back, cos(gama), gc));
J_pure_back = simplify(subs(J_pure_back, sin(alpha), as));
J_pure_back = simplify(subs(J_pure_back, cos(alpha), ac));

[coef_J_pure, mon_J_pure] = coeffs(J_pure_back, x);

Jacob2 = jacobian(J_pure_back, x).'; %对原始的关于三角函数的进行求导
 [coef_J_pure, mon_J_pure] = coeffs(Jacob2(1), x);



Jacob = jacobian(J_pure, x_origin).'; %对原始的关于三角函数的进行求导
Jacob = simplify(Jacob);



mons={};



for i = 1 : 4
    Jacob(i) = simplify(subs(Jacob(i), sin(gama), gs));
    Jacob(i) = simplify(subs(Jacob(i), cos(gama), gc));
    Jacob(i) = simplify(subs(Jacob(i), sin(alpha), as));
    Jacob(i) = simplify(subs(Jacob(i), cos(alpha), ac));

    [coef_J_pure, mon_J_pure] = coeffs(Jacob(i), x);
    generateFuncFile(coef_J_pure, fullfile('func_files', ['coef_J_pure_',num2str(i),'_',problem_name,'.m']), {A(1 : 3, :), B(1 : 3, :),delta_p, t3});

    mons{i} = mon_J_pure;
    length(mon_J_pure)
end

A_coef = sym('A_coef', [2, 42]);
showSyms(symvar(A_coef));

B_coef = sym('B_coef', [2, 11]);
showSyms(symvar(B_coef));

f1 = A_coef(1,:)*mons{1}'
f2 = A_coef(2,:)*mons{2}'
f3 = B_coef(1,:)*mons{3}'
f4 = B_coef(2,:)*mons{4}'
f5 = ac * ac + as * as - 1
f6 = gc * gc + gs * gs - 1

%res = solve(f1,f2,f3,f4, gc,gs,ac,as,t1,t2,'ReturnConditions', true)



%res=solve(Jacob, alpha_2, gama_2, t1 ,t2, 'ReturnConditions', true)

[ac^2*gc^2, ac^2*gc*gs, ac^2*gc, ac^2*gs^2, ac^2*gs, ac^2, ac*as*gc^2, ac*as*gc*gs, ac*as*gc, ac*as*gs^2, ac*as*gs, ac*as, ac*gc^2, ac*gc*gs, ac*gc*t1, ac*gc*t2, ac*gc, ac*gs^2, ac*gs*t1, ac*gs*t2, ac*gs, ac*t1, ac*t2, ac, as^2*gc^2, as^2*gc*gs, as^2*gc, as^2*gs^2, as^2*gs, as^2, as*gc^2, as*gc*gs, as*gc*t1, as*gc*t2, as*gc, as*gs^2, as*gs*t1, as*gs*t2, as*gs, as*t1, as*t2, as]
[ac^2*gc^2, ac^2*gc*gs, ac^2*gc, ac^2*gs^2, ac^2*gs, ac*as*gc^2, ac*as*gc*gs, ac*as*gc, ac*as*gs^2, ac*as*gs, ac*gc^2, ac*gc*gs, ac*gc*t1, ac*gc*t2, ac*gc, ac*gs^2, ac*gs*t1, ac*gs*t2, ac*gs, as^2*gc^2, as^2*gc*gs, as^2*gc, as^2*gs^2, as^2*gs, as*gc^2, as*gc*gs, as*gc*t1, as*gc*t2, as*gc, as*gs^2, as*gs*t1, as*gs*t2, as*gs, gc^2, gc*gs, gc*t1, gc*t2, gc, gs^2, gs*t1, gs*t2, gs]
[ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs, t1, t2, 1]
[ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs, t1, t2, 1]


return


function q = quaternion_multiply(q1, q2)
    w1 = q1(1); x1 = q1(2); y1 = q1(3); z1 = q1(4);
    w2 = q2(1); x2 = q2(2); y2 = q2(3); z2 = q2(4);
    
    w = w1*w2 - x1*x2 - y1*y2 - z1*z2;
    x = w1*x2 + x1*w2 + y1*z2 - z1*y2;
    y = w1*y2 - x1*z2 + y1*w2 + z1*x2;
    z = w1*z2 + x1*y2 - y1*x2 + z1*w2;
    
    q = [w, x, y, z];
end