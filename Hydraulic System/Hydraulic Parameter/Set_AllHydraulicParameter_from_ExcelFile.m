function HydraulicParameter = ...
	Set_AllHydraulicParameter_from_ExcelFile(ExcelFileName,ExcelFileDir)
%%
ExcelFilePath = [ExcelFileDir,'\',ExcelFileName,'.xlsx'];
%%
[HydraulicOilParameter,HydraulicElementParameter] = ...
	create_HydraulicElement(ExcelFilePath);

HydraulicConnectionParameter = create_HydraulicConnection(ExcelFilePath);

% HydraulicSymbolicStateSolution = create_HydraulicCalculationEquation(...
% 	HydraulicOilParameter,HydraulicElementParameter, ...
% 	HydraulicConnectionParameter);

%%
HydraulicParameter.HydraulicElementParameter = HydraulicElementParameter;
HydraulicParameter.HydraulicOilParameter = HydraulicOilParameter;
HydraulicParameter.HydraulicEquation = HydraulicSymbolicStateSolution;

HydraulicParameter.HydraulicCoordinateQuantity = HydraulicCoordinateQuantity;
HydraulicParameter.HydraulicNumericalEquationHandle = ...
	@(HydraulicState)create_HydraulicCalculationEquation_Numerical(HydraulicState,x,u, ...
	HydraulicOilParameter,HydraulicElementParameter, ...
	HydraulicConnectionParameter);

end