%测试我们的grobner baiss的代码是否正确

clc
clear all
close all

load simulated_AB

AA=T_cb;
T_bc = inv(T_cb);

%x_init = decompose_X(AA);
%x_init=[0 0 0 0 0 0].';
%z = T_cb(3,4);
%res=optimize_AX_XB(A_matrices, B_matrices, x_init, z)

sum_coef_1 = zeros(1,42);
sum_coef_2 = zeros(1,42);
sum_coef_3 = zeros(1,11);
sum_coef_4 = zeros(1,11);

for i = 1 : length(A_matrices)
    var_A = B_matrices{i}(1:3,:);
    var_B = A_matrices{i}(1:3,:);
    var_pitch = diff_pitch;
    var_z = diff_z;
    coef_1 = coef_J_pure_1_const_pitch_kown_scale(var_A, var_B, var_pitch, var_z);
    coef_2 = coef_J_pure_2_const_pitch_kown_scale(var_A, var_B, var_pitch, var_z);
    coef_3 = coef_J_pure_3_const_pitch_kown_scale(var_A, var_B, var_pitch, var_z);
    coef_4 = coef_J_pure_4_const_pitch_kown_scale(var_A, var_B, var_pitch, var_z);

    sum_coef_1 = sum_coef_1 + coef_1;
    sum_coef_2 = sum_coef_2 + coef_2;
    sum_coef_3 = sum_coef_3 + coef_3;
    sum_coef_4 = sum_coef_4 + coef_4;
end
%% 老子自己算，为啥结果不对呢？

alpha = 0;
gama = 0;

syms ac as gc gs t1 t2 real
ac = cos(alpha);
as = sin(alpha);
gc = cos(gama);
gs = sin(gama);
t1 = T_bc(1,4);
t2 = T_bc(2,4);

mons1 = [ac^2*gc^2, ac^2*gc*gs, ac^2*gc, ac^2*gs^2, ac^2*gs, ac^2, ac*as*gc^2, ac*as*gc*gs, ac*as*gc, ac*as*gs^2, ac*as*gs, ac*as, ac*gc^2, ac*gc*gs, ac*gc*t1, ac*gc*t2, ac*gc, ac*gs^2, ac*gs*t1, ac*gs*t2, ac*gs, ac*t1, ac*t2, ac, as^2*gc^2, as^2*gc*gs, as^2*gc, as^2*gs^2, as^2*gs, as^2, as*gc^2, as*gc*gs, as*gc*t1, as*gc*t2, as*gc, as*gs^2, as*gs*t1, as*gs*t2, as*gs, as*t1, as*t2, as];
mons2 = [ac^2*gc^2, ac^2*gc*gs, ac^2*gc, ac^2*gs^2, ac^2*gs, ac*as*gc^2, ac*as*gc*gs, ac*as*gc, ac*as*gs^2, ac*as*gs, ac*gc^2, ac*gc*gs, ac*gc*t1, ac*gc*t2, ac*gc, ac*gs^2, ac*gs*t1, ac*gs*t2, ac*gs, as^2*gc^2, as^2*gc*gs, as^2*gc, as^2*gs^2, as^2*gs, as*gc^2, as*gc*gs, as*gc*t1, as*gc*t2, as*gc, as*gs^2, as*gs*t1, as*gs*t2, as*gs, gc^2, gc*gs, gc*t1, gc*t2, gc, gs^2, gs*t1, gs*t2, gs];
mons3 = [ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs, t1, t2, 1];
mons4 = [ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs, t1, t2, 1];



% two equations representing an ellipse and a hyperbola
eq(1) = sum_coef_1 * mons1.';
eq(2) = sum_coef_2 * mons2.';
eq(3) = sum_coef_3 * mons3.';
eq(4) = sum_coef_4 * mons4.';
eq(5) = ac * ac + as * as - 1;
eq(6) = gc * gc + gs * gs - 1;


return
%% grobner算,怎么不对呢？
A= [sum_coef_1;sum_coef_2]

B= [sum_coef_3;sum_coef_4]

A = reshape(A, 1, 42*2)

B = reshape(B, 1, 11*2)

AB=num2cell([A,B])


[ac, as, gc, gs, t1, t2]=solver_tiv_const_pitch_const_z(AB{:})
