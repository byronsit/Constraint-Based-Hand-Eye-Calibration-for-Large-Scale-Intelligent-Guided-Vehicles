clc
clear all
close all
syms a1 a2 a3 x y real
f1 = a2*y*y + a3*sqrt(1-x*x)*x==0



assume(a1~=0)
assumeAlso(a1,'real')
assumeAlso(a2,'real')
assumeAlso(a3,'real')
assumeAlso(a3~=0)
assumeAlso(a2~=0)

res=solve(f1,x,'ReturnConditions',true)