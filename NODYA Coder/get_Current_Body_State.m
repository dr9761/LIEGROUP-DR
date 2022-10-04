function [Frame,Body] = get_Current_Body_State(x,ModelParameter)
%%
g = ModelParameter.g;
BodyElementParameter = ModelParameter.BodyElementParameter;
Frame_Joint_Parameter = ModelParameter.Frame_Joint_Parameter;
Joint_Parameter = ModelParameter.Joint_Parameter;
%%
q = x(1:numel(x)/2);
dq = x(numel(x)/2+1:end);
BodyQuantity = numel(BodyElementParameter);
%% Set Frame
q0  = zeros(6,1);
dq0 = zeros(6,1);

Frame.Joint = set_Frame_Joint(q0,dq0,Frame_Joint_Parameter);
Frame.T_qe_q = zeros(6,numel(q));
Frame.BodyType = 'Rigid Body';
%%
Body = cell(BodyQuantity,1);
for BodyNr = 1:BodyQuantity
	%% Body Type
	Body{BodyNr}.BodyType = ...
		BodyElementParameter{BodyNr}.BodyType;
	%% Coordinate
	BodyCoordinate = ...
		BodyElementParameter{BodyNr}.GlobalCoordinate;
	
	qe  = q(BodyCoordinate);
	dqe = dq(BodyCoordinate);
% 	T_qe_q = zeros(numel(BodyCoordinate),numel(q));
% 	T_qe_q(:,BodyCoordinate) = eye(numel(BodyCoordinate));
	
	Body{BodyNr}.qe = qe;
	Body{BodyNr}.dqe = dqe;
% 	Body{BodyNr}.T_qe_q = T_qe_q;
	%%
% 	[Body{BodyNr}.Mass,Body{BodyNr}.Force] = ...
% 		get_Element_MassForce(...
% 		qe,dqe,g,BodyElementParameter{BodyNr});
	%% Joint
	Body{BodyNr}.Joint = set_Joint(...
		qe,dqe,BodyElementParameter,BodyNr,Joint_Parameter);
	%% Truss Parameter
	if strcmpi(BodyElementParameter{BodyNr}.BodyType, ...
			'Super Truss Element')
		Body{BodyNr}.Truss_Parameter = ...
			BodyElementParameter{BodyNr}.Truss_Parameter;
	end
end

end