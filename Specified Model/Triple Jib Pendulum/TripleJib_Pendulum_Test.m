% TripleJib_Pendulum_Test
%%
clc;clear;close all;
ExcelFileName = ...
	'Triple Jib Pendulum';
ExcelFileDir = [...
	'Parameter File'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%%
phi_s = 0;
phi_1 = 0;
phi_2 = 0;
phi_y = 0;
phi_z = 0;
q = [phi_s;phi_1;phi_2;phi_y;phi_z];
%
dphi_sdt = 0;
dphi_1dt = 0;
dphi_2dt = 0;
dphi_ydt = 0;
dphi_zdt = 0;
dq = [dphi_sdt;dphi_1dt;dphi_2dt;dphi_ydt;dphi_zdt];
%
[qb,dqb,Tb,dTb] = get_TripleJib_Pendulum_ElementCoordinate(...
	q,dq,ModelParameter);
%
u = [0;2e5;1e5];
%%
t = 0;
x = [q;dq];
ComputingFigure = figure('Name','3DoF Folding Boom');
ComputingFigure = axes(ComputingFigure);
dx = TripleJib_Pendulum_Dynamic_func(...
	t,x,u,ModelParameter,SolverParameter,ComputingFigure);
%%
SystemForceFcn = @(u)TripleJib_Pendulum_Dynamic_Force(...
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
u = [1e6;u_Static(2)*1.05;u_Static(3)*0.95];
% u = [1e4;u_Static(2);u_Static(3)];
%%
x0 = x;
tspan = [0,3];
AbsoluteTolerance = SolverParameter.ODE_Solver.AbsTol;
RelativeTolerance = SolverParameter.ODE_Solver.RelTol;
MaxStep = SolverParameter.ODE_Solver.MaxStep;
opt = odeset('RelTol',RelativeTolerance, ...
	'AbsTol',AbsoluteTolerance, ...
	'MaxStep',MaxStep, ...
	'OutputFcn',[]);
%
[t_set,x_set] = Runge_Kutta_4(...
	@(t,x)TripleJib_Pendulum_Dynamic_func(...
	t,x,u,ModelParameter,SolverParameter,ComputingFigure), ...
	tspan,x0,opt);
