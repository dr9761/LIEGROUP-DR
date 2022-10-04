% SingleJib_Pendulum_Symbolic_Test
%%
clc;clear;close all;
ExcelFileName = ...
	'Single Jib Pendulum';
ExcelFileDir = [...
	'Parameter File'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%%
q = casadi.SX.sym('q',3,1);
dq = casadi.SX.sym('dq',3,1);
u = casadi.SX.sym('u',1,1);
%%
t = 0;
x = [q;dq];

[dx,Mass,Force] = SingleJib_Pendulum_Dynamic_func_Symbolic(...
	x,u,ModelParameter);
%%
ddxdx = jacobian(dx,x);
ddxdu = jacobian(dx,u);

MassJacobianBase = casadi.SX.sym('b',3,1);
dMbdq = jacobian(Mass*MassJacobianBase,q);

dFdq = jacobian(Force,q);
dFddq = jacobian(Force,dq);
dFdu = jacobian(Force,u);
%%
J_M_F = ...
	casadi.Function('J_M_F', ...
	{q,dq,u,MassJacobianBase}, {Mass,Force,dMbdq,dFdq,dFddq,dFdu}, ...
	{'q','dq','u','b'}, {'Mass','Force','dMbdq','dFdq','dFddq','dFdu'});

J_dx = ...
	casadi.Function('J_dx', ...
	{x,u}, {dx,ddxdx,ddxdu}, ...
	{'x','u'}, {'dx','ddxdx','ddxdu'});
%%
dpsi = 0;
dphi1 = deg2rad(0);
dphi2 = deg2rad(0);
qn = [dpsi;dphi1;dphi2];
%
ddpsidt = 0;
ddphi1dt = 0;
ddphi2dt = 0;
dqn = [ddpsidt;ddphi1dt;ddphi2dt];
%
un = 0;
%
xn = [qn;dqn];
MassJacobianBase_n = [1;1;1];
%%
J_M_F_n = J_M_F('q',qn,'dq',dqn,'u',un,'b',MassJacobianBase_n);
J_dx_n = J_dx('x',xn,'u',un);
%
Mass_n = full(J_M_F_n.Mass);
Force_n = full(J_M_F_n.Force);
dMbdq_n = full(J_M_F_n.dMbdq);
dFdq_n = full(J_M_F_n.dFdq);
dFddq_n = full(J_M_F_n.dFddq);
dFdu_n = full(J_M_F_n.dFdu);
%
dx_n = full(J_dx_n.dx);
ddxdx_n = full(J_dx_n.ddxdx);
ddxdu_n = full(J_dx_n.ddxdu);