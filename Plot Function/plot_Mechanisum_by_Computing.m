function IterationNr = plot_Mechanisum_by_Computing(...
	q,t,ModelParameter,SolverParameter, ...
	CalcPlotFigure,IterationNr,tspan)
%%
if isempty(CalcPlotFigure)
	IterationNr = 0;
	return;
end
%%
if t == tspan(1) || t == 0
	IterationNr = 0;
else
	IterationNr = IterationNr + 1;
end
%%
plot_Start_Iteration = ...
	SolverParameter.ComputingDisplay.PlotStartInteration;%5400
plot_Iteration_Interval = ...
	SolverParameter.ComputingDisplay.PlotInterationInterval;
%%
% if IterationNr > plot_Start_Iteration && ...
% 		mod(IterationNr,plot_Iteration_Interval) == 0 && ...
% 		t >= 0
if IterationNr > plot_Start_Iteration && ...
		mod(IterationNr,plot_Iteration_Interval) == 0
	plot_Mechanism(q,ModelParameter,SolverParameter,CalcPlotFigure);
	title(CalcPlotFigure,['IterationNr = ',num2str(IterationNr)]);
	drawnow;
end

end