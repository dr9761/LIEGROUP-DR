function [MassForce_JacobianFunc,State_JacobianFunc] = ...
	get_MassForce_JacobianFunc_Multi_Body_Dynamic_Symbolic(...
	ModelParameter)
% MassForce_StateVariable_JacobianFunc = [];
% State_JacobianFunc = [];

%%
q  = casadi.SX.sym('q', numel(ModelParameter.InitialState.q0), 1);
dq = casadi.SX.sym('dq',numel(ModelParameter.InitialState.dq0),1);
x = [q;dq];
t = casadi.SX.sym('t');
DriveParameter = ModelParameter.DriveParameter;
u = casadi.SX.sym('u', ...
	DriveParameter.NodalForceDriveParameter.Drive_Action_Map.Count,1);

[dx,Mass,Force,lambda] = Multi_Body_Dynamics_Symbolic_func(...
	t,x,u,ModelParameter);
%%
StateJacobian_x = jacobian(dx,x);
StateJacobian_u = jacobian(dx,u);
StateJacobian_t = jacobian(dx,t);
%
MassJacobianBase = casadi.SX.sym('b',numel(ModelParameter.InitialState.q0),1);
MassJacobian = jacobian(Mass*MassJacobianBase,q);
MassJacobian = jacobian(Mass,q);
%
ForceJacobian_q = jacobian(Force,q);
ForceJacobian_dq = jacobian(Force,dq);
ForceJacobian_u = jacobian(Force,u);
%%
MassForce_JacobianFunc = ...
	casadi.Function('MassForce_StateVariable_JacobianFunc', ...
	{q,dq,u,MassJacobianBase}, {MassJacobian, ForceJacobian_q,ForceJacobian_dq,ForceJacobian_u}, ...
	{'q','dq','u','b'}, {'MassJacobian','ForceJacobian_q','ForceJacobian_dq','ForceJacobian_u'});

State_JacobianFunc = ...
	casadi.Function('State_JacobianFunc', ...
	{t,x,u}, {dx,StateJacobian_t,StateJacobian_x,StateJacobian_u}, ...
	{'t','x','u'}, {'f','StateJacobian_t','StateJacobian_x','StateJacobian_u'});

end