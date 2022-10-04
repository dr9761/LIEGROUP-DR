function [qc,dqc,Tc,dTcdt] = ...
	get_InternalNode_Coordination_TimoshenkoBeam(...
	qs,dqs,xi,BodyParameter)
L = BodyParameter.L;
%%
r0s = [qs(1:3);qs(7:9)];
Rs = [get_R(qs(4:6));get_R(qs(10:12))];
[r0B,RB,dqB,TB,dTBdt] = ...
	get_Corotational_Coordination_TimoshenkoBeam(r0s,Rs,dqs,L);
%
% r0B = qB(1:3);
% phiB = qB(4:6);
% RB = get_R(phiB);
%
omegaB = dqB(4:6);
%%
r_rigid_1 = [0;0;0];
r_rigid_2 = [L;0;0];
[qd_end,dqd_end,Td_end,dTd_enddt] = ...
	get_Deformation_Coordination_at_Endpoint(...
	r0s,Rs,dqs,r0B,RB,dqB,TB,dTBdt,r_rigid_1,r_rigid_2);
%
dqd_enddt = dqd_end;
%% ÐÍº¯Êý
N_c = Shapefunction_N(BodyParameter,xi);
%
qdc = N_c * qd_end;
kuc = qdc(1:3);
psic = qdc(4:6);
Rdc = get_R(psic);
%
dqdcdt = N_c*dqd_enddt;
dqdc = dqdcdt;
dpsic_dt = dqdcdt(4:6);
omegadc = get_T(psic) * dpsic_dt;
%%
r_rigid = [xi*L;0;0];
r0c = r0B + RB * (r_rigid + kuc);
phic = get_Rotation_from_R(RB*Rdc,zeros(3,1));

qc = [r0c;phic];	
%%
krc = r_rigid + kuc;
TBc = ...
	[eye(3),	-RB*skew(krc),	RB,			zeros(3);
	zeros(3),	Rdc',			zeros(3),	eye(3)];
%
dqc = TBc * [dqB;dqdc];
Tc = TBc * [TB;N_c * Td_end];
%%
dTBcdt = ...
	[zeros(3),	-RB*skew(omegaB)*skew(krc),	2*RB*skew(omegaB),	zeros(3);
	zeros(3),	-skew(omegadc)*Rdc',		zeros(3),			zeros(3)];
dTcdt = TBc * [dTBdt;N_c*dTd_enddt] + dTBcdt * [TB;N_c*Td_end];
end