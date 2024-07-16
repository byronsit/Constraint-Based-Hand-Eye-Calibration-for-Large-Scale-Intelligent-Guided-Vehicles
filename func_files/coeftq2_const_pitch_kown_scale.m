function obj = coeftq2_const_pitch_kown_scale(in1)
coef_J17 = in1(:,17);
coef_J20 = in1(:,20);
coef_J23 = in1(:,23);
coef_J31 = in1(:,31);
coef_J34 = in1(:,34);
coef_J37 = in1(:,37);
coef_J45 = in1(:,45);
coef_J48 = in1(:,48);
coef_J51 = in1(:,51);
coef_J57 = in1(:,57);
obj = [coef_J17,coef_J20,coef_J23,coef_J31,coef_J34,coef_J37,coef_J45,coef_J48,coef_J51,coef_J57];
end
