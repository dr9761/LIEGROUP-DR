function NodalForceParameter = apply_Action_to_NodalForceParameter(...
	DriveParameter,NodalForceParameter,Action,ActionTagSet)
%%
NodalForceDriveParameter = DriveParameter.NodalForceDriveParameter;
NodalForceDrive = NodalForceDriveParameter.NodalForceDrive;
Drive_Action_Map = NodalForceDriveParameter.Drive_Action_Map;
%%
if isempty(ActionTagSet)
	ActionTagSet = Drive_Action_Map.keys;
end
%%
for ActionNr = 1:numel(Action)
	ActionValue = Action(ActionNr);
	ActionTag = ActionTagSet{ActionNr};
	for DriveNr = Drive_Action_Map(ActionTag)
		NodalForceNr = NodalForceDrive{DriveNr}.NodalForceNr;
		NodalForceType = NodalForceDrive{DriveNr}.NodalForceType;
		NodalForceIndex = NodalForceDrive{DriveNr}.NodalForceIndex;
		switch NodalForceType
			case 'Force'
				NodalForceParameter{NodalForceNr}.NodalForce(NodalForceIndex) = ...
					ActionValue;
			case 'Moment'
				NodalForceParameter{NodalForceNr}.NodalMoment(NodalForceIndex) = ...
					ActionValue;
		end
	end
end

end