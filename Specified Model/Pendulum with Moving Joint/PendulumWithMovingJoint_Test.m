% PendulumWithMovingJoint_Test
%%
clc;clear;close all;
ExcelFileName = ...
	'Pendulum with Moving Joint';
ExcelFileDir = [...
	'Parameter File', ...
	'\Pendulum Test'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%%
r0 = [0;0;0];
alpha = 0;
beta = 0;
q = [r0;alpha;beta];
%
dr0dt = [0;0;0];
dalphadt = 0;
dbetadt = 0;
dq = [dr0dt;dalphadt;dbetadt];
%
% ddr0dtdt = [0;0;0];
% u = ddr0dtdt;
%%
t = 0;
x = [q;dq];
ComputingFigure = figure('Name','3DoF Folding Boom');
ComputingFigure = axes(ComputingFigure);
dx = PendulumWithMovingJoint_Dynamic_func(t,x, ...
	ModelParameter,SolverParameter,ComputingFigure);
%%
x0 = x;
tspan = [SolverParameter.ODE_Solver.t_start,SolverParameter.ODE_Solver.t_end];
AbsoluteTolerance = SolverParameter.ODE_Solver.AbsTol;
RelativeTolerance = SolverParameter.ODE_Solver.RelTol;
MaxStep = SolverParameter.ODE_Solver.MaxStep;
MaxStep = 0.02;
opt = odeset('RelTol',RelativeTolerance, ...
	'AbsTol',AbsoluteTolerance, ...
	'MaxStep',MaxStep, ...
	'OutputFcn',[]);
%
% [t_set,x_set] = Runge_Kutta_4(...
% 	@(t,x)PendulumWithMovingJoint_Dynamic_func(...
% 	t,x,ModelParameter,SolverParameter,ComputingFigure), ...
% 	tspan,x0,opt);
[t_set,x_set] = Runge_Kutta_4_PID(...
	@(t,x,u)PendulumWithMovingJoint_Dynamic_func(...
	t,x,ModelParameter,SolverParameter,ComputingFigure,u), ...
	tspan,x0,opt);
%
AngleStateFigure = figure('Name','Angle State');
AngleStateAxes = subplot(3,1,1,'Parent',AngleStateFigure);
AngleVelocityAxes = subplot(3,1,2,'Parent',AngleStateFigure);
AngleAccelerationAxes = subplot(3,1,3,'Parent',AngleStateFigure);
y_set = x_set(:,4:5)';
dy_set = x_set(:,9:10)';
ddy_set = [zeros(2,1),1/MaxStep*diff(dy_set')'];
r0_set = x_set(:,1:3)';
dr0dt_set = x_set(:,6:8)';
ddr0dtdt_set = [zeros(3,1),1/MaxStep*diff(dr0dt_set')'];

y_d_set = zeros(2,numel(t_set));
dy_d_set = zeros(2,numel(t_set));
ddy_d_set = zeros(2,numel(t_set));
u_set = zeros(3,numel(t_set));
u_d_set = zeros(3,numel(t_set));
DesignedTrajectoryFunc = @(t)DesignedTrajectoryFunc_PendulumWithMovingJoint(t);
for tNr = 1:numel(t_set)
	t = t_set(tNr);
	[y_d_set(:,tNr),dy_d_set(:,tNr),ddy_d_set(:,tNr)] = ...
		DesignedTrajectoryFunc_PendulumWithMovingJoint(t);
	u_set(:,tNr) = PID_Controller(x_set',DesignedTrajectoryFunc,t,MaxStep, ...
		'Pendulum with Moving Joint','normal');
	ddrzdtdt = 0;
	L = ModelParameter.BodyElementParameter{1}.L;
	g = norm(ModelParameter.g);
	u_d_set(:,tNr) = get_IdealAcceleration_PendulumWithMovingJoint(...
		t,DesignedTrajectoryFunc,ddrzdtdt,L,g);
end

plot(AngleStateAxes,t_set,y_set,'-',t_set,y_d_set,'--');
legend(AngleStateAxes,'\alpha','\beta', ...
	'\alpha_{designed}','\beta_{designed}', ...
	'Location','eastoutside');
grid(AngleStateAxes,'on');grid(AngleStateAxes,'MINOR');
plot(AngleVelocityAxes,t_set,dy_set,'-',t_set,dy_d_set,'--');
legend(AngleVelocityAxes,'d\alpha/dt','d\beta/dt', ...
	'd\alpha_{designed}/dt','d\beta_{designed}/dt', ...
	'Location','eastoutside');
grid(AngleVelocityAxes,'on');grid(AngleVelocityAxes,'MINOR');
plot(AngleAccelerationAxes,t_set,ddy_set,'-',t_set,ddy_d_set,'--');
legend(AngleAccelerationAxes,'d^2\alpha/{dt}^2','d^2\beta/{dt}^2', ...
	'd^2\alpha_{designed}/{dt}^2','d^2\beta_{designed}/{dt}^2', ...
	'Location','eastoutside');
grid(AngleAccelerationAxes,'on');grid(AngleAccelerationAxes,'MINOR');
%
ControlFigure = figure('Name','Control Variables');
ControlAxes_1 = subplot(3,1,1,'Parent',ControlFigure);
ControlAxes_2 = subplot(3,1,2,'Parent',ControlFigure);
ControlAxes_3 = subplot(3,1,3,'Parent',ControlFigure);

plot(ControlAxes_1,t_set,u_set(1,:),'-',t_set,u_d_set(1,:),'--');
legend(ControlAxes_1,'u_1','u_{1,theoretic}', ...
	'Location','eastoutside');
grid(ControlAxes_1,'on');grid(ControlAxes_1,'MINOR');
plot(ControlAxes_2,t_set,u_set(2,:),'-',t_set,u_d_set(2,:),'--');
legend(ControlAxes_2,'u_2','u_{2,theoretic}', ...
	'Location','eastoutside');
grid(ControlAxes_2,'on');grid(ControlAxes_2,'MINOR');
plot(ControlAxes_3,t_set,u_set(3,:),'-',t_set,u_d_set(3,:),'--');
legend(ControlAxes_3,'u_3','u_{3,theoretic}', ...
	'Location','eastoutside');
grid(ControlAxes_3,'on');grid(ControlAxes_3,'MINOR');
%%
fprintf('Final Location:[%6.4f;\t%6.4f;\t%6.4f]\n',x_set(end,1),x_set(end,2),x_set(end,3));

%%
% t_sym = sym('t',[1,1]);
% x_sym = sym('x',[10,1]);
% u_sym = sym('u',[3,1]);
% dx_sym = PendulumWithMovingJoint_Dynamic_func(t_sym,x_sym, ...
% 	ModelParameter,SolverParameter,ComputingFigure,u_sym);

function ddrdtdt = get_IdealAcceleration_PendulumWithMovingJoint(...
	t,DesignedTrajectoryFunc,ddrzdtdt,L,g)

[y_d,dy_d,ddy_d] = DesignedTrajectoryFunc(t);
alpha = y_d(1);
dalphadt = dy_d(1);
ddalphadtdt = ddy_d(1);
beta = y_d(2);
dbetadt = dy_d(2);
ddbetadtdt = ddy_d(2);
% [alpha,dalphadt,ddalphadtdt] = AngleFunction(t,T1_alpha,T2_alpha);
% [beta,dbetadt,ddbetadtdt] = AngleFunction(t,T1_beta,T2_beta);

M = [-cos(alpha)*cos(beta),		0;
	sin(alpha)*sin(beta),		cos(beta)];
F = [...
	sin(alpha)*cos(beta)*ddrzdtdt+L*(cos(beta))^2*ddalphadtdt+g*sin(alpha)*cos(beta)-L*sin(2*beta)*dalphadt*dbetadt;
	cos(alpha)*sin(beta)*ddrzdtdt+L*ddbetadtdt+g*cos(alpha)*sin(beta)+L/2*sin(2*beta)*dalphadt*dalphadt];
ddrdtdt = -M\F;
ddrdtdt = [ddrdtdt;ddrzdtdt];
end