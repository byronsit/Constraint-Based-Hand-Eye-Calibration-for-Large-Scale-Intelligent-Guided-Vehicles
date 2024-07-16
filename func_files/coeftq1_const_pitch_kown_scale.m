function obj = coeftq1_const_pitch_kown_scale(in1)
coef_J16 = in1(:,16);
coef_J19 = in1(:,19);
coef_J22 = in1(:,22);
coef_J30 = in1(:,30);
coef_J33 = in1(:,33);
coef_J36 = in1(:,36);
coef_J44 = in1(:,44);
coef_J47 = in1(:,47);
coef_J50 = in1(:,50);
coef_J55 = in1(:,55);
obj = [coef_J16,coef_J19,coef_J22,coef_J30,coef_J33,coef_J36,coef_J44,coef_J47,coef_J50,coef_J55];
end
