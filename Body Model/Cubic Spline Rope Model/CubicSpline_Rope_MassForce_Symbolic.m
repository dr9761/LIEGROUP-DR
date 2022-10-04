function [Mass,Force] = CubicSpline_Rope_MassForce_Symbolic(...
	qe,dqe,g,BodyParameter)
%%
L  = BodyParameter.L;
A  = BodyParameter.A;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
E  = BodyParameter.E;
rho = BodyParameter.rho;
%
J = diag([Iy+Iz,Iz,Iy]);
Stiffness = E*A;
%%
q1 = qe(1:numel(qe)/2);
q2 = qe(numel(qe)/2+1:end);

r01        = q1(1:3);
phi1       = q1(4:6);
norm_dr1dx = q1(7);
r02        = q2(1:3);
phi2       = q2(4:6);
norm_dr2dx = q2(7);
%%
dq1 = dqe(1:numel(dqe)/2);
dq2 = dqe(numel(dqe)/2+1:end);

omega1 = dq1(4:6);
omega2 = dq2(4:6);

Tomega1 = [zeros(3),eye(3),zeros(3,1),zeros(3),zeros(3),zeros(3,1)];
Tomega2 = [zeros(3),zeros(3),zeros(3,1),zeros(3),eye(3),zeros(3,1)];
%%
gx = [1;0;0];
gy = [0;1;0];
gz = [0;0;1];
%%
R1 = get_R_Symbolic(phi1);
R2 = get_R_Symbolic(phi2);
nx1 = R1 * gx;
nx2 = R2 * gx;
dr1dx = nx1 * norm_dr1dx;
dr2dx = nx2 * norm_dr2dx;

Angle_1_2 = get_small_Rotation_from_2_R_Cardan(R1'*R2);
phi_1_2 = Angle_1_2(1);

T_12 = get_T_Cardan(Angle_1_2);

Tphi12 = T_12 \ (Tomega2 - R2'*R1*Tomega1);
dAngle_1_2dt = Tphi12 * dqe;

dT_12dt = get_dT_Cardan(Angle_1_2,dAngle_1_2dt);
dTphi12dt = T_12 \ ...
	(skew(omega2)*R2'*R1*Tomega1 - R2'*R1*skew(omega1)*Tomega1 - ...
	dT_12dt * Tphi12);
%%
Mtra = casadi.SX.zeros(numel(qe),numel(qe));
Mrot = casadi.SX.zeros(numel(qe),numel(qe));

Dtra = casadi.SX.zeros(numel(qe),numel(qe));
Drot = casadi.SX.zeros(numel(qe),numel(qe));

Fint = casadi.SX.zeros(numel(qe),1);
Fextg = casadi.SX.zeros(numel(qe),1);
%%
D = ...
	[eye(3),zeros(3),zeros(3,1),zeros(3),zeros(3),zeros(3,1);
	zeros(3),-skew(dr1dx)*R1,nx1,zeros(3),zeros(3),zeros(3,1);
	zeros(3),zeros(3),zeros(3,1),eye(3),zeros(3),zeros(3,1);
	zeros(3),zeros(3),zeros(3,1),zeros(3),-skew(dr2dx)*R2,nx2];
dDdt = ...
	[zeros(3),zeros(3),zeros(3,1),zeros(3),zeros(3),zeros(3,1);
	zeros(3),-norm_dr1dx*R1*skew(omega1)*skew(gx),-2*skew(nx1)*R1*omega1,zeros(3),zeros(3),zeros(3,1);
	zeros(3),zeros(3),zeros(3,1),zeros(3),zeros(3),zeros(3,1);
	zeros(3),zeros(3),zeros(3,1),zeros(3),-norm_dr2dx*R2*skew(omega2)*skew(gx),-2*skew(nx2)*R2*omega2];
%%
gaussn = 5;
x_set = gaussx(0,L,gaussn);
w_set = gaussw(gaussn)*L/2;

for i = 1:gaussn
	x = x_set(i);
	w = w_set(i);
	
	xi = x / L;
	%%
	[N_1_0,N_1_1,N_2_0,N_2_1] = ...
		Hermite_Interpolation_Coefficient_N(x,L);
	[dN_1_0,dN_1_1,dN_2_0,dN_2_1] = ...
		Hermite_Interpolation_Coefficient_dN(x,L);
	
	N = [N_1_0*eye(3),N_1_1*eye(3),N_2_0*eye(3),N_2_1*eye(3)];
	dN = [dN_1_0*eye(3),dN_1_1*eye(3),dN_2_0*eye(3),dN_2_1*eye(3)];
	%%
	drdx = dN * [r01;dr1dx;r02;dr2dx];
	%%
	nx = drdx / norm(drdx);
	
	Tnx = 1/norm(drdx) * (eye(3) - nx*nx') * dN * D;
	dnxdt = Tnx * dqe;

	dTnxdt = -1/norm(drdx) * ((2*dnxdt * nx' + nx * dnxdt') * dN * D - ...
		(eye(3) - nx*nx') * dN * dDdt);
	%%
	phi = xi * phi_1_2;
	psi = -asin(gz' * R1' * nx);
	theta = asin(gy' * R1' * nx / cos(psi));
	
	Angle_1_x = [phi;psi;theta];
	R_1_x = get_R_Cardan(Angle_1_x);
	%%
	epsilon = norm(drdx) - 1;
	epsilon = max(epsilon,0);
	% only axial stress be considered
% 	if epsilon < 0
% 		epsilon = 0;
% 	end
	Tepsilon = 1/norm(drdx)*drdx'*dN*D;
	
	Strain = epsilon;
	Stress = Stiffness * Strain;
	TStrain = Tepsilon;
	
	Fint = Fint + TStrain' * Stress * w;
	
	%% dphidt
	Tphi = xi * gx'* Tphi12;
	Tpsi = -1/sqrt(1-(sin(psi))^2) * ...
		gz' * R1' * (Tnx + skew(nx)*R1*Tomega1);
	Ttheta = 1/(cos(psi)*sqrt(1-(sin(theta))^2)) * ...
		gy' * R1' * (skew(nx)*R1*Tomega1 + Tnx + nx*Tpsi*tan(psi));
	
	T_Angle = [Tphi;Tpsi;Ttheta];
	dAngledt = T_Angle * dqe;
	dpsidt = dAngledt(2);
	
	
	Tomegad = get_T_Cardan(Angle_1_x) * T_Angle;
	omegad = Tomegad * dqe;
	
	Tomega = get_T_Cardan(Angle_1_x) * T_Angle + R_1_x' * Tomega1;
	%%
	dTphidt = xi * gx' * dTphi12dt;
	dTpsidt = -1/sqrt(cos(psi)^2) * gz'*R1' * (dTnxdt + ...
		(2*skew(dnxdt) - R1*skew(omega1)*R1'*skew(nx))*R1*Tomega1 + ...
		(dnxdt + skew(nx)*R1*omega1)*tan(psi)*Tpsi);
	Tdthetadt = 1/(cos(psi)*sqrt(cos(theta)^2)) * gy' * (...
		R1'*dTnxdt + R1'*nx*tan(psi)*dTpsidt - ...
		skew(omega1)*R1'*skew(nx)*R1*Tomega1 - 2*skew(omega1)*R1'*Tnx + ...
		(2*R1'*dnxdt*tan(psi) - 2*skew(omega1)*R1'*nx*tan(psi) + ...
		R1'*nx*(sec(psi)^2)*dpsidt + R1'*nx*(tan(psi)^2)*dpsidt)*Tpsi + ...
		(-skew(omega1)*R1'*nx + R1'*dnxdt + R1'*nx*tan(psi)*dpsidt)*tan(theta)*Ttheta);
	
	dT_Angledt = [dTphidt;dTpsidt;Tdthetadt];
	dTomegadt = get_dT_Cardan(Angle_1_x,dAngledt) * T_Angle + ...
		get_T_Cardan(Angle_1_x) * dT_Angledt - ...
		skew(omegad) * R_1_x' * Tomega1;
	
	%%
	Mtra = Mtra + rho*A*D'*N'*N*D*w;
	Mrot = Mrot + rho*Tomega'*J*Tomega*w;
	
	Dtra = Dtra + rho*A*D'*N'*N*dDdt*w;
	Drot = Drot + rho*Tomega'*J*dTomegadt*w;
	%%
	Fextg = Fextg - rho*A*D'*N'*g*w;
end
Mass = Mtra + Mrot;

Dine = Dtra + Drot;
Fine = Dine * dqe;

Force = Fine + Fextg + Fint;
end