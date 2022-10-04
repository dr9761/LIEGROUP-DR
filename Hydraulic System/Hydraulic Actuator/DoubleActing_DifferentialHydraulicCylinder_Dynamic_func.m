function dpdt = DoubleActing_DifferentialHydraulicCylinder_Dynamic_func(...
	s,dsdt,Q,HydraulicOilParameter,HydraulicCylinderParameter)
%%
E = HydraulicOilParameter.E;
%%
alpha = HydraulicCylinderParameter.alpha;
A = HydraulicCylinderParameter.A;
L = HydraulicCylinderParameter.L;
%%
Q2 = -alpha * (L*A*dsdt - Q*(L-s)) / (s+alpha*(L-s));
% Q1 = -Q2 + Q;
%%
% dpdt = E / (A*s)*(-A*dsdt + Q1);
dpdt = E / (alpha*A*(L-s))*(alpha*A*dsdt + Q2);
end