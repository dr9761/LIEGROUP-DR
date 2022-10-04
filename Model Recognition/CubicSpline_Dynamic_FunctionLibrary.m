function [ddqe_Function_Library] = ...
	CubicSpline_Dynamic_FunctionLibrary(...
	qe,dqe,g,BodyParameter,gaussn)
%%
L  = BodyParameter.L;
rho = BodyParameter.rho;
%%
I3_1_1 = zeros(3);I3_1_1(1,1) = rho;
I3_1_2 = zeros(3);I3_1_2(1,2) = rho;
I3_1_3 = zeros(3);I3_1_3(1,3) = rho;

I3_2_1 = zeros(3);I3_2_1(2,1) = rho;
I3_2_2 = zeros(3);I3_2_2(2,2) = rho;
I3_2_3 = zeros(3);I3_2_3(2,3) = rho;

I3_3_1 = zeros(3);I3_3_1(3,1) = rho;
I3_3_2 = zeros(3);I3_3_2(3,2) = rho;
I3_3_3 = zeros(3);I3_3_3(3,3) = rho;
%%
I4_1_1 = zeros(4);I4_1_1(1,1) = rho;
I4_1_2 = zeros(4);I4_1_2(1,2) = rho;
I4_1_3 = zeros(4);I4_1_3(1,3) = rho;
I4_1_4 = zeros(4);I4_1_4(1,4) = rho;

I4_2_1 = zeros(4);I4_2_1(2,1) = rho;
I4_2_2 = zeros(4);I4_2_2(2,2) = rho;
I4_2_3 = zeros(4);I4_2_3(2,3) = rho;
I4_2_4 = zeros(4);I4_2_4(2,4) = rho;

I4_3_1 = zeros(4);I4_3_1(3,1) = rho;
I4_3_2 = zeros(4);I4_3_2(3,2) = rho;
I4_3_3 = zeros(4);I4_3_3(3,3) = rho;
I4_3_4 = zeros(4);I4_3_4(3,4) = rho;

I4_4_1 = zeros(4);I4_4_1(4,1) = rho;
I4_4_2 = zeros(4);I4_4_2(4,2) = rho;
I4_4_3 = zeros(4);I4_4_3(4,3) = rho;
I4_4_4 = zeros(4);I4_4_4(4,4) = rho;
%%
q1 = qe(1:numel(qe)/2);
q2 = qe(numel(qe)/2+1:end);

r01        = q1(1:3);
phi1       = q1(4:6);
norm_dr1dx = 1;
r02        = q2(1:3);
phi2       = q2(4:6);
norm_dr2dx = 1;
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
R1 = get_R(phi1);
R2 = get_R(phi2);
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
% gaussn = 11;
x_set = gaussx(0,L,gaussn);
w_set = gaussw(gaussn)*L/2;
%%
ddqe_Function_Library = zeros(12,12*18*gaussn);
Force_Function_Library = zeros(12,1*52*gaussn);
%%
for i = 1:gaussn
	x = x_set(i);
	w = w_set(i);
	
	xi = x / L;
	%%
	[N_1_0,N_1_1,N_2_0,N_2_1] = ...
		Hermite_Interpolation_Coefficient_N(x,L);
	[dN_1_0,dN_1_1,dN_2_0,dN_2_1] = ...
		Hermite_Interpolation_Coefficient_dN(x,L);
	[ddN_1_0,ddN_1_1,ddN_2_0,ddN_2_1] = ...
		Hermite_Interpolation_Coefficient_ddN(x,L);
	
	N = [N_1_0*eye(3),N_1_1*eye(3),N_2_0*eye(3),N_2_1*eye(3)];
	dN = [dN_1_0*eye(3),dN_1_1*eye(3),dN_2_0*eye(3),dN_2_1*eye(3)];
	ddN = [ddN_1_0*eye(3),ddN_1_1*eye(3),ddN_2_0*eye(3),ddN_2_1*eye(3)];
	%%
	drdx = dN * [r01;dr1dx;r02;dr2dx];
	ddrxdxdx = ddN * [r01;dr1dx;r02;dr2dx];
	%%
	nx = drdx / norm(drdx);
	dnxdx = 1/norm(drdx) * (eye(3) - nx*nx') * ddrxdxdx;
	
	Tnx = 1/norm(drdx) * (eye(3) - nx*nx') * dN * D;
	dnxdt = Tnx * dqe;
	
	dTnxdx = -1/norm(drdx) * (dnxdx * nx' * dN * D + ...
		(nx'*ddrxdxdx*eye(3) + nx*ddrxdxdx') * Tnx - ...
		(eye(3) - nx*nx') * ddN * D);
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
	Tepsilon = 1/norm(drdx)*drdx'*dN*D;
	%% kappa
	dphi = phi_1_2  / L;
	dpsi = - 1/sqrt(1-(sin(psi))^2) * gz' * R1' * dnxdx;
	dtheta = 1/(cos(psi) * sqrt(1-(sin(theta))^2)) * ...
		gy' * R1' * (dnxdx + nx * tan(psi)*dpsi);
	
	dAngle_1_x = [dphi;dpsi;dtheta];
	B_kappa = get_T_Cardan(Angle_1_x) * dAngle_1_x;	
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
	%% dkappadt
	dTphidx = 1/L * gx' * Tphi12;
	dTpsidx = -gz' * R1' * (...
		sin(psi)*cos(psi)*dpsi/((1-(sin(psi))^2)^(3/2))*Tnx + ...
		1/sqrt(1-(sin(psi))^2)*dTnxdx);
	dTthetadx = 1/(cos(psi)*sqrt(cos(theta)^2)) * gy' * R1' * ...
		(skew(dnxdx)*R1*Tomega1 + dTnxdx + ...
		(dnxdx*tan(psi) + nx*(sec(psi)^2)*dpsi)*Tpsi + nx*tan(psi)*dTpsidx + ...
		(tan(psi)*dpsi + tan(theta)*dtheta) * ...
		(skew(nx)*R1*Tomega1 + Tnx + nx*tan(psi)*Tpsi));
	
	dT_Angledx = [dTphidx;dTpsidx;dTthetadx];
	
	Tkappa = get_T_Cardan(Angle_1_x) * dT_Angledx + ...
		get_dT_Cardan_Conjugation(Angle_1_x,dAngle_1_x) * T_Angle - ...
		skew(B_kappa) * Tomega;
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
	Strain = [epsilon;B_kappa];
	TStrain = [Tepsilon;Tkappa];
	%%
	ddqe_Function_Library(:,12*18*(i-1)+[1:12*9]) = [...
		D'*N'*I3_1_1*N*D*w,		D'*N'*I3_1_2*N*D*w,		D'*N'*I3_1_3*N*D*w, ...
		D'*N'*I3_2_1*N*D*w,		D'*N'*I3_2_2*N*D*w,		D'*N'*I3_2_3*N*D*w, ...
		D'*N'*I3_3_1*N*D*w,		D'*N'*I3_3_2*N*D*w,		D'*N'*I3_3_3*N*D*w];
	ddqe_Function_Library(:,12*18*(i-1)+[12*9+1:12*18]) = [...
		Tomega'*I3_1_1*Tomega*w,	Tomega'*I3_1_2*Tomega*w,	Tomega'*I3_1_3*Tomega*w, ...
		Tomega'*I3_2_1*Tomega*w,	Tomega'*I3_2_2*Tomega*w,	Tomega'*I3_2_3*Tomega*w, ...
		Tomega'*I3_3_1*Tomega*w,	Tomega'*I3_3_2*Tomega*w,	Tomega'*I3_3_3*Tomega*w];
	
	%
	Force_Function_Library(:,1*52*(i-1)+[1:16]) = [...
		TStrain'*I4_1_1*Strain*w,	TStrain'*I4_1_2*Strain*w,	TStrain'*I4_1_3*Strain*w,	TStrain'*I4_1_4*Strain*w, ...
		TStrain'*I4_2_1*Strain*w,	TStrain'*I4_2_2*Strain*w,	TStrain'*I4_2_3*Strain*w,	TStrain'*I4_2_4*Strain*w, ...
		TStrain'*I4_3_1*Strain*w,	TStrain'*I4_3_2*Strain*w,	TStrain'*I4_3_3*Strain*w,	TStrain'*I4_3_4*Strain*w, ...
		TStrain'*I4_4_1*Strain*w,	TStrain'*I4_4_2*Strain*w,	TStrain'*I4_4_3*Strain*w,	TStrain'*I4_4_4*Strain*w];
	
	Force_Function_Library(:,1*52*(i-1)+[17:25]) = [...
		D'*N'*I3_1_1*N*dDdt*dqe*w,	D'*N'*I3_1_2*N*dDdt*dqe*w,	D'*N'*I3_1_3*N*dDdt*dqe*w, ...
		D'*N'*I3_2_1*N*dDdt*dqe*w,	D'*N'*I3_2_2*N*dDdt*dqe*w,	D'*N'*I3_2_3*N*dDdt*dqe*w, ...
		D'*N'*I3_3_1*N*dDdt*dqe*w,	D'*N'*I3_3_2*N*dDdt*dqe*w,	D'*N'*I3_3_3*N*dDdt*dqe*w];
	Force_Function_Library(:,1*52*(i-1)+[26:34]) = [...
		Tomega'*I3_1_1*dTomegadt*dqe*w,	Tomega'*I3_1_2*dTomegadt*dqe*w,	Tomega'*I3_1_3*dTomegadt*dqe*w, ...
		Tomega'*I3_2_1*dTomegadt*dqe*w,	Tomega'*I3_2_2*dTomegadt*dqe*w,	Tomega'*I3_2_3*dTomegadt*dqe*w, ...
		Tomega'*I3_3_1*dTomegadt*dqe*w,	Tomega'*I3_3_2*dTomegadt*dqe*w,	Tomega'*I3_3_3*dTomegadt*dqe*w];
	Force_Function_Library(:,1*52*(i-1)+[35:43]) = [...
		Tomega'*skew(omegad)*I3_1_1*Tomega*dqe*w,	Tomega'*skew(omegad)*I3_1_2*Tomega*dqe*w,	Tomega'*skew(omegad)*I3_1_3*Tomega*dqe*w, ...
		Tomega'*skew(omegad)*I3_2_1*Tomega*dqe*w,	Tomega'*skew(omegad)*I3_2_2*Tomega*dqe*w,	Tomega'*skew(omegad)*I3_2_3*Tomega*dqe*w, ...
		Tomega'*skew(omegad)*I3_3_1*Tomega*dqe*w,	Tomega'*skew(omegad)*I3_3_2*Tomega*dqe*w,	Tomega'*skew(omegad)*I3_3_3*Tomega*dqe*w];
	
	Force_Function_Library(:,1*52*(i-1)+[44:52]) = [...
		-D'*N'*I3_1_1*g*w,	-D'*N'*I3_1_2*g*w,	-D'*N'*I3_1_3*g*w, ...
		-D'*N'*I3_2_1*g*w,	-D'*N'*I3_2_2*g*w,	-D'*N'*I3_2_3*g*w, ...
		-D'*N'*I3_3_1*g*w,	-D'*N'*I3_3_2*g*w,	-D'*N'*I3_3_3*g*w];
end

end