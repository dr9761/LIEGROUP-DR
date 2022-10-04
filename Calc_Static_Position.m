function x0 = Calc_Static_Position(...
	Static_Start_Position,max_VelocityAcceleration_Tolerance, ...
	ModelParameter,SolverParameter,opt,InitalStateFigure)
%%
x0 = ModelParameter.InitialState.x0;
tspan = [-11 -1];
Static_Position_Iteration = 0;
while Static_Start_Position
	Static_Position_Iteration = Static_Position_Iteration + 1;
	[~,x_static_set]=ode23tb(...
		@(t,x)Multi_Body_Dynamics_func(...
		t,x,tspan,ModelParameter,SolverParameter, ...
		InitalStateFigure), ...
		tspan,x0,opt);
	%%
	x0 = x_static_set(end,:)';
	dx0_static = Multi_Body_Dynamics_func(...
		-1,x0,tspan,ModelParameter,SolverParameter, ...
		InitalStateFigure);
	if ~isempty(InitalStateFigure)
		title(InitalStateFigure, ...
			['Static_Iteration = ',num2str(Static_Position_Iteration)]);
	end
	%%
	if max(abs(dx0_static)) < max_VelocityAcceleration_Tolerance
		break;
	end
end
% if Static_Start_Position
% 	figure('Name','Static Position');
% 	plot_Mechanism(x0(1:numel(x0)/2),ModelParameter);
% end
end