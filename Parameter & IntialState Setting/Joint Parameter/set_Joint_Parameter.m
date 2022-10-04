function [Frame_Joint_Parameter,Joint_Parameter] = ...
	set_Joint_Parameter(ExcelFilePath)
%%
[~,~,AllJoint_ParameterTableRaw]= ...
	xlsread(ExcelFilePath,'Joint');
%% Frame Joint
FrameJointQuantity = AllJoint_ParameterTableRaw{3,3};
Frame_Joint_Parameter = cell(FrameJointQuantity,1);
for FrameJointNr = 1:FrameJointQuantity
	Frame_Joint_Parameter{FrameJointNr}.r = ...
		[AllJoint_ParameterTableRaw{6*FrameJointNr-3+[1:3],3}]';
	Frame_Joint_Parameter{FrameJointNr}.phi = ...
		[AllJoint_ParameterTableRaw{6*FrameJointNr-3+[4:6],3}]';
end
%% Body Joint
BodyJointQuantity = AllJoint_ParameterTableRaw{1,2};
Joint_Parameter = cell(BodyJointQuantity,1);
for BodyNr = 1:BodyJointQuantity
	Joint_Parameter{BodyNr} = [];
	BodyType = AllJoint_ParameterTableRaw{2,BodyNr+3};
	Joint_Parameter{BodyNr}.BodyType = BodyType;
	%
	if strcmp(BodyType,'Rigid Body')
		JointQuantity = AllJoint_ParameterTableRaw{3,BodyNr+3};
		for JointNr = 1:JointQuantity
			Joint_Parameter{BodyNr}.Joint{JointNr}.r = ...
				[AllJoint_ParameterTableRaw{6*JointNr-3+[1:3],BodyNr+3}]';
			Joint_Parameter{BodyNr}.Joint{JointNr}.phi = ...
				[AllJoint_ParameterTableRaw{6*JointNr-3+[4:6],BodyNr+3}]';
		end
	end
	
end
%%
fprintf('\tJoint Parameter has been loaded!\n');
end