function [dp1dt,dp2dt] = DoubleActing_HydraulicCylinder_Dynamic_func(...
	s,dsdt,Q1,Q2,HydraulicOilParameter,HydraulicCylinderParameter)
%%
E = HydraulicOilParameter.E;
%%
alpha = HydraulicCylinderParameter.alpha;
A = HydraulicCylinderParameter.A;
L = HydraulicCylinderParameter.L;
%%
dp1dt = E / (A*s)*(-A*dsdt + Q1);
dp2dt = E / (alpha*A*(L-s))*(alpha*A*dsdt + Q2);
end