function obj = G_const_pitch_kown_scale(in1)
coef_J53 = in1(:,53);
coef_J54 = in1(:,54);
coef_J56 = in1(:,56);
t2 = -coef_J54;
obj = reshape([coef_J53.*-2.0,t2,t2,coef_J56.*-2.0],[2,2]);
end
