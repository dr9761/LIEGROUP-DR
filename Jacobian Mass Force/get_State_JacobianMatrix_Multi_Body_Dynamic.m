function [f,StateJacobian_t,StateJacobian_x,StateJacobian_u] ...
	= get_State_JacobianMatrix_Multi_Body_Dynamic(...
	t,x,u,State_JacobianFunc)
%%
Jacobian_x = x;
MissingQuantity = numel(x(x == 0));
Jacobian_x(x == 0) = eps*rand(MissingQuantity)*ones(MissingQuantity,1);
%%
StateJacobian = State_JacobianFunc('t',t,'x',Jacobian_x,'u',u);
%%
f = ...
	full(StateJacobian.f);
StateJacobian_x = ...
	full(StateJacobian.StateJacobian_x);
StateJacobian_u = ...
	full(StateJacobian.StateJacobian_u);
StateJacobian_t = ...
	full(StateJacobian.StateJacobian_t);
%%
% StateJacobian_x(isnan(StateJacobian_x)) = 0;
% StateJacobian_u(isnan(StateJacobian_u)) = 0;
% StateJacobian_t(isnan(StateJacobian_t)) = 0;
end