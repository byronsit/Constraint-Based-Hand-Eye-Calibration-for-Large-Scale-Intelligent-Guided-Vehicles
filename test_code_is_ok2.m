%% 通过实验，测试下自动求导器生成的代码，是不是基本是可以用的，经过测试，应该是work的
% 这里测试的代码，是也顺便求t1 t2的代码。 似乎grobner求出来不对。
% 针对的是知道scale,知道pitch的求导器,目前似乎得到的结果是work的，希望grobner是work的

% 普通scale的AX=XB，但是有const的z,并且不需要求解pitch
% 推导 有 scale，且有pitch的

clear all
close all
clc

addpath('func_files');
addpath('utils');
digits(32)
load simulated_AB
% simulated_AB提供如下数据
% T_cprime_b 是最终的答案
% diff_pitch 是知道的,其他都不知道
% T_cb 是提前标定数值，知道的
% diff_z 是前文给出的数值

R_cb = T_cb(1:3,1:3);


diff_x = 0; % 1cm的变化
diff_y = 0; % 1cm的变化
diff_z = -0.4;  % 40cm的变化

delta_p = 30;  %y
alpha =    14; %z
gama =      5; %x

pc = cosd(delta_p);
ps = sind(delta_p);
ac = cosd(alpha);
as = sind(alpha);
gc = cosd(gama);
gs = sind(gama)

%inv(T_cprime_b)

mm = [ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs];

my_R_cprime_b = [c_11_const_pitch_kown_scale(R_cb,ps,pc)*mm.', c_12_const_pitch_kown_scale(R_cb,ps,pc)*mm.', c_13_const_pitch_kown_scale(R_cb,ps,pc)*mm.', 
c_21_const_pitch_kown_scale(R_cb,ps,pc)*mm.', c_22_const_pitch_kown_scale(R_cb,ps,pc)*mm.', c_23_const_pitch_kown_scale(R_cb,ps,pc)*mm.',
c_31_const_pitch_kown_scale(R_cb,ps,pc)*mm.', c_32_const_pitch_kown_scale(R_cb,ps,pc)*mm.', c_33_const_pitch_kown_scale(R_cb,ps,pc)*mm.']

%这个结果近乎是0，所以是对的！

fprintf('应该几乎为0：[%.10f]\n',sum(sum(my_R_cprime_b  - inv(T_cprime_b(1:3,1:3))).'));



%% 继续测试
X_coef = zeros(3,3,8)
for i = 1 : 3
    for j = 1 : 3
        X_coef(i,j,:)=  eval(['c_',num2str(i),num2str(j),'_const_pitch_kown_scale(R_cb,ps,pc)'])
    end
end
% X_coef(3,3,:)= c_11_const_pitch_kown_scale(R_cb,ps,pc)
% X_coef = [c_11_const_pitch_kown_scale(R_cb,ps,pc), c_12_const_pitch_kown_scale(R_cb,ps,pc), c_13_const_pitch_kown_scale(R_cb,ps,pc), 
% c_21_const_pitch_kown_scale(R_cb,ps,pc), c_22_const_pitch_kown_scale(R_cb,ps,pc), c_23_const_pitch_kown_scale(R_cb,ps,pc),
% c_31_const_pitch_kown_scale(R_cb,ps,pc), c_32_const_pitch_kown_scale(R_cb,ps,pc), c_33_const_pitch_kown_scale(R_cb,ps,pc)];

T_b_cprime = inv(T_cprime_b);

t1 = T_b_cprime(1,4);
t2 = T_b_cprime(2,4);
t3 = T_b_cprime(3,4);
J = zeros(1,57);
cost = 0;

for i = 1 : length(B_matrices)
    A = B_matrices{i};
    B = A_matrices_new{i};
    % A=sym(A);
    % B=sym(B);
    J = J + coef_J_const_pitch_kown_scale(A(1 : 3, :), B(1 : 3, :),X_coef(:,:,:),t3);
    cost = cost + J_func_hand_eye(T_b_cprime, A,B); %这个没bug
end
fprintf('应该几乎为0：[%.10f]\n',cost);

mon=[ac^2*gc^2, ac^2*gc*gs, ac^2*gc, ac^2*gs^2, ac^2*gs, ac^2, ac*as*gc^2, ac*as*gc*gs, ac*as*gc, ac*as*gs^2, ac*as*gs, ac*as, ac*gc^2, ac*gc*gs, ac*gc*t1, ac*gc*t2, ac*gc, ac*gs^2, ac*gs*t1, ac*gs*t2, ac*gs, ac*t1, ac*t2, ac, as^2*gc^2, as^2*gc*gs, as^2*gc, as^2*gs^2, as^2*gs, as^2, as*gc^2, as*gc*gs, as*gc*t1, as*gc*t2, as*gc, as*gs^2, as*gs*t1, as*gs*t2, as*gs, as*t1, as*t2, as, gc^2, gc*gs, gc*t1, gc*t2, gc, gs^2, gs*t1, gs*t2, gs, t1^2, t1*t2, t1, t2^2, t2, 1];

fprintf('应该几乎为0：[%.10f]\n',J*mon.');

return


%% 下面开始测试grobner的方法！
clc
clear all
close all

addpath('func_files');
addpath('utils');

load simulated_AB


% 处理提前知道的数值
delta_p = 30;  %y

pc = cosd(delta_p);
ps = sind(delta_p);

T_b_cprime = inv((T_cprime_b));
t3 = T_b_cprime(3,4); %t3可以直接知道
R_cb= (T_cb(1:3,1:3));



X_coef = (zeros(3,3,8))
for i = 1 : 3
    for j = 1 : 3
        X_coef(i,j,:)=  eval(['c_',num2str(i),num2str(j),'_const_pitch_kown_scale(R_cb,ps,pc)'])
    end
end


J = (zeros(1,57));
for i = 1 : length(B_matrices)
    fprintf('running... i = %d\n', i);
    A = (B_matrices{i});
    B = (A_matrices_new{i});

    J = J + simplify(coef_J_const_pitch_kown_scale(A(1 : 3, :), B(1 : 3, :),X_coef(:,:,:),t3));
end
J = simplify(J);
JJ = num2cell(J);

c1 = coef_J_pure_1_const_pitch_kown_scale(JJ{:})
%c2 = coef_J_pure_2_const_pitch_kown_scale(JJ{:})
c3 = coef_J_pure_3_const_pitch_kown_scale(JJ{:})
%c4 = coef_J_pure_4_const_pitch_kown_scale(JJ{:})
c5 = coef_J_pure_5_const_pitch_kown_scale(JJ{:})
c6 = coef_J_pure_6_const_pitch_kown_scale(JJ{:})

c1 = simplify(c1);
c3 = simplify(c3);
c5 = simplify(c5);
c6 = simplify(c6);


A=[c1,c3,c5,c6];
%B=[c5,c6];

% A = reshape(A, 1, 24*2);
% B = reshape(B, 1, 11*2);
AA=num2cell(A)
[ac, as, gc, gs, t1, t2]=solver_tiv_const_pitch_const_z(AA{:})
[ac, as, gc, gs, t1, t2] = solver_solver_prob_known_scale_kown_pitch_using_t1_t2(A)
t = cell2mat(ac).*cell2mat(ac) + cell2mat(as).*cell2mat(as)
t.'

gt_t1 = T_b_cprime(1,4); %t3可以直接知道  7.3455
gt_t2 = T_b_cprime(2,4); %t3可以直接知道  0.1396

return
%% 下面是测试下grobner的代码是否的，但是我看是对的！eq都可以等于0
clc
delta_p = 30;  %y
alpha =    14; %z
gama =      5; %x

ac = cosd(alpha);
as = sind(alpha);
gc = cosd(gama);
gs = sind(gama);
t1 = T_b_cprime(1,4);
t2 = T_b_cprime(2,4);
t3 = T_b_cprime(3,4);


mons1 = [ac*gc^2, ac*gc*gs, ac*gc, ac*gs^2, ac*gs, ac, as*gc^2, as*gc*gs, as*gc, as*gs^2, as*gs, as, gc^2, gc*gs, gc*t1, gc*t2, gc, gs^2, gs*t1, gs*t2, gs, t1, t2, 1];
mons2 = [ac^2*gc, ac^2*gs, ac^2, ac*as*gc, ac*as*gs, ac*as, ac*gc, ac*gs, ac*t1, ac*t2, ac, as^2*gc, as^2*gs, as^2, as*gc, as*gs, as*t1, as*t2, as, gc, gs, t1, t2, 1];
mons3 = [ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs, t1, t2, 1];
mons4 = [ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs, t1, t2, 1];

% two equations representing an ellipse and a hyperbola
eq(1) = A(1:24) * mons1.';
eq(2) = A(25:48) * mons2.';
eq(3) = A(49:49+11-1) * mons3.';
eq(4) = A(49+11 : 49+11+10) * mons4.';
eq(5) = ac * ac + as * as - 1;
eq(6) = gc * gc + gs * gs - 1;
fprintf('应当为0:[%.10f]\n',sum(eq));
return
