function [qd] = ...
	get_Deformation_Coordination_TimoshenkoBeam(...
	qe,qB,r_rigid)
%%
r1   = qe(1:3);
phi1 = qe(4:6);

R1 = get_R(phi1);

rB   = qB(1:3);
phiB = qB(4:6);
%%
RB = get_R(phiB);
%%
u1   = RB'*(r1-rB) - r_rigid;
psi1 = get_Rotation_from_R(RB'*R1,zeros(3,1));

qd = [u1;psi1];
end