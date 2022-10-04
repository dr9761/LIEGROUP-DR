function [Mass,Force] = Strut_Tie_Rope_MassForce(...
	qe,dqe,g,BodyParameter)
%%
L = BodyParameter.L;
E = BodyParameter.E;
m = BodyParameter.m;
rho = BodyParameter.rho;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
%% �⻬����
h = 0.01;
%%
r1 = qe(1:3);
r2 = qe(4:6);
r12 = r2 - r1;
A = m / rho / norm(r12);

drdx = 1/L * (r12);
epsilon = norm(drdx) - 1;
dN = 1/L * [-eye(3),eye(3)];
ddrdxdt = dN * dqe;
Tepsilon = 1/norm(drdx) * drdx' * dN;
Tepsilon = Tepsilon';
dTepsilondt = ddrdxdt' * 1/norm(drdx) * ...
	(eye(3) - (drdx*drdx')/(norm(drdx)^2)) * dN;
dTepsilondt = dTepsilondt';
%%
dr1dt = dqe(1:3);
dr2dt = dqe(4:6);
dr12dt = dr2dt - dr1dt;

nx = r12 / norm(r12);
gx = [1;0;0];
phi = get_Rotation_from_2_x_axis(gx,nx);
R = get_R(phi);

Rx = get_R([pi/2;0;0]);

Tphi = (1/norm(r12)*Rx)*R'*[-eye(3),eye(3)];
omega = Tphi*dqe;

dTphidt = Rx*(r12'*dr12dt/(norm(r12)^2)*eye(3) - skew(omega)) ...
	*skew(gx)*Tphi;
%% ���ø�˹���ֲ���
% inertial
J = diag([Iy+Iz,Iz,Iy]);
dJdt = skew([0;Iy*omega(2);Iz*omega(3)]);
M = rho * L * ...
	(1/6*A*[2*eye(3),eye(3);eye(3),2*eye(3)] + ...
	Tphi'*J*Tphi);
D = -rho*L*Tphi'*(J*dTphidt + dJdt*Tphi);
Fine = D * dqe;
% external
V = -1/2 * rho * A * L * [eye(3);eye(3)];
Fext_g = V * g;
% internal
if epsilon > 0
	K = 1 / norm(drdx) * dN' * dN * E * A * epsilon * L;
	Dint = E*A*L * (h/2*Tepsilon*Tepsilon' + h^2/6*Tepsilon*dTepsilondt');
	Mint = E*A*L * h^2/6*Tepsilon*Tepsilon';
	Fint = K * qe + Dint * dqe;
else
	Mint = zeros(6);
	Fint = zeros(6,1);
end
%%
Mass = M + Mint;
Force = Fine + Fint + Fext_g;
end