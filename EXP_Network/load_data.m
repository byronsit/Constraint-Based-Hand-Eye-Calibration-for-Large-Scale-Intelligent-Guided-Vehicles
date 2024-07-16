
clc
clear all
close all
rng(0);

load_left =  [   0      0     0     0     0     8     8     8     8     8    16    16    16    16    16    24    24    24    24    24    32    32     32    32    32] ;
load_right = [  0     8    16    24    32     0     8    16    24    32     0     8    16    24    32     0     8    16    24    32     0     8     16    24    32] ;
diff_left = -[  0         -0.0035    0.0020    0.0015    0.0130   -0.0485   -0.0375   -0.0335   -0.0270   -0.0225   -0.0665   -0.0540   -0.0485    -0.0430   -0.0410   -0.0920   -0.0715   -0.0630   -0.0615   -0.0625   -0.1020   -0.0855   -0.0830   -0.0795   -0.0735];
diff_right= -[   0       -0.0405   -0.0615   -0.0685   -0.0975    0.0060   -0.0290   -0.0480   -0.0655   -0.0820    0.0120   -0.0225   -0.0460    -0.0615   -0.0785    0.0175   -0.0195   -0.0400   -0.0520   -0.0755    0.0210   -0.0160   -0.0380   -0.0435   -0.0715];
% 确保左边更重
idx = find(load_left < load_right);
for i = 1 : length(idx)
    tmp = load_left(idx(i));
    load_left(idx(i)) = load_right(idx(i));
    load_right(idx(i)) = tmp;

    tmp = diff_left(idx(i));
    diff_left(idx(i)) = diff_right(idx(i));
    diff_right(idx(i)) = tmp;
end

inputs = [load_left; load_right];  %单位吨
targets = [diff_left; diff_right]; %单位cm
targets_left =diff_left;
targets_right =diff_right;