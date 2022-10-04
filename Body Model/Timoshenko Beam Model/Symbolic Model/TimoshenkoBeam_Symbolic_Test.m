% TimoshenkoBeam_Symbolic_Test
clear;
%%
L = 15;
g = [0;0;-9.8];

rho = 7800;
E   = 2.06e11;
v   = 0.25;
ra  = 3;
ri  = 0;

G  = E / (2*(1+v));
A  = pi*(ra^2-ri^2);
Iy = pi*(2*ra)^4*(1-((ri/ra)^4))/64;
Iz = pi*(2*ra)^4*(1-((ri/ra)^4))/64;
Stiffness = diag([E*A,G*A/4,G*A/4,G*(Iy+Iz)/4,E*Iz,E*Iy]);
m = A * L * rho;
r_B_0C = [L/2;0;0];
theta_B_0 = ...
	[	1/2*m*(ra^2-ri^2),		0,					0;
		0,						1/3*m*L^2,			0;
		0,						0,					1/3*m*L^2];

BodyParameter.rho = rho;
BodyParameter.E = E;
BodyParameter.v = v;
BodyParameter.L = L;
BodyParameter.ra = ra;
BodyParameter.ri = ri;
BodyParameter.G  = G;
BodyParameter.A  = A;
BodyParameter.Iy = Iy;
BodyParameter.Iz = Iz;
BodyParameter.Stiffness = Stiffness;
BodyParameter.m = m;
BodyParameter.r_B_0C = r_B_0C;
BodyParameter.theta_B_0 = theta_B_0;	
%%
qe = casadi.SX.sym('qe',12,1);
dqe = casadi.SX.sym('qe',12,1);
%%
[Mass,Force,Fine,Fint,Fext] = ...
	TimoshenkoBeam_MassForce_Symbolic(...
	qe,dqe,g,BodyParameter);
dqedt = get_dqedt_FlexibleBeam_Symbolic(qe,dqe);
