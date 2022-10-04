function [HydraulicElementState] = solve_HydraulicCalculationEquatition(...
	x,u,HydraulicEquation)
%%
SymbolicCalculatedHydraulicElementState = ...
	HydraulicEquation.SymbolicCalculatedHydraulicElementState;

x_Symbolic = HydraulicEquation.x_Symbolic;
x_Pos = HydraulicEquation.x_Pos;
u_Symbolic = HydraulicEquation.u_Symbolic;
u_Pos = HydraulicEquation.u_Pos;

HydraulicElementState = ...
	double(subs(SymbolicCalculatedHydraulicElementState, ...
	[x_Symbolic;u_Symbolic],[x(x_Pos);u(u_Pos)]));
end