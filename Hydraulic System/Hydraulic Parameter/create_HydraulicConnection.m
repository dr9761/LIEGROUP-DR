function HydraulicConnectionParameter = create_HydraulicConnection(ExcelFilePath)
%%
[~,~,HydraulicConnectionParameterTableRaw]= ...
	xlsread(ExcelFilePath,'Connection');
HydraulicConnectionQuantity = HydraulicConnectionParameterTableRaw{2,8};
HydraulicConnectionParameter = cell(HydraulicConnectionQuantity,1);
%%
for HydraulicConnectionNr = 1:HydraulicConnectionQuantity
	HydraulicConnectionParameter{HydraulicConnectionNr}.Element1 = ...
		HydraulicConnectionParameterTableRaw{HydraulicConnectionNr+1,2};
	HydraulicConnectionParameter{HydraulicConnectionNr}.Interface1 = ...
		HydraulicConnectionParameterTableRaw{HydraulicConnectionNr+1,3};
	HydraulicConnectionParameter{HydraulicConnectionNr}.Element2 = ...
		HydraulicConnectionParameterTableRaw{HydraulicConnectionNr+1,4};
	HydraulicConnectionParameter{HydraulicConnectionNr}.Interface2 = ...
		HydraulicConnectionParameterTableRaw{HydraulicConnectionNr+1,5};
end

end