% 查看模型对最终结果的拟合效果
% 我们的

clc
clear all




%% 参数设置
x = 3.7326          % 左右x米的地方，是弹簧的位置
a = 15              % 车总长度
load k.mat
k =  K_estimated;   % 弹簧的系数
g = 9.8;

%% input
gt_diff_L =  [0.0335    0.0270    0.0225    0.0540    0.0430    0.0410    0.0715    0.0630    0.0625    0.0855    0.0830    0.0795];
gt_diff_R =  [0.0480    0.0655    0.0820    0.0225    0.0615    0.0785    0.0195    0.0400    0.0755    0.0160    0.0380    0.0435];
left_load = [ 8     8     8    16    16    16    24    24    24    32    32    32]*1000; %吨换算成千克
right_load = [16    24    32     8    24    32     8    16    32     8    16    24]*1000;

res_diff_L=[];
res_diff_R=[];

load k.mat
k = K_estimated;
load x_and_inv_EI.mat
x;              % 左端该位置有支撑弹簧
inv_EI;         % 1/EI
a = 15 /2 ;
for i = 1 : length(left_load)
    flag = 0; %0的话就是左边更重，1的话，就是交换位置了

    %确保左边更重
    if (left_load(i) < right_load(i))
        flag = 1;
        load_l = right_load(i);
        load_d = left_load(i);
    else 
        load_l = left_load(i);
        load_d = right_load(i);
    end

    %因为称重本身压下去的距离
    diff_r = load_d * g / k;
    diff_l = load_l * g / k;


    q=(load_l - load_d) *g / a;
    delta_l = q * x^4  / (8 ) * inv_EI;
    

    M = q * a / 2 * (x - a / 4);

    delta_r = M*(a-x)^2/(2)* inv_EI;

    res_delta_l = delta_l + diff_l;
    res_delta_r = delta_r + diff_r;

    if (flag == 1)
        res_diff_L(i) = res_delta_r;
        res_diff_R(i) = res_delta_l;
    else 
        res_diff_L(i) = res_delta_l;
        res_diff_R(i) = res_delta_r;
    end
    % 确保left更大
end