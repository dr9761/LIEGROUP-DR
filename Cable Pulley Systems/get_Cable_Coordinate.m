function [qcable,dqcable,Tcable,dTcable] = ...
	get_Cable_Coordinate(qe,dqe,BodyParameter)
%%
[qw,dqw,Tw,dTw] = ...
	get_Cable_ContactPoint_Coordinate(qe,dqe,BodyParameter);
%%
qwe = qe(11:end);
dqwe = dqe(11:end);
Twe = zeros(numel(dqwe),numel(dqe));
Twe(:,11:end) = eye(numel(dqwe));
dTwe = zeros(numel(dqwe),numel(dqe));
%%
% qcable = [qw;qwe];
% dqcable = [dqw;dqwe];
% Tcable = [Tw;Twe];
% dTcable = [dTw;dTwe];

qcable = [qwe;qw];
dqcable = [dqwe;dqw];
Tcable = [Twe;Tw];
dTcable = [dTwe;dTw];
end