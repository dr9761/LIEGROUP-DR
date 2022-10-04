function [Phi,B,dPhi,Tau] = set_Constraint_Prismatic(...
	q,dq,Body1,Joint1,Body2,Joint2)
%%
r0J1 = Joint1.r;
r0J2 = Joint2.r;
phiJ1 = Joint1.phi;
phiJ2 = Joint2.phi;
RJ1 = get_R(phiJ1);
RJ2 = get_R(phiJ2);
%
dr0J1dt = Joint1.dr;
dr0J2dt = Joint2.dr;
omegaJ1 = Joint1.omega;
omegaJ2 = Joint2.omega;
dqJ1 = [Joint1.dr;Joint1.omega];
dqJ2 = [Joint2.dr;Joint2.omega];
dqJ = [dqJ1;dqJ2];
%%
TJ1B1 = Joint1.T_qi_q;
TJ2B2 = Joint2.T_qi_q;
TB1 = Body1.T_qe_q;
TB2 = Body2.T_qe_q;

TJ1J2 = [TJ1B1*TB1;TJ2B2*TB2];
%%
gx = [1;0;0];
gy = [0;1;0];
gz = [0;0;1];
%% g
Phi = zeros(5,1);
Phi(1) = (r0J1-r0J2)' * RJ1 * gy;
Phi(2) = (r0J1-r0J2)' * RJ1 * gz;
Phi(3) = gx' * RJ1' * RJ2 * gz;
Phi(4) = gy' * RJ1' * RJ2 * gz;
Phi(5) = gx' * RJ1' * RJ2 * gy;
%%
BJ1J2 = zeros(5,12);
BJ1J2(1,:) = ...
	[gy'*RJ1',-(r0J1-r0J2)'*RJ1*skew(gy),-gy'*RJ1',zeros(1,3)];
BJ1J2(2,:) = ...
	[gz'*RJ1',-(r0J1-r0J2)'*RJ1*skew(gz),-gz'*RJ1',zeros(1,3)];
BJ1J2(3,:) = ...
	[zeros(1,3),-gz'*RJ2'*RJ1*skew(gx),zeros(1,3),-gx'*RJ1'*RJ2*skew(gz)];
BJ1J2(4,:) = ...
	[zeros(1,3),-gz'*RJ2'*RJ1*skew(gy),zeros(1,3),-gy'*RJ1'*RJ2*skew(gz)];
BJ1J2(5,:) = ...
	[zeros(1,3),-gy'*RJ2'*RJ1*skew(gx),zeros(1,3),-gx'*RJ1'*RJ2*skew(gy)];

BJ1J2 = BJ1J2';
%
B = BJ1J2'*TJ1J2;
B = B';
%%
dPhi = B' * dq;
%%
D12 = skew(omegaJ1)*RJ1'*RJ2 - RJ1'*RJ2*skew(omegaJ2);
D21 = skew(omegaJ2)*RJ2'*RJ1 - RJ2'*RJ1*skew(omegaJ1);
Dr1 = (dr0J1dt-dr0J2dt)'*RJ1+(r0J1-r0J2)'*RJ1*skew(omegaJ1);
Dr1 = Dr1';
%%
dBJ1J2dt = zeros(5,12);
dBJ1J2dt(1,:) = ...
	[-gy'*skew(omegaJ1)*RJ1',-Dr1'*skew(gy),gy'*skew(omegaJ1)*RJ1',zeros(1,3)];
dBJ1J2dt(2,:) = ...
	[-gz'*skew(omegaJ1)*RJ1',-Dr1'*skew(gz),gz'*skew(omegaJ1)*RJ1',zeros(1,3)];
dBJ1J2dt(3,:) = ...
	[zeros(1,3),gz'*D21*skew(gx),zeros(1,3),gx'*D12*skew(gz)];
dBJ1J2dt(4,:) = ...
	[zeros(1,3),gz'*D21*skew(gy),zeros(1,3),gy'*D12*skew(gz)];
dBJ1J2dt(5,:) = ...
	[zeros(1,3),gy'*D21*skew(gx),zeros(1,3),gx'*D12*skew(gy)];
%
dBJ1J2dt = dBJ1J2dt';
Tau = dBJ1J2dt' * dqJ;

end