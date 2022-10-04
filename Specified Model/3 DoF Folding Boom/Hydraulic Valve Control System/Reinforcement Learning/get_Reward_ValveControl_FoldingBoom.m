function Reward = get_Reward_ValveControl_FoldingBoom(Obs,NextObs,Action)
%%
StateQuantity = numel(NextObs);
q = NextObs(1:3);
dq = NextObs(4:6);
p = NextObs(7:10);
%% NextObs
gx = [1;0;0];
gy = [0;1;0];
gz = [0;0;1];
%% 0,80,160
Reward = -((q(2)-deg2rad(80))/deg2rad(90))^2 ...
	-((q(3)-deg2rad(160))/deg2rad(180))^2 ...
	-((q(1)-deg2rad(0))/deg2rad(180))^2;

end