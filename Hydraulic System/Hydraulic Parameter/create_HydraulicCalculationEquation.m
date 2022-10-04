function [HydraulicSymbolicStateSolution] = create_HydraulicCalculationEquation(...
	HydraulicOilParameter,HydraulicElementParameter, ...
	HydraulicConnectionParameter)
%%
% LHS_Symbolic = sym('LHS',[HydraulicCoordinateQuantity,1]);
% RHS_Symbolic = sym('RHS',[HydraulicCoordinateQuantity,1]);

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
            LHS_Symbolic(EquationQuantity) = HydraulicElement.SymbolicCoordinate.p{1};
            RHS_Symbolic(EquationQuantity) = sym(HydraulicElement.p);
		case 'Electronic Throttle Valve'
			EquationQuantity = EquationQuantity + 1;
            LHS_Symbolic(EquationQuantity) = ...
                HydraulicElement.SymbolicCoordinate.Q{1}+HydraulicElement.SymbolicCoordinate.Q{2};
            RHS_Symbolic(EquationQuantity) = sym(0);
			
			EquationQuantity = EquationQuantity + 1;
            LHS_Symbolic(EquationQuantity) = HydraulicElement.SymbolicCoordinate.Q{1};
            p1_Symbolic = HydraulicElement.SymbolicCoordinate.p{1};
            p2_Symbolic = HydraulicElement.SymbolicCoordinate.p{2};
            xv = HydraulicElement.SymbolicControl;
            ValveParameter = HydraulicElement;
            [Q_Symbolic,FlowDirection_Symbolic] = HydraulicValve_Flow_Function(xv,p1_Symbolic,p2_Symbolic, ...
                ValveParameter,HydraulicOilParameter);
            RHS_Symbolic(EquationQuantity) = Q_Symbolic * FlowDirection_Symbolic;
        case 'Back Pressure Valve'
			EquationQuantity = EquationQuantity + 1;
            LHS_Symbolic(EquationQuantity) = ...
                HydraulicElement.SymbolicCoordinate.Q{1}+HydraulicElement.SymbolicCoordinate.Q{2};
            RHS_Symbolic(EquationQuantity) = sym(0);
			
			EquationQuantity = EquationQuantity + 1;
            LHS_Symbolic(EquationQuantity) = HydraulicElement.SymbolicCoordinate.Q{1};
            p1_Symbolic = HydraulicElement.SymbolicCoordinate.p{1};
            p2_Symbolic = HydraulicElement.SymbolicCoordinate.p{2};
            ValveParameter = HydraulicElement;
            [Q_Symbolic,FlowDirection_Symbolic] = BackPressureValve(...
                p1_Symbolic,p2_Symbolic,ValveParameter,HydraulicOilParameter);
            RHS_Symbolic(EquationQuantity) = Q_Symbolic * FlowDirection_Symbolic;
		case 'Constant Throttle Valve'
			EquationQuantity = EquationQuantity + 1;
            LHS_Symbolic(EquationQuantity) = ...
                HydraulicElement.SymbolicCoordinate.Q{1}+HydraulicElement.SymbolicCoordinate.Q{2};
            RHS_Symbolic(EquationQuantity) = sym(0);
			
			EquationQuantity = EquationQuantity + 1;
            LHS_Symbolic(EquationQuantity) = HydraulicElement.SymbolicCoordinate.Q{1};
            p1_Symbolic = HydraulicElement.SymbolicCoordinate.p{1};
            p2_Symbolic = HydraulicElement.SymbolicCoordinate.p{2};
            xv = HydraulicElement.Control;
            ValveParameter = HydraulicElement;
            [Q_Symbolic,FlowDirection_Symbolic] = HydraulicValve_Flow_Function(xv,p1_Symbolic,p2_Symbolic, ...
                ValveParameter,HydraulicOilParameter);
            RHS_Symbolic(EquationQuantity) = Q_Symbolic * FlowDirection_Symbolic;
		case 'Double Acting Hydraulic Cylinder'
			EquationQuantity = EquationQuantity + 1;
            LHS_Symbolic(EquationQuantity) = HydraulicElement.SymbolicCoordinate.p{1};
            RHS_Symbolic(EquationQuantity) = HydraulicElement.SymbolicStateVariable{1};
			
			EquationQuantity = EquationQuantity + 1;
            LHS_Symbolic(EquationQuantity) = HydraulicElement.SymbolicCoordinate.p{2};
            RHS_Symbolic(EquationQuantity) = HydraulicElement.SymbolicStateVariable{2};
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
    LHS_Symbolic(EquationQuantity) = HydraulicElement1.SymbolicCoordinate.Q{InterfaceNr1} + ...
		HydraulicElement2.SymbolicCoordinate.Q{InterfaceNr2};
    RHS_Symbolic(EquationQuantity) = sym(0);
	
	EquationQuantity = EquationQuantity + 1;
    LHS_Symbolic(EquationQuantity) = HydraulicElement1.SymbolicCoordinate.p{InterfaceNr1} - ...
		HydraulicElement2.SymbolicCoordinate.p{InterfaceNr2};
    RHS_Symbolic(EquationQuantity) = sym(0);
end
%%
SymbolicHydraulicStateQuantity = 0;
x_Pos = [];u_Pos = [];
for HydraulicElementNr = 1:HydraulicElementQuantity
    HydraulicElement = HydraulicElementParameter{HydraulicElementNr};
	HydraulicElementType = HydraulicElement.Name;
	switch HydraulicElementType
		case {'Ideal Constant Pressure Pump','Ideal Constant Pressure Sink'}
			SymbolicHydraulicStateQuantity = SymbolicHydraulicStateQuantity + 1;
            SymbolicHydraulicState(SymbolicHydraulicStateQuantity) = ...
                HydraulicElement.SymbolicCoordinate.p{1};
			assume(SymbolicHydraulicState(SymbolicHydraulicStateQuantity),'real');
			assumeAlso(SymbolicHydraulicState(SymbolicHydraulicStateQuantity)>=0);
            
            SymbolicHydraulicStateQuantity = SymbolicHydraulicStateQuantity + 1;
            SymbolicHydraulicState(SymbolicHydraulicStateQuantity) = ...
                HydraulicElement.SymbolicCoordinate.Q{1};
			assume(SymbolicHydraulicState(SymbolicHydraulicStateQuantity),'real');
		case {'Electronic Throttle Valve','Back Pressure Valve','Constant Throttle Valve', ...
                'Double Acting Hydraulic Cylinder'}
			SymbolicHydraulicStateQuantity = SymbolicHydraulicStateQuantity + 1;
            SymbolicHydraulicState(SymbolicHydraulicStateQuantity) = ...
                HydraulicElement.SymbolicCoordinate.p{1};
			assume(SymbolicHydraulicState(SymbolicHydraulicStateQuantity),'real');
			assumeAlso(SymbolicHydraulicState(SymbolicHydraulicStateQuantity)>=0);
            
            SymbolicHydraulicStateQuantity = SymbolicHydraulicStateQuantity + 1;
            SymbolicHydraulicState(SymbolicHydraulicStateQuantity) = ...
                HydraulicElement.SymbolicCoordinate.p{2};
			assume(SymbolicHydraulicState(SymbolicHydraulicStateQuantity),'real');
			assumeAlso(SymbolicHydraulicState(SymbolicHydraulicStateQuantity)>=0);
            
            SymbolicHydraulicStateQuantity = SymbolicHydraulicStateQuantity + 1;
            SymbolicHydraulicState(SymbolicHydraulicStateQuantity) = ...
                HydraulicElement.SymbolicCoordinate.Q{1};
			assume(SymbolicHydraulicState(SymbolicHydraulicStateQuantity),'real');
            
            SymbolicHydraulicStateQuantity = SymbolicHydraulicStateQuantity + 1;
            SymbolicHydraulicState(SymbolicHydraulicStateQuantity) = ...
                HydraulicElement.SymbolicCoordinate.Q{2};
			assume(SymbolicHydraulicState(SymbolicHydraulicStateQuantity),'real');
			
			if strcmpi(HydraulicElementType,'Electronic Throttle Valve')
				for ControlNr = 1:numel(HydraulicElement.Control)
					ControlPos = HydraulicElement.Control(ControlNr);
					if ControlPos ~= 0 && isempty(find(u_Pos == ControlPos,1))
						if isempty(u_Pos)
							u_Symbolic = sym(['u_',num2str(ControlPos)]);
							u_Pos = ControlPos;
						else
							u_Symbolic = [u_Symbolic;sym(['u_',num2str(ControlPos)])];
							u_Pos = [u_Pos;ControlPos];
						end
					end
				end
			end
			
			if strcmpi(HydraulicElementType,'Double Acting Hydraulic Cylinder')
				for StateVariableNr = 1:numel(HydraulicElement.StateVariable)
					StateVariablePos = HydraulicElement.StateVariable(StateVariableNr);
					if isempty(find(x_Pos == StateVariablePos,1))
						if isempty(x_Pos)
							x_Symbolic = sym(['x_',num2str(StateVariablePos)]);
							x_Pos = StateVariablePos;
						else
							x_Symbolic = [x_Symbolic;sym(['x_',num2str(StateVariablePos)])];
							x_Pos = [x_Pos;StateVariablePos];
						end
					end
				end
			end
	end
    %%
% 	if isfield(HydraulicElement,'Control')
% 		for ControlNr = 1:numel(HydraulicElement.Control)
% 			ControlPos = HydraulicElement.Control(ControlNr);
% 			if ControlPos ~= 0 && isempty(find(u_Pos == ControlPos,1))
% 				if isempty(u_Pos)
% 					u_Symbolic = sym(['u_',num2str(ControlPos)]);
% 					u_Pos = ControlPos;
% 				else
% 					u_Symbolic = [u_Symbolic;sym(['u_',num2str(ControlPos)])];
% 					u_Pos = [u_Pos;ControlPos];
% 				end
% 			end
% 		end
% 	end
	%%
% 	if isfield(HydraulicElement,'StateVariable')
% 		for StateVariableNr = 1:numel(HydraulicElement.StateVariable)
% 			StateVariablePos = HydraulicElement.StateVariable(StateVariableNr);
% 			if isempty(find(x_Pos == StateVariablePos,1))
% 				if isempty(x_Pos)
% 					x_Symbolic = sym(['x_',num2str(StateVariablePos)]);
% 					x_Pos = StateVariablePos;
% 				else
% 					x_Symbolic = [x_Symbolic;sym(['x_',num2str(StateVariablePos)])];
% 					x_Pos = [x_Pos;StateVariablePos];
% 				end
% 			end
% 		end
% 	end
end
assume(x_Symbolic,'real');
assumeAlso(x_Symbolic>=0);
assume(u_Symbolic,'real');
%%
tic;
SymbolicCalculatedHydraulicState = solve(...
	LHS_Symbolic == RHS_Symbolic,SymbolicHydraulicState, ...
	'ReturnConditions',false);
toc;

for HydraulicElementNr = 1:HydraulicElementQuantity
    HydraulicElement = HydraulicElementParameter{HydraulicElementNr};
	HydraulicElementType = HydraulicElement.Name;
	switch HydraulicElementType
		case {'Ideal Constant Pressure Pump','Ideal Constant Pressure Sink'}
			StateName = ['p_',num2str(HydraulicElementNr),'_1'];
			SymbolicCalculatedHydraulicElementState(HydraulicElementNr,1) = ...
                SymbolicCalculatedHydraulicState.(StateName);
            
			StateName = ['Q_',num2str(HydraulicElementNr),'_1'];
            SymbolicCalculatedHydraulicElementState(HydraulicElementNr,2) = ...
                SymbolicCalculatedHydraulicState.(StateName);
		case {'Electronic Throttle Valve','Back Pressure Valve', ...
                'Double Acting Hydraulic Cylinder'}
			StateName = ['p_',num2str(HydraulicElementNr),'_1'];
			SymbolicCalculatedHydraulicElementState(HydraulicElementNr,1) = ...
                SymbolicCalculatedHydraulicState.(StateName);
			StateName = ['p_',num2str(HydraulicElementNr),'_2'];
            SymbolicCalculatedHydraulicElementState(HydraulicElementNr,2) = ...
                SymbolicCalculatedHydraulicState.(StateName);
            
			StateName = ['Q_',num2str(HydraulicElementNr),'_1'];
            SymbolicCalculatedHydraulicElementState(HydraulicElementNr,3) = ...
                SymbolicCalculatedHydraulicState.(StateName);
			StateName = ['Q_',num2str(HydraulicElementNr),'_2'];
            SymbolicCalculatedHydraulicElementState(HydraulicElementNr,4) = ...
                SymbolicCalculatedHydraulicState.(StateName);
	end
    
end
%%
HydraulicSymbolicStateSolution.SymbolicCalculatedHydraulicElementState = ...
	SymbolicCalculatedHydraulicElementState;
HydraulicSymbolicStateSolution.x_Symbolic = x_Symbolic;
HydraulicSymbolicStateSolution.x_Pos = x_Pos;
HydraulicSymbolicStateSolution.u_Symbolic = u_Symbolic;
HydraulicSymbolicStateSolution.u_Pos = u_Pos;
end
