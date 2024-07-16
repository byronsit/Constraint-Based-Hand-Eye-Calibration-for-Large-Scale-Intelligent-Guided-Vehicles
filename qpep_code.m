
% 普通scale的AX=XB，但是有const的z,并且不需要求解pitch

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
  
  
syms q0 q1 q2 q3 real
syms t1 t2 t3 lambda real
q = [q0; q1; q2; q3];


syms delta_p alpha gama real


quat2axang([1 0 0 0 ])
axang_qy = [0 1 0 delta_p];
axang_qz = [0 0 1 alpha];
axang_qx = [1 0 0 gama];

qy = [cos(delta_p/2), 0, sin(delta_p/2), 0];
qz = [cos(alpha/2), 0, 0, sin(alpha/2)];
qx = [cos(gama/2),sin(gama/2),0,0];


%下面是做了符号替换
qy = [pc, 0, ps, 0];
qz = [ac, 0, 0, as];
qx = [gc, gs, 0, 0];
RR = q2R(qy).'*q2R(qz).'*q2R(qx).'; %和quat2rotm对应，老吴写的q2R是逆似乎。可能遵循某些规则我不懂?
rot_sym = [ac; as; gc; gs];

tt = [t1; t2]; 
%syms scale
%tts=[t1;t2;t3;scale];

XX = [
    RR, [t1;t2;t3];
    zeros(1, 3), 1];
J_pure = J_func_hand_eye(XX, A, B);
[coef_J_pure, mon_J_pure] = coeffs(J_pure, [rot_sym; tt]);
generateFuncFile(coef_J_pure, fullfile('func_files', ['coef_J_pure_',problem_name,'.m']), {A(1 : 3, :), B(1 : 3, :), pc, ps, t3} );
generateFuncFile(mon_J_pure, fullfile('func_files', ['mon_J_pure_',problem_name,'.m']), {rot_sym, tt});

x = [ac; as; gc; gs; t1; t2; lambda; mu]; %要求的变量


%重新符号表达的系数
coef_len = length(coef_J_pure);
str = sprintf('coef_J = sym(''coef_J'', [1, %d]);', coef_len);
eval(str);
showSyms(symvar(coef_J));

J = coef_J * mon_J_pure.' - 0.5 * lambda * (ac*ac + as*as) - 0.5* mu * (gc*gc + gs*gs);
Jacob = jacobian(J, x);
Jacob = expand(Jacob.');



%% 处理对x,y的导数

G=[];

for i = 1 : 2
    [coef_t, mon_t] = coeffs(Jacob(4+i), [tt]);
    %check哪几个不含q,scale
    has_q=[];
    no_q=[];
    for j = 1 : length(mon_t)
        [a,b]=coeffs(coef_t(j),rot_sym);
        if (length(b)>1)
            has_q = [has_q, j];
        else
            no_q = [no_q, j];
        end
    end
    g = expandAndMultiplySym( coef_t(no_q)  ,mon_t(no_q), tt');

    G =[ G; -g];
    %出去和t和scale有关的项
    %[coef_tq, mont_q] = coeffs(expand(Jacob(4 + i) - coef_t(no_q) * mon_t(no_q).' ), [q;scale])
    % 计算 Jacob 表达式的展开形式
    expanded_Jacob = expand(Jacob(4 + i));
    % 检查 no_q 是否为空
    if isempty(no_q)
        % 如果 no_q 是空的，直接计算 expanded_Jacob 的系数
        [coef_tq, mont_q] = coeffs(expanded_Jacob, [rot_sym]);
    else
        % 如果 no_q 不为空，按照原始操作计算
        [coef_tq, mont_q] = coeffs(expanded_Jacob - coef_t(no_q) * mon_t(no_q).', [rot_sym]);
    end
    coef_tq = expandAndMultiplySym(coef_tq, mont_q, [a2g2, 1]);
    
    generateFuncFile(coef_tq, fullfile('func_files', ['coeftq',num2str(i),'_',problem_name,'.m']), {coef_J});
end

%% 处理G的问题
generateFuncFile(G, fullfile('func_files', ['G_',problem_name,'.m']), {coef_J});

pinvG = sym('pinvG', size(G));
showSyms(symvar(pinvG));
coefs_tq = sym('coefs_tq', [2, length(coef_tq)]); 
showSyms(symvar(coefs_tq));
ts = pinvG * coefs_tq * [a2g2, 1].';
t1 = ts(1);
t2 = ts(2);

generateFuncFile(t1, fullfile('func_files', ['t1_',problem_name,'.m']), {pinvG, coefs_tq, rot_sym});
generateFuncFile(t2, fullfile('func_files', ['t2_',problem_name,'.m']), {pinvG, coefs_tq, rot_sym});
%generateFuncFile(t3, fullfile('func_files', ['t3_',problem_name,'.m']), {pinvG, coefs_tq, q});


%% 四元数 and Q

Q_sym=[];
additional_part = [lambda * ac, lambda * as, mu * gc, mu * gs]
for i = 1 : 4
    [coef_Jacob_qt, mon_Jacob_qt] = coeffs(eval(Jacob(i)) + additional_part(i) , [rot_sym]);
    %coef_Jacob_qt = expandAndMultiplySym(coef_Jacob_qt, mon_Jacob_qt, [ac^3*gc^4, ac^3*gc^3*gs, ac^3*gc^2*gs^2, ac^3*gc*gs^3, ac^3*gs^4, ac^2*as*gc^4, ac^2*as*gc^3*gs, ac^2*as*gc^2*gs^2, ac^2*as*gc*gs^3, ac^2*as*gs^4, ac*as^2*gc^4, ac*as^2*gc^3*gs, ac*as^2*gc^2*gs^2, ac*as^2*gc*gs^3, ac*as^2*gs^4, ac*gc^2, ac*gc*gs, ac*gs^2, ac, as^3*gc^4, as^3*gc^3*gs, as^3*gc^2*gs^2, as^3*gc*gs^3, as^3*gs^4, as*gc^2, as*gc*gs, as*gs^2]);
    generateFuncFile(coef_Jacob_qt, fullfile('func_files', ['coef_Jacob_qt',num2str(i),'_',problem_name,'.m']), {coefs_tq, pinvG, coef_J});
    idx_q0 = find(mon_Jacob_qt==ac);
    idx_q1 = find(mon_Jacob_qt==as);
    idx_q2 = find(mon_Jacob_qt==gc);
    idx_q3 = find(mon_Jacob_qt==gs);
    Qi = [coef_Jacob_qt(idx_q0) coef_Jacob_qt(idx_q1) coef_Jacob_qt(idx_q2) coef_Jacob_qt(idx_q3)];
    Q_sym=[Q_sym;Qi];
    res(i) = expand(coef_Jacob_qt*mon_Jacob_qt.'- Qi * [ac;as;gc;gs]);
end

generateFuncFile(Q_sym, fullfile('func_files', ['Q_sym_',problem_name,'.m']), {coefs_tq, pinvG, coef_J});

H = jacobian(res, q);
h1 = H(:, 1);
h2 = H(:, 2);
h3 = H(:, 3);
h4 = H(:, 4);
P1 = jacobian(h1, q);
P2 = jacobian(h2, q);
P3 = jacobian(h3, q);
P4 = jacobian(h4, q);


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
W = [W1, W2, W3, W4] / 6;
generateFuncFile(W, fullfile('func_files', ['W_',problem_name,'.m']), {coefs_tq, pinvG, coef_J});

return;
