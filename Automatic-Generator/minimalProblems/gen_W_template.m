function [eq, known, unknown, kngroups, cfg, algB] = gen_W()

syms q0 q1 q2 q3;

%equations
eq(1) = a0*x^2 +a1*y;
eq(2) = a1*x;

%known parameters
known = { 'a0' 'a1'};

%unknowns 
unknown = {'q0' ,'q1', 'q1', 'q2' };

%no kngroups
kngroups = [];

%config file
cfg = gbs_InitConfig();

%we do not have precomputed algB
algB = [];

end
