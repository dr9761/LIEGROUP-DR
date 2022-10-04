
function dx = PendulumWithMovingJoint_Dynamic_func(t,x, ...
	ModelParameter,SolverParameter,ComputingFigure,u)
%%
q = x(1:numel(x)/2);
dq = x(numel(x)/2+1:end);
%%
g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;
L = BodyElementParameter{1}.L;
t_total = SolverParameter.ODE_Solver.t_end - SolverParameter.ODE_Solver.t_start;
gx = [1;0;0];
%%
r0 = q(1:3);
alpha = q(4);
beta = q(5);

dalphadt = dq(4);
dbetadt = dq(5);
if nargin < 6
	u(1) = 0.1*sin(2*pi*t/t_total);
	u(2) = -0.1*sin(2*pi*t/t_total);
	u(3) = 0;
end
%%
Tr = [eye(3), [...
	-L*cos(alpha)*cos(beta),	L*sin(alpha)*sin(beta);
	0,							L*cos(beta);
	L*sin(alpha)*cos(beta),		L*cos(alpha)*sin(beta)]];
dTrdt = [zeros(3), [...
	L*sin(alpha)*cos(beta)*dalphadt+L*cos(alpha)*sin(beta)*dbetadt,	L*cos(alpha)*sin(beta)*dalphadt+L*sin(alpha)*cos(beta)*dbetadt;
	0,														-L*sin(beta)*dbetadt;
	L*cos(alpha)*cos(beta)*dalphadt-L*sin(alpha)*sin(beta)*dbetadt,	-L*sin(alpha)*sin(beta)*dalphadt+L*cos(alpha)*cos(beta)*dbetadt]];
M = Tr'*Tr;
D = Tr'*dTrdt;
Fg = -Tr'*g;
F = D*dq + Fg;
%%
M(1:3,:) = 0;
M(1:3,1:3) = eye(3);
F(1:3) = -u;
ddq = -M\F;
dx = [dq;ddq];
%%
if isa(x,'double') && false
RB = get_R_y(alpha+pi/2)*get_R_z(beta);
r1 = r0 + RB*gx*L;
r01 = [r0,r1];
hold(ComputingFigure,'off');
plot3(ComputingFigure,0,0,0,'k*');
hold(ComputingFigure,'on');
plot3(ComputingFigure,r01(1,:),r01(2,:),r01(3,:),'r.-');
plot3(ComputingFigure,r1(1),r1(2),r1(3),'ko');
axis(ComputingFigure,[-10,10,-10,10,-15,5]);
view(ComputingFigure,-37.5,30);
grid(ComputingFigure,'on');
grid(ComputingFigure,'MINOR');
drawnow;
%
fprintf('t = %16.14f\n',t);
end
end