% Strut_Tie_Test_Symbolic
clear;
g = [0;0;-9.8];
BodyParameter.L = 1;
BodyParameter.E = 1e11;
BodyParameter.m = 1;
BodyParameter.rho = 1;
BodyParameter.Iy = 1;
BodyParameter.Iz = 1;
qe = casadi.SX.sym('qe',6,1);
dqe = casadi.SX.sym('dqe',6,1);
[Mass,Force] = Strut_Tie_MassForce_Symbolic(...
	qe,dqe,g,BodyParameter);
Mass\(-Force)
