function dx = ShipCrane_ControlledDynamic_func(t,x,u,s, ...
	ModelParameter)
%%
q = x(1:numel(x)/2);
dq = x(numel(x)/2+1:end);
% s = zeros(6,1);
%%
[ddq,~,~,~,~] = ...
	ShipCrane_ForwardDynamic(q,dq,s,u,ModelParameter);
%
dqdt = dq;
dqdt(4:6) = get_T_Symbolic(q(4:6)) \ dq(4:6);
dx = [dqdt;ddq];

end