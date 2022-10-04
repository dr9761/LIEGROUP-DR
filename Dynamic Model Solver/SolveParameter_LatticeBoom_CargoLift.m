clc;clear;
close all;
%% Change Working Dictionary
fprintf('Welcome to use Rigid-Flexible Hybrid Multi-Body Dynamic Simulation Programm!\n');
fprintf('\n');

FullPathOfProgramm = mfilename('fullpath');
[FullPathOfProject,~]=fileparts(FullPathOfProgramm);
CurrentWorkingDictionary = cd;
if ~strcmp(CurrentWorkingDictionary,FullPathOfProject)
	fprintf('Your Current Working Dictionary is not the path of the Programm!\n');
	fprintf('In order to make the program run normally,\n');
	fprintf('Your Working Dictionary will be changed!\n');
	fprintf('...\n');
	% 	fprintf('Do you want to change your Working Dictionary?[Y/N]\n');
	cd(FullPathOfProject);
	fprintf('Working Dictionary has been changed!\n\n');
end
%% Load Sub-Module
Load_SubModule(FullPathOfProject);
%% Load Parameter from Excel File
ExcelFileName = ...
	'Cargo Lift';
ExcelFileDir = [...
	'Parameter File', ...
	'\Lattice boom crane model', ...
	'\Truss Equivalent Model'];
%
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);

ModelParameter.ConstraintParameter(end) = [];
%% Action Function
SolverParameter.ActionFunction = ...
	@(t,x,tspan,ModelParameter)get_Action_None(...
	t,x,tspan,ModelParameter);
%%
exist_InitialState = true;
if exist_InitialState
	InitialStateFileName = [...
		'Result\Lattice Boom Crane\', ...
		'Cargo Leaving Ground\Result.mat'];
	x0 = load(InitialStateFileName,'x_set');
	x0 = x0.x_set(end,:);
	x0 = x0';
	q0 = x0(1:numel(x0)/2);
	dq0 = x0(numel(x0)/2+1:end);
	
	ModelParameter.InitialState.x0 = x0;
	ModelParameter.InitialState.q0 = q0;
	ModelParameter.InitialState.dq0 = dq0;
	%
	t_start = load(InitialStateFileName,'t_set');
	t_start = t_start.t_set(end);
	
	SolverParameter.ODE_Solver.t_start = t_start;
end
%
InitalStateFigure = figure('Name','InitialState');
InitalStateFigure = axes(InitalStateFigure);
plot_Mechanism(ModelParameter.InitialState.q0, ...
	ModelParameter,SolverParameter,InitalStateFigure);
%
drawnow;
%%
switch SolverParameter.ODE_Solver.OutputFcn
	case 'MechanisumPlot'
		StateFigure = figure('Name','State during Calculation from @odeplot');
		StateAxis = axes(StateFigure);
		%
		CalcPlotFigure = figure('Name','State during Calculation');
		CalcMechanismAxesSet.xz     = subplot(2,2,1,'Parent',CalcPlotFigure);
		CalcMechanismAxesSet.yz     = subplot(2,2,2,'Parent',CalcPlotFigure);
		CalcMechanismAxesSet.xy     = subplot(2,2,3,'Parent',CalcPlotFigure);
		CalcMechanismAxesSet.normal = subplot(2,2,4,'Parent',CalcPlotFigure);
		%
		plot_OdeOutput_Handle = @(t,y,flag)plot_OdeOutput(...
			t,y,flag,ModelParameter,SolverParameter, ...
			StateFigure,StateAxis, ...
			CalcMechanismAxesSet);
	case 'odeplot'
		StateFigure = figure('Name','State during Calculation from @odeplot');
		StateAxis = axes(StateFigure);
		%
		plot_OdeOutput_Handle = @(t,y,flag)odeplot_with_FigureObj(...
			t,y,flag,StateFigure,StateAxis);
	case '[]'
		plot_OdeOutput_Handle = [];
	case 'Judgment_CargoLeavingGround'
		plot_OdeOutput_Handle = @(t,y,flag)Judgment_CargoLeavingGround(...
			t,y,flag,ModelParameter,SolverParameter);
	otherwise
		plot_OdeOutput_Handle = [];
end
plot_OdeOutput_Handle = [];

AbsoluteTolerance = SolverParameter.ODE_Solver.AbsTol;
RelativeTolerance = SolverParameter.ODE_Solver.RelTol;
MaxStep = SolverParameter.ODE_Solver.MaxStep;
opt = odeset('RelTol',RelativeTolerance, ...
	'AbsTol',AbsoluteTolerance, ...
	'MaxStep',MaxStep, ...
	'OutputFcn',plot_OdeOutput_Handle);
%%
if SolverParameter.ComputingDisplay.PlotMechanisum
	ComputingFigure = figure('Name','State during Calculation');
	ComputingFigure = axes(ComputingFigure);
else
	ComputingFigure = [];
end

%% Static Position
tic;
Static_Start_Position = SolverParameter.StaticPosition.do_Calc;
max_VelocityAcceleration_Tolerance = ...
	SolverParameter.StaticPosition.max_Tol;
x0 = Calc_Static_Position(...
	Static_Start_Position,max_VelocityAcceleration_Tolerance, ...
	ModelParameter,SolverParameter,opt,InitalStateFigure);
%% dynamic ode
t_start = SolverParameter.ODE_Solver.t_start;
t_end = SolverParameter.ODE_Solver.t_end;
tspan = [t_start;t_end];

% switch 
% [t_set,x_set] = Runge_Kutta_4(...
% 	@(t,x)Multi_Body_Dynamics_func(...
% 	t,x,tspan,ModelParameter,SolverParameter,ComputingFigure), ...
% 	tspan,x0,opt);

% [t_set,x_set] = Implicit_Runge_Kutta_4(...
% 	ModelParameter, ...
% 	tspan,ModelParameter.InitialState.x0,opt, ...
% 	SolverParameter,ComputingFigure);

[t_set,x_set] = ode23tb(...
	@(t,x)Multi_Body_Dynamics_LatticeBoom_CargoLift_func(...
	t,x,tspan,ModelParameter,SolverParameter,ComputingFigure), ...
	tspan,x0,opt);

SolvingTime = toc;
% pause;
%% Save Result
SaveResult = SolverParameter.Result.SaveResult;
if t_set(end) == tspan(2)
	SaveResult = SaveResult & true;
else
	SaveResult = SaveResult & false;
end
%
if SaveResult
	ResultFileAddress = ...
		['Result\',datestr(now,'yyyymmdd_HHMM'),ExcelFileName];
	mkdir(ResultFileAddress);
	ExcelFilePath = [ExcelFileDir,'\',ExcelFileName,'.xlsx'];
	copyfile(ExcelFilePath,ResultFileAddress);
	save([ResultFileAddress,'\Parameter.mat']);
	save([ResultFileAddress,'\OdeSetup.mat'],'opt','tspan');
	save([ResultFileAddress,'\Result.mat'], ...
		'x_set','t_set','SolvingTime');
end
%%
FinalResultFigure = figure('Name','Final Result');
FinalResultFigure = axes(FinalResultFigure);
pause(0.01);
plot_Mechanism_PostProcessing(x_set,t_set, ...
	ModelParameter,SolverParameter,FinalResultFigure);
%%
fprintf('Finished!\n');
