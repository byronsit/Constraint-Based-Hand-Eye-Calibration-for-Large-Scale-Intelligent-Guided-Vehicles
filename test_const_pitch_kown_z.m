% 测试const pitch known z的数据
clc
clear all
close all
load simulated_AB.mat

Tx = 7.345465303849309; Ty = 0.1395879022194233; Tz = 1.495; % 平移
qx = 0.5744485910542397; qy = -0.5731322100778303; qz = 0.414850377485667; qw = -0.4116156584814286;
noise_level_translation = 0; % 平移噪声水平(米)
noise_level_rotation = 0.1; % 旋转噪声水平(弧度)

% 将四元数转换为旋转矩阵
R = quat2rotm([qw, qx, qy, qz]);