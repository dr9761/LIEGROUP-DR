function [dddN_1_0,dddN_1_1,dddN_2_0,dddN_2_1] = ...
	Hermite_Interpolation_Coefficient_dddN(x,L)
%%
xi = x / L;
%%
dddN_1_0 = 12/L/L/L;
dddN_1_1 = 6/L/L;
dddN_2_0 = -12/L/L/L;
dddN_2_1 = 6/L/L;
end