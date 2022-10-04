function [qb,dqb,Tb,dTb] = get_DoubleJib_Pendulum_ElementCoordinate(...
	q,dq,ModelParameter)
%%
Joint_Parameter = ModelParameter.Joint_Parameter;
BodyQuantity = numel(ModelParameter.BodyElementParameter);
%%
gx = [1;0;0];
gy = [0;1;0];
gz = [0;0;1];
%%
phi_s = q(1);
phi_1 = q(2);
phi_y = q(3);
phi_z = q(4);

% dphi_sdt = dq(1);
% dphi_ydt = dq(2);
% dphi_zdt = dq(3);
%% Body 1
r1 = [0;0;0];
R1 = get_R([0;-pi/2;0])*get_R([phi_s;0;0]);
phi1 = get_Rotation_from_R(R1,[0;0;0]);
q1 = [r1;phi1];
%
Tr1 = zeros(3,4);
Tphi1 = gx*[1;0;0;0]';
T1 = [Tr1;Tphi1];
%
dr1dt = Tr1 * dq;
omega1 = Tphi1 * dq;
dq1 = [dr1dt;omega1];
%
dTr1 = zeros(3,4);
dTphi1 = zeros(3,4);
dT1 = [dTr1;dTphi1];
%% Body 2
r2 = r1 + R1*Joint_Parameter{1}.Joint{2}.r;
R2 = R1*get_R([0;pi/2;0])*get_R([0;-phi_1;0]);
phi2 = get_Rotation_from_R(R2,[0;0;0]);
q2 = [r2;phi2];
%
Tr2 = Tr1 - R1*skew(Joint_Parameter{1}.Joint{2}.r)*Tphi1;
Tphi2 = R2'*R1*Tphi1 + gy*[0;-1;0;0]';
T2 = [Tr2;Tphi2];
%
dr2dt = Tr2 * dq;
omega2 = Tphi2 * dq;
dq2 = [dr2dt;omega2];
%
dTr2 = dTr1 - R1*skew(Joint_Parameter{1}.Joint{2}.r)*dTphi1 - ...
	R1*skew(omega1)*skew(Joint_Parameter{1}.Joint{2}.r)*Tphi1;
dTphi2 = -skew(omega2)*R2'*R1*Tphi1 + R2'*R1*dTphi1;
dT2 = [dTr2;dTphi2];
%% Body 3
r3 = r2 + R2*Joint_Parameter{2}.Joint{2}.r;
% R3 = R2*get_R([0;pi/2;0])*get_R([0;phi_1;0])* ...
% 	get_R([0;phi_y;0])*get_R([0;0;phi_z]);
R3 = R1*get_R([0;pi;0])*get_R([0;phi_y;0])*get_R([0;0;phi_z]);
phi3 = get_Rotation_from_R(R3,[0;0;0]);
q3 = [r3;phi3];
%
Tr3 = Tr2 - R2*skew(Joint_Parameter{2}.Joint{2}.r)*Tphi2;
% Tphi3 = R3'*R2*Tphi2 + R3'*R2*gy*[0;1;0;0]' + R3'*R2*gy*[0;0;1;0]' + ...
% 	gz * [0;0;0;1]';
Tphi3 = R3'*R1*Tphi1 + R3'*R1*gy*[0;0;1;0]' + gz*[0;0;0;1]';
T3 = [Tr3;Tphi3];
%
dr3dt = Tr3 * dq;
omega3 = Tphi3 * dq;
dq3 = [dr3dt;omega3];
%
dTr3 = dTr2 - R2*skew(Joint_Parameter{2}.Joint{2}.r)*dTphi2 - ...
	R2*skew(omega2)*skew(Joint_Parameter{2}.Joint{2}.r)*Tphi2;
dTphi3 = -skew(omega3)*R3'*R1*(Tphi1+gy*[0;0;1;0]') + ...
	R3'*R1*(dTphi1+skew(omega1)*gy*[0;0;1;0]');
dT3 = [dTr3;dTphi3];
%% Body 4
r4 = r3 + R3*Joint_Parameter{3}.Joint{2}.r;
q4 = r4;
%
Tr4 = Tr3 - R3*skew(Joint_Parameter{3}.Joint{2}.r)*Tphi3;
T4 = Tr4;
%
dr4dt = Tr4 * dq;
dq4 = dr4dt;
%
dTr4 = dTr3 - R3*skew(Joint_Parameter{3}.Joint{2}.r)*dTphi3 - ...
	R3*skew(omega3)*skew(Joint_Parameter{3}.Joint{2}.r)*Tphi3;
dT4 = dTr4;
%% qb
qb = cell(BodyQuantity,1);
qb{1} = q1;		qb{2} = q2;		qb{3} = q3;		qb{4} = q4;
%% dqb
dqb = cell(BodyQuantity,1);
dqb{1} = dq1;	dqb{2} = dq2;	dqb{3} = dq3;	dqb{4} = dq4;
%% Tb
Tb = cell(BodyQuantity,1);
Tb{1} = T1;		Tb{2} = T2;		Tb{3} = T3;		Tb{4} = T4;
%% dTb
dTb = cell(BodyQuantity,1);
dTb{1} = dT1;	dTb{2} = dT2;	dTb{3} = dT3;	dTb{4} = dT4;
end