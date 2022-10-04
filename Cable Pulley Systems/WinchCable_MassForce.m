function [Mass,Force] = WinchCable_MassForce(...
	qe,dqe,g,BodyParameter)
%%
sw = qe(10);
%%
Mass = zeros(numel(dqe));
Force = zeros(numel(dqe),1);
%%
[qwinch,dqwinch,Twinch,dTwinch] = get_Winch_Coordinate(...
	qe,dqe,BodyParameter);
%
WinchParameter = BodyParameter.WinchParameter;
[Mass_winch,Force_winch] = RigidBody_MassForce(...
	qwinch,dqwinch,g,WinchParameter);
Mass = Mass + Twinch'*Mass_winch*Twinch;
Force = Force + Twinch'*Mass_winch*dTwinch*dqe + ...
	Twinch'*Force_winch;
%%
[qcable,dqcable,Tcable,dTcable] = get_Cable_Coordinate(...
	qe,dqe,BodyParameter);
%
CableParameter = BodyParameter.CableParameter;
BodyParameter.FreeCableParameter = CableParameter;
BodyParameter.FreeCableParameter.L = CableParameter.L + sw;

[Mass_cable,Force_cable] = FreeCable_MassForce(...
	qcable,dqcable,g,BodyParameter.FreeCableParameter);
Mass = Mass + Tcable'*Mass_cable*Tcable;
Force = Force + Tcable'*Mass_cable*dTcable*dqe + ...
	Tcable'*Force_cable;
%%
[Mass,Force] = add_Redundant_DoF_WinchCable(Mass,Force,qe,dqe);
% Mass\Force
end