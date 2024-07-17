%gbs_GenerateSolver('tiv_const_pitch_const_z')

%最小化问题，grobner来算的最小问题
function [eq, known, unknown, kngroups, cfg, algB] = tiv_const_pitch_const_z()


%A = sym('A%d',[1,24 * 2 + 11 *2]);
%B = sym('B%d',[1,11 * 2]);
A = transpose(gbs_Vector('A', 24 * 2 + 11 *2));
syms ac as gc gs t1 t2 real



known = {};
for var = A
    known = [known, {char(var)}]
end



mons1 = [ac*gc^2, ac*gc*gs, ac*gc, ac*gs^2, ac*gs, ac, as*gc^2, as*gc*gs, as*gc, as*gs^2, as*gs, as, gc^2, gc*gs, gc*t1, gc*t2, gc, gs^2, gs*t1, gs*t2, gs, t1, t2, 1]
mons2 = [ac^2*gc, ac^2*gs, ac^2, ac*as*gc, ac*as*gs, ac*as, ac*gc, ac*gs, ac*t1, ac*t2, ac, as^2*gc, as^2*gs, as^2, as*gc, as*gs, as*t1, as*t2, as, gc, gs, t1, t2, 1]
mons3 = [ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs, t1, t2, 1]
mons4 = [ac*gc, ac*gs, ac, as*gc, as*gs, as, gc, gs, t1, t2, 1]

% two equations representing an ellipse and a hyperbola
%eq = zeros(1, 6);
eq(1) = A(1:24) * mons1.';
eq(2) = A(25:48) * mons2.';
eq(3) = A(49:49+11-1) * mons3.';
eq(4) = A(49+11 : 49+11+10) * mons4.';
eq(5) = ac * ac + as * as - 1;
eq(6) = gc * gc + gs * gs - 1;
% known parameters
%known = { 'a0' 'a1' 'a2' 'a3' 'a4' 'a5' 'a6' 'a7' 'a8' 'a9' 'a10' 'a11' 'a12'};



%two unknowns
unknown = {'ac' ,'as', 'gc', 'gs', 't1', 't2' };



%no kngroups
kngroups = [];

%config file
cfg = gbs_InitConfig();

%we do not have precomputed algB
algB = [];

end
