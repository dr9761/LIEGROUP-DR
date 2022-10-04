% SingleJib_Pendulum_Test
%%
clc;clear;close all;
ExcelFileName = ...
	'Single Jib Pendulum';
ExcelFileDir = [...
	'Parameter File'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%%
phi_s = 0;
phi_y = 0;
phi_z = 0;
q = [phi_s;phi_y;phi_z];
%
dphi_sdt = 0;
dphi_ydt = 0;
dphi_zdt = 0;
dq = [dphi_sdt;dphi_ydt;dphi_zdt];
%
u = 5e4;
%%
t = 0;
x = [q;dq];
ComputingFigure = figure('Name','3DoF Folding Boom');
ComputingFigure = axes(ComputingFigure);
% dx = SingleJib_Pendulum_Dynamic_func(...
% 	t,x,u,ModelParameter,SolverParameter,ComputingFigure);
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
[t_set,x_set] = ode23tb(...
	@(t,x)SingleJib_Pendulum_Dynamic_func(...
	t,x,u,ModelParameter,SolverParameter,ComputingFigure), ...
	tspan,x0,opt);
