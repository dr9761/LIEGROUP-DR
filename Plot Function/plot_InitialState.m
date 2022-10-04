function InitalStateAxes = plot_InitialState(...
	do_plot_InitialState, ...
	ModelParameter,SolverParameter)
%%
InitalStateAxes = [];
%%
if do_plot_InitialState
	%
	InitalStateFigure = figure('Name','InitialState');
	InitalStateAxes = axes(InitalStateFigure);
	plot_Mechanism(ModelParameter.InitialState.q0, ...
		ModelParameter,SolverParameter,InitalStateAxes);
	%
	drawnow;
end

end