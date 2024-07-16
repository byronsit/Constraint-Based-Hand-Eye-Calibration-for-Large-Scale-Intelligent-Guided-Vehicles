sz = 30

res_2d_purelin_right = zeros(n,n);
res_2d_tansig_right = zeros(n,n);
res_2d_logsig_right = zeros(n,n);


%% 算右边
parfor i = 1 : n 
   for j = 1 : n
        tmp = zeros(1,sz);
       for k = 1 : sz
                tmp(k) = donet([i,j],inputs,targets_right, 'purelin');
       end
       res_2d_purelin_right(i,j) = min(tmp);
   end
end


parfor i = 1 : n 
   for j = 1 : n
        tmp = zeros(1,sz);
       for k = 1 : sz
           tmp(k) = donet([i,j],inputs,targets_right, 'tansig');
       end
       res_2d_tansig_right(i,j) = min(tmp);
   end
end


parfor i = 1 : n 
   for j = 1 : n
        tmp = zeros(1,sz);
       for k = 1 : sz
                tmp(k) = donet([i,j],inputs,targets_right, 'logsig');
       end
       res_2d_logsig_right(i,j) = min(tmp);
   end
end
save('res_2d_right', 'res_2d_purelin_right','res_2d_tansig_right','res_2d_logsig_right');

