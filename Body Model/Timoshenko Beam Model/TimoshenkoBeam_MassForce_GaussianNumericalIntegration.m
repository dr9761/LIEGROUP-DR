function [Mass,Force,Fine,Fint,Fext] = ...
	TimoshenkoBeam_MassForce_GaussianNumericalIntegration(...
	qe,dqe,g,BodyParameter)
%% 杆件的材料参数
rho = BodyParameter.rho;
%% 杆件的形状参数
L  = BodyParameter.L;
A  = BodyParameter.A;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
J = diag([Iy+Iz,Iz,Iy]);
%%
[qB,dqB,TB,dTBdt,r_rigid_1,r_rigid_2] = ...
	get_Corotational_Coordination_TimoshenkoBeam(qe,dqe,L);
%
phiB = qB(4:6);
RB = get_R(phiB);
%
omegaB = dqB(4:6);
%%
r_rigid_1 = [0;0;0];
r_rigid_2 = [L;0;0];
[qd_end,dqd_end,Td_end,dTd_enddt] = ...
	get_Deformation_Coordination_at_Endpoint(...
	qe,dqe,qB,dqB,TB,dTBdt,r_rigid_1,r_rigid_2);
%
dqd_enddt = dqd_end;
%%
T_dqe_dqBdqdend = [TB;Td_end];
dT_dqe_dqBdqdenddt = [dTBdt;dTd_enddt];
%%
[H1,H2,~,~] = determine_H(BodyParameter);
%%
gx = [1;0;0];
gy = [0;1;0];
gz = [0;0;1];
%% 初始化相关矩阵
% 惯性力
Me = zeros(12);
MBend = zeros(18);
DBend = zeros(18);
Fine = zeros(12,1);
% 重力
VBend = zeros(18,3);
Ge = zeros(12,1);
%% 设置高斯积分参数
gaussn = 5;
x_set = gaussx(0,L,gaussn);
w_set = gaussw(gaussn)*L/2;
for i = 1:gaussn
	x = x_set(i);
	w = w_set(i);
	%% 型函数
	N_c = Shapefunction_N(BodyParameter,x/L);
	
	qdc = N_c * qd_end;
	kuc = qdc(1:3);
	psic = qdc(4:6);
	Rdc = get_R(psic);
	Rc = RB * Rdc;
	
	dqdcdt = N_c*dqd_enddt;
	dqdc = dqdcdt;
	dpsic_dt = dqdcdt(4:6);
	omegadc = get_T(psic) * dpsic_dt;
	%% 惯性力虚功率
	
	r_rigid = [x;0;0];
	krc = r_rigid + kuc;
	krc = r_rigid;
	
	Ht  = [eye(3),-RB*skew(krc),RB,zeros(3)];
	Dt  = [zeros(3),-RB*skew(omegaB)*skew(krc),2*RB*skew(omegaB),zeros(3)];
	Hry	= [zeros(3),-Rc*skew(gy)*Rdc',zeros(3),-Rc*skew(gy)];
	Dry = [zeros(3),-RB*skew(omegaB)*Rdc*skew(gy)*Rdc',zeros(3),-(2*RB*skew(omegaB)*Rdc+Rc*skew(omegadc))*skew(gy)];
	Hrz = [zeros(3),-Rc*skew(gz)*Rdc',zeros(3),-Rc*skew(gz)];
	Drz = [zeros(3),-RB*skew(omegaB)*Rdc*skew(gz)*Rdc',zeros(3),-(2*RB*skew(omegaB)*Rdc+Rc*skew(omegadc))*skew(gz)];
	%% 惯性力产生的质量阵和阻尼阵
	MBc = rho*A*Ht'*Ht + rho*Iy*Hry'*Hry + rho*Iz*Hrz'*Hrz;
	DBc = rho*A*Ht'*Dt + rho*Iy*Hry'*Dry + rho*Iz*Hrz'*Drz;
	%%
	T_dqBdqdend_dqBdqdc = [eye(6),zeros(6,12);zeros(6),N_c];
	
	T_dqBdqdc_dqe = T_dqBdqdend_dqBdqdc * T_dqe_dqBdqdend;
	dT_dqBdqdc_dqedt = T_dqBdqdend_dqBdqdc * dT_dqe_dqBdqdenddt;
	%% 惯性力
	DBend = DBend + T_dqBdqdend_dqBdqdc' * DBc * T_dqBdqdend_dqBdqdc * w;
	MBend = MBend + T_dqBdqdend_dqBdqdc' * MBc * T_dqBdqdend_dqBdqdc * w;
	Fine = Fine + ...
		(T_dqe_dqBdqdend'*DBend*T_dqe_dqBdqdend + ...
		T_dqe_dqBdqdend'*MBend*dT_dqe_dqBdqdenddt)*dqe * w;
	Me = Me + T_dqBdqdc_dqe' * MBc * T_dqBdqdc_dqe * w;
	Me = Me + T_dqe_dqBdqdend' * MBend * T_dqe_dqBdqdend * w;
	%% 重力
	VBend = VBend + T_dqBdqdend_dqBdqdc' * Ht' * rho * A * w;
	Ge = Ge + T_dqe_dqBdqdend' * T_dqBdqdend_dqBdqdc' * Ht' * rho * A * g * w;
end
%%
% sN = Intergrated_Shapefunction_sN(BodyParameter);
% sxN = Intergrated_Shapefunction_sxN(BodyParameter);
% sNPN = Intergrated_Shapefunction_sNPN(BodyParameter);
% sNWN = Intergrated_Shapefunction_sNWN(BodyParameter,omegaB);
% sWJW = Intergrated_Shapefunction_sWJW(BodyParameter,dqd_end);
% sNWJW = Intergrated_Shapefunction_sNWJW(BodyParameter,dqd_end);
%%
% MBend = zeros(18);
% MBend(1:6,1:6) = rho * ...
% 	[A*L*eye(3),			-1/2*A*L^2*RB*skew(gx);
% 	1/2*A*L^2*skew(gx)*RB',	-1/3*A*L^3*skew(gx)*skew(gx)+J*L];
% MBend(1:6,7:18) = rho * (...
% 	[A*RB,zeros(3);zeros(3),J] * sN + ...
% 	[zeros(3),zeros(3);A*skew(gx),zeros(3)] * sxN);
% MBend(7:18,1:6) = MBend(1:6,7:18)';
% MBend(7:18,7:18) = rho * sNPN;
%
% Me = T_dqe_dqBdqdend' * MBend * T_dqe_dqBdqdend;
%%
% VBend = zeros(18,3);
% VBend(1:3,:) = rho * A * L * eye(3);
% VBend(4:6,:) = rho * A * 1/2 * L^2 * skew(gx) * RB';
% VBend(7:18,:) = rho * A * sN' * [eye(3);zeros(3)] * RB';

% Ge = T_dqe_dqBdqdend' * VBend * g;
%%
% Fine = T_dqe_dqBdqdend' * (DBend * T_dqe_dqBdqdend + ...
% 	MBend * dT_dqe_dqBdqdenddt)*dqe;
%%
% J0 = diag([0,Iy,Iz]);
% 
% Fine_B_end = zeros(18,1);
% Fine_B_end(1:3) = -1/2*L^2*A*RB*skew(omegaB)*skew(gx)*omegaB + ...
% 	2*[A*RB*skew(omegaB),zeros(3)]*sN*dqd_end;
% Fine_B_end(4:6) = skew(omegaB)*L*diag([1/3*A*L^2,Iy,Iz])*omegaB + ...
% 	2*[A*skew(gx)*skew(omegaB),zeros(3)]*sxN*dqd_end + ...
% 	2*[zeros(3),skew(J0*omegaB)]*sN*dqd_end + ...;
% 	sWJW;
% Fine_B_end(7:18) = -sxN'*[eye(3);zeros(3)]*A*skew(omegaB)*skew(gx)*omegaB + ...
% 	sN'*[zeros(3);eye(3)]*skew(omegaB)*J0*omegaB + ...
% 	2*sNWN*dqd_end + ...
% 	sNWJW;
% Fine_B_end = rho * Fine_B_end;
% Fine = T_dqe_dqBdqdend' * (Fine_B_end + ...
% 	MBend * dT_dqe_dqBdqdenddt*dqe);
%% 内力产生的刚度阵以及非线性内力
N_L  = Shapefunction_N (BodyParameter,1);
dN_L = Shapefunction_dN(BodyParameter,1);

N_0  = Shapefunction_N (BodyParameter,0);
dN_0 = Shapefunction_dN(BodyParameter,0);

K_qdend = N_L'*(H1*dN_L+H2*N_L) - N_0'*(H1*dN_0+H2*N_0);
%
Fint = Td_end' * K_qdend * qd_end;
%%
Mass = Me;
% Mass = Mass * L / 2;
%
Fext = -Ge;
% Fext = Fext * L / 2;
% Fine = Fine * L / 2;
%
Force = Fine + Fint + Fext;
% Force = Fint + Fext;
end
