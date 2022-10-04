function [Mass,Force,Fine,Fint,Fext] = ...
	TimoshenkoBeam_MassForce_Symbolic(...
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
r01 = qe(1:3);
phi1 = qe(4:6);
r02 = qe(7:9);
phi2 = qe(10:12);

r0e = [r01;r02];
Re = [get_R_Symbolic(phi1);get_R_Symbolic(phi2)];
%%
[r0B,RB,dqB,TB,dTBdt,r_rigid_1,r_rigid_2] = ...
	get_Corotational_Coordination_TimoshenkoBeam_Symbolic(r0e,Re,dqe,L);
%
omegaB = dqB(4:6);
%%
[qd_end,dqd_end,Td_end,dTd_enddt] = ...
	get_Deformation_Coordination_at_Endpoint_Symbolic(...
	r0e,Re,dqe,r0B,RB,dqB,TB,dTBdt,r_rigid_1,r_rigid_2);
%
% dqd_enddt = dqd_end;
%%
T_dqe_dqBdqdend = [TB;Td_end];
dT_dqe_dqBdqdenddt = [dTBdt;dTd_enddt];
%%
[H1,H2,~,~] = determine_H(BodyParameter);
%%
gx = [1;0;0];
%%
sN = Intergrated_Shapefunction_sN(BodyParameter);
sxN = Intergrated_Shapefunction_sxN(BodyParameter);
sNPN = Intergrated_Shapefunction_sNPN(BodyParameter);
sNWN = Intergrated_Shapefunction_sNWN_Symbolic(BodyParameter,omegaB);
sWJW = Intergrated_Shapefunction_sWJW_Symbolic(BodyParameter,dqd_end);
sNWJW = Intergrated_Shapefunction_sNWJW_Symbolic(BodyParameter,dqd_end);
%%
MBend = casadi.SX.zeros(18,18);
MBend(1:6,1:6) = rho * ...
	[A*L*eye(3),			-1/2*A*L^2*RB*skew(gx);
	1/2*A*L^2*skew(gx)*RB',	-1/3*A*L^3*skew(gx)*skew(gx)+J*L];
MBend(1:6,7:18) = rho * (...
	[A*RB,zeros(3);zeros(3),J] * sN + ...
	[zeros(3),zeros(3);A*skew(gx),zeros(3)] * sxN);
MBend(7:18,1:6) = MBend(1:6,7:18)';
MBend(7:18,7:18) = rho * sNPN;

Me = T_dqe_dqBdqdend' * MBend * T_dqe_dqBdqdend;
%%
VBend = casadi.SX.zeros(18,3);
VBend(1:3,:) = rho * A * L * eye(3);
VBend(4:6,:) = rho * A * 1/2 * L^2 * skew(gx) * RB';
VBend(7:18,:) = rho * A * sN' * [eye(3);zeros(3)] * RB';

Ge = T_dqe_dqBdqdend' * VBend * g;
%%
% Fine = T_dqe_dqBdqdend' * (DBend * T_dqe_dqBdqdend + ...
% 	MBend * dT_dqe_dqBdqdenddt)*dqe;
%%
J0 = diag([0,Iy,Iz]);

Fine_B_end = casadi.SX.zeros(18,1);
Fine_B_end(1:3) = -1/2*L^2*A*RB*skew(omegaB)*skew(gx)*omegaB + ...
	2*[A*RB*skew(omegaB),zeros(3)]*sN*dqd_end;
Fine_B_end(4:6) = skew(omegaB)*L*diag([1/3*A*L^2,Iy,Iz])*omegaB + ...
	2*[A*skew(gx)*skew(omegaB),zeros(3)]*sxN*dqd_end + ...
	2*[zeros(3),skew(J0*omegaB)]*sN*dqd_end + ...;
	sWJW;
Fine_B_end(7:18) = -sxN'*[eye(3);zeros(3)]*A*skew(omegaB)*skew(gx)*omegaB + ...
	sN'*[zeros(3);eye(3)]*skew(omegaB)*J0*omegaB + ...
	2*sNWN*dqd_end + ...
	sNWJW;
Fine_B_end = rho * Fine_B_end;
Fine = T_dqe_dqBdqdend' * (Fine_B_end + ...
	MBend * dT_dqe_dqBdqdenddt*dqe);
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
