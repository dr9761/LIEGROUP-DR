function [InitialObservation,LoggedSignals] = ...
    ResetFunction_DynamicModel(x0)
%%
% global SimulationTime;
% SimulationTime = 0;
%%
% x0(11) = deg2rad((rand(1)-0.5)*180);
% x0(11) = x0(11) + deg2rad(5);
%%
LoggedSignals.State = x0;
LoggedSignals.SimulationTime = 0;
InitialObservation = LoggedSignals.State;
% fprintf('Reset Finished!\n');
%%
LoggedSignals.up = zeros(3,1);
end