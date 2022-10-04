function [Phi,B,dPhi,Tau] = set_Constraint_Spherical(...
	q,dq,Body1,Joint1,Body2,Joint2)
%%
r0J1 = Joint1.r;
r0J2 = Joint2.r;
%%
TJ1B1 = Joint1.T_qi_q;
TJ2B2 = Joint2.T_qi_q;
TB1 = Body1.T_qe_q;
TB2 = Body2.T_qe_q;

TJ1J2 = [TJ1B1*TB1;TJ2B2*TB2];
dqJ = TJ1J2*dq;
%% g
Phi = zeros(3,1);
Phi(1:3) = r0J1 - r0J2;
%%
BJ1J2 = zeros(3,12);
BJ1J2([1:3],:) = [eye(3),zeros(3),-eye(3),zeros(3)];

BJ1J2 = BJ1J2';
%
B = BJ1J2'*TJ1J2;
B = B';
%%
dPhi = B' * dq;
%%
dBJ1J2dt = zeros(3,12);
dBJ1J2dt([1:3],:) = [zeros(3),zeros(3),zeros(3),zeros(3)];
%
dBJ1J2dt = dBJ1J2dt';
Tau = dBJ1J2dt' * dqJ;

end