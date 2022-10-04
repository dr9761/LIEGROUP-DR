clear;close all;
%%
ra  = 0.01;
ri  = 0;
L = 10;
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

% r1   = [0;0;0];dr1dt  = [0;0;0];
% phi1 = [0;0;0];omega1 = [0;0;0];
% norm_dr1dx = 1;norm_ddr1dxdt = 0;
% r2   = [L;0;0];dr2dt  = [0;0;0];
% phi2 = [0.1;0.1;0];omega2 = [0;0;0];
% norm_dr2dx = 1;norm_ddr2dxdt = 0;

r1   = [0;0;0];dr1dt  = [0;0;0];
phi1 = [0;0;0];omega1 = [0;0;0];
norm_dr1dx = 1;norm_ddr1dxdt = 0;
r2   = [L;0;0];dr2dt  = [0;0;0];
phi2 = [0;0;0];omega2 = [0;0;0];
norm_dr2dx = 1;norm_ddr2dxdt = 0;

phi = 0;

r1   = [0;0;0];dr1dt  = [0;0;0];
phi1 = [0;deg2rad(phi);0];omega1 = [0;0;0];
norm_dr1dx = 1;norm_ddr1dxdt = 0;
r2   = [L*cos(deg2rad(phi));0;L*sin(deg2rad(phi))];dr2dt  = [0;0;0];
phi2 = [0;deg2rad(phi);0];omega2 = [0;0;0];
norm_dr2dx = 1;norm_ddr2dxdt = 0;

q1 = [r1;phi1;norm_dr1dx];dq1 = [dr1dt;omega1;norm_ddr1dxdt];
q2 = [r2;phi2;norm_dr2dx];dq2 = [dr2dt;omega2;norm_ddr2dxdt];
qe = [q1;q2];dqe = [dq1;dq2];
%%
% hold on;
% [Mass,Force] = CubicSpline_MassForce(...
% 	qe,dqe,g,BodyParameter);
% plot_CubicSplineBeam(qe,20,BodyParameter,'r-')
% hold off;
%%
x0 = [qe;dqe];
opt=odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',1);
tspan = [0 10];
tic;
[t_set,x_set]=ode23tb(...
	@(t,x)CubicSpline_Rope_ode_Test_func(t,x,g,BodyParameter), ...
	tspan,x0,opt);
SolvingTime = toc;
%%
% qe([7,14]) = [];
% dqe([7,14]) = [];
% xi = 1;
% [qc,dqc,Tc,dTcdt] = ...
% 	get_InternalNode_Coordination_CubicSplineBeam(...
% 	qe,dqe,xi,BodyParameter);
%%
plot_CubicSpline_Test_Postprocessing(...
	t_set,x_set,BodyParameter);
%%
function dx = CubicSpline_Rope_ode_Test_func(t,x,g,BodyParameter)
qe = x(1:numel(x)/2);
dqe = x(numel(x)/2+1:end);

[Mass,Force] = CubicSpline_Rope_MassForce(...
	qe,dqe,g,BodyParameter);
%%
% Mass(1:6,:) = 0;
% Mass(1:6,1:6) = eye(6);
% Force(1:6) = 0;
%
Mass(1:3,:) = 0;
Mass(1:3,1:3) = eye(3);
Force(1:3) = 0;
%
ddqe = -Mass\Force;
%%
dqedt = dqe;
dqedt(4:6) = get_T(qe(4:6)) \ dqe(4:6);
dqedt(11:13) = get_T(qe(11:13)) \ dqe(11:13);

dx = [dqedt;ddqe];
%%
fprintf('t = %d\n',t);
% plot_CubicSplineBeam(qe,20,BodyParameter,'r.-');
% axis([-15,15,-20,10,-20,10]);
% view(0,0);%x-z
% pause(0.02);
end

