function [Phi,B,dPhi,Tau] = set_Constraint_WinchCable(...
	q,dq,Body1,Joint1,Body2,Joint2,WinchRadius)
%%
gx = [1;0;0];
% gy = [0;1;0];
% gz = [0;0;1];
%%
r0w = Joint1.r;
r0c = Joint2.r;
rwc = r0c - r0w;
phiw = Joint1.phi;
phic = Joint2.phi;
Rw = get_R(phiw);
Rc = get_R(phic);
xw = Rw * gx;
xc = Rc * gx;
%
drwdt = Joint1.dr;
drcdt = Joint2.dr;
omegaw = Joint1.omega;
omegac = Joint2.omega;
% dqJ1 = [Joint1.dr;Joint1.omega];
% dqJ2 = [Joint2.dr;Joint2.omega];
% dqJ = [dqJ1;dqJ2];
%%
TJ1B1 = Joint1.T_qi_q;
TJ2B2 = Joint2.T_qi_q;
TB1 = Body1.T_qe_q;
TB2 = Body2.T_qe_q;

TJ1J2 = [TJ1B1*TB1;TJ2B2*TB2];

%% g
Phi = zeros(2,1);
Phi(1) = rwc'*(eye(3)-xw*xw')*rwc - WinchRadius^2;
Phi(2) = xc'*(eye(3)-xw*xw')*rwc;
%%
BJ1J2 = zeros(2,12);
BJ1J2(1,:) = ...
	2 * rwc' * ...
	[-(eye(3)-xw*xw'),-xw*xw'*skew(rwc)*Rw,(eye(3)-xw*xw'),zeros(3)];
BJ1J2(2,:) = ...
	[-xc'*(eye(3)-xw*xw'),-2*xc'*xw*xw'*skew(rwc)*Rw, ...
	xc'*(eye(3)-xw*xw'),-rwc'*(eye(3)-xw*xw')*Rc*skew(gx)];

BJ1J2 = BJ1J2';
%
B = BJ1J2'*TJ1J2;
B = B';
%%
dPhi = B' * dq;
%%
Tau = zeros(2,1);
Tau(1) = 2*(drcdt-drwdt)'*(eye(3)-xw*xw')*(drcdt-drwdt) + ...
	6*(r0c-r0w)'*xw*xw'*Rw*skew(omegaw)*Rw'*(drcdt-drwdt) + ...
	2*(drcdt-drwdt)'*xw*xw'*Rw*skew(omegaw)*Rw'*(r0c-r0w) + ...
	2*(r0c-r0w)'*Rw*skew(omegaw)*gx*gx'*skew(omegaw)*Rw'*(r0c-r0w) - ...
	2*(r0c-r0w)'*xw*xw'*Rw*skew(omegaw)*skew(omegaw)*Rw'*(r0c-r0w);
Tau(2) = 2*(drcdt-drwdt)'*(eye(3)-xw*xw')*Rc*skew(omegac)*gx + ...
	2*(r0c-r0w)'*xw*xw'*Rw*skew(omegaw)*Rw'*Rc*skew(omegac)*gx + ...
	(r0c-r0w)'*(eye(3)-xw*xw')*Rc*skew(omegac)*skew(omegac)*gx - ...
	2*gx'*skew(omegac)*Rc'*xw*xw'*Rw*skew(omegac)*Rw'*(r0c-r0w) + ...
	2*xc'*Rw*skew(omegaw)*gx*gx'*skew(omegaw)*Rw'*(r0c-r0w) - ...
	2*xc'*xw*xw'*Rw*skew(omegaw)*skew(omegaw)*Rw'*(r0c-r0w) + ...
	4*xc'*xw*xw'*Rw*skew(omegaw)*Rw'*(drcdt-drwdt);

end