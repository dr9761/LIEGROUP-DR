function [r0n,Rn,dqn,ddqn,Tn,dTn] = ShipCrane_ForwardKinematics(...
	q,dq,ddq,ModelParameter)
%%
BodyElementParameter = ModelParameter.BodyElementParameter;
%%
gx = [1;0;0];
gy = [0;1;0];
gz = [0;0;1];
%%
r0 = q(1:3);
phi0 = q(4:6);
phi = q(7);
psi = q(8);
theta = q(9);

dr0dt = dq(1:3);
omega0 = dq(4:6);
dphidt = dq(7);
dpsidt = dq(8);
dthetadt = dq(9);

ddr0dtdt = dq(1:3);
domega0dt = dq(4:6);
ddphidtdt = dq(7);
ddpsidtdt = dq(8);
ddthetadtdt = dq(9);

Tr0 = [eye(3),zeros(3),zeros(3)];
Tphi0 = [zeros(3),eye(3),zeros(3)];
Tphi = [zeros(1,6),1,0,0]';
Tpsi = [zeros(1,6),0,1,0]';
Ttheta = [zeros(1,6),0,0,1]';

dTr0 = zeros(3,9);
dTphi0 = zeros(3,9);
dTphi = zeros(9,1);
dTpsi = zeros(9,1);
dTtheta = zeros(9,1);
%% Node 0
R0 = get_R_Cardan(phi0);
%% Node 1
L1 = BodyElementParameter{1}.L;
R1 = R0 * get_R_y(-pi/2) * get_R_x(phi);
r01 = r0 + R1*gx*L1;
%
Tphi1 = R1'*R0*Tphi0 + gx * Tphi';
Tr1 = Tr0 - L1*R1*skew(gx)*Tphi1;
T1 = [Tr1;Tphi1];
%
dr1dt = Tr1 * dq;
omega1 = Tphi1 * dq;
dq1 = [dr1dt;omega1];
%
dTphi1 = get_R_z(phi)'*dTphi0 + skew(omega1)*gx*Tphi' + gx*dTphi';
dTr1 = dTr0 - L1*R1*skew(gx)*dTphi1 - L1*R1*skew(omega1)*skew(gx)*Tphi0;
dT1 = [dTr1;dTphi1];
%
ddr1dtdt = Tr1 * ddq + dTr1 * dq;
domega1dt = Tphi1 * ddq + dTphi1 * dq;
ddq1 = [ddr1dtdt;domega1dt];
%% Node 2
L2 = BodyElementParameter{2}.L;
R2 = R1 * get_R_y(pi/2) * get_R_y(-psi);
r02 = r01 + R2*gx*L2;
%
Tphi2 = R2'*R1*Tphi1 - gy * Tpsi';
Tr2 = Tr1 - L2*R2*skew(gx)*Tphi2;
T2 = [Tr2;Tphi2];
%
dr2dt = Tr2 * dq;
omega2 = Tphi2 * dq;
dq2 = [dr2dt;omega2];
%
dTphi2 = R2'*R1*dTphi1 - skew(omega2)*gz*Tpsi' - gy*dTpsi';
dTr2 = dTr1 - L2*R2*skew(gx)*dTphi2 - L2*R2*skew(omega2)*skew(gx)*Tphi2;
dT2 = [dTr2;dTphi2];
%
ddr2dtdt = Tr2 * ddq + dTr2 * dq;
domega2dt = Tphi2 * ddq + dTphi2 * dq;
ddq2 = [ddr2dtdt;domega2dt];
%% Node 3
L3 = BodyElementParameter{3}.L;
R3 = R2 * get_R_y(theta);
r03 = r02 + R3*gx*L3;
%
Tphi3 = R3'*R2*Tphi2 + gy * Ttheta';
Tr3 = Tr2 - L3*R3*skew(gx)*Tphi3;
T3 = [Tr3;Tphi3];
%
dr3dt = Tr3 * dq;
omega3 = Tphi3 * dq;
dq3 = [dr3dt;omega3];
%
dTphi3 = R3'*R3*dTphi2 - skew(omega3)*gz*Ttheta' + gy*dTtheta';
dTr3 = dTr2 - L3*R3*skew(gx)*dTphi3 - L3*R3*skew(omega3)*skew(gx)*Tphi3;
dT3 = [dTr3;dTphi3];
%
ddr3dtdt = Tr3 * ddq + dTr3 * dq;
domega3dt = Tphi3 * ddq + dTphi3 * dq;
ddq3 = [ddr3dtdt;domega3dt];
%% qn
r0n = cell(3,1);
r0n{1} = r01;	r0n{2} = r02;	r0n{3} = r03;
%% Rn
Rn = cell(3,1);
Rn{1} = R1;		Rn{2} = R2;		Rn{3} = R3;
%% dqn
dqn = cell(3,1);
dqn{1} = dq1;	dqn{2} = dq2;	dqn{3} = dq3;
%% ddqn
ddqn = cell(3,1);
ddqn{1} = ddq1;	ddqn{2} = ddq2;	ddqn{3} = ddq3;
%% Tn
Tn = cell(3,1);
Tn{1} = T1;		Tn{2} = T2;		Tn{3} = T3;
%% dTn
dTn = cell(3,1);
dTn{1} = dT1;	dTn{2} = dT2;	dTn{3} = dT3;
end