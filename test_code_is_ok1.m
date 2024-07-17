%% 做实验，看我的求导对不对



% 普通scale的AX=XB，但是有const的z,并且不需要求解pitch
% 推导 有 scale，且有pitch的

clear all
close all
clc

addpath('func_files');
addpath('utils');

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




qy = [cosd(delta_p/2), 0, sind(delta_p/2), 0];
qz = [cosd(alpha/2), 0, 0, sind(alpha/2)];
qx = [cosd(gama/2),sind(gama/2),0,0];
b_R_cprime_c = (q2R(qy)')* (q2R(qz)')* (q2R(qx)'); %和quat2rotm对应，老吴写的q2R是逆似乎。可能遵循某些规则我不懂?
R_cprime_c = R_cb * b_R_cprime_c.' * R_cb.';
R_cprime_b = R_cprime_c * R_cb;


b_t_c_c_prime = [diff_x; diff_y; diff_z];                % 提前定义好的
t_cprime_c = R_cprime_b * (-b_t_c_c_prime);              %check
%t_c_cprimbe = R_cb * (b_t_c_c_prime);                    %check

T_cprime_c = [R_cprime_c, t_cprime_c;0 0 0 1];

% T_cprime_c * T_cb - T_cprime_b
% my_T_cprime_b = T_cprime_c * T_cb; %???
% T_b_cprime = inv(T_cprime_b);
% T_bc = inv(T_cb);

%% 测试A * X_cb = X_cb * B
for i = 1 : length(A_matrices)
    A = A_matrices{i};
    B = B_matrices{i};
    J_pure(i) = J_func_hand_eye(T_cb, A, B);
end
fprintf('确保这个数值为0：[%.10f]\n', sum(J_pure))


%% 测试新的A_new X_c'c = X_c'c B_new
for i = 1 : length(B_matrices)
    A = A_matrices_new{i};
    B = T_cb * B_matrices{i} * inv(T_cb);
    J_pure(i) = J_func_hand_eye((T_cprime_b * inv(T_cb)), A, B);
end
fprintf('确保这个数值为0：[%.10f]\n', sum(J_pure))

%% 自动求导程序，也需要一样的功能。我需要大致验证这个东东，这部分是自动求导工具的核心。希望那谁的代码是对的噢噢噢噢
for i = 1 : length(B_matrices)
    A = A_matrices_new{i};
    B = T_cb * B_matrices{i} * inv(T_cb);
    J_pure(i) = J_func_hand_eye(T_cprime_c, A, B);
end
fprintf('确保这个数值为0：[%.10f]\n', sum(J_pure))




return

b_R_cprime_c = (q2R(qy)).'* (q2R(qz)).'* (q2R(qx)).'; %和quat2rotm对应，老吴写的q2R是逆似乎。可能遵循某些规则我不懂?

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


%看看我的XX对不对！


return

rot_sym = [alpha, gama]
%尝试化简RR的形式


J_pure = J_func_hand_eye(XX, A, B);

x = [ac; as; gc; gs; t1; t2; lambda; mu]; %要求的变量
x_origin = [alpha, gama, t1 ,t2]

Jacob = jacobian(J_pure, x_origin).'; %对原始的关于三角函数的进行求导
Jacob = simplify(Jacob);


%% 测试J_pure是不是等于0
load simulated_AB

%我的A,B是反的！
%delta_p = diff_pitch;

T_bc = inv(T_cb);
var_z = diff_z;
t1 = T_bc(1,4);
t2 = T_bc(2,4);
t3 = T_bc(3,4); %直接const掉！之前是错的！
RR = T_bc(1:3,1:3);
A = B_matrices;
B = A_matrices;
XX = [
    RR, [t1;t2;t3];
    zeros(1, 3), 1];


 [eul,eulAlt] = rotm2eul(RR, 'XZY')
eul/pi*180

eulAlt/pi*180
alpha = eul(1);
gama = eul(3);


pc = cos(eul(1));
ps = sin(eul(1));
ac = cos(eul(2));
as = sin(eul(2));
gc = cos(eul(3));
gs = sin(eul(3));

error = objective_function(XX, A, B);


for i = 1 : length(A)
    J_pure(i) = J_func_hand_eye(XX, A{i}, B{i});
end
fprintf('gt的误差是%.10f\n:', sum(J_pure));


% 开始模拟,看看雅可比矩阵是否为0


% pc = cos()
% ps = 
ac = cos(alpha);
as = sin(alpha);
gc = cos(gama);
gs = sin(gama);
t1 = T_bc(1,4);
t2 = T_bc(2,4);
t3 = T_bc(3,4);


tic
J_coefs = zeros(1,57);
for i = 1 : length(A)
    AA = A{i};
    BB = B{i};
    J_coefs = J_coefs + coef_J_const_pitch_kown_scale(AA(1 : 3, :), BB(1 : 3, :),cos(delta_p), sin(delta_p), t3);
end
toc

%coef_J_pure_const_pitch_kown_scale(A(1 : 3, :), B(1 : 3, :),delta_p, t3)





return
%% end 测试

x = [ac; as; gc; gs; t1; t2; lambda; mu]; %要求的变量
x_origin = [alpha, gama, t1 ,t2]

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


function error = objective_function(X, A_matrices, B_matrices)    
    error = 0;
    for i = 1:length(A_matrices)
        A = A_matrices{i};
        B = B_matrices{i};
        
        % 计算AX-XB的误差
        error = error + norm(A * X - X * B, 'fro')^2;
    end
end


function R = myq2R(q)
    q0 = q(1); q1 = q(2); q2 = q(3); q3 = q(4);
    R = [
        q0^2+q1^2-q2^2-q3^2, 2*(q1*q2-q0*q3), 2*(q1*q3+q0*q2);
        2*(q1*q2+q0*q3), q0^2-q1^2+q2^2-q3^2, 2*(q2*q3-q0*q1);
        2*(q1*q3-q0*q2), 2*(q2*q3+q0*q1), q0^2-q1^2-q2^2+q3^2
    ];
end