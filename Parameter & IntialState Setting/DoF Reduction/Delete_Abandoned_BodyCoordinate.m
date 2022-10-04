function BodyElementParameter = ...
	Delete_Abandoned_BodyCoordinate(...
	BodyElementParameter,TotalCoordinateQuantity, ...
	Abandon_StateVariableNrSet)
%%
BodyQuantity = numel(BodyElementParameter);
BodyCoordinateSet = cell(BodyQuantity,1);
%%
for BodyNr = 1:BodyQuantity
	BodyCoordinateSet{BodyNr} = BodyElementParameter{BodyNr}.GlobalCoordinate;
	while numel(intersect(BodyCoordinateSet{BodyNr},...
			Abandon_StateVariableNrSet(2,:))) ~= 0
		for BodyCoordinateNr = 1:numel(BodyCoordinateSet{BodyNr})
			GlobalReplaceCoordinatePosition = ...
				find(Abandon_StateVariableNrSet(2,:) == ...
				BodyCoordinateSet{BodyNr}(BodyCoordinateNr));
			if numel(GlobalReplaceCoordinatePosition) ~= 0
				GlobalReplaceCoordinate = ...
					min(Abandon_StateVariableNrSet(1,GlobalReplaceCoordinatePosition));
				BodyCoordinateSet{BodyNr}(BodyCoordinateNr) = GlobalReplaceCoordinate;
			end
		end
	end
end
%%
GlobalCoordinate = 1:TotalCoordinateQuantity;
for GlobalCoordinateNr = 1:TotalCoordinateQuantity
	AbandonGlobalCoordinateTest = ...
		find(Abandon_StateVariableNrSet(2,:) == GlobalCoordinateNr);
	if numel(AbandonGlobalCoordinateTest) ~= 0
		GlobalCoordinate(GlobalCoordinateNr) = NaN;
	end
end
GlobalCoordinate = rmmissing(GlobalCoordinate);
GlobalCoordinateReplaceBasis = ...
	[1:numel(GlobalCoordinate); ...
	GlobalCoordinate];
NoUseGlobalCoordinateReplaceBasisNr = ...
	[(GlobalCoordinateReplaceBasis(2,:) - ...
	GlobalCoordinateReplaceBasis(1,:)) == 0];
GlobalCoordinateReplaceBasis(:,NoUseGlobalCoordinateReplaceBasisNr) = [];
%%
for BodyNr = 1:BodyQuantity
	for BodyCoordinateNr = 1:numel(BodyCoordinateSet{BodyNr})
		GlobalReplaceCoordinatePosition = ...
			find(GlobalCoordinateReplaceBasis(2,:) == ...
			BodyCoordinateSet{BodyNr}(BodyCoordinateNr));
		if numel(GlobalReplaceCoordinatePosition) ~= 0
			GlobalReplaceCoordinate = ...
				min(GlobalCoordinateReplaceBasis(1,GlobalReplaceCoordinatePosition));
			BodyCoordinateSet{BodyNr}(BodyCoordinateNr) = GlobalReplaceCoordinate;
		end
	end
	BodyElementParameter{BodyNr}.GlobalCoordinate = ...
		BodyCoordinateSet{BodyNr};
end

end