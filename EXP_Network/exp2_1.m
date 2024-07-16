%只有1个隐含层的情况 

clc
clear all
close all
load_data;

%% 只有1个隐含层，算2个数值
need_1d = true;
if need_1d == true
    res_1d_purelin = zeros(1,30);
    res_1d_tansig = zeros(1,30);
    res_1d_logsig = zeros(1,30);

    parfor i = 1 : 30
        tmp = zeros(1,100);
        for j = 1 : 100
            tmp(j) = donet([i],inputs,targets, 'purelin');
        end
        res_1d_purelin(i) = median(tmp);
    end

    parfor i = 1 : 30
        tmp = zeros(1,100);
        for j = 1 : 100
            tmp(j) = donet([i],inputs,targets, 'tansig');
        end
        res_1d_tansig(i) = median(tmp);
    end

    parfor i = 1 : 30
        tmp = zeros(1,100);
        for j = 1 : 100
            tmp(j) = donet([i],inputs,targets, 'logsig');
        end
        res_1d_logsig(i) = median(tmp);
    end

    save('res_1d', 'res_1d_purelin', 'res_1d_tansig', 'res_1d_logsig');
else
    load res_1d.mat
end


%% 只有1个隐含层，分别算前后数值-左
need_1d_left = true;

%给target更换下
target = targets_left; 
if need_1d_left == true
    res_1d_purelin_left = zeros(1,30);
    res_1d_tansig_left = zeros(1,30);
    res_1d_logsig_left = zeros(1,30);

    parfor i = 1 : 30
        tmp = zeros(1,100);
        for j = 1 : 100
            tmp(j) = donet([i],inputs,targets_left, 'purelin');
        end
        res_1d_purelin_left(i) = median(tmp);
    end

    parfor i = 1 : 30
        tmp = zeros(1,100);
        for j = 1 : 100
            tmp(j) = donet([i],inputs,targets_left, 'tansig');
        end
        res_1d_tansig_left(i) = median(tmp);
    end

    parfor i = 1 : 30
        tmp = zeros(1,100);
        for j = 1 : 100
            tmp(j) = donet([i],inputs,targets_left, 'logsig');
        end
        res_1d_logsig_left(i) = median(tmp);
    end

    save('res_1d_left', 'res_1d_purelin_left', 'res_1d_tansig_left', 'res_1d_logsig_left');
else
    load res_1d_left.mat
end
clear res_1d_purelin_left res_1d_tansig_left res_1d_logsig_left


%% 只有1个隐含层，分别算前后数值-右
need_1d_right = true;

%给target更换下
target = targets_left; 
if need_1d_right == true
    res_1d_purelin_right = zeros(1,30);
    res_1d_tansig_right = zeros(1,30);
    res_1d_logsig_right = zeros(1,30);

    parfor i = 1 : 30
        tmp = zeros(1,100);
        for j = 1 : 100
            tmp(j) = donet([i],inputs,targets_right, 'purelin');
        end
        res_1d_purelin_right(i) = median(tmp);
    end

    parfor i = 1 : 30
        tmp = zeros(1,100);
        for j = 1 : 100
            tmp(j) = donet([i],inputs,targets_right, 'tansig');
        end
        res_1d_tansig_right(i) = median(tmp);
    end

    parfor i = 1 : 30
        tmp = zeros(1,100);
        for j = 1 : 100
            tmp(j) = donet([i],inputs,targets_right, 'logsig');
        end
        res_1d_logsig_right(i) = median(tmp);
    end

    save('res_1d_right', 'res_1d_purelin_right', 'res_1d_tansig_right', 'res_1d_logsig_right');
else
    load res_1d_right.mat
end
