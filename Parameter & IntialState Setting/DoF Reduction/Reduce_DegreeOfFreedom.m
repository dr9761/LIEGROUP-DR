function [q0,dq0,BodyElementParameter,ConstraintParameter] = ...
	Reduce_DegreeOfFreedom(...
	q0,dq0,BodyElementParameter,ConstraintParameter)
%%
fprintf('The degree of freedom will be reduced according to the constraints.\n');
fprintf('...\n');
ConstraintQuantity = numel(ConstraintParameter);
TotalCoordinateQuantity = numel(q0);
Abandon_ConstraintNrSet = [];
Abandon_StateVariableNrSet = [];
for ConstraintNr = 1:ConstraintQuantity
	ConstraintType = ConstraintParameter{ConstraintNr}.ConstraintType;
	BodyNr1 = ConstraintParameter{ConstraintNr}.BodyNr1;
	BodyNr2 = ConstraintParameter{ConstraintNr}.BodyNr2;
	
	JointNr1 = ConstraintParameter{ConstraintNr}.JointNr1;
	JointNr2 = ConstraintParameter{ConstraintNr}.JointNr2;
	if BodyNr1 == 0
		Body1 = [];
		BodyType1 = 'Frame';
	else
		Body1 = BodyElementParameter{BodyNr1};
		BodyType1 = Body1.BodyType;
	end
	if BodyNr2 == 0
		Body2 = [];
		BodyType2 = 'Frame';
	else
		Body2 = BodyElementParameter{BodyNr2};
		BodyType2 = Body2.BodyType;
	end
	%%
	[Coordinate_overlap,Coordinate_abandon, ...
		AbandonConstraintNr] = ...
		Reduce_DegreeOfFreedom_According_ConstraintType(...
		ConstraintType,ConstraintNr, ...
		Body1,Body2,BodyType1,BodyType2,JointNr1,JointNr2);
	
	Abandon_StateVariableNrSet = [Abandon_StateVariableNrSet, ...
		[Coordinate_overlap;Coordinate_abandon]];
	
	Abandon_ConstraintNrSet = ...
		[Abandon_ConstraintNrSet,AbandonConstraintNr];
end
%%
if ~isempty(Abandon_StateVariableNrSet)
	% delete abandoned Body Coordinate Number
	BodyElementParameter = ...
		Delete_Abandoned_BodyCoordinate(...
		BodyElementParameter,TotalCoordinateQuantity, ...
		Abandon_StateVariableNrSet);
	% delete abandoned State Variable
	[q0,dq0] = Delete_Abandoned_StateVariable(...
		q0,dq0,TotalCoordinateQuantity, ...
		Abandon_StateVariableNrSet);
	%
	fprintf('Degree of Freedom: From %d to %d,\tsaving %4.2f%%\n', ...
		TotalCoordinateQuantity,numel(q0), ...
		100*(1-numel(q0)/TotalCoordinateQuantity));
end

%% delete abandoned Constraint
if ~isempty(Abandon_ConstraintNrSet)
	PreviousConstraintQuantity = numel(ConstraintParameter);
	ConstraintParameter(Abandon_ConstraintNrSet) = [];
	CurrentConstraintQuantity = numel(ConstraintParameter);
	%
	fprintf('Constraint:        From %d to %d,\tsaving %4.2f%%\n', ...
		PreviousConstraintQuantity,CurrentConstraintQuantity, ...
		100*(1-CurrentConstraintQuantity/PreviousConstraintQuantity));
end

%%
fprintf('Reduction has been completed!\n\n');
end