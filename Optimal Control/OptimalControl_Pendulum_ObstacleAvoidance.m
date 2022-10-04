% OptimalControl_Pendulum_ObstacleAvoidance
%%
clear; close all; clc;
%%
ExcelFileName = ...
	'Pendulum with Moving Joint';
ExcelFileDir = [...
	'Parameter File', ...
	'\Pendulum Test'];
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
fprintf('All Parameters have been successfully loaded!\n');
%%
r0 = [0;0;2];
alpha = 0;
beta = 0;
q = [r0;alpha;beta];
%
dr0dt = [0;0;0];
dalphadt = 0;
dbetadt = 0;
dq = [dr0dt;dalphadt;dbetadt];
%%
t_Nr = 0;
x = [q;dq];
%%
x0 = x;
x_min = [-2;    -3; 2;-deg2rad( 1);-deg2rad( 1); ...
		 -0.2;-0.2;-0;-deg2rad(10);-deg2rad(10)];
x_max = [ 2;     3; 2; deg2rad( 1); deg2rad( 1); ...
		  0.2; 0.2; 0; deg2rad(10);	deg2rad(10)];
% u_min = [-20;-20;0];
% u_max = [ 20; 20;0];
u_min = [-0.1;-0.1;0];
u_max = [ 0.1; 0.1;0];
n_x = numel(x_min);
n_u = numel(u_min);
ts = 0.1;tf = 20;
N_NMPC = floor(tf/ts);
%
CostParameters.ProblemName = 'Pendulum with Moving Joint - Obstacle Avoidance';
CostParameters.xe = [2;2;2;0;0; ...
					 0;0;0;0;0];
CostParameters.Q = diag([1,1,1,10,10, ...
						 10,10,10,10,10]);
CostParameters.R = 0*diag([1,1,1]);
CostParameters.Pend = 3*N_NMPC*diag([1,1,1,10,10, ...
							   10,10,10,10,10]);
%
Obstacle.cost_range = [1e1,0];
Obstacle.confidence = 0.9;
Obstacle.safety_distance = 0.1;
Obstacle.p = 8;
Obstacle.phi = [0;0;deg2rad(0)];
Obstacle.size = [0.62;0.26;0.27];
Obstacle.xb = [1;1;0.27/2];
CostParameters.Obstacle{1} = Obstacle;
%
% Obstacle.cost_range = [1e1,0];
% Obstacle.confidence = 0.9;
% Obstacle.safety_distance = 0.1;
% Obstacle.p = 8;
% Obstacle.phi = [0;0;deg2rad(-75)];
% Obstacle.size = [0.62;0.26;0.27];
% Obstacle.xb = [0.5;0.6;0.27/2];
% CostParameters.Obstacle{1} = Obstacle;
% 
% Obstacle.cost_range = [1e1,0];
% Obstacle.confidence = 0.9;
% Obstacle.safety_distance = 0.1;
% Obstacle.p = 8;
% Obstacle.phi = [0;0;deg2rad(15)];
% Obstacle.size = [0.62;0.26;0.27];
% Obstacle.xb = [1;1.6;0.27/2];
% CostParameters.Obstacle{2} = Obstacle;
%
CostParameters.BodyElementParameter = ModelParameter.BodyElementParameter;

DynamicsFuncHandle = @(x,u)PendulumWithMovingJoint_Dynamic_func(t_Nr,x, ...
	ModelParameter,SolverParameter,[],u);
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
StateTimeFigure = figure('Name','State-Time');
StateAxes_r0 = subplot(3,1,1,'Parent',StateTimeFigure);
StateAxes_phi = subplot(3,1,2,'Parent',StateTimeFigure);
ControlAxes = subplot(3,1,3,'Parent',StateTimeFigure);

plot(StateAxes_r0,ts*[0:size(OptimalStateTrajectory,2)-1],OptimalStateTrajectory(1:3,:),'-', ...
	ts*[0:size(OptimalStateTrajectory,2)-1],OptimalStateTrajectory(6:8,:),'--');
legend(StateAxes_r0,'r_{0,x}','r_{0,y}','r_{0,z}', ...
	'Location','eastoutside');
grid(StateAxes_r0,'on');grid(StateAxes_r0,'MINOR');

plot(StateAxes_phi,ts*[0:size(OptimalStateTrajectory,2)-1],rad2deg(OptimalStateTrajectory(4:5,:)),'-', ...
	ts*[0:size(OptimalStateTrajectory,2)-1],rad2deg(OptimalStateTrajectory(9:10,:)),'--');
legend(StateAxes_phi,'\alpha','\beta', ...
	'Location','eastoutside');
grid(StateAxes_phi,'on');grid(StateAxes_phi,'MINOR');

plot(ControlAxes,ts*[0:size(OptimalControlTrajectory,2)-1],OptimalControlTrajectory);
legend(ControlAxes,'u_{1}','u_{2}','u_{3}', ...
	'Location','eastoutside');
grid(ControlAxes,'on');grid(ControlAxes,'MINOR');
%% cost map
CostMapFigure = figure('Name','Cost Map');
CostMapAxes = axes(CostMapFigure);
StateVariableNr1 = 1;
StateVariableNr2 = 2;
% x1_set = linspace(x_min(StateVariableNr1),x_max(StateVariableNr1),100);
% x2_set = linspace(x_min(StateVariableNr2),x_max(StateVariableNr2),100);
x1_set = linspace(0,2,100);
x2_set = linspace(0,2,100);

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

CostSet = nan(size(OptimalStateTrajectory,2),1);
AccumulativeCostSet = nan(size(OptimalStateTrajectory,2),1);
r1_set = nan(3,size(OptimalControlTrajectory,2));
Length = CostParameters.BodyElementParameter{1}.L;
gx = [1;0;0];
for t_Nr = 1:size(OptimalControlTrajectory,2)
	x = OptimalStateTrajectory(:,t_Nr);
	u = OptimalControlTrajectory(:,t_Nr);
	CostSet(t_Nr) = StageCostFuncHandle(x,u);
	AccumulativeCostSet(t_Nr) = sum(CostSet(1:t_Nr));
	
	r0 = reshape(x(1:3),[3,1]);
	alpha = x(4);
	beta = x(5);
	
	RB = get_R_y(pi/2+alpha)*get_R_z(beta);
	r01 = r0 + Length * RB * gx;
	r1_set(:,t_Nr) = r01;
end
x = OptimalStateTrajectory(:,end);
CostSet(end) = TerminalCostFuncHandle(x);
AccumulativeCostSet(end) = sum(CostSet);

plot3(CostMapAxes,OptimalStateTrajectory(StateVariableNr1,:), ...
	OptimalStateTrajectory(StateVariableNr2,:),CostSet,'k-','LineWidth',1);
plot3(CostMapAxes,OptimalStateTrajectory(StateVariableNr1,1:end-1), ...
	OptimalStateTrajectory(StateVariableNr2,1:end-1), ...
	zeros(numel(OptimalStateTrajectory(StateVariableNr1,1:end-1)),1),'k-','LineWidth',1);
plot3(CostMapAxes,r1_set(1,:),r1_set(2,:),r1_set(3,:),'r-','LineWidth',2);
% cost curve
CostCurveFigure = figure('Name','Cost Map');
CostCurveAxes = axes(CostCurveFigure);
plot(CostCurveAxes,ts*[0:size(OptimalControlTrajectory,2)],CostSet,'r-', ...
	ts*[0:size(OptimalControlTrajectory,2)],AccumulativeCostSet,'b-');

drawnow;
%%
if false
	ResultFileAddress = ...
		['Result\Optimal Control\',datestr(now,'yyyymmdd_HHMM'),ExcelFileName];
	mkdir(ResultFileAddress);
	ExcelFilePath = [ExcelFileDir,'\',ExcelFileName,'.xlsx'];
	copyfile(ExcelFilePath,ResultFileAddress);
	save([ResultFileAddress,'\Result.mat'], ...
		'd','OptimalStateTrajectory','OptimalControlTrajectory');
end
%%
ResamplingPoint = 1:5:201;
SegmentQuantity = numel(ResamplingPoint) - 1;
OptimalState_drxdt = OptimalStateTrajectory(6,ResamplingPoint);
OptimalState_drydt = OptimalStateTrajectory(7,ResamplingPoint);
OptimalState_drzdt = OptimalStateTrajectory(8,ResamplingPoint);
OptimalTime = 0:ts:tf;
OptimalTime = OptimalTime(ResamplingPoint);

[xData, yData] = prepareCurveData( OptimalTime, OptimalState_drxdt );
ft = 'splineinterp';
[OptimalState_drxdt_FuncRaw, gof] = fit( xData, yData, ft, 'Normalize', 'off' );
OptimalState_drxdt_Func = OptimalState_drxdt_FuncRaw.p.coefs;

[xData, yData] = prepareCurveData( OptimalTime, OptimalState_drydt );
ft = 'splineinterp';
[OptimalState_drydt_FuncRaw, gof] = fit( xData, yData, ft, 'Normalize', 'off' );
OptimalState_drydt_Func = OptimalState_drydt_FuncRaw.p.coefs;

[xData, yData] = prepareCurveData( OptimalTime, OptimalState_drzdt );
ft = 'splineinterp';
[OptimalState_drzdt_FuncRaw, gof] = fit( xData, yData, ft, 'Normalize', 'off' );
OptimalState_drzdt_Func = OptimalState_drzdt_FuncRaw.p.coefs;

OptimalState_Velocity_Func_readme.ts = ts;
OptimalState_Velocity_Func_readme.tf = tf;
OptimalState_Velocity_Func_readme.FuncType = 'cubic spline interpolation';
% save('OptimalState_Velocity_Func.mat', ...
% 	'OptimalState_drxdt_Func','OptimalState_drydt_Func','OptimalState_drzdt_Func', ...
% 	'OptimalState_Velocity_Func_readme');
% Fit_FuncRaw = OptimalState_drzdt_FuncRaw;
% absError = 0;
% for SegmentNr = 1:numel(Fit_FuncRaw.p.breaks)-1
% 	t_sub_set = linspace((SegmentNr-1)*ts*5,SegmentNr*ts*5,10);
% 	t_sub_set_0 = linspace(0,ts*5,10);
% 	
% 	polyfunc = Fit_FuncRaw.p.coefs(SegmentNr,:);
% % 	polyValue = polyval(polyfunc,t_sub_set_0);
% 	polyValue = polyfunc(1)*t_sub_set_0.^3 + polyfunc(2)*t_sub_set_0.^2 + ...
% 		polyfunc(3)*t_sub_set_0.^1 + polyfunc(4)*t_sub_set_0.^0;
% 	
% 	splineValue = Fit_FuncRaw(t_sub_set);
% 	splineValue = reshape(splineValue,size(polyValue));
% 	absError = max(absError,max(abs(polyValue - splineValue)));
% end
% absError

VelocityInterpolationFigure = figure('Name','Velocity Interpolation Test');
VelocityInterpolationAxes = axes(VelocityInterpolationFigure);
hold(VelocityInterpolationAxes,'on');
plot(VelocityInterpolationAxes,0:ts:tf,OptimalStateTrajectory(6:8,:),'.');
plot(VelocityInterpolationAxes,0:ts:tf,OptimalState_drxdt_FuncRaw(0:ts:tf),'-');
plot(VelocityInterpolationAxes,0:ts:tf,OptimalState_drydt_FuncRaw(0:ts:tf),'-');
plot(VelocityInterpolationAxes,0:ts:tf,OptimalState_drzdt_FuncRaw(0:ts:tf),'-');
title(VelocityInterpolationAxes,['Number of Segments: ',num2str(SegmentQuantity)]);
grid(VelocityInterpolationAxes,'on');grid(VelocityInterpolationAxes,'minor');
%
OptimalState_alpha = OptimalStateTrajectory(4,:);
OptimalState_beta = OptimalStateTrajectory(5,:);
OptimalState_dalphadt = OptimalStateTrajectory(9,:);
OptimalState_dbetadt = OptimalStateTrajectory(10,:);
OptimalState_Angle_readme.AngleRepresentation = 'Cardan';
OptimalState_Angle_readme.Sequence = 'I->y,alpha->z,beta->B';
save('OptimalState_Angle.mat', ...
	'OptimalState_alpha','OptimalState_beta', ...
	'OptimalState_dalphadt','OptimalState_dbetadt', ...
	'OptimalState_Angle_readme');