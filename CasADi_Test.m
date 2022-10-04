% CasADi_Test
tic;
import casadi.*
clear;
%%
% ra  = SX.sym('ra');
% ri  = SX.sym('ri');
% L = SX.sym('L');
% E = SX.sym('E');
% v = SX.sym('v');
% g = SX.sym('g',3,1);
% rho = SX.sym('rho');

ra  = 1;
ri  = 0;
L = 15;
E = 2.06e11;
v = 0.25;
g = [0;0;-9.8];
rho = 7800;
%%
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
%
J = diag([Iy+Iz,Iz,Iy]);
%%
qe = SX.sym('qe',14,1);
dqe = SX.sym('dqe',14,1);
%%
[Mass,Force] = CubicSpline_MassForce_Symbolic(...
	qe,dqe,g,BodyParameter);
ForceJacobian = jacobian(Force,qe);
dForceJacobian = jacobian(Force,dqe);
MassJacobianBase = SX.sym('MJB',14,1);

MassJacobian = jacobian(Mass*MassJacobianBase,qe);
F = Function('F', {qe,dqe,MassJacobianBase}, {MassJacobian, ForceJacobian,dForceJacobian}, ...
	{'qe','dqe','b'}, {'MassJacobian','ForceJacobian','dForceJacobian'});
toc;
%%
r1   = [0;0;0];dr1dt  = [0;0;0];
phi1 = [0;-pi/2;0];omega1 = [0;0;0];
norm_dr1dx = 1;norm_ddr1dxdt = 0;
r2   = [0;L;0];dr2dt  = [0;0;0];
phi2 = [0;-pi/2;0];omega2 = [0;0;0];
norm_dr2dx = 1;norm_ddr2dxdt = 0;

q1 = [r1;phi1;norm_dr1dx];dq1 = [dr1dt;omega1;norm_ddr1dxdt];
q2 = [r2;phi2;norm_dr2dx];dq2 = [dr2dt;omega2;norm_ddr2dxdt];
qe = [q1;q2];dqe = [dq1;dq2];

MassJacobianBase = ones(14,1);
Fk = F('qe',qe,'dqe',dqe,'b',MassJacobianBase);
dForceJacobian = full(Fk.dForceJacobian);
ForceJacobian = full(Fk.ForceJacobian);
MassJacobian = full(Fk.MassJacobian);
toc;
%%
phi = casadi.SX.sym('phi',3,1);
R = get_R_Symbolic(phi);
JacobianR = 
JacobianR_Func = 
%% MatLab Symbolic Test
% clear;
% %%
% ra  = sym('ra','real');
% ri  = sym('ri','real');
% L = sym('L','real');
% E = sym('E','real');
% v = sym('v','real');
% g = sym('g',[3,1],'real');
% rho = sym('rho','real');
% %%
% G  = E / (2*(1+v));
% A  = pi*(ra^2-ri^2);
% Iy = pi*(2*ra)^4*(1-((ri/ra)^4))/64;
% Iz = pi*(2*ra)^4*(1-((ri/ra)^4))/64;
% 
% BodyParameter.L  = L;
% BodyParameter.E  = E;
% BodyParameter.G  = G;
% BodyParameter.A  = A;
% BodyParameter.Iy = Iy;
% BodyParameter.Iz = Iz;
% BodyParameter.rho = rho;
% %
% J = diag([Iy+Iz,Iz,Iy]);
% %%
% qe = sym('qe',[14,1],'real');
% dqe = sym('dqe',[14,1],'real');
% %%
% [Mass,Force] = CubicSpline_MassForce_MatLab_Symbolic(...
% 	qe,dqe,g,BodyParameter);
% ForceJacobian = jacobian(Force,qe);
% MassJacobianBase = sym('MJB',14,1);
% MassJacobian = jacobian(Mass*MassJacobianBase,qe);