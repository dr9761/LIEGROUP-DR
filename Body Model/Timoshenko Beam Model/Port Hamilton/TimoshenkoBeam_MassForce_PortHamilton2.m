% function [Mass,Force] = ...
% 	TimoshenkoBeam_MassForce_PortHamilton( ...
% 	re,phie,ptrae,prote,epsilone,kappae,BodyParameter)
function dx = ...
	TimoshenkoBeam_MassForce_PortHamilton2( ...
	t,x,BodyParameter)
%%
NodeQuantity = numel(x)/18;
re = x(1:3*NodeQuantity);
phie = x(3*NodeQuantity+1:6*NodeQuantity);
epsilone = x(6*NodeQuantity+1:9*NodeQuantity);
kappae = x(9*NodeQuantity+1:12*NodeQuantity);
ptrae = x(12*NodeQuantity+1:15*NodeQuantity);
prote = x(15*NodeQuantity+1:18*NodeQuantity);
%%
L = BodyParameter.L;
rho = BodyParameter.rho;
A = BodyParameter.A;
E = BodyParameter.E;
G = BodyParameter.G;
I = BodyParameter.J;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;

BC = diag([E*A,G*A,G*A]);
BD = I;
%%
g = [0;0;-9.8];
%%
gaussn = 5;
x_set = gaussx(0,L,gaussn);
w_set = gaussw(gaussn)*L/2;
%
Me = zeros(3*NodeQuantity);
De = zeros(3*NodeQuantity);
Se = zeros(3*NodeQuantity);

D0 = zeros(3*NodeQuantity);
Deps = zeros(3*NodeQuantity);
Dcur = zeros(3*NodeQuantity);
Seps = zeros(3*NodeQuantity);
sPhi3 = zeros(3,3*NodeQuantity);
for i = 1:gaussn
	s = x_set(i);
	w = w_set(i);
	
	Phi3 = Lagrangian_Vector_ShapeFunction(linspace(0,L,NodeQuantity),3,s);
	dPhi3 = Lagrangian_Vector_ShapeFunction_dPhi(...
		linspace(0,L,NodeQuantity),3,s);
	
	ri = Phi3*re;
	phii = Phi3*phie;
	dridx = dPhi3*re;
	kappai = Phi3*kappae;
	
	Ri = get_R(phii);
	
	IC = Ri * BC * Ri';
	ID = Ri * BD * Ri';
% 	Me = Me + Phi3'*Phi3*w;
% 	De = De + dPhi3'*Ri*Phi3*w;
% 	Se = Se + Phi3'*skew(dridx)*Ri*Phi3*w;
	
	Me = Me + Phi3'*Phi3*w;
	De = De + Phi3'*Ri*dPhi3*w;
	Se = Se + Phi3'*skew(dridx)*Ri*Phi3*w;
	
	D0 = D0 + Phi3'*dPhi3*w;
	Deps = Deps + (Phi3'*skew(kappai)*IC*Phi3 - ...
		Phi3'*IC*skew(kappai)*Phi3 + ...
		Phi3'*IC*dPhi3)*w;
	Dcur = Dcur + (Phi3'*skew(kappai)*ID*Phi3 - ...
		Phi3'*ID*skew(kappai)*Phi3 + ...
		Phi3'*ID*dPhi3)*w;
	Seps = Seps + (Phi3'*skew(dridx)*Phi3 + ...
		Phi3'*skew(ri)*dPhi3)*w;
	sPhi3 = sPhi3 + Phi3*w;
end
%%
Zeroe = zeros(3*NodeQuantity);
% M = zeros(18*NodeQuantity);
% for StateNr = 1:6
% 	StatePos = 3*NodeQuantity*(StateNr-1)+[1:3*NodeQuantity];
% 	M(StatePos,StatePos) = Me;
% end
M = [	Me,		Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe;
		Zeroe,	Me,		Zeroe,	Zeroe,	Zeroe,	Zeroe;
		Zeroe,	Zeroe,	Me,		Zeroe,	Zeroe,	Zeroe;
		Zeroe,	Zeroe,	Zeroe,	Me,		Zeroe,	Zeroe;
		Zeroe,	Zeroe,	Zeroe,	Zeroe,	Me,		Zeroe;
		Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Me];
% J = zeros(18*NodeQuantity);

Je = [	Zeroe,	Zeroe,	Me,		Zeroe,	Zeroe,	Zeroe;
		Zeroe,	Zeroe,	Zeroe,	Me,		Zeroe,	Zeroe;
		-Me,	Zeroe,	Zeroe,	Zeroe,	Deps,	Zeroe;
		Zeroe,	-Me,	Zeroe,	Zeroe,	Seps,	Dcur;
		Zeroe,	Zeroe,	D0,		Zeroe,	Zeroe,	Zeroe;
		Zeroe,	Zeroe,	Zeroe,	D0,		Zeroe,	Zeroe];

Jtra = zeros(3*NodeQuantity);
Jrot = zeros(3*NodeQuantity);
Keps = zeros(3*NodeQuantity);
Kcur = zeros(3*NodeQuantity);
dHdr = zeros(3*NodeQuantity,1);
for NodeNr = 1:NodeQuantity
	NodePos = 3*(NodeNr-1)+[1:3];
	phii = phie(NodePos);
	Ri = get_R(phii);
% 	Ti = get_T(phii);
	ID = Ri * BD * Ri';
	Jtra(NodePos,NodePos) = 1/(rho*A)*eye(3);
	Jrot(NodePos,NodePos) = 1/rho*inv(ID);
	Keps(NodePos,NodePos) = eye(3);
	Kcur(NodePos,NodePos) = eye(3);
	
	dHdr(NodePos) = rho*A*g;
end
K =	[	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe;
		Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe;
		Zeroe,	Zeroe,	Jtra,	Zeroe,	Zeroe,	Zeroe;
		Zeroe,	Zeroe,	Zeroe,	Jrot,	Zeroe,	Zeroe;
		Zeroe,	Zeroe,	Zeroe,	Zeroe,	Keps,	Zeroe;
		Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Kcur];

V = zeros(numel(x),1);
% V(1:3*NodeQuantity) = sPhi3'*rho*A*g;
V(6*NodeQuantity+1:9*NodeQuantity) = sPhi3'*rho*A*g;


ZeroF = zeros(3*NodeQuantity,3);
Phi0 = Lagrangian_Vector_ShapeFunction(linspace(0,L,NodeQuantity),3,0);
Phie = Lagrangian_Vector_ShapeFunction(linspace(0,L,NodeQuantity),3,L);
G = [	ZeroF,	ZeroF,	ZeroF,	ZeroF;
		ZeroF,	ZeroF,	ZeroF,	ZeroF;
		Phi0',	Phie',	ZeroF,	ZeroF;
		ZeroF,	ZeroF,	Phi0',	Phie';
		ZeroF,	ZeroF,	ZeroF,	ZeroF;
		ZeroF,	ZeroF,	ZeroF,	ZeroF];
Force0 = [0;0;0];
Forcee = [0;0;100];
Moment0 = [0;0;0];
Momente = [0;0;0];
Fext =[Force0;Forcee;Moment0;Momente];
%%
% dredt(1:3) = 0;
% dphiedt(1:3) = 0;
% Ftra(1:3) = 0;
% Frot(1:3) = 0;
% F = [dredt;dphiedt;depsilonedt;dkappaedt;Ftra;Frot];
%%
% F = (Je*(K*x + V) + G*Fext);
F = (Je*K*x + V + G*Fext);
% tra
M(6*NodeQuantity+[1:3],:) = 0;
M(6*NodeQuantity+[1:3],6*NodeQuantity+[1:3]) = eye(3);
F(6*NodeQuantity+[1:3]) = 0;
% % rot
M(9*NodeQuantity+[1:3],:) = 0;
M(9*NodeQuantity+[1:3],9*NodeQuantity+[1:3]) = eye(3);
F(9*NodeQuantity+[1:3]) = 0;

dx = M\F;
dredt = dx(1:3*NodeQuantity);
dphiedt = dx(3*NodeQuantity+1:6*NodeQuantity);
dptraedt = dx(6*NodeQuantity+1:9*NodeQuantity);
dprotedt = dx(9*NodeQuantity+1:12*NodeQuantity);
depsilonedt = dx(12*NodeQuantity+1:15*NodeQuantity);
dkappaedt = dx(15*NodeQuantity+1:18*NodeQuantity);
%%
fprintf('t = %16.14f\n',t);
s_plot = linspace(0,L,NodeQuantity);
r_plot = zeros(3,numel(s_plot));
for k = 1:numel(s_plot)
	Phi3_plot = Lagrangian_Vector_ShapeFunction(linspace(0,L,NodeQuantity),3,s_plot(k));
	r_plot(:,k) = Phi3_plot*re;
% 	Vector_Lagrangian_Interpolation_Value(p_r,s_plot(k));
end
x_plot = r_plot(1,:);
y_plot = r_plot(2,:);
z_plot = r_plot(3,:);
plot3(x_plot,y_plot,z_plot,'r.-');
view(0,0);%x-z
grid MINOR;
axis([-1,1,-1,1,-1,1]*20);
drawnow;
% pause(0.01);
end