% OptimalControl_TripleJibPendulum_2
%%
clear; close all; clc;
rng(0);
%% Load Parameter
ExcelFileName = ...
	'Triple Jib Pendulum';
ExcelFileDir = [...
	'Parameter File'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%%
phi_s = 0;
phi_1 = deg2rad(75);
phi_2 = deg2rad(150);
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
x = [q;dq];
[r0b,~,dqb,~,~] = get_TripleJib_Pendulum_ElementCoordinate_Symbolic(...
	q,dq,ModelParameter);
r5 = r0b{5};
dr5dt = dqb{5};
%%
phi_s_e = deg2rad(30);
phi_1_e = deg2rad(70);
phi_2_e = deg2rad(140);
phi_y_e = 0;
phi_z_e = 0;
q_e = [phi_s_e;phi_1_e;phi_2_e;phi_y_e;phi_z_e];
%
[r0b_e,~,~,~,~] = get_TripleJib_Pendulum_ElementCoordinate_Symbolic(...
	q_e,zeros(size(q_e)),ModelParameter);
r5e = r0b_e{5};
%%
x0 = x;
x_min = [-pi;deg2rad(-85);deg2rad(  5);deg2rad(-5);deg2rad(-5); ...
		 -0.1;-0.5;-0.5;deg2rad(-2);deg2rad(-2)];
x_max = [ pi;deg2rad( 85);deg2rad(175);deg2rad( 5);deg2rad( 5); ...
		  0.1; 0.5; 0.5;deg2rad( 2);deg2rad( 2)];
u_min = [-1e9;-1e9;-1e9];
u_max = [ 1e9; 1e9; 1e9];
n_x = numel(x_min);
n_u = numel(u_min);
ts = 0.2;tf = 10;
N_NMPC = floor(tf/ts);
% N_NMPC = 10;
%%
CostParameters.ProblemName = 'Triple Jib Pendulum - PTP';
CostParameters.Q = 1*diag([1;1;1;    1;1;1;   1;1;   1;1]);
CostParameters.R = 0e-12*diag([1;1;1]);
CostParameters.Pend = 1*diag([1;1;1;   1;1;1;   1;1;   1;1]);
CostParameters.x5e = [r5e;0;0;0];
CostParameters.ModelParameter = ModelParameter;
%%
DynamicsFuncHandle = @(x,u)TripleJib_Pendulum_Dynamic_func_Symbolic(x,u, ...
	ModelParameter);
StageCostFuncHandle = @(x,u)define_stage_cost(x,u,CostParameters);
TerminalCostFuncHandle = @(x)define_terminal_cost(x,CostParameters);
TerminalConstraintFuncHandle = @(x)define_terminal_constraint(x,CostParameters);
%%
tic;
d.c.mpc = import_mpctools();
d.p.x0 = x0;
d = build_setup(d, ...
	x_min,x_max,u_min,u_max, ...
	n_x,n_u,ts,tf,N_NMPC,x0);
d = create_simulator(d,DynamicsFuncHandle);
d = create_NMPC(d,DynamicsFuncHandle, ...
	StageCostFuncHandle,TerminalCostFuncHandle, ...
	TerminalConstraintFuncHandle);
toc;
%%
[OptimalControlTrajectory,OptimalStateTrajectory] = ...
	solve_OptimalControl(d);
toc;
%%
AnimationFigure = figure('Name','Animation');
AnimationAxes = axes(AnimationFigure);

r5_set = [];
Cost_set = [];
for t_Nr = 1:size(OptimalStateTrajectory,2)
% for t_Nr = 1:11
	t = (t_Nr-1) * ts;
	x = OptimalStateTrajectory(:,t_Nr);
	q = x(1:numel(x)/2);
	dq = x(numel(x)/2+1:end);
	[r0b,~,~,~,~] = get_TripleJib_Pendulum_ElementCoordinate_Symbolic(...
		q,dq,ModelParameter);
	position_set = [r0b{1},r0b{2},r0b{3},r0b{4},r0b{5}];
	r5_set = [r5_set,r0b{5}];
	plot3(AnimationAxes,position_set(1,:),position_set(2,:),position_set(3,:),'r.-');
	axis(AnimationAxes,[-30,30,-30,30,-15,45]);
	grid(AnimationAxes,'on');grid(AnimationAxes,'MINOR');
	title(['t_Nr = ',num2str(t_Nr)]);
	if t_Nr < size(OptimalStateTrajectory,2)
		u = OptimalControlTrajectory(:,t_Nr);
		Cost_set = [Cost_set,StageCostFuncHandle(x,u)];
	end
	drawnow;
	pause(0.2);
end
%% End Point
% r3_set = nan(3,size(OptimalStateTrajectory,2));
% for t_Nr = 1:size(OptimalStateTrajectory,2)
% 	x = OptimalStateTrajectory(:,t_Nr);
% 	q = x(1:numel(x)/2);
% 	dq = x(numel(x)/2+1:end);
% 	[r0n,~,~,~,~,~] = ShipCrane_ForwardKinematics(...
% 		q,dq,zeros(size(dq)),ModelParameter);
% 	r3_set(:,t_Nr) = r0n{3};
% end
TrajectoryFigure = figure('Name','End Point Trajectory');
TrajectoryAxes = axes(TrajectoryFigure);
% hold(TrajectoryAxes,'on');
plot3(TrajectoryAxes,r5_set(1,:),r5_set(2,:),r5_set(3,:),'b-');
% plot3(TrajectoryAxes,DesignedTrajectoryFunc{1}(linspace(0,20,20)), ...
% 	DesignedTrajectoryFunc{2}(linspace(0,20,20)), ...
% 	DesignedTrajectoryFunc{3}(linspace(0,20,20)),'b.');
% %%
% DisturbFigure = figure('Name','Disturb');
% DisturbPositionAxes = subplot(3,1,1,'Parent',DisturbFigure);
% DisturbVelocityAxes = subplot(3,1,2,'Parent',DisturbFigure);
% DisturbAccelerationAxes = subplot(3,1,3,'Parent',DisturbFigure);
% plot(DisturbPositionAxes,ts*[0:(size(d.s.s,2))],d.s.x(1:6,:));
% plot(DisturbVelocityAxes,ts*[0:(size(d.s.s,2))],d.s.x(10:15,:));
% plot(DisturbAccelerationAxes,ts*[0:(size(d.s.s,2)-1)],d.s.s);
%%
StateFigure = figure('Name','State - Time');
StateAxes = axes(StateFigure);
plot(StateAxes, ...
	1:size(OptimalStateTrajectory,2),OptimalStateTrajectory);