function Force = Multi_Body_Dynamics_Force(q,tspan, ...
	ModelParameter,SolverParameter)

function Force = Multi_Body_Dynamics_Force(q,tspan, ...
	ModelParameter,SolverParameter)
%%
t = tspan(1);
dq = zeros(size(q));
x = [q;dq];
%%
g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;
Frame_Joint_Parameter = ModelParameter.Frame_Joint_Parameter;
Joint_Parameter = ModelParameter.Joint_Parameter;
ConstraintParameter = ModelParameter.ConstraintParameter;
NodalForceParameter = ModelParameter.NodalForceParameter;
DriveParameter = ModelParameter.DriveParameter;

BodyQuantity = numel(BodyElementParameter);
%%
[Action,ActionTagSet] = get_Action(t,x,tspan,ModelParameter, ...
	SolverParameter.ActionFunction);
if DriveParameter.NodalForceDriveParameter.Drive_Action_Map.length ...
		~= numel(Action)
	Action = ...
		zeros(numel(DriveParameter),1);
	ActionTagSet = ...
		DriveParameter.NodalForceDriveParameter.Drive_Action_Map.keys;
	warning('Drive Parameter and Action do not match!');
% 	error('Drive Parameter and Action do not match!');
end
NodalForceParameter = apply_Action_to_NodalForceParameter(...
	DriveParameter,NodalForceParameter,Action,ActionTagSet);
%%
Mass = zeros(numel(q),numel(q));
Force = zeros(numel(q),1);
%% Set Frame
q0  = zeros(6,1);
dq0 = zeros(6,1);

Frame.Joint = set_Frame_Joint(q0,dq0,Frame_Joint_Parameter);
Frame.T_qe_q = zeros(6,numel(q));
Frame.BodyType = 'Rigid Body';
%%
Body = cell(BodyQuantity,1);
for BodyNr = 1:BodyQuantity
	%%
	Body{BodyNr}.BodyType = ...
		BodyElementParameter{BodyNr}.BodyType;
	%%
	BodyCoordinate = ...
		BodyElementParameter{BodyNr}.GlobalCoordinate;
	
	qe  = q(BodyCoordinate);
	dqe = dq(BodyCoordinate);
	T_qe_q = zeros(numel(BodyCoordinate),numel(q));
	T_qe_q(:,BodyCoordinate) = eye(numel(BodyCoordinate));
	
	Body{BodyNr}.T_qe_q = T_qe_q;
	%%
	[Body{BodyNr}.Mass,Body{BodyNr}.Force] = get_Element_MassForce(...
		qe,dqe,g,BodyElementParameter{BodyNr});
	%%
	Body{BodyNr}.Joint = set_Joint(...
		qe,dqe,BodyElementParameter,BodyNr,Joint_Parameter);
	%%
	Mass(BodyCoordinate,BodyCoordinate) = ...
		Mass(BodyCoordinate,BodyCoordinate) + Body{BodyNr}.Mass;
	Force(BodyCoordinate) = ...
		Force(BodyCoordinate) + Body{BodyNr}.Force;
end
%% add Force Drive
Drive_Force = add_NodalForce(q,dq,t,Body,NodalForceParameter);
Force = Force + Drive_Force;
%% add Constraint
[Phi,B,dPhi,Tau] = add_Constraint(q,dq,Frame,Body, ...
	BodyElementParameter,ConstraintParameter);
%Display time

fprintf('t = %16.14f\n',t);
end