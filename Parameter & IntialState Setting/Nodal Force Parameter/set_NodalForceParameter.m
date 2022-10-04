function [NodalForceParameter,NodalForceDriveParameter] = ...
	set_NodalForceParameter(ExcelFilePath)
%%
[~,~,NodalForceParameterTableRaw]= ...
	xlsread(ExcelFilePath,'Nodal Force');
%%
NodalForceQuantity = NodalForceParameterTableRaw{3,14};
NodalForceParameter = cell(NodalForceQuantity,1);
DriveQuantity = 0;
NodalForceDrive = {};
for NodalForceNr = 1:NodalForceQuantity
	BodyNr = NodalForceParameterTableRaw{NodalForceNr+2,2};
	JointNr = NodalForceParameterTableRaw{NodalForceNr+2,3};
	NodalForceParameter{NodalForceNr}.BodyNr = BodyNr;
	NodalForceParameter{NodalForceNr}.JointNr = JointNr;
	
	NodalForceParameter{NodalForceNr}.NodalForce = zeros(3,1);
	for ForceIndex = 1:3
		if isnumeric(NodalForceParameterTableRaw{NodalForceNr+2,ForceIndex+3})
			NodalForceParameter{NodalForceNr}.NodalForce(ForceIndex) = ...
				NodalForceParameterTableRaw{NodalForceNr+2,ForceIndex+3};
		else
			NodalForceParameter{NodalForceNr}.NodalForce(ForceIndex) = NaN;
			
			DriveQuantity = DriveQuantity + 1;
			NodalForceDrive{DriveQuantity}.NodalForceNr = NodalForceNr;
			NodalForceDrive{DriveQuantity}.NodalForceType = 'Force';
			NodalForceDrive{DriveQuantity}.NodalForceIndex = ForceIndex;
			NodalForceDrive{DriveQuantity}.Tag = ...
				NodalForceParameterTableRaw{NodalForceNr+2,ForceIndex+3};
		end
	end
	
	NodalForceParameter{NodalForceNr}.NodalMoment = zeros(3,1);
	for MomentIndex = 1:3
		if isnumeric(NodalForceParameterTableRaw{NodalForceNr+2,MomentIndex+7})
			NodalForceParameter{NodalForceNr}.NodalMoment(MomentIndex) = ...
				NodalForceParameterTableRaw{NodalForceNr+2,MomentIndex+7};
		else
			NodalForceParameter{NodalForceNr}.NodalMoment(MomentIndex) = NaN;
			
			DriveQuantity = DriveQuantity + 1;
			NodalForceDrive{DriveQuantity}.NodalForceNr = NodalForceNr;
			NodalForceDrive{DriveQuantity}.NodalForceType = 'Moment';
			NodalForceDrive{DriveQuantity}.NodalForceIndex = MomentIndex;
			NodalForceDrive{DriveQuantity}.Tag = ...
				NodalForceParameterTableRaw{NodalForceNr+2,MomentIndex+7};
		end
	end
	
	NodalForceParameter{NodalForceNr}.NodalForceCoordinate = ...
		NodalForceParameterTableRaw{NodalForceNr+2,7};
	NodalForceParameter{NodalForceNr}.NodalMomentCoordinate = ...
		NodalForceParameterTableRaw{NodalForceNr+2,11};
end
%%
DriveTagSet = cell(0);
Drive_Action_Table = {};
Drive_Action_Map = containers.Map(...
	'UniformValues',false);
for DriveNr = 1:numel(NodalForceDrive)
	new_DriveTag = true;
	DriveTag = NodalForceDrive{DriveNr}.Tag;
	if ~Drive_Action_Map.isKey(DriveTag)
		Drive_Action_Map(DriveTag) = DriveNr;
	else
		Drive_Action_Map(DriveTag) = [Drive_Action_Map(DriveTag), ...
			DriveNr];
	end
end
%%
NodalForceDriveParameter.NodalForceDrive = NodalForceDrive;
NodalForceDriveParameter.Drive_Action_Map = Drive_Action_Map;
%%
fprintf('\tNodal Force Parameter has been loaded!\n');
end