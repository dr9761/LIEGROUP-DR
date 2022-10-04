function SolverParameter = set_SolverParameter(ExcelFilePath)
%%
[~,~,Solver_ParameterTableRaw]= ...
	xlsread(ExcelFilePath,'Solver Parameter');
%%
JacobianCalculation.Calculate = Solver_ParameterTableRaw{3,3};
%
SolverParameter.JacobianCalculation = JacobianCalculation;
%% ODE_Solver_Parameter
ODE_Solver.SolverName =		Solver_ParameterTableRaw{8,3};
ODE_Solver.SolverMethod =	Solver_ParameterTableRaw{9,3};
ODE_Solver.SolverOrder =	Solver_ParameterTableRaw{10,3};
ODE_Solver.SolverOption =	Solver_ParameterTableRaw{11,3};
ODE_Solver.t_start =		Solver_ParameterTableRaw{12,3};
ODE_Solver.t_end =			Solver_ParameterTableRaw{13,3};
ODE_Solver.AbsTol =			Solver_ParameterTableRaw{14,3};
ODE_Solver.RelTol =			Solver_ParameterTableRaw{15,3};
ODE_Solver.MaxStep =		Solver_ParameterTableRaw{16,3};
ODE_Solver.OutputFcn =		Solver_ParameterTableRaw{17,3};
%
SolverParameter.ODE_Solver = ODE_Solver;
%% Static Position
StaticPosition.do_Calc = Solver_ParameterTableRaw{19,3};
StaticPosition.max_Tol = Solver_ParameterTableRaw{20,3};
%
SolverParameter.StaticPosition = StaticPosition;
%% Display By Computing
ComputingDisplay.DisplayTime =				Solver_ParameterTableRaw{22,3};
ComputingDisplay.PlotMechanisum =			Solver_ParameterTableRaw{23,3};
ComputingDisplay.PlotStartInteration =		Solver_ParameterTableRaw{24,3};
ComputingDisplay.PlotInterationInterval =	Solver_ParameterTableRaw{25,3};
%
SolverParameter.ComputingDisplay = ComputingDisplay;
%% Result
Result.SaveResult = Solver_ParameterTableRaw{27,3};
Result.Existence =	Solver_ParameterTableRaw{28,3};
Result.Dictionary = Solver_ParameterTableRaw{29,3};
%
SolverParameter.Result = Result;
%% Plot Configuration
PlotConfiguration.AxesSize =			str2num(Solver_ParameterTableRaw{31,3});
PlotConfiguration.GridSetting =			Solver_ParameterTableRaw{32,3};
PlotConfiguration.ObservationAngle =	Solver_ParameterTableRaw{33,3};
switch PlotConfiguration.ObservationAngle
	case 'x-z'
		PlotConfiguration.Azimuth = 0;
		PlotConfiguration.Elevation = 0;
	otherwise
		PlotConfiguration.Azimuth = -37.5;
		PlotConfiguration.Elevation = 30;
end
%
SolverParameter.PlotConfiguration = PlotConfiguration;
end