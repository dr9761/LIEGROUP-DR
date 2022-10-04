function [N_1_0,N_1_1,N_2_0,N_2_1] = ...
	Hermite_Interpolation_Coefficient_N(x,L)
%%
xi = x / L;
%%
N_1_0 = 1 - 3*xi^2 + 2*xi^3;
N_1_1 = L * (xi - 2*xi^2 + xi^3);
N_2_0 = 3*xi^2 - 2*xi^3;
N_2_1 = L * (xi^3 - xi^2);

end