clear;close all;
%%
gx = [1;0;0];
gy = [0;1;0];
gz = [0;0;1];
WinchRadius = 1;
CableRadius = 0.1;
WinchLength = 0.2;
%%
ra  = CableRadius;
ri  = 0;
L = 10;
E = 2.06e11;
v = 0.25;
g = [0;0;-9.8];
rho = 7800;
%%
G  = E / (2*(1+v));
A  = pi*(ra^2-ri^2);
Iy = pi*(2*ra)^4*(1-((ri/ra)^4))/64;
Iz = pi*(2*ra)^4*(1-((ri/ra)^4))/64;


CableParameter.L  = L;
CableParameter.E  = E;
CableParameter.G  = G;
CableParameter.A  = A;
CableParameter.Iy = Iy;
CableParameter.Iz = Iz;
CableParameter.rho = rho;

WinchMass = rho/100*(pi*WinchRadius^2)*WinchLength;
WinchParameter.m = WinchMass;
WinchParameter.r_B_0C = [WinchLength/2;0;0];
WinchParameter.theta_B_0 = ...
	[1/2*WinchMass*(WinchRadius^2),0,0;
	0,1/3*WinchMass*WinchLength^2,0;
	0,0,1/3*WinchMass*WinchLength^2];;


phiwc0 = 0/2*pi;
rwc0x = 0/2 * WinchLength;
HelixRadius = sqrt(WinchRadius^2 + CableRadius^2/(pi^2));

BodyParameter.CableParameter = CableParameter;
BodyParameter.WinchParameter = WinchParameter;
BodyParameter.WinchRadius = WinchRadius;
BodyParameter.CableRadius = CableRadius;
BodyParameter.WinchLength = WinchLength;
BodyParameter.phiwc0 = phiwc0;
BodyParameter.rwc0x = rwc0x;
BodyParameter.HelixRadius = HelixRadius;
%%
sw = pi/2*HelixRadius;

r0A = [0;0;0];
phiA = [0;0;0];
thetap = 0;
thetaw = 0;
dthetawdx = 1/HelixRadius;
sw = thetap*HelixRadius;
r0c = [0;WinchRadius;-L-sw];
dr0cdx = [0;0;1];
%%
dr0Adt = [0;0;0];
omegaA = [0;0;0];
dthetapdt = 0;
dthetawdt = 0;
ddthetawdxdt = 0;
dswdt = 1/dthetawdx*(dthetawdt-dthetapdt);
%%
rw = BodyParameter.WinchRadius;
rc = BodyParameter.CableRadius;
rh = BodyParameter.HelixRadius;
h = 2*rc;
%
RA = get_R(phiA);
Rxw = get_R_x(thetaw);
Txw = get_T_x(thetaw);
dTxw = get_dT_x(thetaw);
%
rAw = h/(2*pi)*thetaw*gx + rw*Rxw*gy;
tw = 1/rh*(h/(2*pi)*gx + rw*Txw*gy);
nw = dTxw*gy;
%
r0w = r0A + RA*rAw;
dr0wdx = rh*RA*tw*dthetawdx;
qw = [r0w;dr0wdx];
%
r0c = r0w - (L+sw)*dr0wdx;
dr0cdx = dr0wdx;
dr0cdt = [0;0;0];
ddr0cdxdt = [0;0;0];
%%
q = [r0A;phiA; ...
	thetap; ...
	thetaw;dthetawdx;sw; ...
	r0c;dr0cdx];
dq = [dr0Adt;omegaA; ...
	dthetapdt; ...
	dthetawdt;ddthetawdxdt;dswdt; ...
	dr0cdt;ddr0cdxdt];
%%
CalcPlotFigure = figure('Name','State during Calculation');
CalcPlotFigure = axes(CalcPlotFigure);
opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',0.02, ...
	'OutputFcn',[]);%@odeplot
tspan = [0;5];
x0 = [q;dq];
[t_set,x_set] = ode23tb(...
	@(t,x)WinchCable_MassForce_Test_ode_func(...
	t,x,g,BodyParameter,CalcPlotFigure), ...
	tspan,x0,opt);
%%
function dx = WinchCable_MassForce_Test_ode_func(...
	t,x,g,BodyParameter,FigureObj)
%%
q = x(1:numel(x)/2);
dq = x(numel(x)/2+1:end);

q(7) = 1*t;
dq(7) = 1;
%%
[Mass,Force] = WinchCable_MassForce(...
	q,dq,g,BodyParameter);
%%
Mass(1:6,:) = 0;
Mass(1:6,1:6) = eye(6);
Force(1:6) = 0;

Mass(7,:) = 0;
Mass(7,7) = 1;
Force(7) = 0;

% Force(13) = Force(13)+100;
% Force(7) = Force(7)-20000;
ddq = -Mass\Force;
%%
dthetawdx = q(9);
dthetapdt = dq(7);
dthetawdt = dq(8);

dqdt = dq;
dqdt(4:6) = get_T(q(4:6))\dq(4:6);
dqdt(10) = 1/dthetawdx*(dthetawdt-dthetapdt);
% [dqdt(10),1/dthetawdx*(dthetawdt-dthetapdt)]
dx = [dqdt;ddq];
%%
fprintf('t=%16.14f\n',t);
hold(FigureObj,'off');
plot3(0,0,0);
hold(FigureObj,'on');
plot_WinchCableSystem(q,BodyParameter,FigureObj);
axis([-1,1,-1,1,-1,1]*10);
xlabel('x');ylabel('y');zlabel('z');
view(90,0);
grid on;
grid MINOR;
pause(0.001);
end