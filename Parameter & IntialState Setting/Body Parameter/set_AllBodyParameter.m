function BodyElementParameter = set_AllBodyParameter(ExcelFilePath)
%% Laod Excel Data
[~,~,BodyParameterTableRaw]= ...
	xlsread(ExcelFilePath,'BodyParameter');
%%
BodyQuantity = BodyParameterTableRaw{1,3};
TotalCoordinateNr = 0;
BodyElementParameter = cell(BodyQuantity,1);
%%
for BodyNr = 1:BodyQuantity
	[BodyElementParameter,TotalCoordinateNr] = set_BodyParameter(...
		BodyParameterTableRaw,BodyNr,TotalCoordinateNr,BodyElementParameter);
end
%%
fprintf('\tBody Parameter has been loaded!\n');
end