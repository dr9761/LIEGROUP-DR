% FoldingBoom_3DoF_Hydraulic_Test
%%
clc;clear;close all;
ExcelFileName = ...
	'Folding Boom - Rigid 3DoF Hydraulic';
ExcelFileDir = [...
	'Parameter File', ...
	'\Folding Boom System\Controllable System'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);

HydraulicOilParameter.E = 1.29e9;

HydraulicCylinderElementParameter.L = 2.85;
HydraulicCylinderElementParameter.A = 0.08;
HydraulicCylinderElementParameter.alpha = 0.75;
HydraulicCylinderParameter{1} = HydraulicCylinderElementParameter;

HydraulicCylinderElementParameter.L = 2.45;
HydraulicCylinderElementParameter.A = 0.08;
HydraulicCylinderElementParameter.alpha = 0.75;
HydraulicCylinderParameter{2} = HydraulicCylinderElementParameter;

HydraulicParameter.HydraulicCylinderParameter = HydraulicCylinderParameter;
HydraulicParameter.HydraulicOilParameter = HydraulicOilParameter;
ModelParameter.HydraulicParameter = HydraulicParameter;
%%
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
p1 = 1e7;
p2 = 1e7;
p = [p1;p2];
%
ut = 0;
u1 = 2.5*0.25*0.08/100;
u2 = 2.0*0.25*0.08/100;
u = [ut;u1;u2];
%%
t = 0;
x = [q;dq;p];
ComputingFigure = figure('Name','3DoF Folding Boom');
ComputingFigure = axes(ComputingFigure);
% dx = FoldingBoom_3DoF_Hydraulic_Dynamic_func(t,x,u, ...
% 	ModelParameter,SolverParameter,ComputingFigure);
%%
% dpsi = 0;
% dphi1 = deg2rad(0);
% dphi2 = deg2rad(0);
% q = [dpsi;dphi1;dphi2];
% x = [q;dq;p];
% FoldingBoom_3DoF_Hydraulic_Dynamic_func(...
% 	t,x,u,ModelParameter,SolverParameter,ComputingFigure);
% %
% dpsi = 0;
% dphi1 = deg2rad(85);
% dphi2 = deg2rad(170);
% q = [dpsi;dphi1;dphi2];
% x = [q;dq];
% FoldingBoom_3DoF_Dynamic_func(...
% 	t,x,u,ModelParameter,SolverParameter,ComputingFigure);
%%
p0 = 1e7*[1;1];
SystemForceFcn = @(p)FoldingBoom_3DoF_Hydraulic_Dynamic_Force(...
	q,p,ModelParameter);
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
[p_Static,Force_Static,StaticFlag,output,jacobian] = ...
	fsolve(SystemForceFcn,p0,opt);
StaticError = SystemForceFcn(p_Static);
MaxAbsStaticError=max(abs(StaticError));
%%
x0 = [q;dq;p_Static];
% tspan = [0,2.8];
tspan = [0,100];
% tspan = [0,0.01];
AbsoluteTolerance = SolverParameter.ODE_Solver.AbsTol;
RelativeTolerance = SolverParameter.ODE_Solver.RelTol;
MaxStep = SolverParameter.ODE_Solver.MaxStep;
MaxStep = 5;
opt = odeset('RelTol',RelativeTolerance, ...
	'AbsTol',AbsoluteTolerance, ...
	'MaxStep',MaxStep, ...
	'OutputFcn',[]);
%
[t_set,x_set] = ode23tb(...
	@(t,x)FoldingBoom_3DoF_Hydraulic_Dynamic_func(...
	t,x,u,ModelParameter,SolverParameter,ComputingFigure), ...
	tspan,x0,opt);
%Runge_Kutta_4