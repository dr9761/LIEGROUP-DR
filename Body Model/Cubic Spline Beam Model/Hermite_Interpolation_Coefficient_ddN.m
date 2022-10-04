function [ddN_1_0,ddN_1_1,ddN_2_0,ddN_2_1] = ...
	Hermite_Interpolation_Coefficient_ddN(x,L)
%%
xi = x / L;
%%
ddN_1_0 = (-6 + 12*xi) / L / L;
ddN_1_1 = (-4 + 6*xi) / L;
ddN_2_0 = (6 - 12*xi) / L / L;
ddN_2_1 = (6*xi - 2) / L;

end