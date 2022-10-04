function [qb,dqb,Tb,dTb] = get_SingleJib_Pendulum_ElementCoordinate(...
	q,dq,ModelParameter)
%%
Joint_Parameter = ModelParameter.Joint_Parameter;
%%
gy = [0;1;0];
gz = [0;0;1];
%%
phi_s = q(1);
phi_y = q(2);
phi_z = q(3);

% dphi_sdt = dq(1);
% dphi_ydt = dq(2);
dphi_zdt = dq(3);
%% Body 1
r1 = [0;0;0];
phi1 = [0;0;phi_s];
R1 = get_R(phi1);
q1 = [r1;phi1];
%
Tr1 = zeros(3);
Tphi1 = zeros(3);Tphi1(3,1) = 1;
T1 = [Tr1;Tphi1];
%
dr1dt = Tr1 * dq;
omega1 = Tphi1 * dq;
dq1 = [dr1dt;omega1];
%
dTr1 = zeros(3);
dTphi1 = zeros(3);
dT1 = [dTr1;dTphi1];
%% Body 2
r2 = r1 + R1*Joint_Parameter{1}.Joint{2}.r;
Ry = get_R([0;phi_y;0]);
Rz = get_R([0;0;phi_z]);
R2 = R1*get_R([0;pi/2;0])*Ry*Rz;
phi2 = get_Rotation_from_R(R2,[0;0;0]);
q2 = [r2;phi2];
%
Tr2 = Tr1 - R1*skew(Joint_Parameter{1}.Joint{2}.r)*Tphi1;
Tphiy = zeros(3);Tphiy(2,2) = 1;
Tphiz = zeros(3);Tphiz(3,3) = 1;
Tphi2 = R2'*R1*Tphi1 + Rz'*Tphiy + Tphiz;
T2 = [Tr2;Tphi2];
%
dr2dt = Tr2 * dq;
omega2 = Tphi2 * dq;
dq2 = [dr2dt;omega2];
%
dTr2 = dTr1 - R1*skew(Joint_Parameter{1}.Joint{2}.r)*dTphi1 - ...
	R1*skew(omega1)*skew(Joint_Parameter{1}.Joint{2}.r)*Tphi1;
dTphi2 = -skew(omega2)*R2'*R1*Tphi1 - dphi_zdt*skew(gz)*Rz'*gy*gy';
dT2 = [dTr2;dTphi2];
%% Body 3
r3 = r2 + R2*Joint_Parameter{2}.Joint{2}.r;
q3 = r3;
%
Tr3 = Tr2 - R2*skew(Joint_Parameter{2}.Joint{2}.r)*Tphi2;
T3 = Tr3;
%
dr3dt = Tr3 * dq;
dq3 = dr3dt;
%
dTr3 = dTr2 - R2*skew(Joint_Parameter{2}.Joint{2}.r)*dTphi2 - ...
	R2*skew(omega2)*skew(Joint_Parameter{2}.Joint{2}.r)*Tphi2;
dT3 = dTr3;
%% qb
qb = cell(3,1);
qb{1} = q1;		qb{2} = q2;		qb{3} = q3;
%% dqb
dqb = cell(3,1);
dqb{1} = dq1;	dqb{2} = dq2;	dqb{3} = dq3;
%% Tb
Tb = cell(3,1);
Tb{1} = T1;		Tb{2} = T2;		Tb{3} = T3;
%% dTb
dTb = cell(3,1);
dTb{1} = dT1;	dTb{2} = dT2;	dTb{3} = dT3;
end