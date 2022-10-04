function dx = ...
	TimoshenkoBeam_MassForce_PortHamilton( ...
	t,x,BodyParameter,PlotFigureObj)
%%
NodeQuantity = numel(x)/18;
re = x(1:3*NodeQuantity);
phie = x(3*NodeQuantity+1:6*NodeQuantity);
ptrae = x(6*NodeQuantity+1:9*NodeQuantity);
prote = x(9*NodeQuantity+1:12*NodeQuantity);
epsilone = x(12*NodeQuantity+1:15*NodeQuantity);
kappae = x(15*NodeQuantity+1:18*NodeQuantity);

%%
Length = BodyParameter.L;
rho = BodyParameter.rho;
A = BodyParameter.A;
E = BodyParameter.E;
B = BodyParameter.G;
I = BodyParameter.J;
Iy = BodyParameter.Iy;
Iz = BodyParameter.Iz;
%%
g = [0;0;-9.8];
gx = [1;0;0];
%%
gaussn = 5;
x_set = gaussx(0,Length,gaussn);
w_set = gaussw(gaussn)*Length/2;
%
Me = zeros(3*NodeQuantity);
De = zeros(3*NodeQuantity);
DeT = zeros(3*NodeQuantity);
D0 = zeros(3*NodeQuantity);
Se = zeros(3*NodeQuantity);
Te = zeros(3*NodeQuantity);
L = zeros(18*NodeQuantity);
P = zeros(18*NodeQuantity,18);
%

for i = 1:gaussn
	s = x_set(i);
	w = w_set(i);
	
	Phi3 = Lagrangian_Vector_ShapeFunction(linspace(0,Length,NodeQuantity),3,s);
	dPhi3 = Lagrangian_Vector_ShapeFunction_dPhi(...
		linspace(0,Length,NodeQuantity),3,s);
	
	Phi18 = Lagrangian_Vector_ShapeFunction(linspace(0,Length,NodeQuantity),18,s);
% 	dPhi18 = Lagrangian_Vector_ShapeFunction_dPhi(...
% 		linspace(0,L,NodeQuantity),18,s);
	
	phii = Phi3*phie;
	dridx = dPhi3*re;
	kappai = Phi3*kappae;
	
	Ri = get_R(phii);
	Ti = get_T(phii);
	
	Me = Me + Phi3'*Phi3*w;
	De = De + (dPhi3'*Ri*Phi3 + Phi3'*Ri*skew(kappai)*Phi3)*w;
	Se = Se + Phi3'*skew(dridx)*Ri*Phi3*w;
	
	Lc = [ ...
		zeros(3),zeros(3),zeros(3),			zeros(3),			zeros(3),			zeros(3);
		zeros(3),zeros(3),zeros(3),			zeros(3),			zeros(3),			zeros(3);
		zeros(3),zeros(3),1/(rho*A)*eye(3),	zeros(3),			zeros(3),			zeros(3);
		zeros(3),zeros(3),zeros(3),			1/rho*inv(Ri*I*Ri'),zeros(3),			zeros(3);
		zeros(3),zeros(3),zeros(3),			zeros(3),			diag([E*A,B*A,B*A]),zeros(3);
		zeros(3),zeros(3),zeros(3),			zeros(3),			zeros(3),			diag([B*(Iy+Iz),E*Iy,E*Iz])];
	L = L + Phi18'*Lc*Phi18*w;
	
% 	P = P + Phi18'*Jc*w;
	
	Te = Te + Phi3'*inv(Ti)*Ri'*Phi3*w;
	% 	Me = Me + Phi3'*Phi3*w;
	% 	D0 = D0 + (Phi3'*dPhi3)*w;
	% % 	De = De + (dPhi3'*Ri*Phi3 + Phi3'*skew(kappai)*Ri*Phi3)*w;
	% %   De = De + (Phi3'*Ri*dPhi3 + Phi3'*Ri*skew(kappai)*Phi3)*w;
	% 	De = De + (Phi3'*Ri*dPhi3)*w;
	% 	DeT = DeT + (Phi3'*Ri'*dPhi3)*w;
	% 	Se = Se + Phi3'*Ri'*skew(dridx)*Ri*Phi3*w;
end
%%
Zeroe = zeros(3*NodeQuantity);
M = [ ...
	Me,		Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe;
	Zeroe,	Me,		Zeroe,	Zeroe,	Zeroe,	Zeroe;
	Zeroe,	Zeroe,	Me,		Zeroe,	Zeroe,	Zeroe;
	Zeroe,	Zeroe,	Zeroe,	Me,		Zeroe,	Zeroe;
	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Me,		Zeroe;
	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Me];

Q = M\L;
% P = inv(M)*P;
J = [ ...
	Zeroe,	Zeroe,	Me,		Zeroe,	Zeroe,	Zeroe;
	Zeroe,	Zeroe,	Zeroe,	Te,		Zeroe,	Zeroe;
	-Me,	Zeroe,	Zeroe,	Zeroe,	-De,	Zeroe;
	Zeroe,	-Te',	Zeroe,	Zeroe,	Se,		-De;
	Zeroe,	Zeroe,	De',	-Se',	Zeroe,	Zeroe;
	Zeroe,	Zeroe,	Zeroe,	De',	Zeroe,	Zeroe];

Jtra = zeros(3*NodeQuantity);
Jrot = zeros(3*NodeQuantity);
Keps = zeros(3*NodeQuantity);
Kcur = zeros(3*NodeQuantity);
dHdr = zeros(3*NodeQuantity,1);
V = zeros(numel(x),1);
for NodeNr = 1:NodeQuantity
	NodePos = 3*(NodeNr-1)+[1:3];
	phii = phie(NodePos);
	Ti = get_T(phii);
	Ri = get_R(phii);
	Jtra(NodePos,NodePos) = 1/(rho*A)*eye(3);
	Jrot(NodePos,NodePos) = 1/rho*inv(Ri*I*Ri');
	Keps(NodePos,NodePos) = E*A*eye(3);
	Kcur(NodePos,NodePos) = diag([B*(Iy+Iz),E*Iy,E*Iz]);
	
% 	dHdr(NodePos) = rho*A*g;
	V(NodePos) = rho*A*g;
	V(12*NodeQuantity+NodePos) = -gx;
end
K =	[...
	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe;
	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe;
	Zeroe,	Zeroe,	Jtra,	Zeroe,	Zeroe,	Zeroe;
	Zeroe,	Zeroe,	Zeroe,	Jrot,	Zeroe,	Zeroe;
	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Keps,	Zeroe;
	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Zeroe,	Kcur];


% V(1:3*NodeQuantity) = dHdr;
% Vc = [zeros(3,1);zeros(3,1);rho*A*g;zeros(3,1);zeros(3,1);zeros(3,1)];

ZeroF = zeros(3*NodeQuantity,3);
Phi0 = Lagrangian_Vector_ShapeFunction(linspace(0,Length,NodeQuantity),3,0);
Phie = Lagrangian_Vector_ShapeFunction(linspace(0,Length,NodeQuantity),3,Length);
B = [ ...
	ZeroF,	ZeroF,	ZeroF,	ZeroF;
	ZeroF,	ZeroF,	ZeroF,	ZeroF;
	Phi0',	Phie',	ZeroF,	ZeroF;
	ZeroF,	ZeroF,	Phi0',	Phie';
	ZeroF,	ZeroF,	ZeroF,	ZeroF;
	ZeroF,	ZeroF,	ZeroF,	ZeroF];
Force0 = [0;0;0];
Forcee = [0;0;0];
Moment0 = [0;0;0];
Momente = [0;0;0];
Fext =[Force0;Forcee;Moment0;Momente];

G = zeros(12,18*NodeQuantity);
G(1:3,0*NodeQuantity+[1:3]) = eye(3);
G(4:6,3*NodeQuantity+[1:3]) = eye(3);
G(7:9,6*NodeQuantity+[1:3]) = eye(3);
G(10:12,9*NodeQuantity+[1:3]) = eye(3);
%%
% F = J*K*x + J*V + B*Fext;
% F = J*Q*x + J*V + B*Fext;
alpha = 1;
lambda = -inv(G*inv(M)*G')*G*(inv(M)*(J*Q*x+J*V+B*Fext)+alpha*x);
F = J*Q*x + J*V + B*Fext + G'*lambda;

dx = M\F;
% [max(abs(G*dx)),max(abs(G*x)),max(abs(G*(dx+alpha*x)))]

% % tra
% M(6*NodeQuantity+[1:3],:) = 0;
% M(6*NodeQuantity+[1:3],6*NodeQuantity+[1:3]) = eye(3);
% F(6*NodeQuantity+[1:3]) = 0;
% % rot
% M(9*NodeQuantity+[1:3],:) = 0;
% M(9*NodeQuantity+[1:3],9*NodeQuantity+[1:3]) = eye(3);
% F(9*NodeQuantity+[1:3]) = 0;

dredt = dx(1:3*NodeQuantity);
dphiedt = dx(3*NodeQuantity+1:6*NodeQuantity);
dptraedt = dx(6*NodeQuantity+1:9*NodeQuantity);
dprotedt = dx(9*NodeQuantity+1:12*NodeQuantity);
depsilonedt = dx(12*NodeQuantity+1:15*NodeQuantity);
dkappaedt = dx(15*NodeQuantity+1:18*NodeQuantity);
%%
fprintf('t = %16.14f\n',t);
%%
MechanismFigure = PlotFigureObj.MechanismFigure;
s_plot = linspace(0,Length,NodeQuantity);
r_plot = zeros(3,numel(s_plot));
for k = 1:numel(s_plot)
	Phi3_plot = Lagrangian_Vector_ShapeFunction( ...
		linspace(0,Length,NodeQuantity),3,s_plot(k));
	r_plot(:,k) = Phi3_plot*re;
	% r_plot(:,k) = Phi3_plot*re;
	% Vector_Lagrangian_Interpolation_Value(p_r,s_plot(k));
end
x_plot = r_plot(1,:);
y_plot = r_plot(2,:);
z_plot = r_plot(3,:);
hold(MechanismFigure,'off');
plot3(MechanismFigure,x_plot,y_plot,z_plot,'r.-');
view(MechanismFigure,0,0);%x-z
grid(MechanismFigure,'MINOR');
axis(MechanismFigure,[-1,1,-1,1,-1,1]*20);
%%
do_plot_State = false;
if do_plot_State
plot_TimoshenkoBeam_PortHamilton_Static_StateVariable( ...
	PlotFigureObj,NodeQuantity,Length,re,phie,ptrae,prote,epsilone,kappae);
end
%
drawnow;
end

function plot_TimoshenkoBeam_PortHamilton_Static_StateVariable( ...
	PlotFigureObj,NodeQuantity,Length,re,phie,ptrae,prote,epsilone,kappae)

StaticStateFigure = PlotFigureObj.StaticStateFigure;
% r
AxesObj = StaticStateFigure.r;
qe = re;
InterpolationQuantity = NodeQuantity * 10;
AxesName = 'r';
plot_TimoshenkoBeam_PortHamilton_Single_Static_StateVariable( ...
	AxesObj,qe,Length,NodeQuantity,InterpolationQuantity,AxesName);
%phi
AxesObj = StaticStateFigure.phi;
qe = phie;
InterpolationQuantity = NodeQuantity * 10;
AxesName = 'phi';
plot_TimoshenkoBeam_PortHamilton_Single_Static_StateVariable( ...
	AxesObj,qe,Length,NodeQuantity,InterpolationQuantity,AxesName)
% ptra
AxesObj = StaticStateFigure.ptra;
qe = ptrae;
InterpolationQuantity = NodeQuantity * 10;
AxesName = 'ptra';
plot_TimoshenkoBeam_PortHamilton_Single_Static_StateVariable( ...
	AxesObj,qe,Length,NodeQuantity,InterpolationQuantity,AxesName)
% prot
AxesObj = StaticStateFigure.prot;
qe = prote;
InterpolationQuantity = NodeQuantity * 10;
AxesName = 'prot';
plot_TimoshenkoBeam_PortHamilton_Single_Static_StateVariable( ...
	AxesObj,qe,Length,NodeQuantity,InterpolationQuantity,AxesName)
% epsilon
AxesObj = StaticStateFigure.epsilon;
qe = epsilone;
InterpolationQuantity = NodeQuantity * 10;
AxesName = 'epsilon';
plot_TimoshenkoBeam_PortHamilton_Single_Static_StateVariable( ...
	AxesObj,qe,Length,NodeQuantity,InterpolationQuantity,AxesName)
% kappa
AxesObj = StaticStateFigure.kappa;
qe = kappae;
InterpolationQuantity = NodeQuantity * 10;
AxesName = 'kappa';
plot_TimoshenkoBeam_PortHamilton_Single_Static_StateVariable( ...
	AxesObj,qe,Length,NodeQuantity,InterpolationQuantity,AxesName)

end

function plot_TimoshenkoBeam_PortHamilton_Single_Static_StateVariable( ...
	AxesObj,qe,Length,NodeQuantity,InterpolationQuantity,AxesName)

s_plot = linspace(0,Length,InterpolationQuantity);
r_plot = zeros(3,numel(s_plot));
for k = 1:numel(s_plot)
	Phi3_plot = Lagrangian_Vector_ShapeFunction( ...
		linspace(0,Length,NodeQuantity),3,s_plot(k));
	r_plot(:,k) = Phi3_plot*qe;
end
x_plot = r_plot(1,:);
y_plot = r_plot(2,:);
z_plot = r_plot(3,:);
hold(AxesObj,'off');
plot(AxesObj,s_plot,x_plot,'r-');
hold(AxesObj,'on');
plot(AxesObj,s_plot,y_plot,'b-');
plot(AxesObj,s_plot,z_plot,'g-');
hold(AxesObj,'off');
legend(AxesObj,'x','y','z');
grid(AxesObj,'MINOR');
title(AxesObj,AxesName);

end