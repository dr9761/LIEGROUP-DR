% FoldingBoom_3DoF_ValveControlHydraulic_Test
%%
clc;clear;close all;
ExcelFileName = ...
	'Folding Boom - Rigid 3DoF Hydraulic';
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
pL1 = 10;
pL2 = 1;
pU1 = 10;
pU2 = 1;
p = [pL1;pL2;pU1;pU2];
%
ut = 0;
u1 = 0;
u2 = 0;
u = [ut;u1;u2];
%
t = 0;
x = [q;dq;p];
%%
ExcelFilePath = 'Parameter File\Hydraulic System Test\Hydraulic System Test - 2.xlsx';

[HydraulicOilParameter,HydraulicElementParameter,HydraulicCoordinateQuantity] = ...
	create_HydraulicElement(ExcelFilePath);
HydraulicConnectionParameter = create_HydraulicConnection(ExcelFilePath);

HydraulicSymbolicStateSolution = create_HydraulicCalculationEquation(...
	HydraulicOilParameter,HydraulicElementParameter, ...
	HydraulicConnectionParameter);
%%
HydraulicParameter.HydraulicElementParameter = HydraulicElementParameter;
HydraulicParameter.HydraulicOilParameter = HydraulicOilParameter;
HydraulicParameter.HydraulicConnectionParameter = HydraulicConnectionParameter;
HydraulicParameter.HydraulicCoordinateQuantity = HydraulicCoordinateQuantity;

HydraulicParameter.HydraulicSymbolicStateSolution = HydraulicSymbolicStateSolution;
HydraulicParameter.HydraulicSymbolicStateSolutionHandle = ...
	matlabFunction(HydraulicSymbolicStateSolution.SymbolicCalculatedHydraulicElementState);

HydraulicParameter.HydraulicNumericalEquationHandle = ...
	@(HydraulicState)create_HydraulicCalculationEquation_Numerical(HydraulicState,x,u, ...
	HydraulicOilParameter,HydraulicElementParameter, ...
	HydraulicConnectionParameter);
%%
ComputingFigure = figure('Name','3DoF Folding Boom');
ComputingFigure = axes(ComputingFigure);

%%
p0 = 1e1*[1;0.1;1;0.1];
SystemForceFcn = @(p)FoldingBoom_3DoF_ValveControlHydraulic_Dynamic_func(...
	0,[zeros(6,1);p],zeros(3,1),zeros(3,1),[0,1], ...
	ModelParameter,HydraulicParameter,SolverParameter,[]);
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
dx = FoldingBoom_3DoF_ValveControlHydraulic_Dynamic_func(t,x0,u,u,[0,1], ...
	ModelParameter,HydraulicParameter,SolverParameter,ComputingFigure);

%%
% tspan = [0,2.8];
tspan = [0,150];
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
x0 = [q;dq;p_Static];
up = [0;0;0];
u = [0;1;1];
tic;
[t_set,x_set] = ode23tb(...
	@(t,x)FoldingBoom_3DoF_ValveControlHydraulic_Dynamic_func(...
	t,x,u,up,tspan,ModelParameter,HydraulicParameter,SolverParameter,ComputingFigure), ...
	tspan,x0,opt);
toc;
%
% x0 = x_set(end,:)';
% up = u;
% u = [0;0;0];
% tic;
% [t_set,x_set] = ode23tb(...
% 	@(t,x)FoldingBoom_3DoF_ValveControlHydraulic_Dynamic_func(...
% 	t,x,u,up,tspan,ModelParameter,HydraulicParameter,SolverParameter,ComputingFigure), ...
% 	tspan,x0,opt);
% toc;
%Runge_Kutta_4
plot(t_set,x_set(:,7:10));
plot(t_set,rad2deg(x_set(:,1:3)));
legend('L1','L2','U1','U2');