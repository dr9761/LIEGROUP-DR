function [HydraulicNumericalEquation] = ...
	create_HydraulicCalculationEquation_Numerical(HydraulicState,x,u,...
	HydraulicOilParameter,HydraulicElementParameter, ...
	HydraulicConnectionParameter)
%%
EquationQuantity = 0;
%% Equation from Hydraulic Element
HydraulicElementQuantity = numel(HydraulicElementParameter);
%
for HydraulicElementNr = 1:HydraulicElementQuantity
	HydraulicElement = HydraulicElementParameter{HydraulicElementNr};
	HydraulicElementType = HydraulicElement.Name;
	switch HydraulicElementType
		case {'Ideal Constant Pressure Pump','Ideal Constant Pressure Sink'}
			EquationQuantity = EquationQuantity + 1;
            LHS(EquationQuantity) = HydraulicState(HydraulicElement.Coordinate.p{1});
            RHS(EquationQuantity) = HydraulicElement.p;
		case 'Electronic Throttle Valve'
			EquationQuantity = EquationQuantity + 1;
            LHS(EquationQuantity) = ...
                HydraulicState(HydraulicElement.Coordinate.Q{1}) + ...
				HydraulicState(HydraulicElement.Coordinate.Q{2});
            RHS(EquationQuantity) = 0;
			
			EquationQuantity = EquationQuantity + 1;
            LHS(EquationQuantity) = HydraulicState(HydraulicElement.Coordinate.Q{1});
            p1 = HydraulicState(HydraulicElement.Coordinate.p{1});
            p2 = HydraulicState(HydraulicElement.Coordinate.p{2});
            xv = u(HydraulicElement.Control);
            ValveParameter = HydraulicElement;
            [Q,FlowDirection] = HydraulicValve_Flow_Function(xv,p1,p2, ...
                ValveParameter,HydraulicOilParameter);
            RHS(EquationQuantity) = Q * FlowDirection;
        case 'Back Pressure Valve'
			EquationQuantity = EquationQuantity + 1;
            LHS(EquationQuantity) = ...
                HydraulicState(HydraulicElement.Coordinate.Q{1}) + ...
				HydraulicState(HydraulicElement.Coordinate.Q{2});
            RHS(EquationQuantity) = 0;
			
			EquationQuantity = EquationQuantity + 1;
            LHS(EquationQuantity) = HydraulicState(HydraulicElement.Coordinate.Q{1});
            p1 = HydraulicState(HydraulicElement.Coordinate.p{1});
            p2 = HydraulicState(HydraulicElement.Coordinate.p{2});
            ValveParameter = HydraulicElement;
            [Q,FlowDirection] = BackPressureValve(...
                p1,p2,ValveParameter,HydraulicOilParameter);
            RHS(EquationQuantity) = Q * FlowDirection;
		case 'Constant Throttle Valve'
			EquationQuantity = EquationQuantity + 1;
            LHS(EquationQuantity) = ...
                HydraulicState(HydraulicElement.Coordinate.Q{1}) + ...
				HydraulicState(HydraulicElement.Coordinate.Q{2});
            RHS(EquationQuantity) = 0;
			
			EquationQuantity = EquationQuantity + 1;
            LHS(EquationQuantity) = HydraulicState(HydraulicElement.Coordinate.Q{1});
            p1 = HydraulicState(HydraulicElement.Coordinate.p{1});
            p2 = HydraulicState(HydraulicElement.Coordinate.p{2});
            xv = HydraulicElement.Control;
            ValveParameter = HydraulicElement;
            [Q,FlowDirection] = HydraulicValve_Flow_Function(xv,p1,p2, ...
                ValveParameter,HydraulicOilParameter);
            RHS(EquationQuantity) = Q * FlowDirection;
		case 'Double Acting Hydraulic Cylinder'
			EquationQuantity = EquationQuantity + 1;
            LHS(EquationQuantity) = HydraulicState(HydraulicElement.Coordinate.p{1});
            RHS(EquationQuantity) = x(HydraulicElement.StateVariable(1));
			
			EquationQuantity = EquationQuantity + 1;
            LHS(EquationQuantity) = HydraulicState(HydraulicElement.Coordinate.p{2});
            RHS(EquationQuantity) = x(HydraulicElement.StateVariable(2));
	end

end
%% Equation from Hydraulic Connection
HydraulicConnectionQuantity = numel(HydraulicConnectionParameter);
for HydraulicConnectionNr = 1:HydraulicConnectionQuantity
	HydraulicConnection = HydraulicConnectionParameter{HydraulicConnectionNr};
	%
	ElementNr1 = HydraulicConnection.Element1;
	InterfaceNr1 = HydraulicConnection.Interface1;
	ElementNr2 = HydraulicConnection.Element2;
	InterfaceNr2 = HydraulicConnection.Interface2;
	%
	HydraulicElement1 = HydraulicElementParameter{ElementNr1};
	HydraulicElement2 = HydraulicElementParameter{ElementNr2};
	%
	EquationQuantity = EquationQuantity + 1;
    LHS(EquationQuantity) = ...
		HydraulicState(HydraulicElement1.Coordinate.Q{InterfaceNr1}) + ...
		HydraulicState(HydraulicElement2.Coordinate.Q{InterfaceNr2});
    RHS(EquationQuantity) = 0;
	
	EquationQuantity = EquationQuantity + 1;
    LHS(EquationQuantity) = ...
		HydraulicState(HydraulicElement1.Coordinate.p{InterfaceNr1}) - ...
		HydraulicState(HydraulicElement2.Coordinate.p{InterfaceNr2});
    RHS(EquationQuantity) = 0;
end
%%
HydraulicNumericalEquation = LHS - RHS;
end
