function [Force] = Multi_Body_Dynamics_Force(x0,epsilon,d,tspan, ...
	ModelParameter,SolverParameter)
%%
t = tspan(1);
q = x0(1:numel(x0)/2)
dq = x0(numel(x0)/2+1:end);

%% PreProcessingMethode = 'Lattice Boom Crane Control';
PreProcessingMethode = 'None';
[q0,dq0,x0,ModelParameter] = ModelPreProcessing(PreProcessingMethode,t,x0,tspan,ModelParameter);

% dq = zeros(size(q));
% x = [q;dq];
%%
g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;
Frame_Joint_Parameter = ModelParameter.Frame_Joint_Parameter;
Joint_Parameter = ModelParameter.Joint_Parameter;
ConstraintParameter = ModelParameter.ConstraintParameter;
NodalForceParameter = ModelParameter.NodalForceParameter;
DriveParameter = ModelParameter.DriveParameter;

BodyQuantity = numel(BodyElementParameter);
%
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
%%
%% Set Frame
if t >= 0 && t <= 15
	% 	q0(5) = -pi/2 * 1/2*(1-cos(t*2*pi/10));
	% 	dq0(5) = -pi^2/20 * sin(t*2*pi/10);
	
	% 	[q0(5),dq0(5),~] = ...
	% 		ThreeStage_PolyFunc(t,9.5,0,0.5,-pi/10);
end
Frame.Joint = set_Frame_Joint(q0,dq0,Frame_Joint_Parameter);
Frame.T_qe_q = zeros(6,numel(q));
Frame.BodyType = 'Rigid Body';
%%
Mass = zeros(12);
Force = zeros(12,1);
Body = cell(BodyQuantity,1);
for BodyNr = 1:BodyQuantity
	%% nur ein Body
%     BodyNr =1;
    Body{BodyNr}.BodyType = ...
		BodyElementParameter{BodyNr}.BodyType;

   	BodyCoordinate = ...
		BodyElementParameter{BodyNr}.GlobalCoordinate;
    
    qe  = q(BodyCoordinate);
	dqe = dq(BodyCoordinate);
		T_qe_q = zeros(numel(BodyCoordinate),numel(q));
	T_qe_q(:,BodyCoordinate) = eye(numel(BodyCoordinate));
	
	Body{BodyNr}.T_qe_q = T_qe_q;
	%%
	[Body{BodyNr}.Mass,Body{BodyNr}.Force] = get_Element_MassForce(g,d,epsilon,BodyElementParameter{BodyNr});
    %%%26.8 已修改
	Body{BodyNr}.Joint = set_Joint(...
		qe,dqe,BodyElementParameter,BodyNr,Joint_Parameter);
	%%
	Mass(BodyCoordinate,BodyCoordinate) = ...
		Mass(BodyCoordinate,BodyCoordinate) + Body{BodyNr}.Mass;
	Force(BodyCoordinate) = ...
		Force(BodyCoordinate) + Body{BodyNr}.Force;
end
%% add static damping
StaticDampingFactor = 1;
if t < 0
	Force = Force + StaticDampingFactor * dq;
end
%%
% if t > 100 && t <= 110
% 	DampingFactor = 1;
% elseif t > 110
% 	DampingFactor = 0.01;
% else
% 	DampingFactor = 0;
% end
DampingFactor = 0;
Force = Force + DampingFactor * dq;
%% add Force Drive
% NodalForceParameter{1}.NodalMoment = ...
% 	-sign(t-1.8)*sign(t-3.3)*sign(t-6.9)*sign(t-8.45)*sign(t-15)*...
% 	NodalForceParameter{1}.NodalMoment;
if t >= 0
	Drive_Force = add_NodalForce(q,dq,t,Body,NodalForceParameter);
	Force = Force + Drive_Force;
end
%% add Constraint
[Phi,B,dPhi,Tau] = add_Constraint(q,dq,Frame,Body, ...
	BodyElementParameter,ConstraintParameter);
%% Baumgartner Stability Method
[~,Force] = Baumgartner_Stability_MassForce(...
	Mass,Force,Phi,dPhi,B,Tau);

end