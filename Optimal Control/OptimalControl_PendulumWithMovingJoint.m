% OptimalControl_PendulumWithMovingJoint
%%
clear; close all; clc;
%%
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
%%
t_Nr = 0;
x = [q;dq];
%%
x0 = x;
x_min = [-100;-100;-100;-deg2rad(85);-deg2rad(85); ...
		 -100;-100;-100;		-100;		-100];
x_max = [ 100; 100; 100; deg2rad(85); deg2rad(85); ...
		  100; 100; 100;		 100;		 100];
u_min = [-100;-100;0];
u_max = [ 100; 100;0];
n_x = numel(x_min);
n_u = numel(u_min);
ts = 0.01;tf = 10;
N_NMPC = 1;
%
CostParameters.ProblemName = 'Pendulum with Moving Joint - Tracking';
CostParameters.Q = diag([1,1]);


DynamicsFuncHandle = @(x,u)PendulumWithMovingJoint_Dynamic_func(t_Nr,x, ...
	ModelParameter,SolverParameter,[],u);
% StageCostFuncHandle = @(x,u)define_stage_cost(x,u,CostParameters);
% TerminalCostFuncHandle = @(x)define_terminal_cost(x,CostParameters);
% TerminalConstraintFuncHandle = @(x)define_terminal_constraint(x,CostParameters);
%%
d.c.mpc = import_mpctools();
d.p.x0 = x0;
d = build_setup(d, ...
	x_min,x_max,u_min,u_max, ...
	n_x,n_u,ts,tf,N_NMPC,x0);
d = create_simulator(d,DynamicsFuncHandle);

for t_Nr = 1:d.p.t_final
	t = (t_Nr-1) * ts;
	[phi_d,~,~] = DesignedTrajectoryFunc_PendulumWithMovingJoint(t);
	alpha_d = phi_d(1);
	beta_d  = phi_d(2);
	
	CostParameters.alpha_d = alpha_d;
	CostParameters.beta_d = beta_d;
	
	StageCostFuncHandle = @(x,u)define_stage_cost(x,u,CostParameters);
	TerminalCostFuncHandle = @(x)define_terminal_cost(x,CostParameters);
	TerminalConstraintFuncHandle = @(x)define_terminal_constraint(x,CostParameters);
	
	d = create_NMPC(d,DynamicsFuncHandle, ...
		StageCostFuncHandle,TerminalCostFuncHandle, ...
		TerminalConstraintFuncHandle);
	
	d = solve_NMPC(d,t_Nr);
	d = evolve_dynamics(d,t_Nr);
	% 	d.p.N_NMPC = max(d.p.N_NMPC-1,50);
	% 	d.p.T = ts;
	fprintf('t = %6.4f\n',d.p.T*t_Nr);
end
d = rmfield(d,'c');
%%
StateTimeFigure = figure('Name','State-Time');
StateAxes_r0 = subplot(3,1,1,'Parent',StateTimeFigure);
StateAxes_phi = subplot(3,1,2,'Parent',StateTimeFigure);
ControlAxes = subplot(3,1,3,'Parent',StateTimeFigure);

plot(StateAxes_r0,ts*[0:size(d.s.x,2)-1],d.s.x(1:3,:));
legend(StateAxes_r0,'r_{0,x}','r_{0,y}','r_{0,z}', ...
	'Location','eastoutside');
grid(StateAxes_r0,'on');grid(StateAxes_r0,'MINOR');

plot(StateAxes_phi,ts*[0:size(d.s.x,2)-1],d.s.x(4:5,:));
legend(StateAxes_phi,'\alpha','\beta', ...
	'Location','eastoutside');
grid(StateAxes_phi,'on');grid(StateAxes_phi,'MINOR');

plot(ControlAxes,ts*[0:size(d.s.u,2)-1],d.s.u);
legend(ControlAxes,'u_{1}','u_{2}','u_{3}', ...
	'Location','eastoutside');
grid(ControlAxes,'on');grid(ControlAxes,'MINOR');