function [Abandon_StateVariableNrSet,Abandon_ConstraintNrSet] = ...
	Reduce_DegreeOfFreedom_between_FlexibleElement(...
	ConstraintType,Body1,JointNr1,Body2,JointNr2, ...
	Abandon_StateVariableNrSet,Abandon_ConstraintNrSet)
%%
Coordinate1 = Body1.Coordinate;
Coordinate2 = Body2.Coordinate;
switch ConstraintType
	case 'Fixed'
		if JointNr1 == 1
			Coordinate1_overlap = Coordinate1(1:numel(Coordinate1)/2);
		elseif JointNr1 == 2
			Coordinate1_overlap = Coordinate1(numel(Coordinate1)/2+1:end);
		end
		if JointNr2 == 1
			Coordinate2_overlap = Coordinate2(1:numel(Coordinate2)/2);
		elseif JointNr2 == 2
			Coordinate2_overlap = Coordinate2(numel(Coordinate2)/2+1:end);
		end
		
		Coordinate_overlap = ...
			min(Coordinate1_overlap,Coordinate2_overlap);
		Coordinate_abandon = ...
			max(Coordinate1_overlap,Coordinate2_overlap);
		
		Abandon_StateVariableNrSet = [Abandon_StateVariableNrSet, ...
			[Coordinate_overlap;Coordinate_abandon]];
		
		Abandon_ConstraintNrSet = [Abandon_ConstraintNrSet,ConstraintNr];
end

end