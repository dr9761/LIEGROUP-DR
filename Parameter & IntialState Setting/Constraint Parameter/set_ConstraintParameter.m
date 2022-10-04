function ConstraintParameter = set_ConstraintParameter(ExcelFilePath)
%%
[~,~,ConstraintParameterTableRaw]= ...
	xlsread(ExcelFilePath,'Constraint');
%%
ConstraintQuantity = ConstraintParameterTableRaw{2,8};
BodyQuantity = ConstraintParameterTableRaw{3,8};
%%
ValidConstraintNr = 1;
ConstraintParameter = cell(ConstraintQuantity,1);
for ConstraintNr = 1:ConstraintQuantity
	BodyNr1  = ConstraintParameterTableRaw{ConstraintNr+1,2};
	JointNr1 = ConstraintParameterTableRaw{ConstraintNr+1,3};
	BodyNr2  = ConstraintParameterTableRaw{ConstraintNr+1,4};
	JointNr2 = ConstraintParameterTableRaw{ConstraintNr+1,5};
	ConstraintType = ConstraintParameterTableRaw{ConstraintNr+1,6};
	%%
	if BodyNr1 <= BodyQuantity && BodyNr2 <= BodyQuantity
		% Body1 Joint1
		ConstraintParameter{ValidConstraintNr}.BodyNr1  = BodyNr1;
		ConstraintParameter{ValidConstraintNr}.JointNr1 = JointNr1;
		% Body2 Joint2
		ConstraintParameter{ValidConstraintNr}.BodyNr2  = BodyNr2;
		ConstraintParameter{ValidConstraintNr}.JointNr2 = JointNr2;
		% Constraint Type
		ConstraintParameter{ValidConstraintNr}.ConstraintType = ConstraintType;
		%
		ValidConstraintNr = ValidConstraintNr + 1;
	end
end
%%
fprintf('\tConstraint Parameter has been loaded!\n');
end