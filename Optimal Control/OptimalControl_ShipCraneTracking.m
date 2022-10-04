% OptimalControl_ShipCraneTracking
%%
clear; close all; clc;
rng(0);
%% Load Parameter
ExcelFileName = ...
	'Ship Crane';
ExcelFileDir = [...
	'Parameter File'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%%
r0 = [0;0;0];
phi0 = [0;0;0]+eps;
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
x = [q;dq];
[r0n,~,~,~,~,~] = ShipCrane_ForwardKinematics(...
	q,dq,zeros(size(dq)),ModelParameter);
r3 = r0n{3};
y0 = [r3;zeros(size(r3))];
%%
x0 = x;
x_min = [-5;-5;-5;-0.2;-0.2;-0.2;-pi;deg2rad(-85);deg2rad(5); ...
		 -5;-5;-5;-5;-5;-5;-10;-10;-10];
x_max = [ 5; 5; 5; 0.2; 0.2; 0.2; pi;deg2rad(85);deg2rad(175); ...
		  5; 5; 5; 5; 5; 5; 10;10;10];
u_min = [-1e6;-1e6;-1e6];
u_max = [ 1e6; 1e6; 1e6];
n_x = numel(x_min);
n_u = numel(u_min);
ts = 0.1;tf = 20;
N_NMPC = 1;
%
CostParameters.ProblemName = 'Ship Crane - Tracking';
CostParameters.Q = diag([1;1;1;		1;1;1]);
CostParameters.ModelParameter = ModelParameter;
%
DesignedTrajectory = load(...
	'Specified Model\Ship Crane\Pendulum with Moving Joint without Crane\Result.mat', ...
	'OptimalStateTrajectory');
DesignedTrajectory = DesignedTrajectory.OptimalStateTrajectory;
DesignedTrajectory = [...
	repmat(DesignedTrajectory(:,1),1,5), ...
	DesignedTrajectory, ...
	repmat(DesignedTrajectory(:,end),1,5)
	];
DesignedTime = [linspace(-5,-1,5)';(0:0.1:20)';20+linspace(1,5,5)'];
ft = 'splineinterp';
TrajectoryDimension = size(DesignedTrajectory,1);
DesignedTrajectoryFunc = cell(TrajectoryDimension,1);
for TrajectoryDimensionNr = 1:TrajectoryDimension
	DesignedTrajectoryFunc{TrajectoryDimensionNr} = ...
		fit(DesignedTime,DesignedTrajectory(TrajectoryDimensionNr,:)', ...
		ft, 'Normalize', 'on' );
end
%%
s = zeros(6,1);
DynamicsFuncHandle = @(x,u)ShipCrane_ControlledDynamic_func(0,x,u,s, ...
	ModelParameter);
%%
d.c.mpc = import_mpctools();
d.p.x0 = x0;
d = build_setup(d, ...
	x_min,x_max,u_min,u_max, ...
	n_x,n_u,ts,tf,N_NMPC,x0);
d = create_simulator(d,DynamicsFuncHandle);
%%
ComputingFigure = figure('Name','Computing Figure');
% ComputingAxes = axes(ComputingFigure);
ComputingAxes_xy = subplot(2,2,1,'Parent',ComputingFigure);
ComputingAxes_xz = subplot(2,2,2,'Parent',ComputingFigure);
ComputingAxes_yz = subplot(2,2,3,'Parent',ComputingFigure);
ComputingAxes_3D = subplot(2,2,4,'Parent',ComputingFigure);
y0(3) = 0;

d.s.s = nan(6,d.p.t_final);
for t_Nr = 1:d.p.t_final
	t = (t_Nr-1) * ts;
	CostParameters.ye = zeros(TrajectoryDimension,1);
	for TrajectoryDimensionNr = 1:TrajectoryDimension
		CostParameters.ye(TrajectoryDimensionNr) = ...
			DesignedTrajectoryFunc{TrajectoryDimensionNr}(t+ts);
	end
	CostParameters.ye = DesignedTrajectory([1:3,6:8],t_Nr) + y0;
	
	StageCostFuncHandle = @(x,u)define_stage_cost(x,u,CostParameters);
	TerminalCostFuncHandle = @(x)define_terminal_cost(x,CostParameters);
	TerminalConstraintFuncHandle = @(x)define_terminal_constraint(x,CostParameters);
	
	tic;
	d = create_NMPC(d,DynamicsFuncHandle, ...
		StageCostFuncHandle,TerminalCostFuncHandle, ...
		TerminalConstraintFuncHandle);
	
	d = solve_NMPC(d,t_Nr);
	fprintf('t = %6.4f\tCalculating Time:%6.4f\n',d.p.T*t_Nr,toc);
	
	s = 1*0.01*diag([2,2,2,1,1,1])*2*(rand(6,1)-0.5);
	d.s.s(:,t_Nr) = s;
	DynamicsFuncHandle = @(x,u)ShipCrane_ControlledDynamic_func(0,x,u,s, ...
		ModelParameter);
	d = create_simulator(d,DynamicsFuncHandle);
	

% 	s = 0.02*2*(rand(6,1)-0.5);
% 	d.s.s(:,t_Nr) = s;
% 	DynamicsFuncHandle = @(x,u)ShipCrane_ControlledDynamic_func(0,x,u,s, ...
% 		ModelParameter);
	d = evolve_dynamics(d,t_Nr);

	x = d.s.x(:,t_Nr);
% 	u = d.s.u(:,t_Nr);
% 	DynamicInterval = 10;
% 	h = ts / DynamicInterval;
% 	for DynamicIterationNr = 1:DynamicInterval
% 		k1 = DynamicsFuncHandle(x,u);
% 		k2 = DynamicsFuncHandle(x + k1*h/2,u);
% 		k3 = DynamicsFuncHandle(x + k2*h/2,u);
% 		k4 = DynamicsFuncHandle(x + k3*h,u);
% 		x = x + (k1 + 2*k2 + 2*k3 + k4)*h/6;
% 	end
% 	d.s.x(:,t_Nr+1) = x;
	
	q = x(1:numel(x)/2);
	dq = x(numel(x)/2+1:end);
	[r0n,~,~,~,~,~] = ShipCrane_ForwardKinematics(...
		q,dq,zeros(size(dq)),ModelParameter);
	position_set = [q(1:3),r0n{1},r0n{2},r0n{3}];
	plot3(ComputingAxes_3D,position_set(1,:),position_set(2,:),position_set(3,:),'r.-');
	axis(ComputingAxes_3D,[-6,6,-6,6,-2,10]);
	grid(ComputingAxes_3D,'on');grid(ComputingAxes_3D,'MINOR');
	
	plot(ComputingAxes_xy,position_set(1,:),position_set(2,:),'r.-');
	axis(ComputingAxes_xy,[-6,6,-6,6]);
	grid(ComputingAxes_xy,'on');grid(ComputingAxes_xy,'MINOR');
	
	plot(ComputingAxes_xz,position_set(1,:),position_set(3,:),'r.-');
	axis(ComputingAxes_xz,[-6,6,-2,10]);
	grid(ComputingAxes_xz,'on');grid(ComputingAxes_xz,'MINOR');
	
	plot(ComputingAxes_yz,position_set(2,:),position_set(3,:),'r.-');
	axis(ComputingAxes_yz,[-6,6,-2,10]);
	grid(ComputingAxes_yz,'on');grid(ComputingAxes_yz,'MINOR');
	drawnow;
end
OptimalControlTrajectory = d.s.u;
OptimalStateTrajectory = d.s.x;
%% End Point
r3_set = nan(3,size(OptimalStateTrajectory,2));
for t_Nr = 1:size(OptimalStateTrajectory,2)
	x = OptimalStateTrajectory(:,t_Nr);
	q = x(1:numel(x)/2);
	dq = x(numel(x)/2+1:end);
	[r0n,~,~,~,~,~] = ShipCrane_ForwardKinematics(...
		q,dq,zeros(size(dq)),ModelParameter);
	r3_set(:,t_Nr) = r0n{3};
end
TrajectoryFigure = figure('Name','End Point Trajectory');
TrajectoryAxes = axes(TrajectoryFigure);
hold(TrajectoryAxes,'on');
plot3(TrajectoryAxes,r3_set(1,:)-y0(1),r3_set(2,:)-y0(2),r3_set(3,:)-y0(3),'b-');
plot3(TrajectoryAxes,DesignedTrajectoryFunc{1}(linspace(0,20,20)), ...
	DesignedTrajectoryFunc{2}(linspace(0,20,20)), ...
	DesignedTrajectoryFunc{3}(linspace(0,20,20)),'b.');
%% Disturbance
DisturbFigure = figure('Name','Disturb');
DisturbPositionAxes = subplot(3,1,1,'Parent',DisturbFigure);
DisturbVelocityAxes = subplot(3,1,2,'Parent',DisturbFigure);
DisturbAccelerationAxes = subplot(3,1,3,'Parent',DisturbFigure);
plot(DisturbPositionAxes,ts*[0:(size(d.s.s,2))],d.s.x(1:6,:));
plot(DisturbVelocityAxes,ts*[0:(size(d.s.s,2))],d.s.x(10:15,:));
plot(DisturbAccelerationAxes,ts*[0:(size(d.s.s,2)-1)],d.s.s);
%% Dynamic Verification
ControlFigure = figure('Name','Control Value Trajectory');
ControlAxes = axes(ControlFigure);
hold(ControlAxes,'on');
plot(ControlAxes,0:ts:(20-ts),OptimalControlTrajectory,'.');
%
x0 = OptimalStateTrajectory(:,1);
u0_ref = OptimalControlTrajectory(:,1);
s = zeros(6,1);
SystemForceFcn = @(u)ShipCrane_ControlledDynamic_func(0,x0,u,s, ...
	ModelParameter);
opt = optimoptions('fsolve', ...
	'Algorithm','trust-region', ...
	'StepTolerance',1e-15, ...
	'FunctionTolerance',1e-15, ...
	'SpecifyObjectiveGradient',false, ...
	'Display','iter', ...
	'MaxIterations',40000, ...
	'MaxFunctionEvaluations',2000000, ...
	'PlotFcn',[]);
u0_static = fsolve(SystemForceFcn,zeros(3,1),opt);
StaticError = SystemForceFcn(u0_static);
MaxAbsStaticError_0 = max(abs(StaticError));
%
xe = OptimalStateTrajectory(:,end);
ue_ref = OptimalControlTrajectory(:,end);
s = zeros(6,1);
SystemForceFcn = @(u)ShipCrane_ControlledDynamic_func(0,xe,u,s, ...
	ModelParameter);
opt = optimoptions('fsolve', ...
	'Algorithm','trust-region', ...
	'StepTolerance',1e-15, ...
	'FunctionTolerance',1e-15, ...
	'SpecifyObjectiveGradient',false, ...
	'Display','iter', ...
	'MaxIterations',40000, ...
	'MaxFunctionEvaluations',2000000, ...
	'PlotFcn',[]);
ue_static = fsolve(SystemForceFcn,zeros(3,1),opt);
StaticError = SystemForceFcn(ue_static);
MaxAbsStaticError_e = max(abs(StaticError));
%
Expanded_OptimalControlTrajectory = [...
	repmat(u0_static,[1,5]), ...
	OptimalControlTrajectory, ...
	repmat(ue_static,[1,5])];
Expanded_TimeSet = [(-5*ts):ts:(tf+4*ts)]';
%
OptimalControlFunc = cell(size(OptimalControlTrajectory,1),1);
ft = 'linear';
for ControlDimensionNr = 1:size(OptimalControlTrajectory,1)
	DesignedTrajectoryFunc{ControlDimensionNr} = ...
		fit(Expanded_TimeSet,Expanded_OptimalControlTrajectory(ControlDimensionNr,:)', ...
		ft, 'Normalize', 'on' );
	plot(ControlAxes,linspace(-5*ts,tf+4*ts,1000), ...
		DesignedTrajectoryFunc{ControlDimensionNr}(linspace(-5*ts,tf+4*ts,1000)),'--');
end
%
t = 0;
x0_pendulum = [x0(7:9);0;0;x0(16:18);0;0];
u_pendulum = [DesignedTrajectoryFunc{1}(t); ...
	DesignedTrajectoryFunc{2}(t); ...
	DesignedTrajectoryFunc{3}(t)];
dx_pendulum = TripleJib_Pendulum_Dynamic_func_Symbolic(x_pendulum,u_pendulum, ...
	ModelParameter)
