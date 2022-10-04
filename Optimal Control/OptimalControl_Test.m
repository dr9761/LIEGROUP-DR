%%
clear; close all; clc;
%%
x0 = [-10;0;0;0];
x_min = [-50;0;-1;-1];
x_max = [-5;30;1;1];
u_min = [-0.2;-0.2];
u_max = [0.2;0.2];
ts = 0.1;tf = 50;
%
xe = [-35;10;0;0];
Q = 500*diag([1,1,0,0]);
R = 200*diag([1,1]);
Pend = 100*diag([1,1,1,1]);

DynamicsFuncHandle = @(x,u)define_dynamics(x,u);
StageCostFuncHandle = @(x,u)define_stage_cost(x,u,Q,R,xe);
TerminalCostFuncHandle = @(x)define_terminal_cost(x,Pend,xe);
TerminalConstraintFuncHandle = @(x)define_terminal_constraint(x,Pend,xe);
%%
n_x = numel(x_min);
n_u = numel(u_min);
N_NMPC = floor(tf/ts);
%
d.c.mpc = import_mpctools();
d.p.x0 = x0;
d = build_setup(d, ...
	x_min,x_max,u_min,u_max, ...
	n_x,n_u,ts,tf,N_NMPC,x0);
d = create_simulator(d,DynamicsFuncHandle);
d = create_NMPC(d,DynamicsFuncHandle, ...
	StageCostFuncHandle,TerminalCostFuncHandle, ...
	TerminalConstraintFuncHandle);
%%
tic;
[OptimalControlTrajectory,OptimalStateTrajectory] = ...
	solve_OptimalControl(d);
toc;
figure('Name','Trajectory');
hold on;
plot([x0(1),xe(1)],[x0(2),xe(2)],'k*');
plot(OptimalStateTrajectory(1,:),OptimalStateTrajectory(2,:),'b.-');