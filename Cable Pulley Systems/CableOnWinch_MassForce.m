function [Mass,Force] = CableOnWinch_MassForce(qe,dqe,g,BodyParameter)
%%
HelixRadius = BodyParameter.HelixRadius;
CableRadius = BodyParameter.CableRadius;
WinchRadius = BodyParameter.WinchRadius;
phiwc0 = BodyParameter.phiwc0;
rwc0x = BodyParameter.rwc0x;
CableOnWinchParameter = BodyParameter.CableOnWinchParameter;
L = CableOnWinchParameter.L;
rho = CableOnWinchParameter.rho;
A = CableOnWinchParameter.A;
E = CableOnWinchParameter.E;
w_rww0 = [rwc0x;0;0];
w_rw0c0 = [0;-WinchRadius*sin(phiwc0);WinchRadius*cos(phiwc0)];
%%
gx = [1;0;0];
%%
qw = qe(1:6);
r0w = qw(1:3);
phiw = qw(4:6);
Rw = get_R(phiw);

qc = qe(7);
thetac = qc(1);
%%
dqw = dqe(1:6);
omegaw = dqw(4:6);

Trw = zeros(3,numel(qe));Trw(:,1:3) = eye(3);
Tphiw = zeros(3,numel(qe));Tphiw(:,4:6) = eye(3);
Tthetac = zeros(1,numel(qe));Tthetac(:,7) = 1;
%%
Mtra = zeros(numel(qe));
Dtra = zeros(numel(qe));

Fint = zeros(numel(qe),1);
Fextg = zeros(numel(qe),1);
%%
gaussn = 5;
x_set = gaussx(0,L,gaussn);
w_set = gaussw(gaussn);

for i = 1:gaussn
	w = w_set(i);
	x = x_set(i);
	
	thetax = x/L*thetac;
	w_rw0x = get_R_x(thetax)*w_rw0c0 + CableRadius/pi*gx*thetax;
	w_tx = get_T_x(thetax)*w_rw0c0 + CableRadius/pi*gx;
	Trx = Trw - Rw*skew(w_rww0)*Tphiw - Rw*skew(w_rw0x)*Tphiw + Rw*w_tx*x/L*Tthetac;
	dTrx = (-Rw*skew(omegaw)*skew(w_rww0) - Rw*skew(omegaw)*skew(w_rw0x))*Tphiw + ...
		(Rw*skew(omegaw)*w_tx + Rw*get_dT_x(thetax)*w_rw0c0)*x/L*Tthetac;
	
	Mtra = Mtra + rho*A*Trx'*Trx*w;
	Dtra = Dtra + rho*A*Trx'*dTrx*w;
	Fextg = Fextg - rho*A*Trx'*g*w;
end
%%
epsilon = HelixRadius/L*thetac - 1;
if epsilon < 0
	epsilon = 0;
end
Fint(7) = E*A*HelixRadius*epsilon;
%%
Mass = Mtra;
Dampfer = Dtra;
Fine = Dampfer * dqe;
Force = Fextg + Fint + Fine;
end