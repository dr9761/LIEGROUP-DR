% CubicSpline_Rope_Test_Symbolic
clear;close all;
%% BodyParameter
ra  = 0.15;
ri  = 0;
L = 15;
E = 2.06e11;
v = 0.25;
g = [0;0;-9.8];
rho = 7800;
%
G  = E / (2*(1+v));
A  = pi*(ra^2-ri^2);
Iy = pi*(2*ra)^4*(1-((ri/ra)^4))/64;
Iz = pi*(2*ra)^4*(1-((ri/ra)^4))/64;

BodyParameter.L  = L;
BodyParameter.E  = E;
BodyParameter.G  = G;
BodyParameter.A  = A;
BodyParameter.Iy = Iy;
BodyParameter.Iz = Iz;
BodyParameter.rho = rho;
%% qe dqe
qe = casadi.SX.sym('qe',14,1);
dqe = casadi.SX.sym('dqe',14,1);
%%
[Mass,Force] = CubicSpline_Rope_MassForce_Symbolic(...
	qe,dqe,g,BodyParameter);