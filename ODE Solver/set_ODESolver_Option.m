function opt = set_ODESolver_Option(ModelParameter,SolverParameter)
%% Output Function
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
	otherwise
		plot_OdeOutput_Handle = [];
end
%% Tolearance & Max Step
AbsoluteTolerance = SolverParameter.ODE_Solver.AbsTol;
RelativeTolerance = SolverParameter.ODE_Solver.RelTol;
MaxStep = SolverParameter.ODE_Solver.MaxStep;
%% opt
opt = odeset('RelTol',RelativeTolerance, ...
	'AbsTol',AbsoluteTolerance, ...
	'MaxStep',MaxStep, ...
	'OutputFcn',plot_OdeOutput_Handle);

end