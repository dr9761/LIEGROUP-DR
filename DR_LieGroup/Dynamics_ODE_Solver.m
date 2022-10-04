function [t_set,y_set] = Dynamics_ODE_Solver(...
	tspan,x0,y0,opt,ModelParameter,SolverParameter)

if SolverParameter.ComputingDisplay.PlotMechanisum
	ComputingFigure = figure('Name','State during Calculation');
	ComputingFigure = axes(ComputingFigure);
else
	ComputingFigure = [];
end

% [t_set,RA_set,xA_set,vA_set,RB_set,xB_set,vB_set] = ode23(@(t,RA, ...
%     xA,vA,RB,xB,vB)Multi_Body_Dynamics_func(t,RA,xA,vA,RB,xB,vB,tspan, ...
% 	SystemForceFcn,MassMtx),tspan,y0,opt);
[t_set,y_set] = ode23tb(@(t,y)Multi_Body_Dynamics_func(t,y,x0,tspan,ModelParameter,SolverParameter,ComputingFigure),tspan,y0,opt);
end