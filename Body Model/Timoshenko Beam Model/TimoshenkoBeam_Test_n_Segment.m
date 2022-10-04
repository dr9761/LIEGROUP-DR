% Timoshenko_Beam_3D_Test_n_Segment
clear;clc;close;
L = 15;
n = 3;
g = [0;0;-9.8];

% BodyParameter = set_BodyParameter(1/n,'Test');
BodyParameter = ...
	set_BodyParameter_TimoshenkoBeam_Test(L/n);

% r1 = [0;0;0];phi1 = [0;0;0];
% r2 = [L;0;0];phi2 = [0;0;0];
% q1 = [r1;phi1];q2 = [r2;phi2];
% qe = [q1;q2];
% 
% dr1dt = [0;0;0];omega1 = [0;0;0];
% dr2dt = [0;0;0];omega2 = [0;0;0];
% dq1 = [dr1dt;omega1];dq2 = [dr2dt;omega2];
% dqe = [dq1;dq2];

qe = [];dqe = [];
Angle = deg2rad(0);
for i = 1:n+1
	ri = [L/n*(i-1)*cos(Angle);0;-L/n*(i-1)*sin(Angle)];
	phii = [0;Angle;0];
	qe = [qe;ri;phii];
	
	dridt = [0;0;0];
	omegai = [0;0;0];
	dqe = [dqe;dridt;omegai];
end
%%
x = [qe;dqe];
x0 = x;
opt=odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',1);
tspan = [0 10];
tic;
[t_set,x_set]=ode23tb( ...
	@(t,x)Timoshenko_Beam_3D_odefunc_Cantilever_Test( ...
	t,x,g,BodyParameter),tspan,x0,opt);
toc;
%%
% [Mass,Force,Fine,Fint,Fext] = TimoshenkoBeam_MassForce(...
% 	qe,dqe,g,BodyParameter);
% [Fine,Fint,Fext]
%%
% postprocess_plot(t_set,x_set,BodyParameter);
% figure(2);hold off;
% for i = 1:n
% 	plot(t_set,x_set(:,6*i+3));
% 	hold on;
% end
% hold off;

function [dx] = ...
	Timoshenko_Beam_3D_odefunc_Cantilever_Test( ...
	t,x,g,BodyParameter)
n = numel(x)/2/6-1;
q = x(1:numel(x)/2);
dq = x(numel(x)/2+1:end);

% q(5) = -pi/2 * 1/2*(1-cos(t*2*pi/10));
% dq(5) = -pi^2/20 * sin(t*2*pi/10);
	
M = zeros(numel(x)/2);
F = zeros(numel(x)/2,1);
for i = 1:n
	m = 6*(i-1)+[1:12];
	qe = x(m);
	dqe = x(m+6*(n+1));
	
	phi0 = qe(4:6);
	phie = qe(10:12);
	omega0 = dqe(4:6);
	
	[Mass,Force] = ...
		TimoshenkoBeam_MassForce_GaussianNumericalIntegration(qe,dqe,g,BodyParameter);
% 	[Mass,Force] = TimoshenkoBeam_MassForce(qe,dqe,g,BodyParameter);
	
	M(m,m) = M(m,m) + Mass;
	F(m,1) = F(m,1) + Force;
end
%%
% qe = y(1:12);
% dqe = y(13:24);
dqedt = zeros(numel(x)/2,1);
for i = 1:n+1
	m = 6*(i-1)+1:6*(i-1)+6;
	phi = x(m(4:6));
	dqedt(m(1:3)) = x(m(1:3)+6*(n+1));
	dqedt(m(4:6)) = get_T(phi) \ x(m(4:6)+6*(n+1));
end
%%
% F = F + 100*dq;
%% add constraint
M(1:6,:) = 0;
M(1:6,1:6) = eye(6);
F(1:6) = zeros(1,6);
% F(5) = -pi^3/100 * cos(t*2*pi/10);

% M(1:3,:) = 0;
% M(1:3,1:3) = eye(3);
% F(1:3) = 0;
%%
ddqedt = -M\F;
%%
dx = [dqedt;ddqedt];
%% plot
fprintf('t = %d\n',t);
r_set = [];
% for i = 1:n+1
% 	m = 6*(i-1)+[1:3];
% 	r_set = [r_set,q(m)];
% end
% plot_x = r_set(1,:);
% plot_y = r_set(2,:);
% plot_z = r_set(3,:);
% plot3(plot_x,plot_y,plot_z,'k.-');
% axis([-10,10,-10,10,-10,10]*2);
% grid on;
% view(0,0);%x-z
pause(0.001);

hold off;
for i = 1:n
	m = 6*(i-1)+[1:12];
	q_plot = q(m);
	dq_plot = dq(m);
plot_r = [];
for xi = linspace(0,1,10)
	[qc,dqc,Tc,dTcdt] = ...
		get_InternalNode_Coordination_TimoshenkoBeam(...
		q_plot,dq_plot,xi,BodyParameter);
	plot_r = [plot_r,qc(1:3)];
end
plot_x = plot_r(1,:);
plot_y = plot_r(2,:);
plot_z = plot_r(3,:);
plot3(plot_x,plot_y,plot_z,'.-');
hold on;
end
% axis([0,20,-10,10,-0.1,0.1]);
axis([-10,20,-10,10,-15,15]);
view(0,0);%x-z
grid MINOR;
drawnow;
% pause(0.01);
end

function BodyParameter = ...
	set_BodyParameter_TimoshenkoBeam_Test(L)
rho = 7800;
E   = 2.06e11;
v   = 0.25;
ra  = 0.15;
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
end