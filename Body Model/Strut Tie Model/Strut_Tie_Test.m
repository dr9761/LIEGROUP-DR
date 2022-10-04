% Strut_Tie_Test
clear;
g = [0;0;-9.8];
r1 = [0;0;0];
r2 = [1;0;1];
dr1dt = [0;0;0];
dr2dt = [0;0;0];
BodyParameter.L = norm(r2-r1);
BodyParameter.E = 1e11;
BodyParameter.m = 1;
BodyParameter.rho = 1;
BodyParameter.Iy = 1;
BodyParameter.Iz = 1;
qe = [r1;r2];
dqe = [dr1dt;dr2dt];
[Mass,Force] = Strut_Tie_MassForce(...
	qe,dqe,g,BodyParameter);
Mass\(-Force)
