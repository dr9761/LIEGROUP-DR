function [r0B,RB,dqB,TB,dTBdt,r_rigid_1,r_rigid_2] = ...
	get_Corotational_Coordination_TimoshenkoBeam_Symbolic(...
	r0e,Re,dqe,L)
%%
r01  = r0e(1:3);
r02  = r0e(4:6);
R1 = Re(1:3,:);
R2 = Re(4:6,:);
%%
r0B = r01;
RB = R1;
%
TB = [	eye(3),		zeros(3),	zeros(3),zeros(3);
		zeros(3),	eye(3),		zeros(3),zeros(3);];
%
dqB = TB*dqe;
%
dTBdt = [	zeros(3),	zeros(3),	zeros(3),zeros(3);
			zeros(3),	zeros(3),	zeros(3),zeros(3);];
%
r_rigid_1 = [0;0;0];
r_rigid_2 = [L;0;0];
end