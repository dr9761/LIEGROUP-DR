function PlotParameter = set_PlotParameter(ExcelFilePath)
%%
[~,~,PlotParameterTableRaw]= ...
	xlsread(ExcelFilePath,'Plot Parameter');
[~,~,BodyParameterTableRaw]= ...
	xlsread(ExcelFilePath,'BodyParameter');
%%
BodyQuantity = PlotParameterTableRaw{1,2};
PlotParameter = cell(BodyQuantity,1);
for BodyNr = 1:BodyQuantity
	BodyType = PlotParameterTableRaw{2,BodyNr+2};
	switch BodyType
		case 'Rigid Body'
			PlotParameter{BodyNr}.PlotSequence = ...
				str2num(PlotParameterTableRaw{3,BodyNr+2});
		case 'Timoshenko Beam'
			BodyElementParameter = {};
			[BodyElementParameter,~] = set_BodyParameter(...
				BodyParameterTableRaw,BodyNr,0,BodyElementParameter);
			PlotParameter{BodyNr}.BodyParameter = ...
				BodyElementParameter{BodyNr};
			clear BodyElementParameter;
			
			PlotParameter{BodyNr}.InterpolationNr = ...
				PlotParameterTableRaw{4,BodyNr+2};
		case 'Super Truss Element'
			PlotParameter{BodyNr}.Truss_Parameter = ...
				set_Truss_Parameter(...
				BodyParameterTableRaw,BodyNr);
			
			PlotParameter{BodyNr}.InterpolationNr = ...
				PlotParameterTableRaw{4,BodyNr+2};
		case 'Strut Tie Model'
			%
		case 'Cubic Spline Beam'
			BodyElementParameter = {};
			[BodyElementParameter,~] = set_BodyParameter(...
				BodyParameterTableRaw,BodyNr,0,BodyElementParameter);
			PlotParameter{BodyNr}.BodyParameter = ...
				BodyElementParameter{BodyNr};
			clear BodyElementParameter;
			
			PlotParameter{BodyNr}.InterpolationNr = ...
				PlotParameterTableRaw{4,BodyNr+2};
		case 'Cubic Spline Rope'
			BodyElementParameter = {};
			[BodyElementParameter,~] = set_BodyParameter(...
				BodyParameterTableRaw,BodyNr,0,BodyElementParameter);
			PlotParameter{BodyNr}.BodyParameter = ...
				BodyElementParameter{BodyNr};
			clear BodyElementParameter;
			
			PlotParameter{BodyNr}.InterpolationNr = ...
				PlotParameterTableRaw{4,BodyNr+2};
	end
	PlotParameter{BodyNr}.PlotStyle = PlotParameterTableRaw{5,BodyNr+2};
end
%%
fprintf('\tPlot Parameter has been loaded!\n');
end