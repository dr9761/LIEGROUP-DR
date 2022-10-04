%%
clear; close all; clc;
%%
x0 = [-10;0;0;0];
x_min = [-50;0;-1;-1];
x_max = [-5;30;1;1];
u_min = [-0.2;-0.2];
u_max = [0.2;0.2];
n_x = numel(x_min);
n_u = numel(u_min);
ts = 1;tf = 50;
N_NMPC = 30;
% ts = 0.1;tf = 50;
% N_NMPC = 100;
%
CostParameters.ProblemName = 'Simple 2D Obstacle Avoidance';
CostParameters.xe = [-35;10;0;0];
CostParameters.Q = 500*diag([1,1,1,1]);
CostParameters.R = 200*diag([1,1]);
CostParameters.Pend = 100*diag([1,1,1,1]);

DynamicsFuncHandle = @(x,u)define_dynamics(x,u);
StageCostFuncHandle = @(x,u)define_stage_cost(x,u,CostParameters);
TerminalCostFuncHandle = @(x)define_terminal_cost(x,CostParameters);
TerminalConstraintFuncHandle = @(x)define_terminal_constraint(x,CostParameters);
%%
d.c.mpc = import_mpctools();
d.p.x0 = x0;
d = build_setup(d, ...
	x_min,x_max,u_min,u_max, ...
	n_x,n_u,ts,tf,N_NMPC,x0);
d = create_simulator(d,DynamicsFuncHandle);
d = create_NMPC(d,DynamicsFuncHandle, ...
	StageCostFuncHandle,TerminalCostFuncHandle, ...
	TerminalConstraintFuncHandle);

[OptimalControlTrajectory,OptimalStateTrajectory] = ...
	solve_OptimalControl(d);

% d = solve_OptimalControl_NMPC(d);
% d = evolve_dynamics_OptimalControl(d);
% OptimalControlTrajectory = d.s.u(:,1:N_NMPC);
% OptimalStateTrajectory = d.s.x(:,1:N_NMPC);
for t = 1:d.p.t_final
	d = solve_NMPC(d,t);
	d = evolve_dynamics(d,t);
% 	d.p.N_NMPC = max(d.p.N_NMPC-1,50);
% 	d.p.T = ts;
	fprintf('t = %6.4f\n',d.p.T*t);
end
d = rmfield(d,'c');
%% State-Time Curve
StateTimeFigure = figure('Name','State-Time');
StateTimeAxes = subplot(2,1,1,'Parent',StateTimeFigure);
DiffStateTimeAxes = subplot(2,1,2,'Parent',StateTimeFigure);
% plot(StateTimeAxes,1:size(d.s.x,2),d.s.x(:,:));
% plot(DiffStateTimeAxes,1:size(d.s.x,2),d.s.x(:,:) - d.s.x(:,1));
plot(StateTimeAxes,1:size(d.s.x,2),d.s.x(1:2,:));
plot(DiffStateTimeAxes,1:size(d.s.x,2),d.s.x(3:4,:));
%% Distance to End State
DiatanceToEndFigure = figure('Name','Distance to End State');
DiatanceToEndAxes = axes(DiatanceToEndFigure);
plot(DiatanceToEndAxes,1:size(d.s.x,2),d.s.x(:,:) - CostParameters.xe);
%% cost
% CostFigure = figure('Name','Cost');
% CostAxes = axes(CostFigure);

% plot(CostAxes,1:numel(d.s.CPU_time),CostSet);
%% cost map
CostMapFigure = figure('Name','Cost Map');
CostMapAxes = axes(CostMapFigure);
StateVariableNr1 = 1;
StateVariableNr2 = 2;
x1_set = linspace(x_min(StateVariableNr1),x_max(StateVariableNr1),100);
x2_set = linspace(x_min(StateVariableNr2),x_max(StateVariableNr2),100);

[x1_grid,x2_grid] = meshgrid(x1_set,x2_set);
value_grid = nan(size(x1_grid));
for x_MapNr = 1:numel(x1_grid)
	x = x0;
	x(StateVariableNr1) = x1_grid(x_MapNr);
	x(StateVariableNr2) = x2_grid(x_MapNr);
	u = zeros(size(u_min));
	value_grid(x_MapNr) = StageCostFuncHandle(x,u);
end
surf(CostMapAxes,x1_grid,x2_grid,value_grid,'EdgeColor','none','FaceAlpha',0.3);colorbar;
hold(CostMapAxes,'on');
contour(CostMapAxes,x1_grid,x2_grid,value_grid,50);

CostSet = nan(numel(d.s.CPU_time),1);
for t_Nr = 1:numel(d.s.CPU_time)
	x = d.s.x(:,t_Nr);
	u = d.s.u(:,t_Nr);
	CostSet(t_Nr) = StageCostFuncHandle(x,u);
end
plot3(CostMapAxes,d.s.x(StateVariableNr1,1:end-1),d.s.x(StateVariableNr2,1:end-1),CostSet,'k-','LineWidth',1);
plot3(CostMapAxes,d.s.x(StateVariableNr1,1:end-1),d.s.x(StateVariableNr2,1:end-1),zeros(numel(d.s.x(StateVariableNr1,1:end-1)),1),'k-','LineWidth',1);
%%
% OptimalTrajectory = d.s;
% save('Result\Lattice Boom Crane 100t Static Position\LatticeBoomCrane_EndPoint_Trajectory3.mat', ...
% 	'OptimalTrajectory');