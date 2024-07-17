
% 转化为最后还是A T_bc' = T_bc' * B,其中B是相机的轨迹。这样比较简单
% 这个new似乎是ok的!让我来求解试试看
% 最后求grobner也用了t1和t2的数值。(it looks that we still need to kil the t1 and t2)

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




qy = [cos(delta_p/2), 0, sin(delta_p/2), 0];
qz = [cos(alpha/2), 0, 0, sin(alpha/2)];
qx = [cos(gama/2),sin(gama/2),0,0];



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

T_cprime_c = [R_cprime_c, t_cprime_c;0 0 0 1];%本质XX就是T_cprime_c
T_cprime_b = T_cprime_c * T_cb
T_b_cprime = inv(T_cprime_b);
T_b_cprime = simplify(T_b_cprime)


T_b_cprime = (subs(T_b_cprime, sin(gama), gs));
T_b_cprime = (subs(T_b_cprime, cos(gama), gc));
T_b_cprime = (subs(T_b_cprime, sin(alpha), as));
T_b_cprime = (subs(T_b_cprime, cos(alpha), ac));
T_b_cprime = (subs(T_b_cprime, cos(delta_p), pc));
T_b_cprime = (subs(T_b_cprime, sin(delta_p), ps));


c=cell(3,4);
m=c;
for i = 1 : 3
    for j = 1 : 4
        [coef,mon]=coeffs(T_b_cprime(i,j), [x;t3]);
        c{i,j} = coef;
        m{i,j} = mon;
        generateFuncFile(c{i,j}, fullfile('func_files', ['c_',num2str(i),num2str(j),'_',problem_name,'.m']), {T_cb(1:3,:), ps,pc});
    end
end

%这个程序表示，我们直接表达t3,这样就这里就只有t1,t2了


%% 重新表达要计算的X
% 此时我们的X用T_b_cprime就可以了！
mm = [ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs];
X_coef = sym('X_coef', [3,3,length(mm)]);

X = sym(zeros(4,4));
X(4,4)=1;
for i = 1 :3
    for j = 1 : 3
        X(i, j) = reshape(X_coef(i,j,:),1,8)*mm.';
    end
end

X(1,4)=t1;
X(2,4)=t2;
X(3,4)=t3;

%% 此时重新得到X了，未知数还是x=[ac as gc gs t1 t2]
J = J_func_hand_eye(X, A, B);
[coef_J_pure, mon_J_pure] = coeffs(J, x);
generateFuncFile(coef_J_pure, fullfile('func_files', ['coef_J_',problem_name,'.m']), {A(1 : 3, :), B(1 : 3, :),X_coef(:,:,:),t3});


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

%2，4行可以不需要！
[ac*gc^2, ac*gc*gs, ac*gc, ac*gs^2, ac*gs, ac, as*gc^2, as*gc*gs, as*gc, as*gs^2, as*gs, as, gc^2, gc*gs, gc*t1, gc*t2, gc, gs^2, gs*t1, gs*t2, gs, t1, t2, 1]
%[ac*gc^2, ac*gc*gs, ac*gc, ac*gs^2, ac*gs, ac, as*gc^2, as*gc*gs, as*gc, as*gs^2, as*gs, as, gc^2, gc*gs, gc*t1, gc*t2, gc, gs^2, gs*t1, gs*t2, gs, t1, t2, 1]
[ac^2*gc, ac^2*gs, ac^2, ac*as*gc, ac*as*gs, ac*as, ac*gc, ac*gs, ac*t1, ac*t2, ac, as^2*gc, as^2*gs, as^2, as*gc, as*gs, as*t1, as*t2, as, gc, gs, t1, t2, 1]
%[ac^2*gc, ac^2*gs, ac^2, ac*as*gc, ac*as*gs, ac*as, ac*gc, ac*gs, ac*t1, ac*t2, ac, as^2*gc, as^2*gs, as^2, as*gc, as*gs, as*t1, as*t2, as, gc, gs, t1, t2, 1]
[ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs, t1, t2, 1]
[ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs, t1, t2, 1]

