function [Mass,Force,Fine,Fint,Fext] = ...
	TimoshenkoBeam_AbsoluteCoordinate_MassForce(...
	qe,dqe,g,BodyParameter)
%%
L  = BodyParameter.L;
A  = BodyParameter.A;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
E  = BodyParameter.E;
G  = BodyParameter.G;
rho = BodyParameter.rho;
%
J = diag([Iy+Iz,Iz,Iy]);
Kepsilon = diag([E*A,G*A,G*A]);
Kepsilon = diag([E*A,0,0]);
Kkappa = diag([G*(Iy+Iz),E*Iy,E*Iz]);
%%
gx = [1;0;0];
%%
NodeQuantity = numel(qe)/2/3;
Ttra = zeros(3*NodeQuantity,6*NodeQuantity);
Ttra(:,1:3*NodeQuantity) = eye(3*NodeQuantity);

Trot = zeros(3*NodeQuantity,6*NodeQuantity);
Trot(:,3*NodeQuantity+1:end) = eye(3*NodeQuantity);
re = Ttra * qe;
phie = Trot * qe;
ptrae = Ttra * dqe;
prote = Trot * dqe;
%%
inv_Tpe = zeros(3*NodeQuantity);
inv_dTpedt = zeros(3*NodeQuantity);
for NodeNr = 1:NodeQuantity
	NodePos = 3*(NodeNr-1) + (1:3);
	phii = phie(NodePos);
	proti = prote(NodePos);
	
	Ri = get_R(phii);
	Ti = get_T(phii);
	
	dphiidt = inv(Ti)*inv(J)*Ri'*proti;
	omegai = Ti * dphiidt;
	dTidt = get_dT(phii,dphiidt);
	
	inv_Tpe(NodePos,NodePos) = inv(Ti)*inv(J)*Ri';
	inv_dTpedt(NodePos,NodePos) = -inv(Ti)*(inv(J)*skew(omegai) + ...
		dTidt*inv(Ti)*inv(J))*Ri';
end

%%
gaussn = 5;
x_set = gaussx(0,L,gaussn);
w_set = gaussw(gaussn)*L/2;
Interpolation_X_set = linspace(0,L,NodeQuantity);
Mtra = zeros(3*NodeQuantity);
Mrot = zeros(3*NodeQuantity);
Drot = zeros(3*NodeQuantity);
Fint = zeros(numel(dqe),1);
Fint_epsilon = zeros(numel(dqe),1);
Fint_kappa = zeros(numel(dqe),1);
Ve =  zeros(numel(dqe),3);
for i = 1:gaussn
	x = x_set(i);
	w = w_set(i);
	
	Nr = Lagrangian_Vector_ShapeFunction_N(...
		Interpolation_X_set,3,x);
	dNr = Lagrangian_Vector_ShapeFunction_dN(...
		Interpolation_X_set,3,x);
	Nphi = Lagrangian_Vector_ShapeFunction_N(...
		Interpolation_X_set,3,x);
	dNphi = Lagrangian_Vector_ShapeFunction_dN(...
		Interpolation_X_set,3,x);
	
	r0c = Nr * re;
	phic = Nphi * phie;
	Rc = get_R(phic);
	Tc = get_T(phic);
	
	dr0cdx = dNr * re;
	dphicdx = dNphi * phie;
	kappac = Tc * dphicdx;
	
	dphicdt = 1/rho*Nphi*inv_Tpe*prote;
	dTcdx_conj = get_dT_Conjugation(phic,dphicdt);
	dTcdt = get_dT(phic,dphicdt);
	
% 	epsilonc = Rc'*dr0cdx - skew(kappac)*Rc'*r0c - gx;
	epsilonc = Rc'*dr0cdx - gx;
% 	kappac = Tc * dphicdx;
	
% 	Tepsilonc = 1/(rho*A)*(Rc'*dNr-skew(kappac)*Rc'*Nr)*Ttra + ...
% 		1/rho*(Rc'*skew(dr0cdx)*Rc*Tc*Nphi + ...
% 		Rc'*skew(r0c)*Rc*(dTcdx_conj*Nphi+Tc*dNphi) - ...
% 		skew(kappac)*Rc'*skew(r0c)*Rc*Tc*Nphi)*inv_Tpe*Trot;
	Tepsilonc = 1/(rho*A)*Rc'*dNr*Ttra + ...
		1/rho*Rc'*skew(dr0cdx)*Rc*Tc*Nphi*inv_Tpe*Trot;
	Tkappac = 1/rho*(dTcdx_conj*Nphi + Tc*dNphi)*inv_Tpe*Trot;
	
	Mtra = Mtra + 1/(rho*A)*Nr'*Nr*w;
	Mrot = Mrot + 1/rho*inv_Tpe'*(Nphi'*Tc'*J*Tc*Nphi)*inv_Tpe*w;
	Drot = Drot + 1/rho*inv_Tpe'*(Nphi'*Tc'*J*Tc*Nphi*inv_dTpedt + ...
		Nphi'*Tc'*J*dTcdt*Nphi*inv_Tpe)*w;
	
	Fint_epsilon = Fint_epsilon + Tepsilonc'*Kepsilon*epsilonc*w;
	Fint_kappa = Fint_kappa + Tkappac'*Kkappa*kappac*w;
	Fint = Fint + (Tepsilonc'*Kepsilon*epsilonc + Tkappac'*Kkappa*kappac)*w;
	Ve = Ve - Ttra'*Nr'*w;
end

Mass = [...
	Mtra,					zeros(3*NodeQuantity);
	zeros(3*NodeQuantity),	Mrot];
Dampfer = [...
	zeros(3*NodeQuantity),	zeros(3*NodeQuantity);
	zeros(3*NodeQuantity),	Drot];
Fine = Dampfer * dqe;
Fext = Ve*g;

Force = Fine + Fint + Fext;
end