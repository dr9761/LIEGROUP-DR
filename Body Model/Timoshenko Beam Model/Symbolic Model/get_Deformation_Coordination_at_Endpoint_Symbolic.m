function [qd_end,dqd_end,Td_end,dTd_enddt] = ...
	get_Deformation_Coordination_at_Endpoint_Symbolic(...
	r0e,Re,dqe,r0B,RB,dqB,TB,dTBdt,r_rigid_1,r_rigid_2)
%%
r01  = r0e(1:3);
r02  = r0e(4:6);

R1 = Re(1:3,:);
R2 = Re(4:6,:);
%%
omegaB = dqB(4:6);
%%
u1   = RB'*(r01-r0B) - r_rigid_1;
psi1 = get_Rotation_from_R_small_deofrmation(RB'*R1);

u2   = RB'*(r02-r0B) - r_rigid_2;
psi2 = get_Rotation_from_R_small_deofrmation(RB'*R2);

qd_end = [u1;psi1;u2;psi2];
%%
Rd1 = get_R_Symbolic(psi1);
Rd2 = get_R_Symbolic(psi2);
%%
T_dend_Be = ...
	[-RB',		skew(r_rigid_1+u1),	RB',		zeros(3),	zeros(3),	zeros(3);
	zeros(3),	-Rd1',				zeros(3),	eye(3),		zeros(3),	zeros(3);
	-RB',		skew(r_rigid_2+u2),	zeros(3),	zeros(3),	RB',		zeros(3);
	zeros(3),	-Rd2',				zeros(3),	zeros(3),	zeros(3),	eye(3)];
T_Be_e = [TB;eye(12)];
Td_end = T_dend_Be * T_Be_e;
%%
dqd_end = Td_end * dqe;

omegad1 = dqd_end(4:6);
omegad2 = dqd_end(10:12);
%%
dT_dend_Bedt = ...
	[2*skew(omegaB)*RB',-skew(omegaB)*skew(r_rigid_1+u1),	-2*skew(omegaB)*RB',zeros(3),	zeros(3),				zeros(3);
	zeros(3),			skew(omegad1)*Rd1',					zeros(3),			zeros(3),	zeros(3),				zeros(3);
	2*skew(omegaB)*RB',-skew(omegaB)*skew(r_rigid_2+u2),	zeros(3),			zeros(3),	-2*skew(omegaB)*RB',	zeros(3);
	zeros(3),			skew(omegad2)*Rd2',					zeros(3),			zeros(3),	zeros(3),				zeros(3);];
dT_Be_edt = [dTBdt;zeros(12)];
dTd_enddt = T_dend_Be * dT_Be_edt + dT_dend_Bedt * T_Be_e;
end