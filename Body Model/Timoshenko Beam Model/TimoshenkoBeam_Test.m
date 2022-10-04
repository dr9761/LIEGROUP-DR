% TimoshenkoBeam_Test
clear;
L = 15;
g = [0;0;-9.8];
% BodyParameter = set_BodyParameter(L,'Test');

r1 = [0;0;0];
phi1 = [0;0;0];
r2 = [L;0;0];
phi2 = [0;0.01;0];

dr1dt = [0;0;0];
omega1 = [0;0;0];
dr2dt = [0;0;0];
omega2 = [0;0;0];

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

qe = [r1;phi1;r2;phi2];
dqe = [dr1dt;omega1;dr2dt;omega2];

%%
x0 = [qe;dqe];
opt=odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',1);
tspan = [0 10];
tic;
[t_set,x_set]=ode23tb(@(t,x)...
	TimoshenkoBeam_Test_func(t,x,g,BodyParameter),...
	tspan,x0,opt);
toc;
%%
% [Mass1,Force1,Fine1,Fint1,Fext1] = TimoshenkoBeam_MassForce(...
% 	qe,dqe,g,BodyParameter);
% -Mass1\Fint1
% % -Mass\Fext
% % -Mass\Fint
% qe2 = [qe(1:6);1;qe(7:12);1];
% dqe2 = [dqe(1:6);0;dqe(7:12);0];
% [Mass2,Force2,Fine2,Fint2,Fext2] = CubicSpline_MassForce(...
% 	qe2,dqe2,g,BodyParameter);
% -Mass2\Fint2
%%
hold off;
plot_r = [];
for xi = linspace(0,1)
	[qc,dqc,Tc,dTcdt] = ...
		get_InternalNode_Coordination_TimoshenkoBeam(...
		qe,dqe,xi,BodyParameter);
	plot_r = [plot_r,qc(1:3)];
end
plot_x = plot_r(1,:);
plot_y = plot_r(2,:);
plot_z = plot_r(3,:);
plot3(plot_x,plot_y,plot_z,'r.-');

hold on;
plot_r = [];
for xi = linspace(0,1)
	[qc,dqc,Tc,dTcdt] = ...
		get_InternalNode_Coordination_CubicSplineBeam(...
		qe,dqe,xi,BodyParameter);
	plot_r = [plot_r,qc(1:3)];
end
plot_x = plot_r(1,:);
plot_y = plot_r(2,:);
plot_z = plot_r(3,:);
plot3(plot_x,plot_y,plot_z,'b.-');
%%
function dxdt = TimoshenkoBeam_Test_func(t,x,g,BodyParameter)
qe  = x(1:numel(x)/2);
dqe = x(numel(x)/2+1:end);
%%
[Mass,Force] = TimoshenkoBeam_MassForce(...
	qe,dqe,g,BodyParameter);
%%
Mass(1:6,:) = 0;
Mass(1:6,1:6) = eye(6);
Force(1:6) = 0;
%%
ddqe = Mass\(-Force);
dqedt = get_dqedt_FlexibleBeam(qe,dqe);
dxdt = [dqedt;ddqe];
fprintf('t = %16.14f\n',t);
r1 = qe(1:3);
r2 = qe(7:9);
r = [r1,r2];
x = r(1,:);
y = r(2,:);
z = r(3,:);
plot3(x,y,z);
view(0,0);%x-z
axis([-10,10,-10,10,-10,10]);
grid on;
drawnow;

% pause(0.001);

end
