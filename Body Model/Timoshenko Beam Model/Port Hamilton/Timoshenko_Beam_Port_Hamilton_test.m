% Timoshenko_Beam_Port_Hamilton_test
clear;clc;close all;
%%
r01 = [0;0;0];
r02 = [5;0;0];
r03 = [10;0;0];
r04 = [15;0;0];
r = [r01;r02;r03;r04];
% r = [r01;r02;r03];
% r = [r01;r02];
%%
phi1 = [0;0;0];
phi2 = [0;0;0];
phi3 = [0;0;0];
phi4 = [0;0;0];
phi = [phi1;phi2;phi3;phi4];
% phi = [phi1;phi2;phi3];
% phi = [phi1;phi2];
%
q = [r;phi];
%%
ptra1 = [0;0;0];
ptra2 = [0;0;0];
ptra3 = [0;0;0];
ptra4 = [0;0;0];
ptra = [ptra1;ptra2;ptra3;ptra4];
% ptra = [ptra1;ptra2;ptra3];
% ptra = [ptra1;ptra2];

prot1 = [0;0;0];
prot2 = [0;0;0];
prot3 = [0;0;0];
prot4 = [0;0;0];
prot = [prot1;prot2;prot3;prot4];
% prot = [prot1;prot2;prot3];
% prot = [prot1;prot2];
%
p = [ptra;prot];
%%
epsilon1 = [0;0;0];
epsilon2 = [0;0;0];
epsilon3 = [0;0;0];
epsilon4 = [0;0;0];
epsilon = [epsilon1;epsilon2;epsilon3;epsilon4];
% epsilon = [epsilon1;epsilon2;epsilon3];
% epsilon = [epsilon1;epsilon2];
%%
kappa1 = [0;0;0];
kappa2 = [0;0;0];
kappa3 = [0;0;0];
kappa4 = [0;0;0];
kappa = [kappa1;kappa2;kappa3;kappa4];
% kappa = [kappa1;kappa2;kappa3];
% kappa = [kappa1;kappa2];
%%
x = [r;phi;ptra;prot;epsilon;kappa];
%%
rho = 7800;
E   = 2.06e10;
v   = 0.25;
ra  = 0.2;
ri  = 0;

G  = E / (2*(1+v));
A  = pi*(ra^2-ri^2);
Iy = pi*(2*ra)^4*(1-((ri/ra)^4))/64;
Iz = pi*(2*ra)^4*(1-((ri/ra)^4))/64;

BodyParameter.rho = rho;
BodyParameter.A = A;
BodyParameter.E = E;
BodyParameter.G = G;
BodyParameter.Iy = Iy;
BodyParameter.Iz = Iz;
% BodyParameter.Je = 1;
BodyParameter.L = 15;
BodyParameter.J = diag([Iy+Iz,Iz,Iy]);
%%
MechanismFigure = figure('Name','Mechanism');
MechanismFigure = axes(MechanismFigure);
PlotFigureObj.MechanismFigure = MechanismFigure;

CalcPlotFigure = figure('Name','CalcPlotFigure');
StaticStateFigure.r			= subplot(3,2,1,'Parent',CalcPlotFigure);
StaticStateFigure.phi		= subplot(3,2,2,'Parent',CalcPlotFigure);
StaticStateFigure.ptra		= subplot(3,2,3,'Parent',CalcPlotFigure);
StaticStateFigure.prot		= subplot(3,2,4,'Parent',CalcPlotFigure);
StaticStateFigure.epsilon	= subplot(3,2,5,'Parent',CalcPlotFigure);
StaticStateFigure.kappa		= subplot(3,2,6,'Parent',CalcPlotFigure);
PlotFigureObj.StaticStateFigure = StaticStateFigure;
%% Shape Function
% [Mass,Force] = ...
% 	TimoshenkoBeam_MassForce_PortHamilton( ...
% 	r,phi,ptra,prot,epsilon,kappa,BodyParameter);

t = 0;
dx = TimoshenkoBeam_MassForce_PortHamilton( ...
	t,x,BodyParameter,PlotFigureObj);
%%
x0 = x;
tspan = [0;2];
opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.02);
% opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.02, ...
% 	'OutputFcn',@odeplot);
% [t_set,x_set] = Runge_Kutta_4(...
% 	@(t,x)TimoshenkoBeam_MassForce_PortHamilton(...
% 	t,x,BodyParameter), ...
% 	tspan,x0,opt);
[t_set,x_set] = ode23tb(...
	@(t,x)TimoshenkoBeam_MassForce_PortHamilton(...
	t,x,BodyParameter,PlotFigureObj), ...
	tspan,x0,opt);
