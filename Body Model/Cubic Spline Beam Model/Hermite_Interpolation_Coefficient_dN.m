function [dN_1_0,dN_1_1,dN_2_0,dN_2_1] = ...
	Hermite_Interpolation_Coefficient_dN(x,L)
%%
xi = x / L;
%%
dN_1_0 = (-6*xi + 6*xi^2) / L;
dN_1_1 = 1 - 4*xi + 3*xi^2;
dN_2_0 = (6*xi - 6*xi^2) / L;
dN_2_1 = 3*xi^2 - 2*xi;

end