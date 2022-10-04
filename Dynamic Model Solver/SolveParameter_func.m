function SolveParameter_func(configs)
%% Load Parameter from Excel File
ExcelFileName = configs.ExcelFileName;
ExcelFileDir = configs.ExcelFileDir;
%
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir);
%
SolverParameter.ComputingDisplay.PlotMechanisum = false;
%%
AbsoluteTolerance = SolverParameter.ODE_Solver.AbsTol;
RelativeTolerance = SolverParameter.ODE_Solver.RelTol;
MaxStep = SolverParameter.ODE_Solver.MaxStep;
opt = odeset('RelTol',RelativeTolerance, ...
	'AbsTol',AbsoluteTolerance, ...
	'MaxStep',MaxStep, ...
	'OutputFcn',[]);
%%
SolverParameter.ActionFunction = configs.ActionFunctionHandle;
%% Static Position
tic;
Static_Start_Position = SolverParameter.StaticPosition.do_Calc;
max_VelocityAcceleration_Tolerance = ...
	SolverParameter.StaticPosition.max_Tol;
x0 = Calc_Static_Position(...
	Static_Start_Position,max_VelocityAcceleration_Tolerance, ...
	ModelParameter,SolverParameter,opt,[]);
%% dynamic ode
t_start = SolverParameter.ODE_Solver.t_start;
t_end = SolverParameter.ODE_Solver.t_end;
tspan = [t_start;t_end];
%
[t_set,x_set] = ode23tb(...
	@(t,x)Multi_Body_Dynamics_func(...
	t,x,tspan,ModelParameter,SolverParameter,[]), ...
	tspan,x0,opt);
% [t_set,x_set] = ode23tb(...
% 	@(t,x)Multi_Body_Dynamics_Static_func2(...
% 	t,x,tspan,ModelParameter,SolverParameter,[]), ...
% 	tspan,x0,opt);
%
SolvingTime = toc;
%% Save Result
SaveResult = SolverParameter.Result.SaveResult;
%
if SaveResult == true
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
fprintf('Finished!\n');

end