% FoldingBoom_3DoF_Test
%%
clc;clear;close all;
ExcelFileName = ...
	'Folding Boom - Rigid 3DoF';
ExcelFileDir = [...
	'Parameter File', ...
	'\Folding Boom System\Controllable System'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%%
dpsi = 0;
dphi1 = deg2rad(0);
dphi2 = deg2rad(0);
q = [dpsi;dphi1;dphi2];
%
ddpsidt = 0;
ddphi1dt = 0;
ddphi2dt = 0;
dq = [ddpsidt;ddphi1dt;ddphi2dt];
%
ut = 0;
u1 = 1e6;
u2 = 1e6;
u = [ut;u1;u2];
%%
t = 0;
x = [q;dq];
ComputingFigure = figure('Name','3DoF Folding Boom');
ComputingFigure = axes(ComputingFigure);
% dx = FoldingBoom_3DoF_Dynamic_func(t,x,u, ...
% 	ModelParameter,SolverParameter,ComputingFigure);
%%
x0 = x;
tspan = [0,2];
AbsoluteTolerance = SolverParameter.ODE_Solver.AbsTol;
RelativeTolerance = SolverParameter.ODE_Solver.RelTol;
MaxStep = SolverParameter.ODE_Solver.MaxStep;
MaxStep = 0.05;
opt = odeset('RelTol',RelativeTolerance, ...
	'AbsTol',AbsoluteTolerance, ...
	'MaxStep',MaxStep, ...
	'OutputFcn',[]);
%
[t_set,x_set] = Runge_Kutta_4(...
	@(t,x)FoldingBoom_3DoF_Dynamic_func(...
	t,x,u,ModelParameter,SolverParameter,ComputingFigure), ...
	tspan,x0,opt);
