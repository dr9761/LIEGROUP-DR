function [Mass] = Multi_Body_Dynamics_Mass(x0,epsilon,d,tspan, ...
	ModelParameter,SolverParameter)
%%
t = tspan(1);

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
[Action,ActionTagSet] = get_Action(t,x0,tspan,ModelParameter, ...
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


%% Set Frame
q0  = zeros(6,1);
dq0 = zeros(6,1);

Frame.Joint = set_Frame_Joint(q0,dq0,Frame_Joint_Parameter);
Frame.BodyType = 'Rigid Body';
%%
Mass = zeros(12);
Body = cell(BodyQuantity,1);
for BodyNr = 1:BodyQuantity

    Body{BodyNr}.BodyType = ...
		BodyElementParameter{BodyNr}.BodyType;

   	BodyCoordinate = ...
		BodyElementParameter{BodyNr}.GlobalCoordinate;
    

	[Body{BodyNr}.Mass,Body{BodyNr}.Force] = get_Element_MassForce(g,d,epsilon,BodyElementParameter{BodyNr});
    %%%26.8 已修改
% 	Body{BodyNr}.Joint = set_Joint(...
% 		qe,dqe,BodyElementParameter,BodyNr,Joint_Parameter);
	%%
	Mass(BodyCoordinate,BodyCoordinate) = ...
		Mass(BodyCoordinate,BodyCoordinate) + Body{BodyNr}.Mass;
	
end

Mass = Mass;

end