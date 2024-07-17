KK = ZZ / 30097;
R = KK[x1,x2,x3,x4,MonomialOrder=>GRevLex];
red = matrix(R, {{x1^2, x1^2*x2, x1^2*x2*x4, x1^2*x3, x1^2*x4, x1^2*x4^2, x1*x2^2, x1*x2^2*x4, x1*x2*x3, x1*x2*x3*x4, x1*x2*x4^2, x1*x3*x4, x1*x3*x4^2, x1*x4^3, x2^3, x2^3*x4, x2^2*x3, x2^2*x3*x4, x2^2*x4^2, x2*x3*x4^2, x2*x4^3, x1*x3^2, x2*x3^2, x2*x3^2*x4, x3^2, x3^2*x4, x3^2*x4^2, x3*x4^3, x4^4}});
b = matrix(R, {{1, x1, x1*x2, x1*x2*x4, x1*x3, x1*x4, x1*x4^2, x2, x2^2, x2^2*x4, x2*x3, x2*x3*x4, x2*x4, x2*x4^2, x3, x3*x4, x3*x4^2, x4, x4^2, x4^3}});
eq1 = 13122*x1*x3^2 + 780*x1*x3*x4 + 16543*x1*x3 + 13101*x1*x4^2 + 12651*x1*x4 + 9942*x1 + 6159*x2*x3^2 + 18638*x2*x3*x4 + 9018*x2*x3 + 8030*x2*x4^2 + 18694*x2*x4 + 15925*x2 + 4050*x3^2 + 15457*x3*x4 + 5551*x3 + 23636*x4^2 + 25702*x4 + 14875*1
eq2 = 25478*x1^2*x3 + 2397*x1^2*x4 + 15206*x1^2 + 1964*x1*x2*x3 + 12885*x1*x2*x4 + 2905*x1*x2 + 3827*x1*x3 + 17960*x1*x4 + 6802*x1 + 3218*x2^2*x3 + 6630*x2^2*x4 + 10528*x2^2 + 14078*x2*x3 + 6071*x2*x4 + 19274*x2 + 14538*x3 + 15206*x4 + 11644*1
eq3 = x1^2 + x2^2 + 30096*1
eq4 = x3^2 + x4^2 + 30096*1
eqs = matrix(R, {{eq1, eq2, eq3, eq4}});
I = ideal eqs;
gbTrace = 0;
Q = R/I;
b0 = lift(basis Q,R);
use R
S = (coefficients(b%I,Monomials => b0))_1;
if numcols b0 <= numcols b then (
  Sinv = transpose(S)*inverse(S*transpose(S));
) else (
  Sinv = inverse(transpose(S)*S)*transpose(S);
)
AM = Sinv*((coefficients(red%I,Monomials => b0))_1);
pp = red - b*AM;
A = pp // eqs;
gbRemove(I);
M = kernel eqs;
A = A % M;
 "cache/matrix.1.txt" << toString A << close;
quit();
