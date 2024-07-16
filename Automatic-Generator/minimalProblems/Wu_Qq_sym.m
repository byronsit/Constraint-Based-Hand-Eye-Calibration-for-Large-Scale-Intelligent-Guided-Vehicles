function [eq, known, unknown, kngroups, cfg, algB] = Wu_Qq_sym()



syms W [4 64]
syms Q11 Q12 Q13 Q14
syms     Q22 Q23 Q24
syms         Q33 Q34
syms             Q44
syms lambda
syms q0 q1 q2 q3

Q = [
    Q11, Q12, Q13, Q14;
    Q12, Q22, Q23, Q24;
    Q13, Q23, Q33, Q34;
    Q14, Q24, Q34, Q44;
    ];

q = [q0; q1; q2; q3];
u = kron(kron(q, q), q);
%u = [q0^3, q0^2*q1, q0^2*q2, q0^2*q3, q0^2*q1, q0*q1^2, q0*q1*q2, q0*q1*q3, q0^2*q2, q0*q1*q2, q0*q2^2, q0*q2*q3, q0^2*q3, q0*q1*q3, q0*q2*q3, q0*q3^2, q0^2*q1, q0*q1^2, q0*q1*q2, q0*q1*q3, q0*q1^2, q1^3, q1^2*q2, q1^2*q3, q0*q1*q2, q1^2*q2, q1*q2^2, q1*q2*q3, q0*q1*q3, q1^2*q3, q1*q2*q3, q1*q3^2, q0^2*q2, q0*q1*q2, q0*q2^2, q0*q2*q3, q0*q1*q2, q1^2*q2, q1*q2^2, q1*q2*q3, q0*q2^2, q1*q2^2, q2^3, q2^2*q3, q0*q2*q3, q1*q2*q3, q2^2*q3, q2*q3^2, q0^2*q3, q0*q1*q3, q0*q2*q3, q0*q3^2, q0*q1*q3, q1^2*q3, q1*q2*q3, q1*q3^2, q0*q2*q3, q1*q2*q3, q2^2*q3, q2*q3^2, q0*q3^2, q1*q3^2, q2*q3^2, q3^3];
eq = sym(zeros(1, 5));
eq(1 : 4) = (W * u - (Q - lambda * eye(4)) * q).';
eq(5) = q0 * q0 + q1 * q1 + q2 * q2 + q3 * q3 - 1;

% four unknowns
unknown = {'q0' 'q1' 'q2' 'q3' 'lambda'};

% known parameters
vars = transpose([reshape(W, [256, 1]); [Q11; Q12; Q13; Q14; Q22; Q23; Q24; Q33; Q34; Q44]]);
known = {};
for var = vars
  known = [known {char(var)}];
end

kngroups = [];
cfg = gbs_InitConfig();
algB = [];

end