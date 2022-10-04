% TimoshenkoBeam_AbsoluteCoordinate_MassForce_Test
clear;
L = 15;
NodeQuantity = 3;
g = [0;0;-9.8];
% BodyParameter = set_BodyParameter(L,'Test');
%%
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
%%
r_set = zeros(3*NodeQuantity,1);
phi_set = zeros(3*NodeQuantity,1);
ptra_set = zeros(3*NodeQuantity,1);
prot_set = zeros(3*NodeQuantity,1);
dL = L / (NodeQuantity-1);
for NodeNr = 1:NodeQuantity
	NodePos = 3*(NodeNr-1) + (1:3);
	x = 0 + dL*(NodeNr-1);
	r_set(NodePos) = [x;0;0];
	phi_set(NodePos) = [0;0;0];
	ptra_set(NodePos) = [0;0;0];
	prot_set(NodePos) = [0;0;0];
end

%
qe = [r_set;phi_set];
dqe = [ptra_set;prot_set];
%%
% r1 = [0;0;0];
% phi1 = [0;-0.01;0];
% r2 = [L;0;0];
% phi2 = [0;0.01;0];
% 
% ptra1 = [0;0;0];
% prot1 = [0;0;0];
% ptra2 = [0;0;0];
% prot2 = [0;0;0];
% 
% qe = [r1;r2;phi1;phi2];
% dqe = [ptra1;ptra2;prot1;prot2];
%%
% [Mass,Force,Fine,Fint,Fext] = ...
% 	TimoshenkoBeam_AbsoluteCoordinate_MassForce(...
% 	qe,dqe,g,BodyParameter);
% 
% qe2 = [r1;phi1;r2;phi2];
% dqe2 = [ptra1;prot1;ptra2;prot2];
% [Mass2,Force2,Fine2,Fint2,Fext2] = ...
% 	TimoshenkoBeam_MassForce(...
% 	qe2,dqe2,g,BodyParameter);
%%
x0 = [qe;dqe];
opt=odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.01);
tspan = [0 10];
tic;
[t_set,x_set]=ode23tb(@(t,x)...
	TimoshenkoBeam_AbsoluteCoordinate_ode_func(t,x,g,BodyParameter),...
	tspan,x0,opt);
toc;
%%
function dx = TimoshenkoBeam_AbsoluteCoordinate_ode_func(...
	t,x,g,BodyParameter)

%%
L  = BodyParameter.L;
A  = BodyParameter.A;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
E  = BodyParameter.E;
G  = BodyParameter.G;
rho = BodyParameter.rho;
%
J = diag([Iy+Iz,Iz,Iy]);
Kepsilon = diag([E*A,G*A,G*A]);
Kkappa = diag([G*(Iy+Iz),E*Iy,E*Iz]);

qe = x(1:numel(x)/2);
dqe = x(numel(x)/2+1:end);

NodeQuantity = numel(qe)/2/3;

Ttra = zeros(3*NodeQuantity,6*NodeQuantity);
Ttra(:,1:3*NodeQuantity) = eye(3*NodeQuantity);

Trot = zeros(3*NodeQuantity,6*NodeQuantity);
Trot(:,3*NodeQuantity+1:end) = eye(3*NodeQuantity);

re = Ttra * qe;
phie = Trot * qe;
ptrae = Ttra * dqe;
prote = Trot * dqe;

[Mass,Force,Fine,Fint,Fext] = ...
	TimoshenkoBeam_AbsoluteCoordinate_MassForce(...
	qe,dqe,g,BodyParameter);

Mass(1:3,:) = 0;
Mass(1:3,1:3) = eye(3);
Force(1:3) = 0;

Mass(7:9,:) = 0;
Mass(7:9,7:9) = eye(3);
Force(7:9) = 0;

ddqe = -Mass\Force;


dredt = zeros(numel(dqe)/2,1);
dphiedt = zeros(numel(dqe)/2,1);
for NodeNr = 1:NodeQuantity
	NodePos = 3*(NodeNr-1) + (1:3);
	
	phii = phie(NodePos);
	Ri = get_R(phii);
	Ti = get_T(phii);
	
	dredt(NodePos) = 1/(rho*A)*ptrae(NodePos);
	dphiedt(NodePos) = 1/rho*inv(Ti)*inv(J)*Ri'*prote(NodePos);
end

dx = [dredt;dphiedt;ddqe];
fprintf('t = %16.14f\n',t);

plot_x = re(1:3:numel(re));
plot_y = re(2:3:numel(re));
plot_z = re(3:3:numel(re));
plot3(plot_x,plot_y,plot_z,'r.-');
axis([0,10,-5,5,-5,5]*2);
grid MINOR;
grid on;
view(0,0);
pause(0.01);

end