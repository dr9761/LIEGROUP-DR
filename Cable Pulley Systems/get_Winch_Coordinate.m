function [qwinch,dqwinch,Twinch,dTwinch] = ...
	get_Winch_Coordinate(qe,dqe,BodyParameter)
%%
gx = [1;0;0];
%%
r0A = qe(1:3);
phiA = qe(4:6);
thetap = qe(7);
%
dr0Adt = dqe(1:3);
omegaA = dqe(4:6);
dthetapdt = dqe(7);
%
RA = get_R(phiA);
%
TrA = zeros(3,numel(dqe));
TrA(:,1:3) = eye(3);
TphiA = zeros(3,numel(dqe));
TphiA(:,4:6) = eye(3);
Tthetap = zeros(1,numel(qe));
Tthetap(:,7) = 1;
%%
r0p = r0A;
dr0pdt = dr0Adt;

R_A_P = get_R_x(thetap);
Rp = RA * R_A_P;
phip = get_Rotation_from_R(Rp,zeros(3,1));
omegap = R_A_P' * omegaA + dthetapdt * gx;
%%
qwinch = [r0p;phip];
dqwinch = [dr0pdt;omegap];
%
Trp = TrA;
Trphip = R_A_P'*TphiA + gx*Tthetap;
Twinch = [Trp;Trphip];
%
dTrp = zeros(3,numel(dqe));
dTphip = get_T_x(thetap)'*dthetapdt*TphiA;
dTwinch = [dTrp;dTphip];
end