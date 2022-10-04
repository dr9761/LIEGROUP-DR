function [HydraulicOilParameter,HydraulicElementParameter, ...
	HydraulicCoordinateQuantity] = ...
	create_HydraulicElement(ExcelFilePath)
%%
[~,~,HydraulicElementParameterTableRaw]= ...
	xlsread(ExcelFilePath,'Element');
%
HydraulicCoordinateQuantity = 0;
HydraulicElementQuantity = HydraulicElementParameterTableRaw{1,2};
HydraulicElementParameter = cell(HydraulicElementQuantity,1);
%% Hydraulic Element
for HydraulicElementNr = 0:HydraulicElementQuantity
	HydraulicElementType = ...
		HydraulicElementParameterTableRaw{3,HydraulicElementNr+3};
	CoordinateQuantity = ...
		HydraulicElementParameterTableRaw{4,HydraulicElementNr+3};
	switch HydraulicElementType
		case 'Hydraulic Oil'
			%%
			ParameterStartPosition = 5-1;
			HydraulicElement = create_HydraulicOil(...
				HydraulicElementParameterTableRaw, ...
				HydraulicElementNr,ParameterStartPosition);
		case {'Ideal Constant Pressure Pump','Ideal Constant Pressure Sink'}
			%%
			ParameterStartPosition = 7-1;
			HydraulicElement = create_IdealConstantPressurePump(...
				HydraulicElementParameterTableRaw, ...
				HydraulicElementNr,ParameterStartPosition, ...
				HydraulicCoordinateQuantity,CoordinateQuantity);
		case 'Double Acting Hydraulic Cylinder'
			%%
			ParameterStartPosition = 9-1;
			HydraulicElement = create_DoubleActingHydraulicCylinder(...
				HydraulicElementParameterTableRaw, ...
				HydraulicElementNr,ParameterStartPosition, ...
				HydraulicCoordinateQuantity,CoordinateQuantity);
		case {'Electronic Throttle Valve','Back Pressure Valve','Constant Throttle Valve'}
			%%
			ParameterStartPosition = 15-1;
			HydraulicElement = create_ElectronicThrottleValve(...
				HydraulicElementParameterTableRaw, ...
				HydraulicElementNr,ParameterStartPosition, ...
				HydraulicCoordinateQuantity,CoordinateQuantity);
		otherwise
			warning(['Fail to create Element ',num2str(HydraulicElementNr),'!']);
			HydraulicElement = [];
	end
	%%
	HydraulicElement.Name = HydraulicElementType;
	if HydraulicElementNr == 0
		HydraulicOilParameter = HydraulicElement;
	else
		HydraulicElementParameter{HydraulicElementNr} = HydraulicElement;
	end
	%%
	HydraulicCoordinateQuantity = HydraulicCoordinateQuantity + CoordinateQuantity;
end
%% Selection Matrix
for HydraulicElementNr = 1:HydraulicElementQuantity
	HydraulicElement = HydraulicElementParameter{HydraulicElementNr};
	ElementCoordinate = HydraulicElement.GlobalCoordinate;
	ElementCoordinateQuantity = numel(ElementCoordinate);
	GlobalSelectionMatrix = zeros(ElementCoordinateQuantity,HydraulicCoordinateQuantity);
	GlobalSelectionMatrix(:,ElementCoordinate) = eye(ElementCoordinateQuantity);
	%
	for ElementCoordinateNr = 1:ElementCoordinateQuantity
		StateSelectionMatrix = zeros(1,HydraulicCoordinateQuantity);
		if ElementCoordinateNr <= ElementCoordinateQuantity/2
			StateCoordinatePos = ...
				HydraulicElement.Coordinate.p{ElementCoordinateNr};
			StateSelectionMatrix(StateCoordinatePos) = 1;
			SelectionMatrix.p{ElementCoordinateNr} = StateSelectionMatrix;
		else
			StateCoordinatePos = ...
				HydraulicElement.Coordinate.Q{ElementCoordinateNr-ElementCoordinateQuantity/2};
			StateSelectionMatrix(StateCoordinatePos) = 1;
			SelectionMatrix.Q{ElementCoordinateNr-ElementCoordinateQuantity/2} = StateSelectionMatrix;
		end
	end
	%
	HydraulicElementParameter{HydraulicElementNr}.GlobalSelectionMatrix = ...
		GlobalSelectionMatrix;
	HydraulicElementParameter{HydraulicElementNr}.SelectionMatrix = ...
		SelectionMatrix;
end
end