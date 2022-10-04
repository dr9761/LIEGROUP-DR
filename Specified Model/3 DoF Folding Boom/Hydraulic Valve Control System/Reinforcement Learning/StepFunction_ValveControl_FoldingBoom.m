function [NextObs,Reward,IsDone,LoggedSignals] = ...
    StepFunction_ValveControl_FoldingBoom(Action,LoggedSignals, ...
	ModelParameter,HydraulicParameter,SolverParameter,Ts,Tf, ...
	TrainingFigure,ActionFigure)
%%
% global SimulationTime;
% if isfield(LoggedSignals,'SimulationTime')
% 	LoggedSignals.SimulationTime = LoggedSignals.SimulationTime + Ts;
% else
% 	LoggedSignals.SimulationTime = 0;
% end
SimulationTime = LoggedSignals.SimulationTime;
LoggedSignals.SimulationTime = LoggedSignals.SimulationTime + Ts;
%%
Obs = LoggedSignals.State;
up = LoggedSignals.up;
%%
% Tf = 1;
ActionPlotColorSet = {'r';'g';'b';'y';'m';'c'};
ActionPlotStyleSet = {'.';'+';'*';'o';'x';'s';'d';'^';'v';'>';'<';'p';'h'};
if SimulationTime == 0
	hold(ActionFigure,'off');
else
	hold(ActionFigure,'on');
end
for ActionNr = 1:numel(Action)
	ActionPlotColor = ActionPlotColorSet{mod(ActionNr,numel(ActionPlotColorSet))+1};
	ActionPlotStyle = ActionPlotStyleSet{ceil(ActionNr/numel(ActionPlotColorSet))};
	plot(ActionFigure,SimulationTime/Ts,Action(ActionNr),[ActionPlotColor,ActionPlotStyle]);
end
axis(ActionFigure,[0,Tf/Ts,-1e0,1e0]);
% plot_Mechanism(Obs(1:numel(Obs)/2),ModelParameter,TrainingFigure);
% pause(0.001);

%%
% Action = Action*1e5;
% u = [0;Action * 1e6];
u = zeros(3,1);
u(2:3) = Action;
%%
% DriveParameter = ModelParameter.DriveParameter;
% NodalForceParameter = ModelParameter.NodalForceParameter;
% ActionTagSet = DriveParameter.NodalForceDriveParameter.Drive_Action_Map.keys;
% ModelParameter.NodalForceParameter = ...
% 	apply_Action_to_NodalForceParameter(...
% 	DriveParameter,NodalForceParameter,Action,ActionTagSet);
%%
tspan = [SimulationTime,SimulationTime+Ts];
x0 = Obs;
opt = odeset('RelTol',0.01,'AbsTol',0.01,'MaxStep',Ts);
%
% [~,x_set] = Runge_Kutta_4(...
% 	@(t,x)Controlled_Multi_Body_Dynamics_func(...
% 	t,x,tspan,ModelParameter,Action,ActionTagSet), ...
% 	tspan,x0,opt);
% [~,x_set] = Runge_Kutta_4(...
% 	@(t,x)FoldingBoom_3DoF_Dynamic_func(t,x,u, ...
% 	ModelParameter,SolverParameter,TrainingFigure), ...
% 	tspan,x0,opt);
%
% [~,x_set] = ode23tb(...
% 	@(t,x)Controlled_Multi_Body_Dynamics_func(...
% 	t,x,tspan,ModelParameter,Action,ActionTagSet), ...
% 	tspan,x0,opt);

[~,x_set] = ode23tb(...
	@(t,x)FoldingBoom_3DoF_ValveControlHydraulic_Dynamic_func(...
	t,x,u,up,tspan,ModelParameter,HydraulicParameter,SolverParameter,TrainingFigure), ...
	tspan,x0,opt);
fprintf('Simulation Time Interval: (%6.4f,%6.4f)\n', ...
	SimulationTime,SimulationTime+Ts);

%%
NextObs = x_set(end,:)';
% [NextObs,Body] = Runge_Kutta_4_ControlledDynamicModel(...
% 	Obs,ModelParameter,Action,Ts);
LoggedSignals.State = NextObs;

%% Check terminal condition
IsDone = false;
%% Get reward.
Reward = get_Reward_ValveControl_FoldingBoom(Obs,NextObs,Action);
%%

% SimulationTime = SimulationTime + Ts;
drawnow;
end