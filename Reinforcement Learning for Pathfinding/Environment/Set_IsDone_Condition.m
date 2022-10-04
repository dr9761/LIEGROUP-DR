function IsDone = Set_IsDone_Condition(Obs,NextObs,Action)
%%
StateQuantity = numel(NextObs);
q = NextObs(1:StateQuantity/2);
dq = NextObs(StateQuantity/2+1:end);
%%
% rx = q(7);
% phi = q(4:6);
% gx = [1;0;0];
% gy = [0;1;0];
% gz = [0;0;1];
% nx = get_R(phi) * gx;
% 
% max_distance = 50;
% IsDone = abs(rx+1) > 20;
IsDone = false;
%%
if q(2) < 0 || q(2) > deg2rad(89)
	IsDone = true;
end
if q(3) < 0 || q(3) > deg2rad(179)
	IsDone = true;
end
end