function [r0c,Rc,dqc,Tc,dTcdt] = ...
	get_InternalNode_Coordination_CubicSplineBeam(...
	r0s,Rs,dqs,xi,BodyParameter)
%%
L  = BodyParameter.L;
%%
% q1 = qs(1:numel(qs)/2);
% q2 = qs(numel(qs)/2+1:end);

r01			= r0s(1:3);
R1			= Rs(1:3,:);
norm_dr1dx	= 1;
r02			= r0s(4:6);
R2			= Rs(4:6,:);
norm_dr2dx	= 1;
%%
dq1 = dqs(1:numel(dqs)/2);
dq2 = dqs(numel(dqs)/2+1:end);

omega1 = dq1(4:6);
omega2 = dq2(4:6);

Tomega1 = [zeros(3),eye(3),zeros(3),zeros(3)];
Tomega2 = [zeros(3),zeros(3),zeros(3),eye(3)];
%%
gx = [1;0;0];
gy = [0;1;0];
gz = [0;0;1];
%%
% R1 = get_R(phi1);
% R2 = get_R(phi2);
nx1 = R1 * gx;
nx2 = R2 * gx;
dr1dx = nx1 * norm_dr1dx;
dr2dx = nx2 * norm_dr2dx;

Angle_1_2 = get_small_Rotation_from_2_R_Cardan(R1'*R2);
phi_1_2 = Angle_1_2(1);

T_12 = get_T_Cardan(Angle_1_2);

Tphi12 = T_12 \ (Tomega2 - R2'*R1*Tomega1);
dAngle_1_2dt = Tphi12 * dqs;

dT_12dt = get_dT_Cardan(Angle_1_2,dAngle_1_2dt);
dTphi12dt = T_12 \ ...
	(skew(omega2)*R2'*R1*Tomega1 - R2'*R1*skew(omega1)*Tomega1 - ...
	dT_12dt * Tphi12);
%%
D = ...
	[eye(3),zeros(3),zeros(3,1),zeros(3),zeros(3),zeros(3,1);
	zeros(3),-skew(dr1dx)*R1,nx1,zeros(3),zeros(3),zeros(3,1);
	zeros(3),zeros(3),zeros(3,1),eye(3),zeros(3),zeros(3,1);
	zeros(3),zeros(3),zeros(3,1),zeros(3),-skew(dr2dx)*R2,nx2];
D(:,[7,14]) = [];
dDdt = ...
	[zeros(3),zeros(3),zeros(3,1),zeros(3),zeros(3),zeros(3,1);
	zeros(3),-norm_dr1dx*R1*skew(omega1)*skew(gx),-2*skew(nx1)*R1*omega1,zeros(3),zeros(3),zeros(3,1);
	zeros(3),zeros(3),zeros(3,1),zeros(3),zeros(3),zeros(3,1);
	zeros(3),zeros(3),zeros(3,1),zeros(3),-norm_dr2dx*R2*skew(omega2)*skew(gx),-2*skew(nx2)*R2*omega2];
dDdt(:,[7,14]) = [];
%%
[N_1_0,N_1_1,N_2_0,N_2_1] = ...
	Hermite_Interpolation_Coefficient_N(xi*L,L);
[dN_1_0,dN_1_1,dN_2_0,dN_2_1] = ...
	Hermite_Interpolation_Coefficient_dN(xi*L,L);

N = [N_1_0*eye(3),N_1_1*eye(3),N_2_0*eye(3),N_2_1*eye(3)];
dN = [dN_1_0*eye(3),dN_1_1*eye(3),dN_2_0*eye(3),dN_2_1*eye(3)];
%%
r = N * [r01;dr1dx;r02;dr2dx];
drdx = dN * [r01;dr1dx;r02;dr2dx];

Tr = N * D;
dTrdt = N * dDdt;

drdt = Tr * dqs;
%%
nx = drdx / norm(drdx);

Tnx = 1/norm(drdx) * (eye(3) - nx*nx') * dN * D;
dnxdt = Tnx * dqs;

dTnxdt = -1/norm(drdx) * ((2*dnxdt * nx' + nx * dnxdt') * dN * D - ...
	(eye(3) - nx*nx') * dN * dDdt);
%%
phi = xi * phi_1_2;
psi = -asin(gz' * R1' * nx);
theta = asin(gy' * R1' * nx / cos(psi));

Angle_1_x = [phi;psi;theta];
R_1_x = get_R_Cardan(Angle_1_x);
Rx = R1 * R_1_x;
% Angle = get_Rotation_from_R(Rx,phi1);
%% dphidt
Tphi = xi * gx'* Tphi12;
Tpsi = -1/sqrt(1-(sin(psi))^2) * ...
	gz' * R1' * (Tnx + skew(nx)*R1*Tomega1);
Ttheta = 1/(cos(psi)*sqrt(1-(sin(theta))^2)) * ...
	gy' * R1' * (skew(nx)*R1*Tomega1 + Tnx + nx*Tpsi*tan(psi));

T_Angle = [Tphi;Tpsi;Ttheta];
dAngledt = T_Angle * dqs;
dpsidt = dAngledt(2);


Tomegad = get_T_Cardan(Angle_1_x) * T_Angle;
omegad = Tomegad * dqs;

Tomega = get_T_Cardan(Angle_1_x) * T_Angle + R_1_x' * Tomega1;
omega = Tomega * dqs;

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
% qc = [r;Angle];
r0c = r;
Rc = Rx;
dqc = [drdt;omega];
Tc = [Tr;Tomega];
dTcdt = [dTrdt;dTomegadt];
end