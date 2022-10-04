clc;clear;
close all;
%%
% Change Working Dictionary
Welcome_to_Programm;
% Configure Working Directory
FullPathOfProject = Configure_WorkingDirectory;
% Load Sub-Module
% Load_SubModule(FullPathOfProject);
% Load Parameter from Excel File
ExcelFileName = ...
	'Lattice Boom Crane Simplify 5 400t';
ExcelFileDir = [...
	'Parameter File', ...
	'\Lattice boom crane model'];
%
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
% Action Function
SolverParameter.ActionFunction = get_ActionFunction('None');
% plot Initial State
do_plot_InitialState = false;
InitalStateAxes = plot_InitialState(do_plot_InitialState, ...
	ModelParameter,SolverParameter);
% Static Position
tic;
%% Statics
do_Statics_Calculation = false;
pos_static = cell(41,32);
if do_Statics_Calculation
	for MainBoomAngleNr = 1:41 % 1:41
		MainBoomAngle = MainBoomAngleNr - 1 + 45;
		pos_static_temp = cell(1,32);
		parfor deltaLNr = 1:32 % 1:32
% 			delta_L15 = (delta_L15_Nr-1)*0.1;
			deltaL = deltaLNr - 1;
			[ModelParameter2] = Calc_LatticeBoomCrane_InitialCoordinate(...
				MainBoomAngle,deltaL,ModelParameter);
			
			q0 = ModelParameter2.InitialState.q0;
			SystemForceFcn = @(q)Multi_Body_Dynamics_Force(q,[0,1], ...
				ModelParameter2,SolverParameter);
			%
			fsolve_PlotFcn_Handle = ...
				@(x,optimValues,state,varargin)optimplot_Mechanism(...
				x,optimValues,state,varargin, ...
				ModelParameter2,SolverParameter);
			opt = optimoptions('fsolve', ...
				'Algorithm','trust-region', ...
				'StepTolerance',1e-12, ...
				'FunctionTolerance',1e-12, ...
				'SpecifyObjectiveGradient',false, ...
				'Display','iter', ...
				'MaxIterations',1000, ...
				'MaxFunctionEvaluations',2000000, ...
				'PlotFcn',[]);
			[q_Static,Force_Static,StaticFlag,output,jacobian] = ...
				fsolve(SystemForceFcn,q0,opt);
			StaticError = SystemForceFcn(q_Static);
			MaxAbsStaticError=max(abs(StaticError));
			%
			dq_Static = zeros(size(q_Static));
			x_Static = [q_Static;dq_Static];
			x0 = x_Static;
			dx0 = Multi_Body_Dynamics_func(deltaLNr,x0,[0,1], ...
				ModelParameter2,SolverParameter,[]);
			%
			pos_static_temp{deltaLNr} = q_Static;
% 			pos_static{MainBoomAngleNr,deltaLNr} = q_Static([115,117]);
			% 	plot_Mechanism(q_Static, ...
			% 		ModelParameter,SolverParameter,InitalStateAxes);
			fprintf('%d/%d finished:%d/%d!\n', ...
				MainBoomAngleNr,deltaLNr, ...
				pos_static_temp{deltaLNr}(115),pos_static_temp{deltaLNr}(117));
		end
		for deltaLNr = 1:32
			pos_static{MainBoomAngleNr,deltaLNr} = pos_static_temp{deltaLNr};
		end
	end
end
%% Result Merge
do_ResultMerge = false;
if do_ResultMerge
	pos_static_all = cell(41,32);
	load('Result\Lattice Boom Crane 100t Static Position\Super Truss Element\Temp_1.mat','pos_static');
	for MainBoomAngleNr = 1:1
		for deltaLNr = 1:32
			pos_static_all{MainBoomAngleNr,deltaLNr} = ...
				pos_static{MainBoomAngleNr,deltaLNr};
		end
	end
	load('Result\Lattice Boom Crane 100t Static Position\Super Truss Element\pos_static_old.mat','pos_static');
	for MainBoomAngleNr = 2:41
		for deltaLNr = 1:32
			pos_static_all{MainBoomAngleNr,deltaLNr} = ...
				pos_static{MainBoomAngleNr,deltaLNr};
		end
	end
	pos_static = pos_static_all;
	save('Result\Lattice Boom Crane 100t Static Position\Super Truss Element\pos_static.mat','pos_static');
else
	load('Result\Lattice Boom Crane 100t Static Position\Super Truss Element\pos_static.mat','pos_static');
end
%% Test
do_VideoValidation = false;
if do_VideoValidation
	TestFigure = figure('Name','Test');
	TestAxes = axes(TestFigure);
% 	pos_static = pos_static_all;
	% load('Result\Lattice Boom Crane 100t Static Position\Temp_1_10.mat','pos_static');
	
	VideoObj = VideoWriter('Video\LatticeBoomCrane_StaticPositionValidation_400t.avi');
	VideoObj.FrameRate = 30;
	open(VideoObj);
	
	MaxAbsStaticErrorSet = nan(41,32);
	
	for MainBoomAngleNr = 1:41 % 1:41
		MainBoomAngle = MainBoomAngleNr - 1 + 45;
		pos_static_temp = cell(1,32);
		if mod(MainBoomAngleNr,2) == 1
			deltaLNr_Set = 1:32;
		else
			deltaLNr_Set = 32:-1:1;
		end
		
		for deltaLNr = deltaLNr_Set % 1:32
			deltaL = deltaLNr - 1;
			[ModelParameter2] = Calc_LatticeBoomCrane_InitialCoordinate(...
				MainBoomAngle,deltaL,ModelParameter);
			%
			SystemForceFcn = @(q)Multi_Body_Dynamics_Force(q,[0,1], ...
				ModelParameter2,SolverParameter);
			q_Static = pos_static{MainBoomAngleNr,deltaLNr};
			StaticError = SystemForceFcn(q_Static);
			MaxAbsStaticError=max(abs(StaticError));
			%
			dq_Static = zeros(size(q_Static));
			x_Static = [q_Static;dq_Static];
			x0 = x_Static;
			dx0 = Multi_Body_Dynamics_func(deltaLNr,x0,[0,1], ...
				ModelParameter2,SolverParameter,[]);
			%
			plot_Mechanism(q_Static,ModelParameter2,SolverParameter,TestAxes);
			title(TestAxes,[num2str(MainBoomAngle),'/',num2str(deltaL),':',num2str(MaxAbsStaticError)]);
			axis(TestAxes,[-50,20,-35,35,-10,60]);
			drawnow;
			%
			frame = getframe(TestFigure);
			writeVideo(VideoObj,frame);
			%
			MaxAbsStaticErrorSet(MainBoomAngleNr,deltaLNr) = MaxAbsStaticError;
			fprintf('%d/%d finished:%d/%d!\n', ...
				MainBoomAngleNr,deltaLNr, ...
				q_Static(115),q_Static(117));
			%
			% 		pause(1);
		end
	end
	close(VideoObj);
end
%% Show Mapping Result
MainBoomAngleNr_Set = 1:41;
MainBoomAngle_Set = MainBoomAngleNr_Set - 1 + 45;
deltaLNr_Set = 1:32;
[MainBoomAngleNr_GridSet,~] = meshgrid(MainBoomAngleNr_Set,deltaLNr_Set);
[MainBoomAngle_GridSet,deltaLNr_GridSet] = meshgrid(MainBoomAngle_Set,deltaLNr_Set);
xPos_GridSet = nan(size(MainBoomAngle_GridSet));
zPos_GridSet = nan(size(MainBoomAngle_GridSet));
for DataNr = 1:numel(MainBoomAngle_GridSet)
	MainBoomAngleNr = MainBoomAngleNr_GridSet(DataNr);
	deltaLNr = deltaLNr_GridSet(DataNr);
	q_Static = pos_static{MainBoomAngleNr,deltaLNr};
	
	xPos_GridSet(DataNr) = q_Static(115);
	zPos_GridSet(DataNr) = q_Static(117);
end
MappingFigure = figure('Name','Mapping');
xPosMappingAxes = subplot(2,2,1,'Parent',MappingFigure);
zPosMappingAxes = subplot(2,2,2,'Parent',MappingFigure);
AngleMappingAxes = subplot(2,2,3,'Parent',MappingFigure);
deltaLMappingAxes = subplot(2,2,4,'Parent',MappingFigure);

xPos_SurfObj = surf(xPosMappingAxes,MainBoomAngle_GridSet,deltaLNr_GridSet,xPos_GridSet);
zPos_SurfObj = surf(zPosMappingAxes,MainBoomAngle_GridSet,deltaLNr_GridSet,zPos_GridSet);
Angle_SurfObj = surf(AngleMappingAxes,xPos_GridSet,zPos_GridSet,MainBoomAngle_GridSet);
deltaL_SurfObj = surf(deltaLMappingAxes,xPos_GridSet,zPos_GridSet,deltaLNr_GridSet);

xPos_SurfObj.EdgeColor = 'none';
zPos_SurfObj.EdgeColor = 'none';
Angle_SurfObj.EdgeColor = 'none';
deltaL_SurfObj.EdgeColor = 'none';

xlabel(xPosMappingAxes,'\alpha');ylabel(xPosMappingAxes,'\DeltaL');zlabel(xPosMappingAxes,'r_x');
xlabel(zPosMappingAxes,'\alpha');ylabel(zPosMappingAxes,'\DeltaL');zlabel(zPosMappingAxes,'r_z');
xlabel(AngleMappingAxes,'r_x');ylabel(AngleMappingAxes,'r_z');zlabel(AngleMappingAxes,'\alpha');
xlabel(deltaLMappingAxes,'r_x');ylabel(deltaLMappingAxes,'r_z');zlabel(deltaLMappingAxes,'\DeltaL');

title(xPosMappingAxes,'\alpha+\DeltaL->r_x');
title(zPosMappingAxes,'\alpha+\DeltaL->r_z');
title(AngleMappingAxes,'r_x+r_z->\alpha');
title(deltaLMappingAxes,'r_x+r_z->\DeltaL');
%% Mapping Fit
% ft = 'cubicinterp';
ft = fittype( 'poly22' );

[xPos_GridSet_Data, zPos_GridSet_Data, MainBoomAngle_GridSet_Data] = ...
	prepareSurfaceData( xPos_GridSet, zPos_GridSet, MainBoomAngle_GridSet );
[MainBoomAngle_fitresult, MainBoomAngle_gof] = fit(...
	[xPos_GridSet_Data, zPos_GridSet_Data], MainBoomAngle_GridSet_Data, ...
	ft, 'Normalize', 'on' );

[xPos_GridSet_Data, zPos_GridSet_Data, deltaL_GridSet_Data] = ...
	prepareSurfaceData( xPos_GridSet, zPos_GridSet, deltaLNr_GridSet );
[deltaL_fitresult, deltaL_gof] = fit(...
	[xPos_GridSet_Data, zPos_GridSet_Data], deltaL_GridSet_Data, ...
	ft, 'Normalize', 'on' );

CurveFit_Figure = figure('Name','Curve Fit Result');
MainBoomAngle_FitAxes = subplot(1,2,1,'Parent',CurveFit_Figure);
deltaL_FitAxes = subplot(1,2,2,'Parent',CurveFit_Figure);

Angle_SurfObj2 = surf(MainBoomAngle_FitAxes,xPos_GridSet,zPos_GridSet,MainBoomAngle_GridSet);
deltaL_SurfObj2 = surf(deltaL_FitAxes,xPos_GridSet,zPos_GridSet,deltaLNr_GridSet);
Angle_SurfObj2.EdgeColor = 'none';
deltaL_SurfObj2.EdgeColor = 'none';

hold(MainBoomAngle_FitAxes,'on');
hold(deltaL_FitAxes,'on');

MainBoomAngle_Fit_PlotObj = plot(MainBoomAngle_fitresult, ...
	'Parent',MainBoomAngle_FitAxes);
MainBoomAngle_Fit_PlotObj.EdgeColor = 'none';
MainBoomAngle_Fit_PlotObj.FaceAlpha = 0.3;
view(MainBoomAngle_FitAxes,-37.5,30);

deltaL_Fit_PlotObj = plot(deltaL_fitresult, ...
	'Parent',deltaL_FitAxes);
deltaL_Fit_PlotObj.EdgeColor = 'none';
deltaL_Fit_PlotObj.FaceAlpha = 0.3;
view(deltaL_FitAxes,-37.5,30);

title(MainBoomAngle_FitAxes,'\phi  Fit Surface');
xlabel(MainBoomAngle_FitAxes,'xPos');
ylabel(MainBoomAngle_FitAxes,'zPos');
zlabel(MainBoomAngle_FitAxes,'\phi');

title(deltaL_FitAxes,'\DeltaL_{15}  Fit Surface');
xlabel(deltaL_FitAxes,'xPos');
ylabel(deltaL_FitAxes,'zPos');
zlabel(deltaL_FitAxes,'\DeltaL_{15}');
%% get End Point Trajectory
load('Result\Lattice Boom Crane 100t Static Position\LatticeBoomCrane_EndPoint_Trajectory3.mat', ...
	'OptimalTrajectory');
delta_t = 0.02;
EndPoint_State = OptimalTrajectory.x;
EndPoint_PosSet = EndPoint_State(1:2,:)';
EndPoint_xPosSet = EndPoint_PosSet(:,1);
EndPoint_zPosSet = EndPoint_PosSet(:,2);

EndPoint_Trajectory_Figure = figure('Name','End Point Trajectory');
EndPoint_xPos_Axes = subplot(2,2,1,'Parent',EndPoint_Trajectory_Figure);
EndPoint_zPos_Axes = subplot(2,2,3,'Parent',EndPoint_Trajectory_Figure);
EndPoint_Pos_Axes = subplot(2,2,[2,4],'Parent',EndPoint_Trajectory_Figure);


t_set = [0:numel(EndPoint_zPosSet)-1]' * delta_t;
plot(EndPoint_xPos_Axes,t_set,EndPoint_xPosSet);
plot(EndPoint_zPos_Axes,t_set,EndPoint_zPosSet);
plot(EndPoint_Pos_Axes,EndPoint_xPosSet,EndPoint_zPosSet);

% plot3(MainBoomAngle_FitAxes,)
%% get Control Trajectory
MainBoomAngle_Trajectory = zeros(size(EndPoint_xPosSet));
deltaL_Trajectory = zeros(size(EndPoint_xPosSet));
for EndPoint_PosNr = 1:numel(EndPoint_xPosSet)
	EndPoint_xPos = EndPoint_xPosSet(EndPoint_PosNr);
	EndPoint_zPos = EndPoint_zPosSet(EndPoint_PosNr) + 2;
	
	MainBoomAngle_Trajectory(EndPoint_PosNr) = ...
		MainBoomAngle_fitresult(EndPoint_xPos,EndPoint_zPos);
	deltaL_Trajectory(EndPoint_PosNr) = ...
		deltaL_fitresult(EndPoint_xPos,EndPoint_zPos);
end
ControlTrajetoryFigure = figure('Name','Control Trajetory');
MainBoomAngle_Trajectory_Axes = subplot(2,1,1,'Parent',ControlTrajetoryFigure);
deltaL_Trajectory_Axes = subplot(2,1,2,'Parent',ControlTrajetoryFigure);

plot(MainBoomAngle_Trajectory_Axes,t_set,MainBoomAngle_Trajectory);
plot(deltaL_Trajectory_Axes,t_set,deltaL_Trajectory);

grid(MainBoomAngle_Trajectory_Axes,'on');
grid(MainBoomAngle_Trajectory_Axes,'MINOR');
grid(deltaL_Trajectory_Axes,'on');
grid(deltaL_Trajectory_Axes,'MINOR');
%% Control Curve Derivaive
ControlGradient_Figure = figure('Name','Control Gradient');
ControlGradient_alpha_Axes = subplot(3,2,1,'Parent',ControlGradient_Figure);
ControlGradient_dalphadt_Axes = subplot(3,2,3,'Parent',ControlGradient_Figure);
ControlGradient_dalphadtdt_Axes = subplot(3,2,5,'Parent',ControlGradient_Figure);
ControlGradient_L_Axes = subplot(3,2,2,'Parent',ControlGradient_Figure);
ControlGradient_dLdt_Axes = subplot(3,2,4,'Parent',ControlGradient_Figure);
ControlGradient_dLdtdt_Axes = subplot(3,2,6,'Parent',ControlGradient_Figure);


dMainBoomAngledt_Trajectory = gradient(MainBoomAngle_Trajectory,t_set);
ddMainBoomAngledtdt_Trajectory = gradient(dMainBoomAngledt_Trajectory,t_set);
ddeltaLdt_Trajectory = gradient(deltaL_Trajectory,t_set);
dddeltaLdtdt_Trajectory = gradient(ddeltaLdt_Trajectory,t_set);

plot(ControlGradient_alpha_Axes,t_set,MainBoomAngle_Trajectory);
plot(ControlGradient_dalphadt_Axes,t_set,dMainBoomAngledt_Trajectory);
plot(ControlGradient_dalphadtdt_Axes,t_set,ddMainBoomAngledtdt_Trajectory);
plot(ControlGradient_L_Axes,t_set,deltaL_Trajectory);
plot(ControlGradient_dLdt_Axes,t_set,ddeltaLdt_Trajectory);
plot(ControlGradient_dLdtdt_Axes,t_set,dddeltaLdtdt_Trajectory);
%% Cable Length
L13_Set = nan(size(MainBoomAngle_Trajectory));
L15_Set = nan(size(MainBoomAngle_Trajectory));
for ControlNr = 1:numel(MainBoomAngle_Trajectory)
	MainBoomAngle = MainBoomAngle_Trajectory(ControlNr);
	deltaL = deltaL_Trajectory(ControlNr);
	[ModelParameter2] = Calc_LatticeBoomCrane_InitialCoordinate(...
		MainBoomAngle,deltaL,ModelParameter);
	
	BodyElementParameter = ModelParameter2.BodyElementParameter;
	L13_Set(ControlNr) = BodyElementParameter{13}.L;
	L15_Set(ControlNr) = BodyElementParameter{15}.L;
end
CableLength_Figure = figure('Name','Cable Length');
L13_Axes = subplot(2,1,1,'Parent',CableLength_Figure);
L15_Axes = subplot(2,1,2,'Parent',CableLength_Figure);
plot(L13_Axes,t_set,L13_Set,'b-');
plot(L15_Axes,t_set,L15_Set,'b-');
%% Cable Length Sampling
CableLength_FitDataQuantity = 20;
CableLength_FitDataInterval = ceil(numel(L13_Set)/(CableLength_FitDataQuantity-1));
CableLength_FitData = nan(CableLength_FitDataQuantity,2);
tSet_FitData = nan(CableLength_FitDataQuantity,1);
for CableLength_FitDataNr = 1:CableLength_FitDataQuantity
	CableLength_FitDataIntervalPos = min(numel(L13_Set), ...
		(CableLength_FitDataNr-1)*CableLength_FitDataInterval+1);
	
	CableLength_FitData(CableLength_FitDataNr,:) = ...
		[L13_Set(CableLength_FitDataIntervalPos),L15_Set(CableLength_FitDataIntervalPos)];
	tSet_FitData(CableLength_FitDataNr) = ...
		t_set(1) + (CableLength_FitDataNr-1)*CableLength_FitDataInterval*delta_t;
end
CableLength_FitData_ExpandQuantity = 5;
L13_FitData = [...
	CableLength_FitData(1,1)*ones(CableLength_FitData_ExpandQuantity,1); ...
	CableLength_FitData(:,1); ...
	CableLength_FitData(end,1)*ones(CableLength_FitData_ExpandQuantity,1)];
L15_FitData = [...
	CableLength_FitData(1,2)*ones(CableLength_FitData_ExpandQuantity,1); ...
	CableLength_FitData(:,2); ...
	CableLength_FitData(end,2)*ones(CableLength_FitData_ExpandQuantity,1)];
tSet_FitData = [...
	tSet_FitData(1)+0.01*(max(tSet_FitData)-min(tSet_FitData))*(linspace(-5,-1,CableLength_FitData_ExpandQuantity))'; ...
	tSet_FitData;
	tSet_FitData(end)+0.01*(max(tSet_FitData)-min(tSet_FitData))*(linspace(1,5,CableLength_FitData_ExpandQuantity))'];

hold(L13_Axes,'on');
hold(L15_Axes,'on');
plot(L13_Axes,tSet_FitData,L13_FitData,'k.');
plot(L15_Axes,tSet_FitData,L15_FitData,'k.');
%% Cable Length Fit
ft_CableLength = 'splineinterp';
[L13_FitCurve, L13_gof] = fit( tSet_FitData, L13_FitData, ...
	ft_CableLength, 'Normalize', 'on' );
[L15_FitCurve, L15_gof] = fit( tSet_FitData, L15_FitData, ...
	ft_CableLength, 'Normalize', 'on' );

L13_FitCurveData = L13_FitCurve(t_set);
L15_FitCurveData = L15_FitCurve(t_set);
plot(L13_Axes,t_set,L13_FitCurveData,'r--');
plot(L15_Axes,t_set,L15_FitCurveData,'r--');
%% Save Result
MainBoomAngle_init = MainBoomAngle_Trajectory(1);
deltaL_init = deltaL_Trajectory(1);
save('Result\Lattice Boom Crane 100t Static Position\Super Truss Element\ControlVariable_Func.mat', ...
	'L13_FitCurve','L15_FitCurve', ...
	'MainBoomAngle_init','deltaL_init');
%%
[xPos_fitresult, xPos_gof] = fit(...
	[MainBoomAngle_GridSet_Data, deltaL_GridSet_Data], xPos_GridSet_Data, ...
	ft, 'Normalize', 'on' );

[xPos_GridSet_Data, zPos_GridSet_Data, deltaL_GridSet_Data] = ...
	prepareSurfaceData( xPos_GridSet, zPos_GridSet, deltaLNr_GridSet );
[zPos_fitresult, zPos_gof] = fit(...
	[MainBoomAngle_GridSet_Data, deltaL_GridSet_Data], zPos_GridSet_Data, ...
	ft, 'Normalize', 'on' );

xPos_fitresult(MainBoomAngle_init,deltaL_init);
zPos_fitresult(MainBoomAngle_init,deltaL_init);
%%
clear;close all;
load('Result\Lattice Boom Crane\Control\400t Super Truss Element\Verify\Result.mat', ...
	't_set','x_set');
load('Result\Lattice Boom Crane\Control\100t\Preprocessing\LatticeBoomCrane_EndPoint_Trajectory2.mat', ...
	'OptimalTrajectory');
xPos_is = x_set(:,115);
zPos_is = x_set(:,117)-2;
plot(t_set,[xPos_is,zPos_is],'r-');
hold on;
plot(linspace(0,150,size(OptimalTrajectory.x,2)),OptimalTrajectory.x(1:2,:),'b-');
hold off;
plot(xPos_is,zPos_is,'r-');
hold on;
plot(OptimalTrajectory.x(1,:),OptimalTrajectory.x(2,:),'b-');
grid minor;