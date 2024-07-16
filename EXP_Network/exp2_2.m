%只有2个隐含层的情况,要考虑不同的激活函数+隐含层数量不同


clc
clear all
close all
load_data;

n = 10; %穷举的size
sz = 50; %每一个i,j算的数量

res_2d_purelin = zeros(n,n);
res_2d_tansig = zeros(n,n);
res_2d_logsig = zeros(n,n);

res_2d_purelin_left = zeros(n,n);
res_2d_tansig_left = zeros(n,n);
res_2d_logsig_left = zeros(n,n);

res_2d_purelin_right = zeros(n,n);
res_2d_tansig_right = zeros(n,n);
res_2d_logsig_right = zeros(n,n);

%% 一起算
parfor i = 1 : n 
   for j = 1 : n
        tmp = zeros(1,sz);
       for k = 1 : sz
                tmp(k) = donet([i,j],inputs,targets, 'purelin');
       end
       res_2d_purelin(i,j) = median(tmp);
   end
end


parfor i = 1 : n 
   for j = 1 : n
        tmp = zeros(1,sz);
       for k = 1 : sz
                tmp(k) = donet([i,j],inputs,targets, 'tansig');
       end
       res_2d_tansig(i,j) = median(tmp);
   end
end


parfor i = 1 : n 
   for j = 1 : n
        tmp = zeros(1,sz);
       for k = 1 : sz
                tmp(k) = donet([i,j],inputs,targets, 'logsig');
       end
       res_2d_logsig(i,j) = median(tmp);
   end
end
save('res_2d', 'res_2d_purelin','res_2d_tansig','res_2d_logsig');


%% 算left

parfor i = 1 : n 
   for j = 1 : n
        tmp = zeros(1,sz);
       for k = 1 : sz
                tmp(k) = donet([i,j],inputs,targets_left, 'purelin');
       end
       res_2d_purelin_left(i,j) = median(tmp);
   end
end

parfor i = 1 : n 
   for j = 1 : n
        tmp = zeros(1,sz);
       for k = 1 : sz
                tmp(k) = donet([i,j],inputs,targets_left, 'tansig');
       end
       res_2d_tansig_left(i,j) = median(tmp);
   end
end


parfor i = 1 : n 
   for j = 1 : n
        tmp = zeros(1,sz);
       for k = 1 : sz
                tmp(k) = donet([i,j],inputs,targets_left, 'logsig');
       end
       res_2d_logsig_left(i,j) = median(tmp);
   end
end
save('res_2d_left', 'res_2d_purelin_left','res_2d_tansig_left','res_2d_logsig_left');

%% 算右边
parfor i = 1 : n 
   for j = 1 : n
        tmp = zeros(1,sz);
       for k = 1 : sz
                tmp(k) = donet([i,j],inputs,targets_right, 'purelin');
       end
       res_2d_purelin_right(i,j) = median(tmp);
   end
end


parfor i = 1 : n 
   for j = 1 : n
        tmp = zeros(1,sz);
       for k = 1 : sz
           tmp(k) = donet([i,j],inputs,targets_right, 'tansig');
       end
       res_2d_tansig_right(i,j) = median(tmp);
   end
end


parfor i = 1 : n 
   for j = 1 : n
        tmp = zeros(1,sz);
       for k = 1 : sz
                tmp(k) = donet([i,j],inputs,targets_right, 'logsig');
       end
       res_2d_logsig_right(i,j) = median(tmp);
   end
end
save('res_2d_right', 'res_2d_purelin_right','res_2d_tansig_right','res_2d_logsig_right');

