function [r0b,Rb,dqb,Tb,dTb] = get_TripleJib_Pendulum_ElementCoordinate_Symbolic(...
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
phi_2 = q(3);
phi_y = q(4);
phi_z = q(5);
%% Body 1
r1 = [0;0;0];
R1 = get_R_Symbolic([0;-pi/2;0])*get_R_Symbolic([phi_s;0;0]);
%
Tr1 = zeros(3,5);
Tphi1 = gx*[1;0;0;0;0]';
T1 = [Tr1;Tphi1];
%
dr1dt = Tr1 * dq;
omega1 = Tphi1 * dq;
dq1 = [dr1dt;omega1];
%
dTr1 = zeros(3,5);
dTphi1 = zeros(3,5);
dT1 = [dTr1;dTphi1];
%% Body 2
r2 = r1 + R1*Joint_Parameter{1}.Joint{2}.r;
R2 = R1*get_R_Symbolic([0;pi/2;0])*get_R_Symbolic([0;-phi_1;0]);
%
Tr2 = Tr1 - R1*skew(Joint_Parameter{1}.Joint{2}.r)*Tphi1;
Tphi2 = R2'*R1*Tphi1 + gy*[0;-1;0;0;0]';
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
R3 = R2*get_R_Symbolic([0;phi_2;0]);
%
Tr3 = Tr2 - R2*skew(Joint_Parameter{2}.Joint{2}.r)*Tphi2;
Tphi3 = R3'*R2*Tphi2 + gy*[0;0;1;0;0]';
T3 = [Tr3;Tphi3];
%
dr3dt = Tr3 * dq;
omega3 = Tphi3 * dq;
dq3 = [dr3dt;omega3];
%
dTr3 = dTr2 - R2*skew(Joint_Parameter{2}.Joint{2}.r)*dTphi2 - ...
	R2*skew(omega2)*skew(Joint_Parameter{2}.Joint{2}.r)*Tphi2;
dTphi3 = -skew(omega3)*R3'*R2*Tphi2 + R3'*R2*dTphi2;
dT3 = [dTr3;dTphi3];
%% Body 4
r4 = r3 + R3*Joint_Parameter{3}.Joint{2}.r;
R4 = R1*get_R_Symbolic([0;pi;0])*get_R_Symbolic([0;phi_y;0])*get_R_Symbolic([0;0;phi_z]);
%
Tr4 = Tr3 - R3*skew(Joint_Parameter{3}.Joint{2}.r)*Tphi3;
Tphi4 = R4'*R1*Tphi1 + R4'*R1*gy*[0;0;0;1;0]' + gz*[0;0;0;0;1]';
T4 = [Tr4;Tphi4];
%
dr4dt = Tr4 * dq;
omega4 = Tphi4 * dq;
dq4 = [dr4dt;omega4];
%
dTr4 = dTr3 - R3*skew(Joint_Parameter{3}.Joint{2}.r)*dTphi3 - ...
	R3*skew(omega3)*skew(Joint_Parameter{3}.Joint{2}.r)*Tphi3;
dTphi4 = -skew(omega4)*R4'*R1*(Tphi1+gy*[0;0;0;1;0]') + ...
	R4'*R1*(dTphi1+skew(omega1)*gy*[0;0;0;1;0]');
dT4 = [dTr4;dTphi4];
%% Body 5
r5 = r4 + R4*Joint_Parameter{4}.Joint{2}.r;
%
Tr5 = Tr4 - R4*skew(Joint_Parameter{4}.Joint{2}.r)*Tphi4;
T5 = Tr5;
%
dr5dt = Tr5 * dq;
dq5 = dr5dt;
%
dTr5 = dTr4 - R4*skew(Joint_Parameter{4}.Joint{2}.r)*dTphi4 - ...
	R4*skew(omega4)*skew(Joint_Parameter{4}.Joint{2}.r)*Tphi4;
dT5 = dTr5;
%% qb
r0b = cell(BodyQuantity,1);
r0b{1} = r1;	r0b{2} = r2;	r0b{3} = r3;
r0b{4} = r4;	r0b{5} = r5;
%% Rb
Rb = cell(BodyQuantity,1);
Rb{1} = R1;		Rb{2} = R2;		Rb{3} = R3;
Rb{4} = R4;		Rb{5} = zeros(3);
%% dqb
dqb = cell(BodyQuantity,1);
dqb{1} = dq1;	dqb{2} = dq2;	dqb{3} = dq3;
dqb{4} = dq4;	dqb{5} = dq5;
%% Tb
Tb = cell(BodyQuantity,1);
Tb{1} = T1;		Tb{2} = T2;		Tb{3} = T3;
Tb{4} = T4;		Tb{5} = T5;
%% dTb
dTb = cell(BodyQuantity,1);
dTb{1} = dT1;	dTb{2} = dT2;	dTb{3} = dT3;
dTb{4} = dT4;	dTb{5} = dT5;
end