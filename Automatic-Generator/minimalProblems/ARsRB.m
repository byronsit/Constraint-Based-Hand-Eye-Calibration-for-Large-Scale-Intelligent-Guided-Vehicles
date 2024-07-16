function [eq, known, unknown, kngroups, cfg, algB] = ARsRB()

% clc
% clear all
% close all

syms scale
syms q0 q1 q2 q3

coef = sym('coef_J%d',[1,55]);
showSyms(coef);
q = [q0; q1; q2; q3];
eq = sym(zeros(1, 5));
lambda = 0;

eq(1) = 4*coef_J1*q0^3*scale^2 + 4*coef_J2*q0^3*scale + 4*coef_J3*q0^3 + 3*coef_J4*q0^2*q1*scale + 3*coef_J5*q0^2*q2*scale + 3*coef_J6*q0^2*q3*scale + 2*coef_J7*q0*q1^2*scale^2 + 2*coef_J8*q0*q1^2*scale + 2*coef_J9*q0*q1^2 + 2*coef_J10*q0*q1*q2*scale + 2*coef_J11*q0*q1*q3*scale + 2*coef_J12*q0*q2^2*scale^2 + 2*coef_J13*q0*q2^2*scale + 2*coef_J14*q0*q2^2 + 2*coef_J15*q0*q2*q3*scale + 2*coef_J16*q0*q3^2*scale^2 + 2*coef_J17*q0*q3^2*scale + 2*coef_J18*q0*q3^2 - lambda*q0 + coef_J19*q1^3*scale + coef_J20*q1^2*q2*scale + coef_J21*q1^2*q3*scale + coef_J22*q1*q2^2*scale + coef_J23*q1*q2*q3*scale + coef_J24*q1*q3^2*scale + coef_J25*q2^3*scale + coef_J26*q2^2*q3*scale + coef_J27*q2*q3^2*scale + coef_J28*q3^3*scale;

eq(2) = coef_J4*q0^3*scale + 2*coef_J7*q0^2*q1*scale^2 + 2*coef_J8*q0^2*q1*scale + 2*coef_J9*q0^2*q1 + coef_J10*q0^2*q2*scale + coef_J11*q0^2*q3*scale + 3*coef_J19*q0*q1^2*scale + 2*coef_J20*q0*q1*q2*scale + 2*coef_J21*q0*q1*q3*scale + coef_J22*q0*q2^2*scale + coef_J23*q0*q2*q3*scale + coef_J24*q0*q3^2*scale + 4*coef_J29*q1^3*scale^2 + 4*coef_J30*q1^3*scale + 4*coef_J31*q1^3 + 3*coef_J32*q1^2*q2*scale + 3*coef_J33*q1^2*q3*scale + 2*coef_J34*q1*q2^2*scale^2 + 2*coef_J35*q1*q2^2*scale + 2*coef_J36*q1*q2^2 + 2*coef_J37*q1*q2*q3*scale + 2*coef_J38*q1*q3^2*scale^2 + 2*coef_J39*q1*q3^2*scale + 2*coef_J40*q1*q3^2 - lambda*q1 + coef_J41*q2^3*scale + coef_J42*q2^2*q3*scale + coef_J43*q2*q3^2*scale + coef_J44*q3^3*scale;

eq(3) = coef_J5*q0^3*scale + coef_J10*q0^2*q1*scale + 2*coef_J12*q0^2*q2*scale^2 + 2*coef_J13*q0^2*q2*scale + 2*coef_J14*q0^2*q2 + coef_J15*q0^2*q3*scale + coef_J20*q0*q1^2*scale + 2*coef_J22*q0*q1*q2*scale + coef_J23*q0*q1*q3*scale + 3*coef_J25*q0*q2^2*scale + 2*coef_J26*q0*q2*q3*scale + coef_J27*q0*q3^2*scale + coef_J32*q1^3*scale + 2*coef_J34*q1^2*q2*scale^2 + 2*coef_J35*q1^2*q2*scale + 2*coef_J36*q1^2*q2 + coef_J37*q1^2*q3*scale + 3*coef_J41*q1*q2^2*scale + 2*coef_J42*q1*q2*q3*scale + coef_J43*q1*q3^2*scale + 4*coef_J45*q2^3*scale^2 + 4*coef_J46*q2^3*scale + 4*coef_J47*q2^3 + 3*coef_J48*q2^2*q3*scale + 2*coef_J49*q2*q3^2*scale^2 + 2*coef_J50*q2*q3^2*scale + 2*coef_J51*q2*q3^2 - lambda*q2 + coef_J52*q3^3*scale;

%eq(4) = coef_J6*q0^3*scale + coef_J11*q0^2*q1*scale + coef_J15*q0^2*q2*scale + 2*coef_J16*q0^2*q3*scale^2 + 2*coef_J17*q0^2*q3*scale + 2*coef_J18*q0^2*q3 + coef_J21*q0*q1^2*scale + coef_J23*q0*q1*q2*scale + 2*coef_J24*q0*q1*q3*scale + coef_J26*q0*q2^2*scale + 2*coef_J27*q0*q2*q3*scale + 3*coef_J28*q0*q3^2*scale + coef_J33*q1^3*scale + coef_J37*q1^2*q2*scale + 2*coef_J38*q1^2*q3*scale^2 + 2*coef_J39*q1^2*q3*scale + 2*coef_J40*q1^2*q3 + coef_J42*q1*q2^2*scale + 2*coef_J43*q1*q2*q3*scale + 3*coef_J44*q1*q3^2*scale + coef_J48*q2^3*scale + 2*coef_J49*q2^2*q3*scale^2 + 2*coef_J50*q2^2*q3*scale + 2*coef_J51*q2^2*q3 + 3*coef_J52*q2*q3^2*scale + 4*coef_J53*q3^3*scale^2 + 4*coef_J54*q3^3*scale + 4*coef_J55*q3^3 - lambda*q3;

eq(4) = coef_J2*q0^4 + coef_J30*q1^4 + coef_J46*q2^4 + coef_J54*q3^4 + coef_J4*q0^3*q1 + coef_J5*q0^3*q2 + coef_J6*q0^3*q3 + coef_J19*q0*q1^3 + coef_J25*q0*q2^3 + coef_J28*q0*q3^3 + coef_J32*q1^3*q2 + coef_J33*q1^3*q3 + coef_J41*q1*q2^3 + coef_J44*q1*q3^3 + coef_J48*q2^3*q3 + coef_J52*q2*q3^3 + 2*coef_J1*q0^4*scale + 2*coef_J29*q1^4*scale + 2*coef_J45*q2^4*scale + 2*coef_J53*q3^4*scale + coef_J8*q0^2*q1^2 + coef_J13*q0^2*q2^2 + coef_J17*q0^2*q3^2 + coef_J35*q1^2*q2^2 + coef_J39*q1^2*q3^2 + coef_J50*q2^2*q3^2 + coef_J10*q0^2*q1*q2 + coef_J11*q0^2*q1*q3 + coef_J15*q0^2*q2*q3 + coef_J20*q0*q1^2*q2 + coef_J21*q0*q1^2*q3 + coef_J22*q0*q1*q2^2 + coef_J24*q0*q1*q3^2 + coef_J26*q0*q2^2*q3 + coef_J27*q0*q2*q3^2 + coef_J37*q1^2*q2*q3 + coef_J42*q1*q2^2*q3 + coef_J43*q1*q2*q3^2 + 2*coef_J7*q0^2*q1^2*scale + 2*coef_J12*q0^2*q2^2*scale + 2*coef_J16*q0^2*q3^2*scale + 2*coef_J34*q1^2*q2^2*scale + 2*coef_J38*q1^2*q3^2*scale + 2*coef_J49*q2^2*q3^2*scale + coef_J23*q0*q1*q2*q3;

eq(5) = - q0^2/2 - q1^2/2 - q2^2/2 - q3^2/2 + 1/2;


% four unknowns
unknown = {'q0' 'q1' 'q2' 'q3' 'scale'};

% known parameters
%vars = transpose([reshape(W, [256, 1]); [Q11; Q12; Q13; Q14; Q22; Q23; Q24; Q33; Q34; Q44]]);
vars = transpose([reshape(coef, [55, 1])]);
known = {};
for var = vars
  known = [known {char(var)}];
end

kngroups = [];
cfg = gbs_InitConfig();
algB = [];

end
% Creating random instance in Z_30097 for 5 equations
% calculating Grobner basis using Macaulay2 
% ...algebra B basis :
%    1 q0 q0*q1 q0*q1^2 q0*q1^3 q0*q1^4 q0*q1^5 q0*q1^5*q3 q0*q1^4*q2 q0*q1^4*q2*q3 q0*q1^4*q3 q0*q1^4*q3^2 q0*q1^3*q2 q0*q1^3*q2^2 q0*q1^3*q2^3 q0*q1^3*q2^2*q3 q0*q1^3*q2*q3 q0*q1^3*q2*q3^2 q0*q1^3*q2*scale q0*q1^3*q3 q0*q1^3*q3^2 q0*q1^3*q3^3 q0*q1^3*q3^2*scale q0*q1^3*q3*scale q0*q1^3*scale q0*q1^2*q2 q0*q1^2*q2^2 q0*q1^2*q2^3 q0*q1^2*q2^4 q0*q1^2*q2^3*q3 q0*q1^2*q2^2*q3 q0*q1^2*q2^2*q3^2 q0*q1^2*q2^2*scale q0*q1^2*q2*q3 q0*q1^2*q2*q3^2 q0*q1^2*q2*q3^3 q0*q1^2*q2*q3^2*scale q0*q1^2*q2*q3*scale q0*q1^2*q2*scale q0*q1^2*q3 q0*q1^2*q3^2 q0*q1^2*q3^3 q0*q1^2*q3^4 q0*q1^2*q3^5 q0*q1^2*q3^3*scale q0*q1^2*q3^2*scale q0*q1^2*q3*scale q0*q1^2*scale q0*q1*q2 q0*q1*q2^2 q0*q1*q2^3 q0*q1*q2^4 q0*q1*q2^5 q0*q1*q2^4*q3 q0*q1*q2^3*q3 q0*q1*q2^3*q3^2 q0*q1*q2^3*scale q0*q1*q2^2*q3 q0*q1*q2^2*q3^2 q0*q1*q2^2*q3^3 q0*q1*q2^2*q3^2*scale q0*q1*q2^2*q3*scale q0*q1*q2^2*scale q0*q1*q2*q3 q0*q1*q2*q3^2 q0*q1*q2*q3^3 q0*q1*q2*q3^4 q0*q1*q2*q3^5 q0*q1*q2*q3^3*scale q0*q1*q2*q3^2*scale q0*q1*q2*q3*scale q0*q1*q2*q3*scale^2 q0*q1*q2*q3*scale^3 q0*q1*q2*q3*scale^4 q0*q1*q2*scale q0*q1*q2*scale^2 q0*q1*q2*scale^3 q0*q1*q2*scale^4 q0*q1*q3 q0*q1*q3^2 q0*q1*q3^3 q0*q1*q3^4 q0*q1*q3^5 q0*q1*q3^6 q0*q1*q3^4*scale q0*q1*q3^3*scale q0*q1*q3^3*scale^2 q0*q1*q3^2*scale q0*q1*q3^2*scale^2 q0*q1*q3^2*scale^3 q0*q1*q3*scale q0*q1*q3*scale^2 q0*q1*q3*scale^3 q0*q1*q3*scale^4 q0*q1*q3*scale^5 q0*q1*scale q0*q1*scale^2 q0*q1*scale^3 q0*q1*scale^4 q0*q1*scale^5 q0*q1*scale^6 q0*q2 q0*q2^2 q0*q2^3 q0*q2^4 q0*q2^5 q0*q2^6 q0*q2^5*q3 q0*q2^4*q3 q0*q2^4*q3^2 q0*q2^4*scale q0*q2^3*q3 q0*q2^3*q3^2 q0*q2^3*q3^3 q0*q2^3*q3^2*scale q0*q2^3*q3*scale q0*q2^3*scale q0*q2^2*q3 q0*q2^2*q3^2 q0*q2^2*q3^3 q0*q2^2*q3^4 q0*q2^2*q3^5 q0*q2^2*q3^3*scale q0*q2^2*q3^2*scale q0*q2^2*q3*scale q0*q2^2*q3*scale^2 q0*q2^2*q3*scale^3 q0*q2^2*q3*scale^4 q0*q2^2*scale q0*q2^2*scale^2 q0*q2^2*scale^3 q0*q2^2*scale^4 q0*q2*q3 q0*q2*q3^2 q0*q2*q3^3 q0*q2*q3^4 q0*q2*q3^5 q0*q2*q3^6 q0*q2*q3^4*scale q0*q2*q3^3*scale q0*q2*q3^3*scale^2 q0*q2*q3^2*scale q0*q2*q3^2*scale^2 q0*q2*q3^2*scale^3 q0*q2*q3*scale q0*q2*q3*scale^2 q0*q2*q3*scale^3 q0*q2*q3*scale^4 q0*q2*q3*scale^5 q0*q2*scale q0*q2*scale^2 q0*q2*scale^3 q0*q2*scale^4 q0*q2*scale^5 q0*q2*scale^6 q0*q3 q0*q3^2 q0*q3^3 q0*q3^4 q0*q3^5 q0*q3^6 q0*q3^7 q0*q3^5*scale q0*q3^4*scale q0*q3^3*scale q0*q3^3*scale^2 q0*q3^3*scale^3 q0*q3^3*scale^4 q0*q3^2*scale q0*q3^2*scale^2 q0*q3^2*scale^3 q0*q3^2*scale^4 q0*q3*scale q0*q3*scale^2 q0*q3*scale^3 q0*q3*scale^4 q0*q3*scale^5 q0*q3*scale^6 q0*scale q0*scale^2 q0*scale^3 q0*scale^4 q0*scale^5 q0*scale^6 q0*scale^7 q1 q1^2 q1^3 q1^4 q1^5 q1^6 q1^6*q3 q1^5*q2 q1^5*q2^2 q1^5*q2*q3 q1^5*q3 q1^5*q3^2 q1^4*q2 q1^4*q2^2 q1^4*q2^3 q1^4*q2^2*q3 q1^4*q2*q3 q1^4*q2*q3^2 q1^4*q3 q1^4*q3^2 q1^4*q3^3 q1^3*q2 q1^3*q2^2 q1^3*q2^3 q1^3*q2^4 q1^3*q2^3*q3 q1^3*q2^2*q3 q1^3*q2^2*q3^2 q1^3*q2^2*scale q1^3*q2*q3 q1^3*q2*q3^2 q1^3*q2*q3^3 q1^3*q2*q3^2*scale q1^3*q2*q3*scale q1^3*q2*scale q1^3*q3 q1^3*q3^2 q1^3*q3^3 q1^3*q3^4 q1^3*q3^5 q1^3*q3^3*scale q1^3*q3^2*scale q1^3*q3*scale q1^3*scale q1^2*q2 q1^2*q2^2 q1^2*q2^3 q1^2*q2^4 q1^2*q2^5 q1^2*q2^4*q3 q1^2*q2^3*q3 q1^2*q2^3*q3^2 q1^2*q2^3*scale q1^2*q2^2*q3 q1^2*q2^2*q3^2 q1^2*q2^2*q3^3 q1^2*q2^2*q3^2*scale q1^2*q2^2*q3*scale q1^2*q2^2*scale q1^2*q2*q3 q1^2*q2*q3^2 q1^2*q2*q3^3 q1^2*q2*q3^4 q1^2*q2*q3^5 q1^2*q2*q3^3*scale q1^2*q2*q3^2*scale q1^2*q2*q3*scale q1^2*q2*scale q1^2*q3 q1^2*q3^2 q1^2*q3^3 q1^2*q3^4 q1^2*q3^5 q1^2*q3^6 q1^2*q3^4*scale q1^2*q3^3*scale q1^2*q3^2*scale q1^2*q3*scale q1^2*q3*scale^2 q1^2*q3*scale^3 q1^2*q3*scale^4 q1^2*q3*scale^5 q1^2*scale q1^2*scale^2 q1^2*scale^3 q1^2*scale^4 q1^2*scale^5 q1^2*scale^6 q1*q2 q1*q2^2 q1*q2^3 q1*q2^4 q1*q2^5 q1*q2^6 q1*q2^5*q3 q1*q2^4*q3 q1*q2^4*q3^2 q1*q2^4*scale q1*q2^3*q3 q1*q2^3*q3^2 q1*q2^3*q3^3 q1*q2^3*q3^4 q1*q2^3*q3^2*scale q1*q2^3*q3*scale q1*q2^3*scale q1*q2^2*q3 q1*q2^2*q3^2 q1*q2^2*q3^3 q1*q2^2*q3^4 q1*q2^2*q3^5 q1*q2^2*q3^3*scale q1*q2^2*q3^2*scale q1*q2^2*q3*scale q1*q2^2*q3*scale^2 q1*q2^2*q3*scale^3 q1*q2^2*q3*scale^4 q1*q2^2*scale q1*q2^2*scale^2 q1*q2^2*scale^3 q1*q2^2*scale^4 q1*q2*q3 q1*q2*q3^2 q1*q2*q3^3 q1*q2*q3^4 q1*q2*q3^5 q1*q2*q3^6 q1*q2*q3^4*scale q1*q2*q3^3*scale q1*q2*q3^3*scale^2 q1*q2*q3^2*scale q1*q2*q3^2*scale^2 q1*q2*q3^2*scale^3 q1*q2*q3*scale q1*q2*q3*scale^2 q1*q2*q3*scale^3 q1*q2*q3*scale^4 q1*q2*q3*scale^5 q1*q2*scale q1*q2*scale^2 q1*q2*scale^3 q1*q2*scale^4 q1*q2*scale^5 q1*q2*scale^6 q1*q3 q1*q3^2 q1*q3^3 q1*q3^4 q1*q3^5 q1*q3^6 q1*q3^7 q1*q3^5*scale q1*q3^4*scale q1*q3^3*scale q1*q3^3*scale^2 q1*q3^3*scale^3 q1*q3^3*scale^4 q1*q3^2*scale q1*q3^2*scale^2 q1*q3^2*scale^3 q1*q3^2*scale^4 q1*q3*scale q1*q3*scale^2 q1*q3*scale^3 q1*q3*scale^4 q1*q3*scale^5 q1*q3*scale^6 q1*scale q1*scale^2 q1*scale^3 q1*scale^4 q1*scale^5 q1*scale^6 q1*scale^7 q2 q2^2 q2^3 q2^4 q2^5 q2^6 q2^7 q2^6*q3 q2^5*q3 q2^5*q3^2 q2^5*scale q2^4*q3 q2^4*q3^2 q2^4*q3^3 q2^4*q3^4 q2^4*q3^2*scale q2^4*q3*scale q2^4*scale q2^3*q3 q2^3*q3^2 q2^3*q3^3 q2^3*q3^4 q2^3*q3^5 q2^3*q3^3*scale q2^3*q3^2*scale q2^3*q3*scale q2^3*q3*scale^2 q2^3*q3*scale^3 q2^3*q3*scale^4 q2^3*scale q2^3*scale^2 q2^3*scale^3 q2^3*scale^4 q2^2*q3 q2^2*q3^2 q2^2*q3^3 q2^2*q3^4 q2^2*q3^5 q2^2*q3^6 q2^2*q3^4*scale q2^2*q3^3*scale q2^2*q3^3*scale^2 q2^2*q3^2*scale q2^2*q3^2*scale^2 q2^2*q3^2*scale^3 q2^2*q3*scale q2^2*q3*scale^2 q2^2*q3*scale^3 q2^2*q3*scale^4 q2^2*q3*scale^5 q2^2*scale q2^2*scale^2 q2^2*scale^3 q2^2*scale^4 q2^2*scale^5 q2^2*scale^6 q2*q3 q2*q3^2 q2*q3^3 q2*q3^4 q2*q3^5 q2*q3^6 q2*q3^7 q2*q3^5*scale q2*q3^4*scale q2*q3^3*scale q2*q3^3*scale^2 q2*q3^3*scale^3 q2*q3^3*scale^4 q2*q3^2*scale q2*q3^2*scale^2 q2*q3^2*scale^3 q2*q3^2*scale^4 q2*q3*scale q2*q3*scale^2 q2*q3*scale^3 q2*q3*scale^4 q2*q3*scale^5 q2*q3*scale^6 q2*scale q2*scale^2 q2*scale^3 q2*scale^4 q2*scale^5 q2*scale^6 q2*scale^7 q2*scale^8 q3 q3^2 q3^3 q3^4 q3^5 q3^6 q3^7 q3^8 q3^6*scale q3^5*scale q3^5*scale^2 q3^4*scale q3^4*scale^2 q3^4*scale^3 q3^3*scale q3^3*scale^2 q3^3*scale^3 q3^3*scale^4 q3^3*scale^5 q3^2*scale q3^2*scale^2 q3^2*scale^3 q3^2*scale^4 q3^2*scale^5 q3^2*scale^6 q3*scale q3*scale^2 q3*scale^3 q3*scale^4 q3*scale^5 q3*scale^6 q3*scale^7 q3*scale^8 scale scale^2 scale^3 scale^4 scale^5 scale^6 scale^7 scale^8 
% ...system is expected to have 486 solutions
% analyzing quotient ring basis
% extracting coefficient & monomials
% ...used 94 monomials : 
%    scale^1*q0^4 scale^1*q1^2*q0^2 scale^1*q1^4 scale^1*q2^2*q0^2 scale^1*q2^2*q1^2 scale^1*q2^4 scale^1*q3^2*q0^2 scale^1*q3^2*q1^2 scale^1*q3^2*q2^2 scale^1*q3^4 scale^2*q0^3 scale^2*q1^1*q0^2 scale^2*q1^2*q0^1 scale^2*q1^3 scale^2*q2^1*q0^2 scale^2*q2^1*q1^2 scale^2*q2^2*q0^1 scale^2*q2^2*q1^1 scale^2*q2^3 scale^2*q3^2*q0^1 scale^2*q3^2*q1^1 scale^2*q3^2*q2^1 q0^4 q1^1*q0^3 q1^2*q0^2 q1^3*q0^1 q1^4 q2^1*q0^3 q2^1*q1^1*q0^2 q2^1*q1^2*q0^1 q2^1*q1^3 q2^2*q0^2 q2^2*q1^1*q0^1 q2^2*q1^2 q2^3*q0^1 q2^3*q1^1 q2^4 q3^1*q0^3 q3^1*q1^1*q0^2 q3^1*q1^2*q0^1 q3^1*q1^3 q3^1*q2^1*q0^2 q3^1*q2^1*q1^1*q0^1 q3^1*q2^1*q1^2 q3^1*q2^2*q0^1 q3^1*q2^2*q1^1 q3^1*q2^3 q3^2*q0^2 q3^2*q1^1*q0^1 q3^2*q1^2 q3^2*q2^1*q0^1 q3^2*q2^1*q1^1 q3^2*q2^2 q3^3*q0^1 q3^3*q1^1 q3^3*q2^1 q3^4 scale^1*q0^3 scale^1*q1^1*q0^2 scale^1*q1^2*q0^1 scale^1*q1^3 scale^1*q2^1*q0^2 scale^1*q2^1*q1^1*q0^1 scale^1*q2^1*q1^2 scale^1*q2^2*q0^1 scale^1*q2^2*q1^1 scale^1*q2^3 scale^1*q3^1*q0^2 scale^1*q3^1*q1^1*q0^1 scale^1*q3^1*q1^2 scale^1*q3^1*q2^1*q0^1 scale^1*q3^1*q2^1*q1^1 scale^1*q3^1*q2^2 scale^1*q3^2*q0^1 scale^1*q3^2*q1^1 scale^1*q3^2*q2^1 scale^1*q3^3 q0^3 q1^1*q0^2 q1^2*q0^1 q1^3 q2^1*q0^2 q2^1*q1^2 q2^2*q0^1 q2^2*q1^1 q2^3 q3^2*q0^1 q3^2*q1^1 q3^2*q2^1 q0^2 q1^2 q2^2 q3^2  
% ...max. poly. degree 5
% Adding polynomials
%   Initializing matrix size 25x252
%   35 equations added
%     GJ elimination performed on matrix with size 60x225
%   185 equations added
%     removing 185 equations - all removed
%     GJ elimination performed on matrix with size 60x225
%   Coefficient matrix reallocation, adding 210 (6 degree) monomials
%   665 equations added
%     removing 575 equations - all removed
%     GJ elimination performed on matrix with size 150x435
%   665 equations added
%     removing 665 equations - all removed
%     GJ elimination performed on matrix with size 150x435
%   Coefficient matrix reallocation, adding 330 (7 degree) monomials
%   2036 equations added
%     removing 1854 equations - all removed
%     GJ elimination performed on matrix with size 332x765
%   2036 equations added
%     removing 2036 equations - all removed
%     GJ elimination performed on matrix with size 332x765
%   Coefficient matrix reallocation, adding 495 (8 degree) monomials
%   5515 equations added
%     removing 5185 equations - all removed
%     GJ elimination performed on matrix with size 662x1260
%   5555 equations added
%     removing 5520 equations - all removed
%     GJ elimination performed on matrix with size 697x1260
%   5595 equations added
%     removing 5566 equations - all removed
%     GJ elimination performed on matrix with size 726x1260
%   5595 equations added
%     removing 5595 equations - all removed
%     GJ elimination performed on matrix with size 726x1260
%   Coefficient matrix reallocation, adding 715 (9 degree) monomials
%   14010 equations added
%     removing 13386 equations - all removed
%     GJ elimination performed on matrix with size 1350x1975
%   14275 equations added
%     removing 14157 equations - all removed
%     GJ elimination performed on matrix with size 1468x1977
%   14405 equations added
%     removing 14386 equations - all removed
%     GJ elimination performed on matrix with size 1487x1980
%   14435 equations added
%     removing 14420 equations - all removed
%     GJ elimination performed on matrix with size 1502x1989
%   14435 equations added
%     removing 14435 equations - all removed
%     GJ elimination performed on matrix with size 1502x1989
%   Coefficient matrix reallocation, adding 1001 (10 degree) monomials
%   33839 equations added
%     removing 32843 equations - all removed
%     GJ elimination performed on matrix with size 2498x2990
%   33854 equations added
%     removing 33847 equations - all removed
%     GJ elimination performed on matrix with size 2505x2993
%   33899 equations added
%     removing 33889 equations - all removed
%     GJ elimination performed on matrix with size 2515x3001
% Removing not necessary polynomials: 1-19 20-28 29-32 33-34 35 36 38 39-40 41-44 45-52 53-68 70 72 75 76 82 85 86-87 89 90-91 92-95 96-97 98 100 101-102 103-106 107-114 115-130 131-138 139-154 155-156 157 158 160 161-162 163-166 167-174 175-178 179-180 181 186 192 195 196 202 205 206-207 209 210-211 212-215 216-223 224-239 241 242-243 249 252 253 256 257-258 261 262-263 264 270 273 274 277 278-279 282 283-284 285 288 289-290 291-294 295-302 303-318 319-350 351-354 358 359-360 361-364 365-366 367 368 375 376-377 378-381 382-389 390-393 394-395 396 404 406 410 412 413-414 415-418 419-426 427-442 443-450 451 452 462 468 471 472 478 481 482-483 485 486-487 488-491 492-499 500-515 516-523 524-527 528-535 536 546 552 555 556 562 565 566 569 570-571 577 580 581 584 585-586 589 590-591 592 598 601 602 605 606-607 610 611-612 613 616 617-618 619-622 623-630 631-646 647-654 655-658 659-660 663 666 667 670 671-672 678 681 682 685 686-687 690 691-692 693 699 702 703 706 707-708 711 712-713 714 717 718-719 720 721 727 730 731 734 735-736 738 739-740 741-744 745-752 753-768 769-800 801 802 812 822 823-824 825-828 829-830 831 832 842 846 848 849-850 851-854 855-862 863-866 867 875 877 881 883 884-885 886-889 890-897 898-913 914-945 946-961 962-993 994-997 998-1005 1006 1007 1017 1023 1026 1027 1033 1036 1037-1038 1040 1041-1042 1043-1046 1047-1054 1055-1070 1071-1102 1103-1118 1119-1126 1127 1137 1143 1146 1147 1151 1152-1153 1154-1157 1158-1165 1166-1181 1182-1213 1214-1277 1278-1285 1286-1289 1290-1291 1292 1302 1308 1311 1312 1316 1317-1318 1319-1322 1323-1330 1331-1346 1347-1378 1379-1442 1443-1474 1475-1490 1491-1498 1499-1502 1503-1510 1511 1512 1514 1515-1516 1517 1518-1519 1529 1530-1531 1532-1535 1536-1543 1544-1559 1560-1567 1568-1571 1572-1573 1574 1575 1579 1580-1581 1582 1583-1584 1588 1590 1591-1592 1593-1596 1597-1604 1605-1620 1621-1652 1653-1716 1717-1844 1845-1908 1909-1940 1941-1956 1957-1988 1989-1992 1993-1994 1995-1998 1999 2009 2015 2018 2019 2024 2025-2026 2027-2030 2031-2038 2039-2054 2055-2086 2087-2150 2151-2278 2279-2337 2338-2455 2456-2470 2471-2500 2501-2503 2504 2505-2506 2511 2512-2513 2514-2515
% Extracting the action matrix for variable 'q3' (used coef. matrix size 339x825) 
% --- generating MATLAB solver ---
% --- generating Maple solver ---
