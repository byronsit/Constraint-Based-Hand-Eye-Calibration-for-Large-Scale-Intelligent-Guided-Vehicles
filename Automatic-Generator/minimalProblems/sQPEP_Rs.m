function [eq, known, unknown, kngroups, cfg, algB] = gen_W()

syms q0 q1 q2 q3 lambda scale;

%set syms
Wq = sym('Wq_%d_%d', [4, 24]);   
Ws = sym('Ws_%d', [1, 45]);    %W
q = [q0 q1 q2 q3].';

mon_Jacob_qt = [q0^3*scale^2, q0^2*q1*scale^2, q0^2*q2*scale^2, q0^2*q3*scale^2, q0*q1^2*scale^2, q0*q1*q2*scale^2, q0*q1*q3*scale^2, q0*q2^2*scale^2, q0*q2*q3*scale^2, q0*q3^2*scale^2, q0*scale, q1^3*scale^2, q1^2*q2*scale^2, q1^2*q3*scale^2, q1*q2^2*scale^2, q1*q2*q3*scale^2, q1*q3^2*scale^2, q1*scale, q2^3*scale^2, q2^2*q3*scale^2, q2*q3^2*scale^2, q2*scale, q3^3*scale^2, q3*scale];
mon_Jacob_qt_scale = [q0^4*scale, q0^3*q1*scale, q0^3*q2*scale, q0^3*q3*scale, q0^2*q1^2*scale, q0^2*q1*q2*scale, q0^2*q1*q3*scale, q0^2*q2^2*scale, q0^2*q2*q3*scale, q0^2*q3^2*scale, q0^2, q0*q1^3*scale, q0*q1^2*q2*scale, q0*q1^2*q3*scale, q0*q1*q2^2*scale, q0*q1*q2*q3*scale, q0*q1*q3^2*scale, q0*q1, q0*q2^3*scale, q0*q2^2*q3*scale, q0*q2*q3^2*scale, q0*q2, q0*q3^3*scale, q0*q3, q1^4*scale, q1^3*q2*scale, q1^3*q3*scale, q1^2*q2^2*scale, q1^2*q2*q3*scale, q1^2*q3^2*scale, q1^2, q1*q2^3*scale, q1*q2^2*q3*scale, q1*q2*q3^2*scale, q1*q2, q1*q3^3*scale, q1*q3, q2^4*scale, q2^3*q3*scale, q2^2*q3^2*scale, q2^2, q2*q3^3*scale, q2*q3, q3^4*scale, q3^2];

            eq = sym(zeros(1, 5));
            eq(1 : 4) = expand((Wq * mon_Jacob_qt.' - q * lambda).');
            %eq(5) = expand((Ws * mon_Jacob_qt_scale.').');
            eq(5) = q0 * q0 + q1 * q1 + q2 * q2 + q3 * q3 - 1;

str_Wq = reshape(Wq, 1,[]);
% str = [str_Wq, reshape(Ws, 1,[])]
str_Ws = reshape(Ws, 1,[]);

known1 = sprintf('''%s'' ',str_Wq );
known2 = sprintf('''%s'' ',str_Ws );

eval(['known = {', known1, known2, '};']);
%known parameters
% sym2cell(str_Wq),
% sym2cell(str_Ws)

%known = sym2cell(str_Ws);
%unknowns 
unknown = {'q0' ,'q1', 'q2', 'q3', 'lambda', 'scale' };

%no kngroups
kngroups = [];

%config file
cfg = gbs_InitConfig();

%we do not have precomputed algB
algB = [];

end

%gbs_GenerateSolver('sQPEP_Rs')
