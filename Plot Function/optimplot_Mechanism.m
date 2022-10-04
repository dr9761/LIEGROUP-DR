function stop = optimplot_Mechanism(x,optimValues,state,varargin, ...
	ModelParameter,SolverParameter)

persistent MechanismAxes;
stop = false;

switch state
	case 'iter'
		if optimValues.iteration == 1
			MechanismFigure = figure('Name','Mechanism by fsolve');
			MechanismAxes = axes(MechanismFigure);
		end
		if optimValues.iteration >= 1
			plot_Mechanism(x,ModelParameter,SolverParameter,MechanismAxes);
		end
end