clc
clear all
syms a z real
T_db = [eye(3,3),[a/2;0;z];0,0,0,1];
T_bd = inv(T_db)

syms a_q0 a_q1 a_q2 a_q3 real
syms b_q0 b_q1 b_q2 b_q3 real

q=[q0 q1 q2 q3].';
q2R(q)