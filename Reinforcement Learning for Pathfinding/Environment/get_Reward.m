function Reward = get_Reward(Obs,NextObs,Action)
%%
StateQuantity = numel(NextObs);
q = NextObs(1:StateQuantity/2);
dq = NextObs(StateQuantity/2+1:end);
%% NextObs
gx = [1;0;0];
gy = [0;1;0];
gz = [0;0;1];
%%
% max_distance = 20;
% distance = abs(rx+1);

% max_angular_distance = pi;
% angular_distance = acos(nx'*gz);
% angular_distance = phi(2) + pi/2;

% velocity = abs(drxdt);
%%
% Single Rigid Cart Pole
% Reward = 1 ...
% 	- (angular_distance/max_angular_distance)^3 ...
% 	- (distance/max_distance)^3;

% if distance > max_distance
% 	B = 1;
% else
% 	B = 0;
% end
% Reward = -0.1*(5*angular_distance^2 + distance^2 + 0*0.05*Action^2) ...
% 	-100*B;

% Rigid Beam Pendulum Moment Drive
%% 0,80,160
Reward = -((q(2)-deg2rad(80))/deg2rad(90))^2 ...
	-((q(3)-deg2rad(160))/deg2rad(180))^2 ...
	-((q(1)-deg2rad(0))/deg2rad(180))^2 + 3;

end