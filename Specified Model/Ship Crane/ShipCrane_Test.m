% ShipCrane_Test
clear;close all;clc;
%%
do_calculateLength = false;
if do_calculateLength
	alpha_min = deg2rad(5);
	alpha_max = deg2rad(170);
	h = 4;
	b = 6;
	s_min = sin(alpha_min/2);
	s_max = sin(alpha_max/2);
	x_min = (-1-sqrt(1-(1-s_max^2/s_min^2)*(1+b^2/(4*h^2))))/(1-s_max^2/s_min^2)*h;
	L = x_min/2/s_min;
end
%% Load Parameter
ExcelFileName = ...
	'Ship Crane';
ExcelFileDir = [...
	'Parameter File'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%% Test
do_Kinematic_Dynamic_Test = false;
if do_Kinematic_Dynamic_Test
	r0 = rand(3,1);
	phi0 = [0;0;0];
	phi = 0;
	psi = deg2rad(45);
	theta = deg2rad(45);
	q = [r0;phi0;phi;psi;theta];
	
	dr0dt = [0;0;0];
	omega0 = [0;0;0];
	dphidt = 0;
	dpsidt = 0;
	dthetadt = 0;
	dq = [dr0dt;omega0;dphidt;dpsidt;dthetadt];
	
	ddr0dtdt = 0.0*[1;2;3];
	domega0dt = 0.0*[4;5;6];
	s = [ddr0dtdt;domega0dt];
	
	ddr3dtdt = [1;3;2];
	% forward & inverse kinematics
	ddq_kin = ShipCrane_InverseKinematics(...
		q,dq,s,ddr3dtdt,ModelParameter);
	[r0n_kin,Rn_kin,dqn_kin,ddqn_kin,Tn_kin,dTn_kin] = ShipCrane_ForwardKinematics(...
		q,dq,ddq_kin,ModelParameter);
	%
	u = ShipCrane_InverseDynamic(q,dq,s,ddr3dtdt,ModelParameter);
	ddq_dyn = ShipCrane_ForwardDynamic(q,dq,s,u,ModelParameter);
	[r0n_dyn,Rn_dyn,dqn_dyn,ddqn_dyn,Tn_dyn,dTn_dyn] = ...
		ShipCrane_ForwardKinematics(...
		q,dq,ddq_dyn,ModelParameter);
	[ddr3dtdt,ddqn_kin{3}(1:3),ddqn_dyn{3}(1:3)]'
end
%%
load('Specified Model\Ship Crane\Pendulum with Moving Joint without Crane\Result.mat', ...
	'OptimalStateTrajectory','OptimalControlTrajectory');

ft = 'splineinterp';
ddr3xdtdt_FitFunc = fit( (0:0.1:(20-0.1))', OptimalControlTrajectory(1,:)', ...
	ft, 'Normalize', 'on' );
ddr3ydtdt_FitFunc = fit( (0:0.1:(20-0.1))', OptimalControlTrajectory(2,:)', ...
	ft, 'Normalize', 'on' );
ddr3zdtdt_FitFunc = fit( (0:0.1:(20-0.1))', OptimalControlTrajectory(3,:)', ...
	ft, 'Normalize', 'on' );
ddr3dtdt_FitFunc_Cell = {ddr3xdtdt_FitFunc;ddr3ydtdt_FitFunc;ddr3zdtdt_FitFunc};

dr3xdt_FitFunc = fit( (0:0.1:20)', OptimalStateTrajectory(6,:)', ...
	ft, 'Normalize', 'on' );
dr3ydt_FitFunc = fit( (0:0.1:20)', OptimalStateTrajectory(7,:)', ...
	ft, 'Normalize', 'on' );
dr3zdt_FitFunc = fit( (0:0.1:20)', OptimalStateTrajectory(8,:)', ...
	ft, 'Normalize', 'on' );
dr3dt_FitFunc_Cell = {dr3xdt_FitFunc;dr3ydt_FitFunc;dr3zdt_FitFunc};

r3x_FitFunc = fit( (0:0.1:20)', OptimalStateTrajectory(1,:)', ...
	ft, 'Normalize', 'on' );
r3y_FitFunc = fit( (0:0.1:20)', OptimalStateTrajectory(2,:)', ...
	ft, 'Normalize', 'on' );
r3z_FitFunc = fit( (0:0.1:20)', OptimalStateTrajectory(3,:)', ...
	ft, 'Normalize', 'on' );
r3_FitFunc_Cell = {r3x_FitFunc;r3y_FitFunc;r3z_FitFunc};
%
DesignedTrajectoryFuncCell_ShipCrane.ddr3dtdt_FitFunc_Cell = ddr3dtdt_FitFunc_Cell;
DesignedTrajectoryFuncCell_ShipCrane.dr3dt_FitFunc_Cell = dr3dt_FitFunc_Cell;
DesignedTrajectoryFuncCell_ShipCrane.r3_FitFunc_Cell = r3_FitFunc_Cell;
%
ddr3dtdt_Figure = figure('Name','ddr3dtdt');
ddr3dtdt_Axes = axes(ddr3dtdt_Figure);
hold(ddr3dtdt_Axes,'on');
plot(ddr3dtdt_Axes,(0:0.1:(20-0.1))',OptimalControlTrajectory(1,:)','r-');
plot(ddr3dtdt_Axes,(0:0.1:(20-0.1))',OptimalControlTrajectory(2,:)','b-');
plot(ddr3dtdt_Axes,(0:0.1:(20-0.1))',OptimalControlTrajectory(3,:)','g-');
plot(ddr3dtdt_Axes,(0:0.01:(20-0.1))',ddr3xdtdt_FitFunc((0:0.01:(20-0.1))'),'r.-');
plot(ddr3dtdt_Axes,(0:0.01:(20-0.1))',ddr3ydtdt_FitFunc((0:0.01:(20-0.1))'),'b.-');
plot(ddr3dtdt_Axes,(0:0.01:(20-0.1))',ddr3zdtdt_FitFunc((0:0.01:(20-0.1))'),'g.-');
%%
r0 = [0;0;0];
phi0 = [0;0;0];
phi = 0;
psi = deg2rad(75);
theta = deg2rad(150);
q = [r0;phi0;phi;psi;theta];

dr0dt = [0;0;0];
omega0 = [0;0;0];
dphidt = 0;
dpsidt = 0;
dthetadt = 0;
dq = [dr0dt;omega0;dphidt;dpsidt;dthetadt];
%
t = 0;
x = [q;dq];
ComputingFigure = figure('Name','Computing Figure');
ComputingAxes = axes(ComputingFigure);
dx = ShipCrane_Dynamic_func(t,x, ...
	DesignedTrajectoryFuncCell_ShipCrane,ModelParameter,ComputingAxes);
%
x0 = x;
tspan = [0,20];
% AbsoluteTolerance = SolverParameter.ODE_Solver.AbsTol;
% RelativeTolerance = SolverParameter.ODE_Solver.RelTol;
% MaxStep = SolverParameter.ODE_Solver.MaxStep;
AbsoluteTolerance = 0.001;
RelativeTolerance = 0.001;
MaxStep = 0.1;
opt = odeset('RelTol',RelativeTolerance, ...
	'AbsTol',AbsoluteTolerance, ...
	'MaxStep',MaxStep, ...
	'OutputFcn',[]);
%
[t_set,x_set] = Runge_Kutta_4(...
	@(t,x)ShipCrane_Dynamic_func(...
	t,x,DesignedTrajectoryFuncCell_ShipCrane,ModelParameter,ComputingAxes), ...
	tspan,x0,opt);
%
TrajectoryFigure = figure('Name','Trajectory Figure');
r3_Axes = subplot(3,2,1,'Parent',TrajectoryFigure);
dr3dt_Axes = subplot(3,2,3,'Parent',TrajectoryFigure);
ddr3dtdt_Axes = subplot(3,2,5,'Parent',TrajectoryFigure);
TrajectoryAxes = subplot(3,2,[2,4,6],'Parent',TrajectoryFigure);
r3_set = nan(3,numel(t_set));
dr3dt_set = nan(3,numel(t_set));
ddr3dtdt_set = nan(3,numel(t_set));
for tNr = 1:numel(t_set)
	t = t_set(tNr);
	if t<0 || t>20-0.1
		ddr3dtdt = zeros(3,1);
	else
		ddr3dtdt = nan(3,1);
		ddr3dtdt(1) = ddr3dtdt_FitFunc_Cell{1}(t);
		ddr3dtdt(2) = ddr3dtdt_FitFunc_Cell{2}(t);
		ddr3dtdt(3) = ddr3dtdt_FitFunc_Cell{3}(t);
	end
	s = zeros(6,1);
	%
	x = x_set(tNr,:)';
	q = x(1:numel(x)/2);
	dq = x(numel(x)/2+1:end);
	%
	u = ShipCrane_InverseDynamic(q,dq,s,ddr3dtdt,ModelParameter);
	[ddq,~,~,~,~] = ...
		ShipCrane_ForwardDynamic(q,dq,s,u,ModelParameter);
	[r0n,~,dqn,ddqn,~,~] = ShipCrane_ForwardKinematics(...
		q,dq,ddq,ModelParameter);
	
	r3_set(:,tNr) = r0n{3};
	dr3dt_set(:,tNr) = dqn{3}(1:3);
	ddr3dtdt_set(:,tNr) = ddqn{3}(1:3);
end
hold(TrajectoryAxes,'on');
plot(TrajectoryAxes, ...
	r3_set(1,:)-r3_set(1,1), ...
	r3_set(2,:)-r3_set(2,1),'b-');
plot(TrajectoryAxes, ...
	OptimalStateTrajectory(1,:)-OptimalStateTrajectory(1,1), ...
	OptimalStateTrajectory(2,:)-OptimalStateTrajectory(2,1),'k-');

hold(r3_Axes,'on');
plot(r3_Axes,t_set,r3_set(1,:),'r-', ...
	t_set,r3_set(2,:),'b-', ...
	t_set,r3_set(3,:),'g-');
plot(r3_Axes,(0:0.1:20)',OptimalStateTrajectory(1,:)','r.', ...
	(0:0.1:20)',OptimalStateTrajectory(2,:)','b.', ...
	(0:0.1:20)',OptimalStateTrajectory(3,:)','g.');

hold(dr3dt_Axes,'on');
plot(dr3dt_Axes,t_set,dr3dt_set(1,:),'r-', ...
	t_set,dr3dt_set(2,:),'b-', ...
	t_set,dr3dt_set(3,:),'g-');
plot(dr3dt_Axes,(0:0.1:20)',OptimalStateTrajectory(6,:)','r.', ...
	(0:0.1:20)',OptimalStateTrajectory(7,:)','b.', ...
	(0:0.1:20)',OptimalStateTrajectory(8,:)','g.');

hold(ddr3dtdt_Axes,'on');
plot(ddr3dtdt_Axes,t_set,ddr3dtdt_set(1,:),'r-', ...
	t_set,ddr3dtdt_set(2,:),'b-', ...
	t_set,ddr3dtdt_set(3,:),'g-');
plot(ddr3dtdt_Axes,(0:0.1:20-0.1)',OptimalControlTrajectory(1,:)','r.', ...
	(0:0.1:20-0.1)',OptimalControlTrajectory(2,:)','b.', ...
	(0:0.1:20-0.1)',OptimalControlTrajectory(3,:)','g.');