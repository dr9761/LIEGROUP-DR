function dpdt = SingleActing_HydraulicCylinder_Dynamic_func(...
	s,dsdt,Q,HydraulicOilParameter,HydraulicCylinderParameter)
%%
E = HydraulicOilParameter.E;
%%
A = HydraulicCylinderParameter.A;
%%
dpdt = E / (A*s)*(-A*dsdt + Q);
end