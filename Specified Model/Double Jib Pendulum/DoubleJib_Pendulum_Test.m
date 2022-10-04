% DoubleJib_Pendulum_Test
%%
clc;clear;close all;
ExcelFileName = ...
	'Double Jib Pendulum';
ExcelFileDir = [...
	'Parameter File'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%%
phi_s = 0;
phi_1 = 0;
phi_y = 0;
phi_z = 0;
q = [phi_s;phi_1;phi_y;phi_z];
%
dphi_sdt = 0;
dphi_1dt = 0;
dphi_ydt = 0;
dphi_zdt = 0;
dq = [dphi_sdt;dphi_1dt;dphi_ydt;dphi_zdt];
%
u = [0;1e5];
%%
t = 0;
x = [q;dq];
ComputingFigure = figure('Name','3DoF Folding Boom');
ComputingFigure = axes(ComputingFigure);
% dx = DoubleJib_Pendulum_Dynamic_func(...
% 	t,x,u,ModelParameter,SolverParameter,ComputingFigure);
%%
q0 = ModelParameter.InitialState.q0;
SystemForceFcn = @(u)DoubleJib_Pendulum_Dynamic_Force(...
	q,u,ModelParameter);
%
opt = optimoptions('fsolve', ...
	'Algorithm','trust-region', ...
	'StepTolerance',1e-15, ...
	'FunctionTolerance',1e-15, ...
	'SpecifyObjectiveGradient',false, ...
	'Display','iter', ...
	'MaxIterations',40000, ...
	'MaxFunctionEvaluations',2000000, ...
	'PlotFcn',[]);
[u_Static,Force_Static,StaticFlag,output,jacobian] = ...
	fsolve(SystemForceFcn,u,opt);
StaticError = SystemForceFcn(u_Static);
MaxAbsStaticError=max(abs(StaticError));
%
u = [1e4;u_Static(2)*1.01];
% u = [1e4;u_Static(2)];
%%
x0 = x;
tspan = [0,5];
AbsoluteTolerance = SolverParameter.ODE_Solver.AbsTol;
RelativeTolerance = SolverParameter.ODE_Solver.RelTol;
MaxStep = SolverParameter.ODE_Solver.MaxStep;
opt = odeset('RelTol',RelativeTolerance, ...
	'AbsTol',AbsoluteTolerance, ...
	'MaxStep',MaxStep, ...
	'OutputFcn',[]);
%
[t_set,x_set] = Runge_Kutta_4(...
	@(t,x)DoubleJib_Pendulum_Dynamic_func(...
	t,x,u,ModelParameter,SolverParameter,ComputingFigure), ...
	tspan,x0,opt);
